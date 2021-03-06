USE [EIDSS7_DT]
GO
/****** Object:  StoredProcedure [dbo].[USP_CONF_HumanAggregateCaseMatrixReportRecord_DELETE]    Script Date: 4/9/2019 11:10:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************
NAME						: [USP_CONF_HumanAggregateCaseMatrixReportRecord_DELETE]


Description					: Deletes Entries For Human Aggregate Case Matrix Report 

Author						: Lamont Mitchell

Revision History
		
			Name							Date								Change Detail
			Lamont Mitchell					3/12/19							Initial Created
*******************************************************/
Create PROCEDURE [dbo].[USP_CONF_HumanAggregateCaseMatrixReportRecord_DELETE]
	

@idfAggrHumanCaseMTX	BIGINT

AS 
BEGIN
	DECLARE @returnMsg					VARCHAR(MAX) = 'SUCCESS';
	DECLARE @returnCode					BIGINT = 0;
	SET NOCOUNT ON;

	BEGIN TRY
			IF EXISTS (SELECT * FROM [dbo].[tlbAggrHumanCaseMTX] WHERE idfAggrHumanCaseMTX = @idfAggrHumanCaseMTX)
			BEGIN
					
				DELETE FROM [tlbAggrHumanCaseMTX] WHERE idfAggrHumanCaseMTX = @idfAggrHumanCaseMTX ;
				Print 'Deleted';
			END
			SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage',@idfAggrHumanCaseMTX 'idfAggrHumanCaseMTX'
		END TRY
		BEGIN CATCH
				THROW;
		END CATCH
END
