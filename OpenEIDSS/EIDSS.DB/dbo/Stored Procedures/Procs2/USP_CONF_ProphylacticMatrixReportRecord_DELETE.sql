USE [EIDSS7_DT]
GO
/****** Object:  StoredProcedure [dbo].[USP_CONF_ProphylacticMatrixReportRecord_DELETE]    Script Date: 4/9/2019 10:50:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************
NAME						: [USP_CONF_ProphylacticMatrixReportRecord_DELETE]


Description					: Deletes Entries For Prophylactic Matrix Report 

Author						: Lamont Mitchell

Revision History
		
			Name							Date								Change Detail
			Lamont Mitchell					3/12/19							Initial Created
*******************************************************/
CREATE PROCEDURE [dbo].[USP_CONF_ProphylacticMatrixReportRecord_DELETE]
	

@idfAggrProphylacticActionMTX		BIGINT

AS 
BEGIN
	DECLARE @returnMsg					VARCHAR(MAX) = 'SUCCESS';
	DECLARE @returnCode					BIGINT = 0;
	SET NOCOUNT ON;

	BEGIN TRY
			IF EXISTS (SELECT * FROM [dbo].[tlbAggrProphylacticActionMTX] WHERE idfAggrProphylacticActionMTX = @idfAggrProphylacticActionMTX)
			BEGIN
					
				DELETE FROM [dbo].[tlbAggrProphylacticActionMTX] WHERE idfAggrProphylacticActionMTX = @idfAggrProphylacticActionMTX ;
				Print 'Deleted';
			END
			SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage',@idfAggrProphylacticActionMTX 'idfAggrHumanCaseMTX'
		END TRY
		BEGIN CATCH
				THROW;
		END CATCH
END
