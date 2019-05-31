﻿--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		05/02/2017
-- Last modified by:		Joan Li
-- Description:				05/02/2017: Created based on V6 spOrganization_SelectLookup : rename for V7
--                          Input: langID,i; Output: N/A
--                          05/02/2017: change name to: usp_Organization_GetLookup

-- Testing code:
/*
----testing code:
exec usp_Organization_GetLookup 'en', null, 2
*/

--=====================================================================================================
--##SUMMARY Selects lookup list of organizations.
--##REMARKS Author: Zurin M.
--##REMARKS Create date: 13.12.2009
--##RETURNS Doesn't use



CREATE      PROCEDURE [dbo].[usp_Organization_GetLookup]
	@LangID As nvarchar(50), --##PARAM @LangID - language ID
	@ID as bigint = NULL, --##PARAM @ID - organization ID, if not null only record with this organization is selected
	@intHACode as int = NULL
AS
SELECT  
	idfOffice as idfInstitution, 
	[name], 
	FullName, 
	idfsOfficeName, 
	idfsOfficeAbbreviation, 
	CAST(CASE WHEN (intHACode & 2)>0 THEN 1 ELSE 0 END AS BIT) AS blnHuman,
	CAST(CASE WHEN (intHACode & 96)>0 THEN 1 ELSE 0 END AS BIT) AS blnVet,
	CAST(CASE WHEN (intHACode & 32)>0 THEN 1 ELSE 0 END AS BIT) AS blnLivestock,
	CAST(CASE WHEN (intHACode & 64)>0 THEN 1 ELSE 0 END AS BIT) AS blnAvian,
	CAST(CASE WHEN (intHACode & 128)>0 THEN 1 ELSE 0 END AS BIT) AS blnVector,
	CAST(CASE WHEN (intHACode & 256)>0 THEN 1 ELSE 0 END AS BIT) AS blnSyndromic,
	intHACode,
	idfsSite,
	strOrganizationID,
	intRowStatus
FROM 
	dbo.fnInstitution(@LangID) 
WHERE
	(@ID IS NULL OR @ID = idfOffice)
	and (@intHACode = 0 or @intHACode is null or (intHACode & @intHACode)>0)
ORDER BY
	ISNULL(intOrder,0), [name] 






