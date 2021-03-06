﻿

--##SUMMARY Select data for Reportable Infectious Diseases (Monthly Form IV03).
--##REMARKS Author: 
--##REMARKS Create date: 10.01.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 22.04.2013

--##REMARKS Updated 30.05.2013 by Romasheva S.

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

exec spRepHumMonthlyInfectiousDiseaseFatal 'ru', '2010-01-01', '2013-02-01',  37020000000, 3260000000

exec spRepHumMonthlyInfectiousDiseaseFatal 'ru', '2010-01-01', '2015-02-01'
*/

create  Procedure [dbo].[spRepHumMonthlyInfectiousDiseaseFatal]
	(
		@LangID		as nvarchar(10), 
		@StartDate	as datetime,	 
		@FinishDate	as datetime,
		@RegionID	as bigint = null,
		@RayonID	as bigint = null,
		@SiteID		as bigint = null
	)
AS	

exec dbo.spSetFirstDay

-- Field description may be found here
-- "https://repos.btrp.net/BTRP/Project_Documents/08x-Implementation/Customizations/GG/Reports/Specification for report development - Monthly Form 03 Human GG v1.0.doc"
-- by number marked red at screen form prototype 

declare	@ReportTable	table
(	strICD10			nvarchar(200) collate database_default null,	--6 
	-- strICD10 should be null!
	intAge_0_1			float not null,	--7
	intAge_1_4			float not null, --8
	intAge_5_14			float not null, --9
	intAge_15_19		float not null, --10
	intAge_20_29		float not null, --11
	intAge_30_59		float not null, --12
	intAge_60_more		float not null, --14
	intLethalCases		float not null, --14
	strSpecifyDiseases  nvarchar(max) --45
)




DECLARE @idfsCustomReportType BIGINT
DECLARE @idfsLanguage BIGINT
DECLARE @idfsSite BIGINT
DECLARE 
    @FFP_Age_0_1 BIGINT,--7
    @FFP_Age_1_4 BIGINT, --8
    @FFP_Age_5_14 BIGINT, --9
    @FFP_Age_15_19 BIGINT, --10
    @FFP_Age_20_29 BIGINT, --11
    @FFP_Age_30_59 BIGINT, --12
    @FFP_Age_60_more BIGINT, --13
    @FFP_LethalCases BIGINT
    
declare @FatalCasesOfInfectiousDiseases bigint

--set @FatalCasesOfInfectiousDiseases = 10750760000000 /*Fatal cases of infectious diseases*/    
select @FatalCasesOfInfectiousDiseases = dg.idfsReportDiagnosisGroup
from dbo.trtReportDiagnosisGroup dg
where dg.intRowStatus = 0 and
      dg.strDiagnosisGroupAlias = 'DG_FatalCasesOfInfectiousDiseases'

SET @idfsLanguage = dbo.fnGetLanguageCode (@LangID)

IF @RayonID IS NULL
BEGIN
  SET @idfsSite = ISNULL(@SiteID, dbo.fnSiteID())
  
END
ELSE
BEGIN
   SELECT @idfsSite = fnfl.idfsSite
   FROM dbo.fnReportingFacilitiesList(@idfsLanguage, @RayonID) fnfl

   IF @idfsSite IS NULL SET @idfsSite = dbo.fnSiteID()
END


SET @idfsCustomReportType = 10290008 /*GG Report on Cases of Infectious Diseases (Monthly Form IV–03/1 Old Revision)*/

select @FFP_Age_0_1 = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Age_0_1'
and intRowStatus = 0

select @FFP_Age_1_4 = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Age_1_4'
and intRowStatus = 0

select @FFP_Age_5_14 = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Age_5_14'
and intRowStatus = 0

select @FFP_Age_15_19 = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Age_15_19'
and intRowStatus = 0

select @FFP_Age_20_29 = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Age_20_29'
and intRowStatus = 0

select @FFP_Age_30_59= idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Age_30_59'
and intRowStatus = 0

select @FFP_Age_60_more= idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Age_60_more'
and intRowStatus = 0

select @FFP_LethalCases= idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_LethalCases'
and intRowStatus = 0


