USE [EIDSS7_DT]
GO
/****** Object:  StoredProcedure [dbo].[USP_DAS_INVESTIGATIONS_GETList]    Script Date: 5/7/2019 12:02:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================================
-- NAME: USP_DAS_INVESTIGATIONS_GETList
-- DESCRIPTION: Returns a list of veterinary disease reports based on the language selected
-- AUTHOR: Ricky Moss
-- 
-- Revision History
-- Name					Date			Change Detail
-- Ricky Moss			11/20/2018		Initial Release
-- Ricky Moss			11/30/2018		Removed reference type id variables and return code
-- Ricky Moss			12/03/2018		Renamed fields
-- Ricky Moss			12/13/2018		Added the status criteria
-- Ricky Moss			05/06/2018		Added Pagination
-- Testing Code:
-- exec USP_DAS_INVESTIGATIONS_GETList 'en', 1, 10, 10
-- ================================================================================================================
ALTER PROCEDURE [dbo].[USP_DAS_INVESTIGATIONS_GETList]
(
	@LangId nvarchar(50), 
	@PaginationSet INT = 1,
	@PageSize INT = 10,
	@MaxPagesPerFetch INT = 10  
)
AS  
BEGIN
	BEGIN TRY
		SELECT	vc.idfVetCase, 
		vc.strCaseID  AS strReportID,
		vc.datEnteredDate,
		strSpecies = STUFF
		(
			(
				SELECT			', ' + speciesType.name 
				FROM			dbo.tlbSpecies s
				INNER JOIN		FN_GBL_ReferenceRepair(@LangId, 19000086) AS speciesType
				ON				speciesType.idfsReference = s.idfsSpeciesType 
				INNER JOIN		dbo.tlbHerd AS h 
				ON				h.idfHerd = s.idfHerd 
				INNER JOIN		dbo.tlbFarm AS f2
				ON				h.idfFarm = f2.idfFarm
				WHERE			f2.idfFarm = f.idfFarm  
				GROUP BY speciesType.name
				FOR XML PATH(''), TYPE
			).value('.[1]', 'NVARCHAR(MAX)'), 1, 2, ''
		),
		finalDiagnosis.Name AS strDisease,
		vc.datInvestigationDate AS datInvestigationDate, 
		ISNULL(personInvestigatedBy.strFirstName + ' ', '') + ISNULL(personInvestigatedBy.strFamilyName, '') AS strInvestigatedBy,
		caseClassification.name AS strClassification,									 
		(IIF(glFarm.strForeignAddress IS NULL, 
		((CASE WHEN glFarm.strStreetName IS NULL THEN '' WHEN glFarm.strStreetName = '' THEN '' ELSE glFarm.strStreetName END) + 
		IIF(glFarm.strBuilding = '', '', ', Bld ' + glFarm.strBuilding) +
		IIF(glFarm.strApartment = '', '', ', Apt ' + glFarm.strApartment) + 
		IIF(glFarm.strHouse = '', '', ', ' + glFarm.strHouse) + 
		IIF(glFarm.idfsSettlement IS NULL, '', ', ' + settlement.name) + 
		(CASE WHEN glFarm.strPostCode IS NULL THEN '' WHEN glFarm.strPostCode = '' THEN '' ELSE ', ' + glFarm.strPostCode END) + 
		IIF(glFarm.idfsRayon IS NULL, '', ', ' + rayon.name) + 
		IIF(glFarm.idfsRegion IS NULL, '', ', ' + region.name) + 
		IIF(glFarm.idfsCountry IS NULL, '', ', ' + country.name)), glFarm.strForeignAddress)) AS strAddress
		
		FROM						dbo.tlbVetCase vc 
		INNER JOIN					dbo.tlbFarm AS f
		ON							f.idfFarm = vc.idfFarm
		INNER JOIN					dbo.tlbFarmActual AS fa
		ON							fa.idfFarmActual = f.idfFarmActual 
		LEFT JOIN					dbo.tlbHumanActual AS ha 
		ON							ha.idfHumanActual = fa.idfHumanActual
		LEFT JOIN					dbo.tlbPerson AS personInvestigatedBy 
		ON							personInvestigatedBy.idfPerson = vc.idfPersonInvestigatedBy AND personInvestigatedBy.intRowStatus = 0
		LEFT JOIN					dbo.tlbGeoLocation AS glFarm
		ON							glFarm.idfGeoLocation = f.idfFarmAddress AND glFarm.intRowStatus = 0 
		LEFT JOIN					dbo.FN_GBL_GIS_Reference(@LangId, 19000001) AS country 
		ON							country.idfsReference = glFarm.idfsCountry
		LEFT JOIN					FN_GBL_GIS_REFERENCE(@LangId, 19000002) AS rayon
		ON							rayon.idfsReference = glFarm.idfsRayon
		LEFT JOIN					FN_GBL_GIS_REFERENCE(@LangId, 19000003) AS region
		ON							region.idfsReference = glFarm.idfsRegion
		LEFT JOIN					dbo.FN_GBL_GIS_Reference(@LangId, 19000004) AS settlement 
		ON							settlement.idfsReference = glFarm.idfsSettlement
		LEFT JOIN					FN_GBL_ReferenceRepair(@LangId, 19000019) AS finalDiagnosis
		ON							finalDiagnosis.idfsReference = vc.idfsFinalDiagnosis
		LEFT JOIN					FN_GBL_ReferenceRepair(@LangId, 19000011) AS caseClassification
		ON							caseClassification.idfsReference = vc.idfsCaseClassification
		AND							vc.intRowStatus = 0
		WHERE vc.idfsCaseProgressStatus = 10109001 ORDER BY strCaseID OFFSET(@PageSize * @MaxPagesPerFetch) * (@PaginationSet - 1) ROWS
				FETCH NEXT (@PageSize * @MaxPagesPerFetch) ROWS ONLY ;;
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END
