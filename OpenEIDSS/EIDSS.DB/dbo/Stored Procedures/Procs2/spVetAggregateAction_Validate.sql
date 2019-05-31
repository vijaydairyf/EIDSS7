﻿
--##SUMMARY Checks data validation for VetAggregateAction object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS 0 if all internal validation procedures returns no errors
--##RETURNS 1 if some internal validation procedures returns errors

/*
Example of procedure call:

DECLARE @ID bigint
DECLARE @Result BIT
EXEC @Result = spVetAggregateAction_Validate @ID

Print @Result

*/

CREATE PROCEDURE [dbo].[spVetAggregateAction_Validate]
	@RootId BIGINT	--##PARAM @RootId - VetAggregateAction ID
AS
	EXEC spVetAggregateAction_ValidateForeignKeys @RootId
	
	IF (SELECT @@ROWCOUNT) > 0
		RETURN 1

	RETURN 0