DECLARE	@MonthlyReportDiagnosisTable	TABLE
(	idfsDiagnosis	BIGINT NOT NULL PRIMARY KEY,
  blnIsAggregate BIT,
	intAge_0_1			INT NOT NULL,	--7
	intAge_1_4			INT NOT NULL, --8
	intAge_5_14			INT NOT NULL, --9
	intAge_15_19		INT NOT NULL, --10
	intAge_20_29		INT NOT NULL, --11
	intAge_30_59		INT NOT NULL, --12
	intAge_60_more		INT NOT NULL, --13
	intLethalCases INT NOT NULL
)

INSERT INTO @MonthlyReportDiagnosisTable (
	idfsDiagnosis,
  blnIsAggregate,
	intAge_0_1,
	intAge_1_4,
	intAge_5_14,
	intAge_15_19,
	intAge_20_29,
	intAge_30_59,
	intAge_60_more,
	intLethalCases
	
) 
SELECT DISTINCT
  fdt.idfsDiagnosis,
  CASE WHEN  trtd.idfsUsingType = 10020002  --dutAggregatedCase
    THEN 1
    ELSE 0
  END,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0

FROM dbo.trtDiagnosisToGroupForReportType fdt
    INNER JOIN trtDiagnosis trtd
    ON trtd.idfsDiagnosis = fdt.idfsDiagnosis
    -- AND trtd.intRowStatus = 0
WHERE  fdt.idfsCustomReportType = @idfsCustomReportType 
AND  fdt.idfsReportDiagnosisGroup = @FatalCasesOfInfectiousDiseases /*Fatal cases of infectious diseases*/
       
       
INSERT INTO @MonthlyReportDiagnosisTable (
	idfsDiagnosis,
  blnIsAggregate,
	intAge_0_1,
	intAge_1_4,
	intAge_5_14,
	intAge_15_19,
	intAge_20_29,
	intAge_30_59,
	intAge_60_more,
	intLethalCases
) 
SELECT 
  trtd.idfsDiagnosis,
  CASE WHEN  trtd.idfsUsingType = 10020002  --dutAggregatedCase
    THEN 1
    ELSE 0
  END,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0

FROM dbo.trtReportRows rr
    INNER JOIN trtBaseReference br
    ON br.idfsBaseReference = rr.idfsDiagnosisOrReportDiagnosisGroup
        AND br.idfsReferenceType = 19000019 --'rftDiagnosis'
        --AND br.intRowStatus = 0
    INNER JOIN trtDiagnosis trtd
    ON trtd.idfsDiagnosis = rr.idfsDiagnosisOrReportDiagnosisGroup 
        --AND trtd.intRowStatus = 0
WHERE  rr.idfsCustomReportType = @idfsCustomReportType 
       AND  rr.intRowStatus = 0 
       AND NOT EXISTS 
       (
       SELECT * FROM @MonthlyReportDiagnosisTable
       WHERE idfsDiagnosis = rr.idfsDiagnosisOrReportDiagnosisGroup
       )      AND
       rr.idfsDiagnosisOrReportDiagnosisGroup = @FatalCasesOfInfectiousDiseases /*Fatal cases of infectious diseases*/




       
       
       

DECLARE @MinAdminLevel BIGINT
DECLARE @MinTimeInterval BIGINT
DECLARE @AggrCaseType BIGINT


/*

19000091	rftStatisticPeriodType:
    10091001	sptMonth	Month
    10091002	sptOnday	Day
    10091003	sptQuarter	Quarter
    10091004	sptWeek	Week
    10091005	sptYear	Year

19000089	rftStatisticAreaType
    10089001	satCountry	Country
    10089002	satRayon	Rayon
    10089003	satRegion	Region
    10089004	satSettlement	Settlement


19000102	rftAggregateCaseType:
    10102001  Aggregate Case

*/

SET @AggrCaseType = 10102001

SELECT	@MinAdminLevel = idfsStatisticAreaType,
		@MinTimeInterval = idfsStatisticPeriodType
FROM fnAggregateSettings (@AggrCaseType)--@AggrCaseType



declare	@MonthlyReportHumanAggregateCase	table
(	idfAggrCase	BIGINT not null primary KEY,
  idfCaseObservation BIGINT,
  datStartDate datetime,
  idfVersion bigint
)


