USE [EIDSS7_DT]
GO
/****** Object:  StoredProcedure [dbo].[USP_CONF_GetVetDiseaseList_GET]    Script Date: 4/7/2019 1:29:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************
NAME						: [USP_CONF_GetVetDiseaseList_GET]		


Description					: Retreives Entries Vet Disease

Author						: Lamont Mitchell

Revision History
		
			Name							Date								Change Detail
			Lamont Mitchell					04/03/19							Initial Created
*******************************************************/
Alter PROCEDURE [dbo].[USP_CONF_GetVetDiseaseList_GET]
	
@idfsBaseReference							BIGINT = NULL,
@intHACode									BIGINT = NULL,
@strLanguageID								VARCHAR(5) = NULL
AS BEGIN

SET NOCOUNT ON;

	BEGIN TRY
			Select t.idfsBaseReference,t.strDefault, d.strIDC10, d.strOIECode
			FROM trtBaseReference t
			 Left JOIN  trtDiagnosis d  
				ON  t.idfsBaseReference = d.idfsDiagnosis
				WHERE t.idfsReferenceType = @idfsBaseReference -- Disease
			AND @intHACode in  (SELECT value from String_Split([dbo].[FN_GBL_HACode_ToCSV]('en',intHaCode),',')) AND t.intRowStatus = 0
			ORDER BY strDefault Asc
	END TRY
	BEGIN CATCH
			THROW;
	END CATCH
END


