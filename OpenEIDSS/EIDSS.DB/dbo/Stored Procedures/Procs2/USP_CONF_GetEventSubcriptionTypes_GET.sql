USE [EIDSS7_DT]
GO
/****** Object:  StoredProcedure [dbo].[USP_CONF_GetEventSubcriptionTypes_GET]]    Script Date: 5/16/2019 11:37:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************
NAME						: [USP_CONF_GetEventSubcriptionTypes_GET]		


Description					: Retreives Event Subscription Types For Notifications

Author						: Lamont Mitchell

Revision History
		
			Name							Date								Change Detail
			Lamont Mitchell					05/23/19							Initial Created
*******************************************************/
CREATE PROCEDURE [dbo].[USP_CONF_GetEventSubcriptionTypes_GET]
	

@strLanguageID								VARCHAR(5) = NULL
AS BEGIN

SET NOCOUNT ON;

	BEGIN TRY
			Select t.idfsBaseReference,t.strDefault
			FROM trtBaseReference t
				WHERE t.idfsReferenceType = 19000155 
				AND t.intRowStatus = 0
			    ORDER BY strDefault Asc
	END TRY
	BEGIN CATCH
			THROW;
	END CATCH
END


