declare @ret int
declare @Logmsg nvarchar(max)
declare @results nvarchar(max)

set @results = ''
set @Logmsg = 'Single Sample'

--declare @strBarCode nvarchar(50)
--set @strBarcode = 'S001170396'

select 
  T.idfTesting,
  @strBarCode as MaterialBarCode, 
  TestName.strDefault as TestName,
  TestCat.strDefault as TestCategory,
  TestResult.strDefault as TestResult,
  TestStatus.strDefault as TestStatus,
  Diagnosis.strDefault as Diagnosis

from dbo.tlbTesting T
join dbo.tlbMaterial M on M.idfMaterial = T.idfMaterial
left join dbo.trtBaseReference TestName on T.idfsTestName = TestName.idfsBaseReference
left join dbo.trtBaseReference TestCat on T.idfsTestCategory = TestCat.idfsBaseReference
left join dbo.trtBaseReference TestResult on T.idfsTestResult = TestResult.idfsBaseReference
left join dbo.trtBaseReference TestStatus on T.idfsTestStatus = TestStatus.idfsBaseReference
left join dbo.trtBaseReference Diagnosis on T.idfsTestStatus = Diagnosis.idfsBaseReference

where M.strBarCode = @strBarCode and M.intRowStatus = 0