insert into	@MonthlyReportHumanAggregateCase
(	idfAggrCase,
  idfCaseObservation,
  datStartDate,
  idfVersion
)
select		a.idfAggrCase,
          a.idfCaseObservation,
		  a.datStartDate,
		  a.idfVersion
from		tlbAggrCase a
    left join	gisCountry c
    on			c.idfsCountry = a.idfsAdministrativeUnit
			    and c.idfsCountry = 780000000
    left join	gisRegion r
    on			r.idfsRegion = a.idfsAdministrativeUnit 
			    and r.idfsCountry = 780000000
    left join	gisRayon rr
    on			rr.idfsRayon = a.idfsAdministrativeUnit
			    and rr.idfsCountry = 780000000
    left join	gisSettlement s
    on			s.idfsSettlement = a.idfsAdministrativeUnit
			    and s.idfsCountry = 780000000

WHERE 			
			a.idfsAggrCaseType = @AggrCaseType
			and (	@StartDate <= a.datStartDate
					and a.datFinishDate < DATEADD(day, 1, @FinishDate)
				)
			and (	(	@MinTimeInterval = 10091005 --'sptYear'
						and DateDiff(year, a.datStartDate, a.datFinishDate) = 0
						and DateDiff(quarter, a.datStartDate, a.datFinishDate) > 1
						and DateDiff(month, a.datStartDate, a.datFinishDate) > 1
						and dbo.fnWeekDatediff(a.datStartDate, a.datFinishDate) > 1
						and DateDiff(day, a.datStartDate, a.datFinishDate) > 1
					)
					or	(	@MinTimeInterval = 10091003 --'sptQuarter'
							and DateDiff(quarter, a.datStartDate, a.datFinishDate) = 0
							and DateDiff(month, a.datStartDate, a.datFinishDate) > 1
							and dbo.fnWeekDatediff(a.datStartDate, a.datFinishDate) > 1
							and DateDiff(day, a.datStartDate, a.datFinishDate) > 1
						)
					or (	@MinTimeInterval = 10091001 --'sptMonth'
							and DateDiff(month, a.datStartDate, a.datFinishDate) = 0
							and dbo.fnWeekDatediff(a.datStartDate, a.datFinishDate) > 1
							and DateDiff(day, a.datStartDate, a.datFinishDate) > 1
						)
					or (	@MinTimeInterval = 10091004 --'sptWeek'
							and dbo.fnWeekDatediff(a.datStartDate, a.datFinishDate) = 0
							and DateDiff(day, a.datStartDate, a.datFinishDate) > 1
						)
					or (	@MinTimeInterval = 10091002--'sptOnday'
						and DateDiff(day, a.datStartDate, a.datFinishDate) = 0)
				)    and		
        (	(	@MinAdminLevel = 10089001 --'satCountry' 
			    and a.idfsAdministrativeUnit = c.idfsCountry
		      )
		    or	(	@MinAdminLevel = 10089003 --'satRegion' 
				    and a.idfsAdministrativeUnit = r.idfsRegion
				    AND (r.idfsRegion = @RegionID OR @RegionID IS NULL)
			    )
		    or	(	@MinAdminLevel = 10089002 --'satRayon' 
				    and a.idfsAdministrativeUnit = rr.idfsRayon
				    AND (rr.idfsRayon = @RayonID OR @RayonID IS NULL) 
				    AND (rr.idfsRegion = @RegionID OR @RegionID IS NULL)
			    )
		    or	(	@MinAdminLevel = 10089004 --'satSettlement' 
				    and a.idfsAdministrativeUnit = s.idfsSettlement
				    AND (s.idfsRayon = @RayonID OR @RayonID IS NULL) 
				    AND (s.idfsRegion = @RegionID OR @RegionID IS NULL)

			    )
	      )
	      
and a.intRowStatus = 0	      


DECLARE	@MonthlyReportAggregateDiagnosisValuesTable	TABLE
(	idfsBaseReference	BIGINT NOT NULL PRIMARY KEY,
	intAge_0_1			INT NULL,	--7
	intAge_1_4			INT NULL, --8
	intAge_5_14			INT NULL, --9
	intAge_15_19		INT NULL, --10
	intAge_20_29		INT NULL, --11
	intAge_30_59		INT NULL, --12
	intAge_60_more		INT NULL, --13
	intLethalCases		INT NOT NULL
)



