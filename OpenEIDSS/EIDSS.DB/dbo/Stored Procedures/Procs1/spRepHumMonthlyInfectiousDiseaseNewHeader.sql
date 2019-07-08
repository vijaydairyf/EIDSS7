﻿

--##SUMMARY Select data for Reportable Infectious Diseases (Monthly Form IV03).
--##REMARKS Author: 
--##REMARKS Create date: 10.01.2011

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

exec [spRepHumMonthlyInfectiousDiseaseNewHeader] 'en',  37020000000, 3260000000


*/

create  Procedure [dbo].[spRepHumMonthlyInfectiousDiseaseNewHeader]
	(
		@LangID		as nvarchar(10), 
		@RegionID	as bigint = null,
		@RayonID	as bigint = null,
		@SiteID		as bigint = null,
		@UserID		as bigint = null
	)
AS	

-- Field description may be found here
-- "https://repos.btrp.net/BTRP/Project_Documents/08x-Implementation/Customizations/GG/Reports/Specification for report development - Monthly Form 03 New Revision Human GG v1.0.doc"
-- by number marked red at screen form prototype 

declare	@ReportTable	table
(	
	strOrderNumber		nvarchar(200) collate database_default null, --1
	strOrderDate		nvarchar(200) collate database_default null, --2
	strNA				nvarchar(200) collate database_default null,
	strNameOfRespondent nvarchar(200) collate database_default null, --3
	strActualAddress	nvarchar(200) collate database_default null, --4
	strTelephone		nvarchar(200) collate database_default null, --8
	strChief			nvarchar(200) collate database_default null --69
)

DECLARE 
    @idfsLanguage		 bigint,
    @strNameOfRespondent nvarchar(200),
    @strActualAddress	nvarchar(200),
    @strTelephone		nvarchar(200),
	@strOrderNumber		nvarchar(200),
	@strOrderDate		nvarchar(200),
	@strNA				nvarchar(200),
    @strChief			nvarchar(200),
    @idfsSite			bigint,
    @idfsUser			bigint


SET @idfsLanguage = dbo.fnGetLanguageCode (@LangID)

SET @idfsUser = ISNULL(@UserID, dbo.fnUserID())

IF @RayonID IS NULL
BEGIN
  SET @idfsSite = ISNULL(@SiteID, dbo.fnSiteID())
END
ELSE
BEGIN
	SELECT @idfsSite = fnfl.idfsSite
	FROM dbo.fnReportingFacilitiesList(@idfsLanguage, @RayonID) fnfl
  
	IF @idfsSite IS NULL SET @idfsSite = ISNULL(@SiteID, dbo.fnSiteID())
END


SELECT 
    @strActualAddress = dbo.fnAddressSharedString(@LangID, tlbOffice.idfLocation),
    @strTelephone = tlbOffice.strContactPhone,
    @strNameOfRespondent = ISNULL(trtStringNameTranslation.strTextString, trtBaseReference.strDefault)
FROM tlbOffice
    INNER JOIN tstSite
    ON tlbOffice.idfOffice = tstSite.idfOffice
    AND tstSite.intRowStatus = 0

    INNER JOIN trtBaseReference
    ON tlbOffice.idfsOfficeName = trtBaseReference.idfsBaseReference --AND

    LEFT OUTER JOIN trtStringNameTranslation
    ON trtBaseReference.idfsBaseReference = trtStringNameTranslation.idfsBaseReference
    AND trtStringNameTranslation.idfsLanguage = @idfsLanguage 
    AND trtStringNameTranslation.intRowStatus = 0

WHERE tstSite.idfsSite = @idfsSite AND tlbOffice.intRowStatus = 0




select @strOrderNumber = IsNull(RTrim(r.[name]) + N' ', N'')
from fnReferenceRepair(@LangID, 19000132) r -- Additional report Text
  inner join trtBaseReference br
  on br.idfsBaseReference = r.idfsReference
where br.strBaseReferenceCode = N'Order #'


select @strOrderDate =  IsNull(RTrim(r.[name]) + N' ', N'')
from	fnReferenceRepair(@LangID, 19000132) r	-- Additional report Text
  inner join trtBaseReference br
  on br.idfsBaseReference = r.idfsReference
where	br.strBaseReferenceCode = N'Order Date'


select @strNA = IsNull(RTrim(r.[name]) + N' ', N'')
from fnReferenceRepair(@LangID, 19000132) r -- Additional report Text
where r.strDefault = N'N/A'

select
  @strChief = isnull(strFirstName, '') +  isnull(' ' + strFamilyName, '')
from tstUserTable
  inner join tlbPerson
  on tstUserTable.idfPerson = tlbPerson.idfPerson
  and tlbPerson.intRowStatus = 0
where tstUserTable.idfUserID = @idfsUser


insert into @ReportTable
select
  @strOrderNumber,
	@strOrderDate ,
	@strNA,
	@strNameOfRespondent,
	@strActualAddress,
	@strTelephone,
	@strChief

select * 
from @ReportTable
	


