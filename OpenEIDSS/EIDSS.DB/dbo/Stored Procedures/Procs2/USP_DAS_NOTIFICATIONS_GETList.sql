USE [EIDSS7_DT]
GO
/****** Object:  StoredProcedure [dbo].[USP_DAS_NOTIFICATIONS_GETList]    Script Date: 5/6/2019 5:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================================
-- NAME: USP_DAS_NOTIFICATIONS_GETList
-- DESCRIPTION: Returns a list of human disease reports based on the language selected
-- AUTHOR: Ricky Moss
-- 
-- Revision History
-- Name					Date			Change Detail
-- Ricky Moss			11/19/2018		Initial Release
-- Ricky Moss			11/30/2018		Removed reference type id variable and return code
-- Ricky Moss			12/03/2018		Added Notified By Person field
-- Ricky Moss			05/06/2019		Added Pagination
-- Testing Code:
-- exec USP_DAS_NOTIFICATIONS_GETList 'en', 1, 10, 10
-- ================================================================================================================
ALTER PROCEDURE [dbo].[USP_DAS_NOTIFICATIONS_GETList]
(
	@LangId nvarchar(50), 
	@PaginationSet INT = 1,
	@PageSize INT = 10,
	@MaxPagesPerFetch INT = 10  
)
AS  
BEGIN
	BEGIN TRY
		SELECT		hc.idfHumanCase,
					hc.strCaseId as strReportID,
					hc.datEnteredDate,				
					ISNULL(LEFT(h.strFirstName, 1), '') + ISNULL(LEFT(h.strLastName, 1), N'')  AS strPersonName,
					ISNULL(finaldiagnosis.Name, TentativeDiagnosis.name) AS strDisease,
					hos.FullName as strNotifyingOrganization,
					CASE hc.idfsYNHospitalization
						WHEN 10100001 THEN 'I'
						ELSE 'O'
					END AS [InpatientOrOutpatient],
					ISNULL(LEFT(haPersonEnteredBy.datModificationDate,1), '') + ISNULL(LEFT(haPersonEnteredBy.strLastName, 1),'') AS strNotifiedBy
		FROM							dbo.tlbHumanCase hc
		LEFT JOIN						dbo.tlbHuman AS h
		ON								h.idfHuman = hc.idfHuman AND h.intRowStatus = 0 
		LEFT JOIN						dbo.tlbHumanActual AS ha
		ON								ha.idfHumanActual = h.idfHumanActual AND ha.intRowStatus = 0
		LEFT JOIN						dbo.tlbGeoLocation gl
		ON								gl.idfGeoLocation = hc.idfPointGeoLocation AND gl.intRowStatus = 0 		
		LEFT JOIN						FN_GBL_ReferenceRepair(@LangId, 19000019) FinalDiagnosis
		ON								Finaldiagnosis.idfsReference = hc.idfsFinalDiagnosis	
		LEFT JOIN						FN_GBL_ReferenceRepair(@LangId, 19000019) TentativeDiagnosis
		ON								TentativeDiagnosis.idfsReference = hc.idfsTentativeDiagnosis
		LEFT JOIN						dbo.tlbHumanActual AS haPersonEnteredBy 
		ON								haPersonEnteredBy.idfHumanActual = hc.idfPersonEnteredBy AND haPersonEnteredBy.intRowStatus = 0
		AND								hc.intRowStatus = 0
		LEFT JOIN						dbo.FN_GBL_INSTITUTION(@LangId) hos
		ON								hos.idfOffice = hc.idfHospital	
		WHERE hc.datEnteredDate IS NOT NULL
		ORDER BY HC.datEnteredDate OFFSET(@PageSize * @MaxPagesPerFetch) * (@PaginationSet - 1) ROWS
				FETCH NEXT (@PageSize * @MaxPagesPerFetch) ROWS ONLY;
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END