insert into	@MonthlyReportAggregateDiagnosisValuesTable
(	idfsBaseReference,
	intLethalCases
)
select		
      fdt.idfsDiagnosis,
			sum(CAST(IsNull(agp_LethalCases.varValue, 0)AS INT))

from		@MonthlyReportHumanAggregateCase fhac
-- Updated for version 6

-- Matrix version
inner join	tlbAggrMatrixVersionHeader h
on			h.idfsMatrixType = 71190000000	-- Human Aggregate Case
			and (	-- Get matrix version selected by the user in aggregate case
					h.idfVersion = fhac.idfVersion 
					-- If matrix version is not selected by the user in aggregate case, 
					-- then select active matrix with the latest date activation that is earlier than aggregate case start date
					or (	fhac.idfVersion is null 
							and	h.datStartDate <= fhac.datStartDate
							and	h.blnIsActive = 1
							and not exists	(
										select	*
										from	tlbAggrMatrixVersionHeader h_later
										where	h_later.idfsMatrixType = 71190000000	-- Human Aggregate Case
												and	h_later.datStartDate <= fhac.datStartDate
												and	h_later.blnIsActive = 1
												and h_later.intRowStatus = 0
												and	h_later.datStartDate > h.datStartDate
											)
						))
			and h.intRowStatus = 0

-- Matrix row
inner join	tlbAggrHumanCaseMTX mtx
on			mtx.idfVersion = h.idfVersion
			and mtx.intRowStatus = 0
inner join	@MonthlyReportDiagnosisTable fdt
on			fdt.idfsDiagnosis = mtx.idfsDiagnosis


 
--	LethalCases		
left join	dbo.tlbActivityParameters agp_LethalCases
on			agp_LethalCases.idfObservation = fhac.idfCaseObservation
			and	agp_LethalCases.idfsParameter = @FFP_LethalCases
			and agp_LethalCases.idfRow = mtx.idfAggrHumanCaseMTX
			and agp_LethalCases.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_LethalCases.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
			


group by	fdt.idfsDiagnosis



declare	@MonthlyReportCaseTable	table
(	idfsDiagnosis			BIGINT  not null,
	idfCase				BIGINT not null primary key,
	intYear					int NULL
)

insert into	@MonthlyReportCaseTable
(	idfsDiagnosis,
	idfCase,
	intYear
)
select distinct
			fdt.idfsDiagnosis,
			hc.idfHumanCase AS idfCase,
			case
				when	IsNull(hc.idfsHumanAgeType, -1) = 10042003	-- Years 
						and (IsNull(hc.intPatientAge, -1) >= 0 and IsNull(hc.intPatientAge, -1) <= 200)
					then	hc.intPatientAge
				when	IsNull(hc.idfsHumanAgeType, -1) = 10042002	-- Months
						and (IsNull(hc.intPatientAge, -1) >= 0 and IsNull(hc.intPatientAge, -1) <= 60)
					then	cast(hc.intPatientAge / 12 as int)
				when	IsNull(hc.idfsHumanAgeType, -1) = 10042001	-- Days
						and (IsNull(hc.intPatientAge, -1) >= 0)
					then	0
				else	null
			end
			
FROM tlbHumanCase hc
    INNER JOIN	@MonthlyReportDiagnosisTable fdt
    ON			--fdt.blnIsAggregate = 0 AND 
            fdt.idfsDiagnosis = COALESCE(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis)

    INNER JOIN tlbHuman h
        LEFT OUTER JOIN tlbGeoLocation gl
        ON h.idfCurrentResidenceAddress = gl.idfGeoLocation
		AND gl.intRowStatus = 0
      ON hc.idfHuman = h.idfHuman   AND
         h.intRowStatus = 0
    			
    LEFT OUTER JOIN  tlbGeoLocation cgl
    ON hc.idfPointGeoLocation = cgl.idfGeoLocation
        AND cgl.intRowStatus = 0
			
