﻿--*************************************************************
-- Name 				: USP_HUM_DISEASE_CONTACT_SET
-- Description			: set Human Disease Report Contacts by HDID
--          
-- Author               : JWJ
-- Revision History
--		Name		Date       Change Detail
-- ---------------- ---------- --------------------------------
-- JWJ				201080618		created 

--
-- Testing code:
-- EXEC USP_HUM_DISEASE_CONTACT_SET (enter your params here) 
--*************************************************************
CREATE PROCEDURE [dbo].[USP_HUM_DISEASE_CONTACT_SET] 
(			@idfContactedCasePerson bigint = -1
		   ,@idfsPersonContactType bigint = -1
           ,@idfHuman bigint = -1
           ,@idfHumanCase bigint = -1
           ,@datDateOfLastContact datetime = null
           ,@strPlaceInfo nvarchar(200) = null
           ,@intRowStatus int = 0
           ,@rowguid uniqueIdentifier = NEWID 
           ,@strComments nvarchar(500) = null
           ,@strMaintenanceFlag nvarchar(20) = null
           ,@strReservedAttribute nvarchar(max) = null
		   )
AS
Begin
	DECLARE @returnMsg				VARCHAR(MAX) = 'Success';
	DECLARE @returnCode				BIGINT = 0;

	DECLARE @SupressSelect table
			( retrunCode int,
			  returnMessage varchar(200)
			)

	BEGIN TRY  
		IF NOT EXISTS (SELECT idfContactedCasePerson 
							FROM dbo.tlbContactedCasePerson 
							WHERE idfContactedCasePerson = @idfContactedCasePerson 
								AND	intRowStatus = 0)
			BEGIN
			    INSERT INTO @SupressSelect
				-- Get next key value
				EXEC dbo.USP_GBL_NEXTKEYID_GET 'tlbContactedCasePerson', @idfContactedCasePerson OUTPUT

				INSERT INTO [dbo].[tlbContactedCasePerson]
					   (
						   idfContactedCasePerson,
						   idfsPersonContactType
						   ,idfHuman
						   ,idfHumanCase
						   ,datDateOfLastContact
						   ,strPlaceInfo
						   ,intRowStatus
						   ,rowguid
						   ,strComments
						   ,strMaintenanceFlag
						   ,strReservedAttribute
					   )
				 VALUES
					   (
							@idfContactedCasePerson
							,@idfsPersonContactType 
							,@idfHuman 
							,@idfHumanCase
							,@datDateOfLastContact
							,@strPlaceInfo 
							,@intRowStatus
							,@rowguid 
							,@strComments 
							,@strMaintenanceFlag 
							,@strReservedAttribute 
					   )

			END
		Else
			BEGIN
				UPDATE dbo.tlbContactedCasePerson
				SET 
					   idfsPersonContactType = @idfsPersonContactType
					   ,idfHuman = @idfHuman
					   ,idfHumanCase = @idfHumanCase
					   ,datDateOfLastContact = @datDateOfLastContact
					   ,strPlaceInfo = @strPlaceInfo
					   ,intRowStatus = @intRowStatus
					   ,rowguid = @rowguid
					   ,strComments = @strComments
					   ,strMaintenanceFlag = @strMaintenanceFlag
					   ,strReservedAttribute = @strReservedAttribute
				WHERE idfContactedCasePerson = @idfContactedCasePerson 
					AND	intRowStatus = 0
			END

			--SELECT @returnCode 'ReturnCode', @returnMsg 'ResturnMessage';
		END TRY  
	BEGIN CATCH 
		THROW
	END CATCH;
END

