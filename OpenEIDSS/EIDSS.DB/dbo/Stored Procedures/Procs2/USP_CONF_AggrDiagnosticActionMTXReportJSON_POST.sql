USE [EIDSS7_DT]
GO
/****** Object:  StoredProcedure [dbo].[USP_CONF_AggrDiagnosticActionMTXReportJSON_POST]    Script Date: 4/9/2019 1:11:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************
NAME						: [USP_CONF_AggrDiagnosticActionMTXReportJSON_POST]


Description					: Saves Entries For Diagnostic Matrix Report FROM A JSON STRING

Author						: Lamont Mitchell

Revision History
		
			Name							Date								Change Detail
			Lamont Mitchell					3/04/19							Initial Created
*******************************************************/
Create PROCEDURE [dbo].[USP_CONF_AggrDiagnosticActionMTXReportJSON_POST]
	
@idfAggrDiagnosticActionMTX		BIGINT NULL,
@idfVersion						BIGINT NULL,
@inJsonString					Varchar(Max) NULL






AS 
BEGIN
	DECLARE @returnMsg					VARCHAR(MAX) = 'SUCCESS';
	DECLARE @returnCode					BIGINT = 0;
	Declare @idfsReferenceType			BIGINT ;
	Declare @JsonString					Varchar(Max); 
	SET NOCOUNT ON;

	BEGIN TRY
	SET @JsonString = @inJsonString;
		IF EXISTS (SELECT * FROM [dbo].[tlbAggrDiagnosticActionMTX] WHERE idfVersion = @idfVersion )
			BEGIN
				UPDATE [dbo].[tlbAggrDiagnosticActionMTX]
				SET
				[intRowStatus] =		1
				WHERE [idfVersion] = @idfVersion
				
			END
			
	Declare @SupressSelect table
	( 
			returnCode int,
			returnMessage varchar(200)
	)
	Declare @Disease Table
		( 
			 tidfVersion BIGINT
			,tidfsDiagnosis BIGINT
			,tidfsSpeciesType BIGINT
			,tidfsDiagnosticAction BIGINT
			,tintNumRow INT

		)
		
		INSERT INTO @Disease (tidfVersion, tidfsDiagnosis,tidfsSpeciesType,tidfsDiagnosticAction, tintNumRow)
		SELECT idfVersion, idfsDiagnosis,idfsSpeciesType,idfsDiagnosticAction, intNumRow
		FROM OPENJSON(@JsonString)
		 WITH (
			idfVersion BIGINT,
			idfsDiagnosis BIGINT, 
			idfsSpeciesType BIGINT,
			idfsDiagnosticAction BIGINT,
			intNumRow INT
		)
		Select * from @Disease;
	  DECLARE @rowCount  INT = 0;
	  set  @rowCount =  (SELECT max(tintNumRow) from @Disease);
	  print @rowCount;
	  DECLARE @_int  int = 0;
	  WHILE @_int <= @rowCount
			BEGIN
		
				IF EXISTS (SELECT * FROM [dbo].[tlbAggrDiagnosticActionMTX] WHERE idfVersion = @idfVersion 
				AND idfsDiagnosis = (Select tidfsDiagnosis from @Disease where tintNumRow = @_int)  AND intRowStatus in(0, 1)
				AND idfsSpeciesType = (Select tidfsSpeciesType from @Disease where tintNumRow = @_int)  AND intRowStatus in(0, 1)
				AND idfsDiagnosticAction = (Select tidfsDiagnosticAction from @Disease where tintNumRow = @_int)  AND intRowStatus in(0, 1))
				BEGIN
					
					DECLARE @aggHumanCaseMtxId BIGINT
					SET  @aggHumanCaseMtxId = (Select idfAggrDiagnosticActionMTX from  [dbo].tlbAggrDiagnosticActionMTX WHERE idfVersion = @idfVersion 
					AND idfsDiagnosis = (Select tidfsDiagnosis from @Disease where tintNumRow = @_int)
					AND idfsSpeciesType = (Select tidfsSpeciesType from @Disease where tintNumRow = @_int)
					AND idfsDiagnosticAction = (Select tidfsDiagnosticAction from @Disease where tintNumRow = @_int));
					
					UPDATE [tlbAggrDiagnosticActionMTX]
					SET 
					[intRowStatus] = 0,
					[intNumRow] = @_int
					WHERE 
					idfsDiagnosis = (Select tidfsDiagnosis from @Disease WHERE tintNumRow = @_int) AND
					idfsSpeciesType = (Select tidfsSpeciesType from @Disease WHERE tintNumRow = @_int) AND
					idfsDiagnosticAction = (Select tidfsDiagnosticAction from @Disease WHERE tintNumRow = @_int) AND
					idfVersion = (Select tidfVersion from @Disease WHERE tintNumRow = @_int) AND
					idfAggrDiagnosticActionMTX = @aggHumanCaseMtxId;
					Print 'Updated'
				END
				ELSE
				BEGIN
				Print 'Try Insert'

			
				IF EXISTS(Select * from @Disease where tintNumRow = @_int)
					BEGIN
					Print 'Item is in Disease Table: ' + CONVERT(varchar(10), @_int);

					INSERT INTO @SupressSelect
					EXEC dbo.USP_GBL_NEXTKEYID_GET 'tlbAggrDiagnosticActionMTX', @idfAggrDiagnosticActionMTX OUTPUT;
						INSERT INTO [tlbAggrDiagnosticActionMTX]
					   (
								idfAggrDiagnosticActionMTX
							   ,idfVersion
							   ,idfsDiagnosis
							   ,idfsSpeciesType
							   ,idfsDiagnosticAction
							   ,intNumRow
							   ,intRowStatus
					   
						)
						SELECT	    
								@idfAggrDiagnosticActionMTX
								,tidfVersion
								,tidfsDiagnosis
								,tidfsSpeciesType
								,tidfsDiagnosticAction
								,tintNumRow
								,0
						FROM @Disease where tintNumRow = @_int;
					END
					ELSE
					BEGIN
					Print 'Item not there at : ' + CONVERT(varchar(10), @_int);
					END
				END
			
				Print @_int;
				Set @_int = @_int + 1
			END
			SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage',@idfAggrDiagnosticActionMTX 'idfAggrDiagnosticActionMTX'
		END TRY
		
		BEGIN CATCH
				THROW;
		END CATCH
END