WHERE	
			(	@StartDate <= ISNULL(hc.datOnSetDate, IsNull(hc.datFinalDiagnosisDate, ISNULL(hc.datTentativeDiagnosisDate, IsNull(hc.datNotificationDate, hc.datEnteredDate))))
					and ISNULL(hc.datOnSetDate, IsNull(hc.datFinalDiagnosisDate, ISNULL(hc.datTentativeDiagnosisDate, IsNull(hc.datNotificationDate, hc.datEnteredDate)))) < DATEADD(day, 1, @FinishDate)
			) AND
		(	
			(	cgl.idfsRegion is not null /*and cgl.idfsRayon is not null*/ and @RegionID is not null
				and (cgl.idfsRegion = @RegionID)
				and (cgl.idfsRayon = @RayonID or @RayonID is null)
			)
			or	(	cgl.idfsRegion is null and gl.idfsRegion is not null /*and gl.idfsRayon is not null*/ and @RegionID is not null
					and (gl.idfsRegion = @RegionID)
					and (gl.idfsRayon = @RayonID or @RayonID is null)
				)
			or @RegionID is null
    )
    AND hc.intRowStatus = 0 
    AND COALESCE(hc.idfsFinalCaseStatus, hc.idfsInitialCaseStatus, 370000000) <> 370000000 --'casRefused'
    AND hc.idfsOutcome = 10770000000 /*outDied*/
    and (cgl.idfsCountry is null or cgl.idfsCountry = 780000000)
    

--Total Age_0_1
declare	@MonthlyReportCaseDiagnosis_Age_0_1_TotalValuesTable	table
(	idfsDiagnosis			BIGINT not null primary key,
	intAge_0_1				INT not null
)

insert into	@MonthlyReportCaseDiagnosis_Age_0_1_TotalValuesTable
(	idfsDiagnosis,
	intAge_0_1
)
select		fct.idfsDiagnosis,
			count(fct.idfCase)
from		@MonthlyReportCaseTable fct
where		(fct.intYear >= 0 and fct.intYear < 1)
group by	fct.idfsDiagnosis


--Total Age_1_4
declare	@MonthlyReportCaseDiagnosis_Age_1_4_TotalValuesTable	table
(	idfsDiagnosis			BIGINT not null primary key,
	intAge_1_4				INT not null
)

insert into	@MonthlyReportCaseDiagnosis_Age_1_4_TotalValuesTable
(	idfsDiagnosis,
	intAge_1_4
)
select		fct.idfsDiagnosis,
			count(fct.idfCase)
from		@MonthlyReportCaseTable fct
where		(fct.intYear >= 1 and fct.intYear <= 4)
group by	fct.idfsDiagnosis


--Total Age_5_14
declare	@MonthlyReportCaseDiagnosis_Age_5_14_TotalValuesTable	table
(	idfsDiagnosis			BIGINT not null primary key,
	intAge_5_14				INT not null
)

insert into	@MonthlyReportCaseDiagnosis_Age_5_14_TotalValuesTable
(	idfsDiagnosis,
	intAge_5_14
)
select		fct.idfsDiagnosis,
			count(fct.idfCase)
from		@MonthlyReportCaseTable fct
where		(fct.intYear >= 5 and fct.intYear <= 14)
group by	fct.idfsDiagnosis


--Total Age_15_19
declare	@MonthlyReportCaseDiagnosis_Age_15_19_TotalValuesTable	table
(	idfsDiagnosis			BIGINT not null primary key,
	intAge_15_19				INT not null
)

insert into	@MonthlyReportCaseDiagnosis_Age_15_19_TotalValuesTable
(	idfsDiagnosis,
	intAge_15_19
)
select		fct.idfsDiagnosis,
			count(fct.idfCase)
from		@MonthlyReportCaseTable fct
where		(fct.intYear >= 15 and fct.intYear <= 19)
group by	fct.idfsDiagnosis


--Total Age_20_29
declare	@MonthlyReportCaseDiagnosis_Age_20_29_TotalValuesTable	table
(	idfsDiagnosis			BIGINT not null primary key,
	intAge_20_29				INT not null
)

insert into	@MonthlyReportCaseDiagnosis_Age_20_29_TotalValuesTable
(	idfsDiagnosis,
	intAge_20_29
)
select		fct.idfsDiagnosis,
			count(fct.idfCase)
