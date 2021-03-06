USE [EIDSS7_DT]
GO
/****** Object:  StoredProcedure [dbo].[USP_CONF_VetDiagnosisMatrixReportRecord_DELETE]    Script Date: 4/9/2019 10:50:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************
NAME						: [USP_CONF_VetDiagnosisMatrixReportRecord_DELETE]


Description					: Deletes Entries For Vet Diagnosis Matrix Report FROM A JSON STRING

Author						: Lamont Mitchell

Revision History
		
			Name							Date								Change Detail
			Lamont Mitchell					3/12/19							Initial Created
*******************************************************/
CREATE PROCEDURE [dbo].[USP_CONF_VetDiagnosisMatrixReportRecord_DELETE]
	

@idfAggrDiagnosticActionMTX 	BIGINT

AS 
BEGIN
	DECLARE @returnMsg					VARCHAR(MAX) = 'SUCCESS';
	DECLARE @returnCode					BIGINT = 0;
	Declare @idfsReferenceType			BIGINT ;
	Declare @JsonString				 Varchar(Max); 
	SET NOCOUNT ON;

	BEGIN TRY
			IF EXISTS (SELECT * FROM [dbo].[tlbAggrDiagnosticActionMTX] WHERE idfAggrDiagnosticActionMTX = @idfAggrDiagnosticActionMTX)
			BEGIN
					
				DELETE FROM [tlbAggrDiagnosticActionMTX] WHERE idfAggrDiagnosticActionMTX = @idfAggrDiagnosticActionMTX ;
				Print 'Deleted';
			END
			SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage',@idfAggrDiagnosticActionMTX 'idfAggrHumanCaseMTX'
		END TRY
		BEGIN CATCH
				THROW;
		END CATCH
END
