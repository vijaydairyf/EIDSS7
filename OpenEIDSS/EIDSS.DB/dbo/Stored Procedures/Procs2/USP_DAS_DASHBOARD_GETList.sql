USE [EIDSS7_DT]
GO
/****** Object:  StoredProcedure [dbo].[USP_DAS_DASHBOARD_GETList]    Script Date: 11/30/2018 11:30:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--**********************************************************************
-- NAME: USP_DAS_DASHBOARD_GETList
-- DESCRIPTION: Returns a list of dashboard item based on the 
-- user currently logged in and dashboard item
-- AUTHOR: Ricky Moss
-- 
-- Revision History
-- Date				Change Detail
-- 11/21/2018		Initial Release
-- 11/30/2018		Removed the id variables
-- Testing Code:
-- exec USP_DAS_DASHBOARD_GETList 'en', 55541620000032, 'Icon'
-- exec USP_DAS_DASHBOARD_GETList 'en', 55541620000032, 'Grid'
-- exec USP_DAS_DASHBOARD_GETList 'en', 55541620000032, 'Navi'
--**********************************************************************
ALTER PROCEDURE [dbo].[USP_DAS_DASHBOARD_GETList]
(
	@LangId nvarchar(50), 
	@idfPerson BIGINT,
	@dashboardItemType NVARCHAR(50)
)
AS
BEGIN
	BEGIN TRY
		select br.idfsBaseReference, strBaseReferenceCode, snt.strDefault, snt.name as strName, PageLink  from trtBaseReference br
		join lkupEIDSSAppObject ao 
		on br.idfsBaseReference = ao.AppObjectNameID
		join LkupRoleDashboardObject do 
		on ao.AppObjectNameID = do.DashboardObjectID
		left join FN_GBL_ReferenceRepair('en', 19000506) snt 
		on br.idfsBaseReference = snt.idfsReference
		left join tlbEmployeeGroupMember egm 
		on do.RoleID = egm.idfEmployeeGroup
		where strBaseReferenceCode like '%dashB' + @dashboardItemType + '%' and egm.idfEmployee = @idfPerson and egm.idfEmployeeGroup < 0 and ao.intRowStatus = 0
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END