from		@MonthlyReportCaseTable fct
where		(fct.intYear >= 20 and fct.intYear <= 29)
group by	fct.idfsDiagnosis


--Total Age_30_59
declare	@MonthlyReportCaseDiagnosis_Age_30_59_TotalValuesTable	table
(	idfsDiagnosis			BIGINT not null primary key,
	intAge_30_59				INT not null
)

insert into	@MonthlyReportCaseDiagnosis_Age_30_59_TotalValuesTable
(	idfsDiagnosis,
	intAge_30_59
)
select		fct.idfsDiagnosis,
			count(fct.idfCase)
from		@MonthlyReportCaseTable fct
where		(fct.intYear >= 30 and fct.intYear <= 59)
group by	fct.idfsDiagnosis


--Total Age_60_more
declare	@MonthlyReportCaseDiagnosis_Age_60_more_TotalValuesTable	table
(	idfsDiagnosis			BIGINT not null primary key,
	intAge_60_more				INT not null
)

insert into	@MonthlyReportCaseDiagnosis_Age_60_more_TotalValuesTable
(	idfsDiagnosis,
	intAge_60_more
)
select		fct.idfsDiagnosis,
			count(fct.idfCase)
from		@MonthlyReportCaseTable fct
where		(fct.intYear >= 60)
group by	fct.idfsDiagnosis

--Total LethalCases
declare	@MonthlyReportCaseDiagnosis_LethalCases_TotalValuesTable	table
(	idfsDiagnosis			BIGINT not null primary key,
	intLethalCases				INT not null
)

insert into	@MonthlyReportCaseDiagnosis_LethalCases_TotalValuesTable
(	idfsDiagnosis,
	intLethalCases
)
select		fct.idfsDiagnosis,
			count(fct.idfCase)
from		@MonthlyReportCaseTable fct
group by	fct.idfsDiagnosis



--aggregate cases
update		fdt
set				
	fdt.intLethalCases = fadvt.intLethalCases		
from		@MonthlyReportDiagnosisTable fdt
    inner join	@MonthlyReportAggregateDiagnosisValuesTable fadvt
    on			fadvt.idfsBaseReference = fdt.idfsDiagnosis
--where		fdt.blnIsAggregate = 1


--standard cases
update		fdt
set			fdt.intAge_0_1 = fcdvt.intAge_0_1
from		@MonthlyReportDiagnosisTable fdt
inner join	@MonthlyReportCaseDiagnosis_Age_0_1_TotalValuesTable fcdvt
on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis
--where		fdt.blnIsAggregate = 0

update		fdt
set			fdt.intAge_1_4 = fcdvt.intAge_1_4
from		@MonthlyReportDiagnosisTable fdt
inner join	@MonthlyReportCaseDiagnosis_Age_1_4_TotalValuesTable fcdvt
on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis
--where		fdt.blnIsAggregate = 0

update		fdt
set			fdt.intAge_5_14 = fcdvt.intAge_5_14
from		@MonthlyReportDiagnosisTable fdt
inner join	@MonthlyReportCaseDiagnosis_Age_5_14_TotalValuesTable fcdvt
on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis
--where		fdt.blnIsAggregate = 0
	
update		fdt
set			fdt.intAge_15_19 = fcdvt.intAge_15_19
from		@MonthlyReportDiagnosisTable fdt
inner join	@MonthlyReportCaseDiagnosis_Age_15_19_TotalValuesTable fcdvt
on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis
--where		fdt.blnIsAggregate = 0	
	
update		fdt
set			fdt.intAge_20_29 = fcdvt.intAge_20_29
from		@MonthlyReportDiagnosisTable fdt
inner join	@MonthlyReportCaseDiagnosis_Age_20_29_TotalValuesTable fcdvt
on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis
--where		fdt.blnIsAggregate = 0		
	
update		fdt
set			fdt.intAge_30_59 = fcdvt.intAge_30_59
from		@MonthlyReportDiagnosisTable fdt
inner join	@MonthlyReportCaseDiagnosis_Age_30_59_TotalValuesTable fcdvt
on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis
--where		fdt.blnIsAggregate = 0		
	
update		fdt
set			fdt.intAge_60_more = fcdvt.intAge_60_more
from		@MonthlyReportDiagnosisTable fdt
inner join	@MonthlyReportCaseDiagnosis_Age_60_more_TotalValuesTable fcdvt
on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis
--where		fdt.blnIsAggregate = 0		
	
	
	
