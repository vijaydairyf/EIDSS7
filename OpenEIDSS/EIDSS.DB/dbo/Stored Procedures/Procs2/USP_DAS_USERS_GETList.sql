USE [EIDSS7_DT]
GO
/****** Object:  StoredProcedure [dbo].[USP_DAS_USERS_GETList]    Script Date: 12/11/2018 4:26:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================================================================================
-- NAME: USP_DAS_USERS_GETList
-- DESCRIPTION: Returns a list of users in the system
-- AUTHOR: Ricky Moss
-- 
-- Revision History
-- Name				Date			Change Detail
-- Ricky Moss		11/16/2018		Initial Release
-- Ricky Moss		12/11/2018		Added idfsInstitution and idfsPosition fields and removed identifier fields
-- Ricky Moss		05/06/2018		Added pagination set.
-- Testing Code:
-- exec USP_DAS_USERS_GETList 'en', 1, 10, 10
-- ============================================================================================================
ALTER PROCEDURE [dbo].[USP_DAS_USERS_GETList]
(
	@LangId nvarchar(50), 
	@PaginationSet INT = 1,
	@PageSize INT = 10,
	@MaxPagesPerFetch INT = 10
)
AS
BEGIN
	BEGIN TRY
	SELECT		
				tlbPerson.idfPerson AS idfEmployee
				,tlbPerson.strFirstName
				,tlbPerson.strFamilyName
				,tlbPerson.strSecondName
				,tlbPerson.idfInstitution
				,Org.[name] AS Organization
				,Org.FullName AS OrganizationFullName
				,Position.idfsReference AS idfPosition
				,Position.[name] AS Position
				FROM	
					tlbPerson
					INNER JOIN tlbEmployee ON
						tlbEmployee.idfEmployee = tlbPerson.idfPerson
						AND 
						tlbEmployee.intRowStatus = 0		
					LEFT JOIN fnReferenceRepair(@LangID, 19000073) Position	ON
						tlbPerson.idfsStaffPosition = Position.idfsReference
					LEFT JOIN fnInstitution(@LangID) AS Org ON	
						Org.idfOffice = tlbPerson.idfInstitution
				ORDER BY strFamilyName 
				OFFSET(@PageSize * @MaxPagesPerFetch) * (@PaginationSet - 1) ROWS				
		FETCH NEXT (@PageSize * @MaxPagesPerFetch) ROWS ONLY;
	END TRY  
	BEGIN CATCH 
		THROW;
	END CATCH
END



