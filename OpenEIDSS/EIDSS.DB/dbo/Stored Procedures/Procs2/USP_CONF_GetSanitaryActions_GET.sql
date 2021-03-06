USE [EIDSS7_DT]
GO
/****** Object:  StoredProcedure [dbo].[USP_CONF_GetSanitaryActions_GET]    Script Date: 5/2/2019 10:36:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************
NAME						: [USP_CONF_GetSanitaryActions_GET]		


Description					: Retreives Entries For Sanitary Actions

Author						: Lamont Mitchell

Revision History
		
			Name							Date								Change Detail
			Lamont Mitchell					04/03/19							Initial Created
*******************************************************/
CREATE PROCEDURE [dbo].[USP_CONF_GetSanitaryActions_GET]
	
@idfsBaseReference							BIGINT = NULL,
@intHACode									BIGINT = NULL,
@strLanguageID								VARCHAR(5) = NULL
AS BEGIN

SET NOCOUNT ON;

	BEGIN TRY
			Select t.idfsBaseReference,t.strDefault,s.strActionCode
			FROM trtBaseReference t
			LEFT JOIN trtSanitaryAction s ON s.idfsSanitaryAction = t.idfsBaseReference
				WHERE t.idfsReferenceType = @idfsBaseReference -- Disease
				
			AND @intHACode in  (SELECT value from String_Split([dbo].[FN_GBL_HACode_ToCSV]('en',t.intHaCode),',')) AND t.intRowStatus = 0
			ORDER BY t.strDefault Asc
	END TRY
	BEGIN CATCH
			THROW;
	END CATCH
END