update		fdt
set			fdt.intLethalCases = isnull(fdt.intLethalCases, 0) + fcdvt.intLethalCases
from		@MonthlyReportDiagnosisTable fdt
inner join	@MonthlyReportCaseDiagnosis_LethalCases_TotalValuesTable fcdvt
on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis
--where		fdt.blnIsAggregate = 0		
	
	
	

	

DECLARE	@MonthlyReportDiagnosisGroupTable	TABLE
(	idfsDiagnosisGroup	BIGINT NOT NULL PRIMARY KEY,
	intAge_0_1			INT NOT NULL,	--7
	intAge_1_4			INT NOT NULL, --8
	intAge_5_14			INT NOT NULL, --9
	intAge_15_19		INT NOT NULL, --10
	intAge_20_29		INT NOT NULL, --11
	intAge_30_59		INT NOT NULL, --12
	intAge_60_more		INT NOT NULL, --13
	intLethalCases	INT NULL		
)
	
	
insert into	@MonthlyReportDiagnosisGroupTable
(	idfsDiagnosisGroup,
	intAge_0_1,	
	intAge_1_4, 
	intAge_5_14, 
	intAge_15_19, 
	intAge_20_29, 
	intAge_30_59, 
	intAge_60_more, 
	intLethalCases
)
select		dtg.idfsReportDiagnosisGroup,
	    sum(intAge_0_1),	
	    sum(intAge_1_4), 
	    sum(intAge_5_14), 
	    sum(intAge_15_19), 
	    sum(intAge_20_29), 
	    sum(intAge_30_59), 
	    sum(intAge_60_more), 
	    sum(intLethalCases)
from		@MonthlyReportDiagnosisTable fdt
inner join	dbo.trtDiagnosisToGroupForReportType dtg
on			dtg.idfsDiagnosis = fdt.idfsDiagnosis AND
dtg.idfsCustomReportType = @idfsCustomReportType AND
dtg.idfsReportDiagnosisGroup = @FatalCasesOfInfectiousDiseases /*Fatal cases of infectious diseases*/
group by	dtg.idfsReportDiagnosisGroup	
	
	
declare	@SpecifyDiadnoses	nvarchar(MAX)
set	@SpecifyDiadnoses = N''
select	@SpecifyDiadnoses = IsNull(RTrim(r.[name]) + N' ', N'')
from	fnReferenceRepair(@LangID, 19000132) r	-- Additional report Text
where	r.strDefault = N'Specify disease(s):'

declare	@Separator	nvarchar(10)
set	@Separator = N''

select		@SpecifyDiadnoses = @SpecifyDiadnoses + @Separator + d_ref.[name],
			@Separator = N', '
from	dbo.trtDiagnosisToGroupForReportType	 dtg
inner join	@MonthlyReportDiagnosisTable fdt
on			fdt.idfsDiagnosis = dtg.idfsDiagnosis
			and fdt.intLethalCases > 0
inner join	fnReferenceRepair(@LangID, 19000019 /*rftDiagnosis*/) d_ref
on			d_ref.idfsReference = fdt.idfsDiagnosis
where		dtg.idfsReportDiagnosisGroup = @FatalCasesOfInfectiousDiseases --'dgmFatalCasesOfInfectiousDiseases'


	
	


	

INSERT INTO @ReportTable (
	strICD10,
	intAge_0_1,
	intAge_1_4,
	intAge_5_14,
	intAge_15_19,
	intAge_20_29,
	intAge_30_59,
	intAge_60_more,
  intLethalCases,
	strSpecifyDiseases)
SELECT 
    NULL,
    fdt.intAge_0_1,	
    fdt.intAge_1_4, 
    fdt.intAge_5_14, 
    fdt.intAge_15_19, 
    fdt.intAge_20_29, 
    fdt.intAge_30_59, 
    fdt.intAge_60_more, 
    fdt.intLethalCases,
    @SpecifyDiadnoses
from	@MonthlyReportDiagnosisGroupTable fdt	
	
	


	
select 
	*,
	'some_key' as strKeyField
from @ReportTable
	



