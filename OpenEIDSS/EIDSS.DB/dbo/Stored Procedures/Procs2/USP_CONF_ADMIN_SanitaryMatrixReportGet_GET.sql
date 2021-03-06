USE [EIDSS7_DT]
GO
/****** Object:  StoredProcedure [dbo].[USP_CONF_ADMIN_SanitaryMatrixReportGet_GET]    Script Date: 5/2/2019 2:17:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_CONF_ADMIN_SanitaryMatrixReportGet_GET] 
/*******************************************************
NAME						: [USP_CONF_ADMIN_SanitaryMatrixReportGet_GET]		


Description					: Retreives List of Vet Sanitary Diagnosisis  Matrix  by version

Author						: Lamont Mitchell

Revision History
		
			Name							Date								Change Detail
			Lamont Mitchell					03/4/19							 Initial Created
*******************************************************/
@idfVersion		BIGINT
AS
BEGIN

	BEGIN TRY 
		SELECT	 
				mtx.intNumRow
				,mtx.idfAggrSanitaryActionMTX as idfAggrSanitaryActionMTX
				,mtx.idfsSanitaryAction
				,t.strDefault
				,sa.strActionCode
		FROM	tlbAggrSanitaryActionMTX mtx
			inner join trtSanitaryAction sa
			on sa.idfsSanitaryAction = mtx.idfsSanitaryAction
			inner join dbo.tlbAggrMatrixVersionHeader  amvh
			on	amvh.intRowStatus = 0 and amvh.idfVersion = mtx.idfVersion and mtx.idfVersion = @idfVersion 
			inner Join trtBaseReference t
			on   t.idfsBaseReference = sa.idfsSanitaryAction
		WHERE mtx.intRowStatus = 0 and  mtx.idfVersion = @idfVersion
		ORDER BY mtx.intNumRow ASC
		 

	END TRY
	BEGIN CATCH
			THROW;
	END CATCH
END
