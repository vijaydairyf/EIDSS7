﻿



--##SUMMARY 
--##REMARKS Author: 
--##REMARKS Create date: 

--##RETURNS Doesn't use



/*
--Example of procedure call:

*/




CREATE proc	[dbo].[spVsSessionSummaryDiagnosis_Delete]
	@ID AS BIGINT --#PARAM @ID - session ID
as

DELETE FROM  dbo.tlbVectorSurveillanceSessionSummaryDiagnosis WHERE idfsVSSessionSummaryDiagnosis = @ID