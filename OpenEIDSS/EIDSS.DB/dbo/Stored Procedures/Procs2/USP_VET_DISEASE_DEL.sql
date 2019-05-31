﻿






-- ============================================================================
-- Name: USP_VET_DISEASE_DEL
-- Description:	Sets a disease report record to "inactive".
--                      
-- Author: Stephen Long
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Stephen Long     04/17/2018 Initial release.
-- ============================================================================
CREATE PROCEDURE [dbo].[USP_VET_DISEASE_DEL]
(
	@LangID									NVARCHAR(20) = NULL, 
	@idfVetCase								BIGINT
)
AS

DECLARE @returnCode							INT = 0;
DECLARE	@returnMsg							NVARCHAR(MAX) = 'SUCCESS';

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- Interfering with SELECT statements.
	SET NOCOUNT ON;

    BEGIN TRY
		BEGIN TRANSACTION;

		UPDATE								dbo.tlbVetCase
		SET									intRowStatus = 1, 
											datModificationForArchiveDate = GETDATE()
		WHERE								idfVetCase = @idfVetCase; 

		IF @@TRANCOUNT > 0 AND @returnCode = 0
			COMMIT;

		SELECT								@returnCode, @returnMsg;
	END TRY
	BEGIN CATCH
		IF @@Trancount = 1 
			ROLLBACK;

		SET @returnCode = ERROR_NUMBER();
		SET @returnMsg = 
			' ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER()) 
		  + ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY())
		  + ' ErrorState: ' + CONVERT(VARCHAR, ERROR_STATE())
		  + ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE(), 'N/A')
		  + ' ErrorLine: ' +  CONVERT(VARCHAR, ISNULL(ERROR_LINE(), 'N/A'))
		  + ' ErrorMessage: ' + ERROR_MESSAGE() 
		  + ' State: ' + CONVERT(VARCHAR, ISNULL(XACT_STATE(), 'N/A'));

		SELECT @returnCode, @returnMsg;
	END CATCH
END
