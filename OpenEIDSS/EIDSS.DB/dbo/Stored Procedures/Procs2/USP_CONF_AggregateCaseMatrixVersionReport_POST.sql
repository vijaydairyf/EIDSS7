USE [EIDSS7_DT]
GO
/****** Object:  StoredProcedure [dbo].[USP_CONF_AggregateCaseMatrixVersion_POST]    Script Date: 2/26/2019 9:41:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************
NAME						: [USP_CONF_AggregateCaseMatrixVersionReport_POST]	


Description					: Saves Entries For Human Aggregate Case Matrix Report

Author						: Lamont Mitchell

Revision History
		
			Name							Date								Change Detail
			Lamont Mitchell					01/24/19							Initial Created
*******************************************************/
Create PROCEDURE [dbo].[USP_CONF_AggregateCaseMatrixVersionReport_POST]
	

@idfAggrHumanCaseMTX	BIGINT NULL,
@idfVersion				BIGINT NULL, 
@idfsDiagnosis			BIGINT NULL, 
@intNumRow				INT	, 
@intRowStatus			INT




AS BEGIN
	DECLARE @returnMsg					VARCHAR(MAX) = 'SUCCESS';
	DECLARE @returnCode					BIGINT = 0;
	Declare @idfsReferenceType			BIGINT ;

	SET NOCOUNT ON;
		Declare @SupressSelect table
	( 
		retrunCode int,
		returnMessage varchar(200)
	)
	BEGIN TRY
		IF EXISTS (SELECT * FROM [dbo].[tlbAggrHumanCaseMTX] WHERE idfVersion = @idfVersion )
			BEGIN
				UPDATE [dbo].[tlbAggrHumanCaseMTX]
				SET
				[intRowStatus] =		0
				WHERE [idfVersion] =	@idfVersion
			END
		ELSE
			BEGIN
			INSERT INTO @SupressSelect
			EXEC dbo.USP_GBL_NEXTKEYID_GET 'tlbAggrHumanCaseMTX', @idfVersion OUTPUT
			INSERT INTO [tlbAggrHumanCaseMTX]
			   (
						idfVersion
					   ,idfsDiagnosis
					   ,intNumRow
					   ,intRowStatus
					   
				)
			VALUES	
			   (
						@idfVersion
					   ,@idfsDiagnosis
					   ,@intNumRow
					   ,1
				)
			END
			SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage',@idfVersion 'idfVersion'
		END TRY
		BEGIN CATCH
				THROW;
		END CATCH
END
