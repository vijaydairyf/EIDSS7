USE [EIDSS7_DT]
GO
/****** Object:  StoredProcedure [dbo].[USP_CONF_HumanAggregateCaseMatrix_GET]    Script Date: 4/5/2019 8:54:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************
NAME						: [USP_CONF_AggregateCaseMatrix_GetList]		


Description					: Retreives Entries For Human Aggregate Case Matrix

Author						: Lamont Mitchell

Revision History
		
			Name							Date								Change Detail
			Lamont Mitchell					04/03/19							Initial Created
*******************************************************/
Create PROCEDURE [dbo].[USP_CONF_VetDiagnosisInvestigationList_GET]
	
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
			AND @intHACode in  (SELECT value from String_Split([dbo].[FN_GBL_HACode_ToCSV]('en',intHaCode),','))
			ORDER BY strDefault Asc
	END TRY
	BEGIN CATCH
			THROW;
	END CATCH
END


