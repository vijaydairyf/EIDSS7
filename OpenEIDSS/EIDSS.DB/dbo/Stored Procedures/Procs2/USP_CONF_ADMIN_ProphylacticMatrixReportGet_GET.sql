USE [EIDSS7_DT]
GO
/****** Object:  StoredProcedure [dbo].[USP_CONF_ADMIN_ProphylacticMatrixReportGet_GET]    Script Date: 4/8/2019 10:27:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Alter PROCEDURE [dbo].[USP_CONF_ADMIN_ProphylacticMatrixReportGet_GET] 
/*******************************************************
NAME						: [USP_CONF_ADMIN_ProphylacticMatrixReportGet_GET]		


Description					: Retreives List of Vet Prophylactic Diagnosisis  Matrix  by version

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
				,mtx.idfAggrProphylacticActionMTX as idfAggrProphylacticActionMTX
				,mtx.idfsSpeciesType
				,mtx.idfsDiagnosis
				,mtx.idfsProphilacticAction
				,pa.strActionCode
				,t.strDefault
				,d.strOIECode
		FROM	tlbAggrProphylacticActionMTX mtx
			inner join trtDiagnosis d
			on d.idfsDiagnosis = mtx.idfsDiagnosis
			INNER JOIN trtProphilacticAction pa
			ON pa.idfsProphilacticAction = mtx.idfsProphilacticAction
			inner join dbo.tlbAggrMatrixVersionHeader  amvh
			on	amvh.intRowStatus = 0 and amvh.idfVersion = mtx.idfVersion and mtx.idfVersion = @idfVersion 
			inner Join trtBaseReference t
			on   t.idfsBaseReference = d.idfsDiagnosis
			inner Join trtBaseReference t2
			on   t2.idfsBaseReference = pa.idfsProphilacticAction
		WHERE mtx.intRowStatus = 0 and  mtx.idfVersion = @idfVersion
		ORDER BY mtx.intNumRow ASC
		 

	END TRY
	BEGIN CATCH
			THROW;
	END CATCH
END
