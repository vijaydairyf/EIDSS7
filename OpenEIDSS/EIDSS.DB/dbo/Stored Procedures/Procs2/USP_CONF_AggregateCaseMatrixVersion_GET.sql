USE [EIDSS7_DT]
GO
/****** Object:  StoredProcedure [dbo].[USP_CONF_AggregateCaseMatrixVersion_GET]    Script Date: 2/26/2019 9:45:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************
NAME						: [USP_CONF_AggregateCaseMatrixVersion_GET]		


Description					: Retreives Entries For Human Aggregate Case Matrix Version

Author						: Lamont Mitchell

Revision History
		
			Name							Date								Change Detail
			Lamont Mitchell					01/24/19							Initial Created
*******************************************************/
ALTER PROCEDURE [dbo].[USP_CONF_AggregateCaseMatrixVersion_GET]
	
@idfVersion								BIGINT = NULL
AS BEGIN

	SET NOCOUNT ON;

	BEGIN TRY
			IF @idfVersion IS NULL
			 BEGIN
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
				FROM [dbo].[tlbAggrMatrixVersionHeader]
			 END
			 ELSE
			 BEGIN
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
				FROM [dbo].[tlbAggrMatrixVersionHeader]
				WHERE idfVersion = @idfVersion
			 
			 END
	
		END TRY
		BEGIN CATCH
				THROW;
		END CATCH
END



