USE [EIDSS7_DT]
GO
/****** Object:  StoredProcedure [dbo].[USP_CONF_GetInvestigationTypes_GET]    Script Date: 5/16/2019 11:37:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************
NAME						: [USP_CONF_GetInvestigationTypes_GET]		


Description					: Retreives Entries For InvestigationTypes

Author						: Lamont Mitchell

Revision History
		
			Name							Date								Change Detail
			Lamont Mitchell					04/03/19							Initial Created
*******************************************************/
CREATE PROCEDURE [dbo].[USP_CONF_GetInvestigationTypes_GET]
	
@idfsBaseReference							BIGINT = NULL,
@intHACode									BIGINT = NULL,
@strLanguageID								VARCHAR(5) = NULL
AS BEGIN

SET NOCOUNT ON;

	BEGIN TRY
			Select t.idfsBaseReference,t.strDefault
			FROM trtBaseReference t
				WHERE t.idfsReferenceType = @idfsBaseReference -- Disease
			AND @intHACode in  (SELECT value from String_Split([dbo].[FN_GBL_HACode_ToCSV]('en',intHaCode),','))AND t.intRowStatus = 0
			ORDER BY strDefault Asc
	END TRY
	BEGIN CATCH
			THROW;
	END CATCH
END


