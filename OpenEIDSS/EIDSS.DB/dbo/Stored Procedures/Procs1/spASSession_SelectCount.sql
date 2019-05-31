﻿
--##SUMMARY Selects count of Active Surveillance Sessions

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 31.10.2011

--##RETURNS Doesn't use

/*
--Example of procedure call:
EXECUTE spASSession_SelectCount 
	
*/


create procedure	[dbo].[spASSession_SelectCount]
as

select	COUNT(*) 
FROM	dbo.tlbMonitoringSession
WHERE	intRowStatus = 0

