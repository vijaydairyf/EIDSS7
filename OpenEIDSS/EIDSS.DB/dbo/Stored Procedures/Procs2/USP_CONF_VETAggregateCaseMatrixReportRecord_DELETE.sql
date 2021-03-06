USE [EIDSS7_DT]
GO
/****** Object:  StoredProcedure [dbo].[USP_CONF_VETAggregateCaseMatrixReportRecord_DELETE]    Script Date: 5/29/2019 4:40:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************
NAME						: [USP_CONF_VETAggregateCaseMatrixReportRecord_DELETE]


Description					: Deletes Entries For VET Aggregate Case Matrix Report 

Author						: Lamont Mitchell

Revision History
		
			Name							Date								Change Detail
			Lamont Mitchell					3/12/19							Initial Created
*******************************************************/
ALTER PROCEDURE [dbo].[USP_CONF_VETAggregateCaseMatrixReportRecord_DELETE]
	

@idfAggrVetCaseMTX	BIGINT

AS 
BEGIN
	DECLARE @returnMsg					VARCHAR(MAX) = 'SUCCESS';
	DECLARE @returnCode					BIGINT = 0;
	SET NOCOUNT ON;

	BEGIN TRY
			IF EXISTS (SELECT * FROM [dbo].[tlbAggrVetCaseMTX] WHERE idfAggrVetCaseMTX = @idfAggrVetCaseMTX)
			BEGIN
					
				DELETE FROM [tlbAggrVetCaseMTX] WHERE idfAggrVetCaseMTX = @idfAggrVetCaseMTX ;
				Print 'Deleted';
			END
			SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage',@idfAggrVetCaseMTX 'idfAggrVetCaseMTX'
		END TRY
		BEGIN CATCH
				THROW;
		END CATCH
END
