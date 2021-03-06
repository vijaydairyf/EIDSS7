USE [EIDSS7_DT]
GO
/****** Object:  StoredProcedure [dbo].[USP_DAS_MYNOTIFICATIONS_GETList]    Script Date: 5/6/2019 6:00:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================================
-- NAME: USP_DAS_MYNOTIFICATIONS_GETList
-- DESCRIPTION: Returns a list of human disease reports based on the language selected and the user currently logged in
-- AUTHOR: Ricky Moss
-- 
-- Revision History
-- Name					Date			Change Detail
-- Ricky Moss			11/19/2018		Initial Release
-- Ricky Moss			11/30/2018		Removed reference type id variables and return code
-- Ricky Moss			05/06/2018		Added Pagination
-- Testing Code:
-- exec USP_DAS_MYNOTIFICATIONS_GETList 'en', 55465230000000, 1, 10, 10
-- ================================================================================================================
ALTER PROCEDURE [dbo].[USP_DAS_MYNOTIFICATIONS_GETList]
(
	@LangId nvarchar(50), 
	@idfPerson BIGINT, 
	@PaginationSet INT = 1,
	@PageSize INT = 10,
	@MaxPagesPerFetch INT = 10  
)
AS  
BEGIN
	BEGIN TRY
		Select					
					hc.idfHumanCase,
					hc.strCaseId AS strReportID,	
					hc.datEnteredDate,
					ISNULL(LEFT(h.strFirstName, 1), '') + ISNULL(LEFT(h.strLastName, 1), N'')  AS strPerson,
					ISNULL(finaldiagnosis.Name, TentativeDiagnosis.name) AS strDisease,
					hc.datTentativeDiagnosisDate as datDiseaseDate,			
					ISNULL(FinalCaseClassification.name, InitialCaseClassification.name) AS strClassification,
					ISNULL(haInvestigatedBy.strLastName, N'') + ISNULL(' ' + haInvestigatedBy.strFirstName, '') + ISNULL(' ' + haInvestigatedBy.strSecondName, '') AS strInvestigatedBy
		FROM							dbo.tlbHumanCase hc
		LEFT JOIN						dbo.tlbHuman AS h
		ON								h.idfHuman = hc.idfHuman AND h.intRowStatus = 0 
		LEFT JOIN						dbo.tlbHumanActual AS ha
		ON								ha.idfHumanActual = h.idfHumanActual AND ha.intRowStatus = 0
		INNER JOIN						FN_GBL_ReferenceRepair(@LangId, 19000019) TentativeDiagnosis
		ON								tentativediagnosis.idfsReference = hc.idfsFinalDiagnosis
		INNER JOIN						FN_GBL_ReferenceRepair(@LangId, 19000019) FinalDiagnosis
		ON								Finaldiagnosis.idfsReference = hc.idfsFinalDiagnosis
		LEFT JOIN						FN_GBL_ReferenceRepair(@LangId, 19000011) InitialCaseClassification
		ON								InitialCaseClassification.idfsReference = hc.idfsInitialCaseStatus
		LEFT JOIN						FN_GBL_ReferenceRepair(@LangId, 19000011) FinalCaseClassification
		ON								FinalCaseClassification.idfsReference = hc.idfsFinalCaseStatus
		LEFT JOIN						dbo.tlbHuman AS haInvestigatedBy 
		ON								haInvestigatedBy.idfHuman = hc.idfInvestigatedByPerson AND haInvestigatedBy.intRowStatus = 0
		AND								hc.intRowStatus = 0
		WHERE hc.datEnteredDate is not null and idfPersonEnteredBy = @idfPerson
		ORDER BY hc.datEnteredDate OFFSET(@PageSize * @MaxPagesPerFetch) * (@PaginationSet - 1) ROWS
				FETCH NEXT (@PageSize * @MaxPagesPerFetch) ROWS ONLY;
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END
