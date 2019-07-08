﻿
--##SUMMARY Checks if BasicSyndromicSurveillance object can be deleted.

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS 0 if BasicSyndromicSurveillance can't be deleted 
--##RETURNS 1 if BasicSyndromicSurveillance can be deleted 

/*
Example of procedure call:

DECLARE @ID bigint
DECLARE @Result BIT
EXEC spBasicSyndromicSurveillance_CanDelete @ID, @Result OUTPUT

Print @Result

*/


CREATE PROCEDURE [dbo].[spBasicSyndromicSurveillance_CanDelete]
	@ID AS BIGINT --##PARAM @ID - BasicSyndromicSurveillance ID
	, @Result AS BIT OUTPUT --##PARAM  @Result - 0 if BasicSyndromicSurveillance can't be deleted, 1 in other case
AS

SET @Result = 1

IF ISNULL((SELECT strValue FROM tstGlobalSiteOptions WHERE strName = 'DataValidation' AND intRowStatus = 0), 0) = 1
BEGIN
	DECLARE @DataValidationResult INT	
	EXEC @DataValidationResult = spBasicSyndromicSurveillance_Validate @ID
	IF @DataValidationResult <> 0
		SET @Result = 0
END

RETURN @Result