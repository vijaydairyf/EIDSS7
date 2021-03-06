USE [EIDSS7_DT]
GO
/****** Object:  StoredProcedure [dbo].[USP_CONF_HumanAggregateCaseMatrixVersionByMatrixType_GET]    Script Date: 4/8/2019 6:21:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************
NAME						: [USP_CONF_HumanAggregateCaseMatrixVersionByMatrixType_GET]		


Description					: Retreives Entries For Human Aggregate Case Matrix Version by matrixType

Author						: Lamont Mitchell

Revision History
		
			Name							Date								Change Detail
			Lamont Mitchell					03/24/19							Initial Created
*******************************************************/
Create PROCEDURE [dbo].[USP_CONF_HumanAggregateCaseMatrixVersionByMatrixType_GET]
	
@idfsMatrixType								BIGINT = NULL
AS BEGIN

	SET NOCOUNT ON;

	BEGIN TRY
		
				SELECT 
				[idfVersion], 
				[idfsMatrixType], 
				[MatrixName], 
				[datStartDate], 
				[blnIsActive], 
				[intRowStatus], 
				[rowguid], 
				[blnIsDefault], 
				[strMaintenanceFlag], 
				[strReservedAttribute]
				FROM [dbo].[tlbAggrMatrixVersionHeader] where  intRowStatus =0
				AND idfsMatrixType = @idfsMatrixType
			
		END TRY
		BEGIN CATCH
				THROW;
		END CATCH
END



