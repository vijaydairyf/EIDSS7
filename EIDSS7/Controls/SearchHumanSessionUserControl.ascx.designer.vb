﻿'------------------------------------------------------------------------------
' <auto-generated>
'     This code was generated by a tool.
'
'     Changes to this file may cause incorrect behavior and will be lost if
'     the code is regenerated. 
' </auto-generated>
'------------------------------------------------------------------------------

Option Strict On
Option Explicit On


Partial Public Class SearchHumanSessionUserControl
    
    '''<summary>
    '''upSearchHumanMonitoringSession control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents upSearchHumanMonitoringSession As Global.System.Web.UI.UpdatePanel
    
    '''<summary>
    '''hdfSelectMode control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents hdfSelectMode As Global.System.Web.UI.WebControls.HiddenField
    
    '''<summary>
    '''hdfidfUserID control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents hdfidfUserID As Global.System.Web.UI.WebControls.HiddenField
    
    '''<summary>
    '''hdfidfInstitution control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents hdfidfInstitution As Global.System.Web.UI.WebControls.HiddenField
    
    '''<summary>
    '''pnlSearchForm control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents pnlSearchForm As Global.System.Web.UI.WebControls.Panel
    
    '''<summary>
    '''divHumanMonitoringSessionSearchUserControlCriteria control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents divHumanMonitoringSessionSearchUserControlCriteria As Global.System.Web.UI.HtmlControls.HtmlGenericControl
    
    '''<summary>
    '''toggleIcon control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents toggleIcon As Global.System.Web.UI.HtmlControls.HtmlGenericControl
    
    '''<summary>
    '''txtEIDSSSessionID control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents txtEIDSSSessionID As Global.System.Web.UI.WebControls.TextBox
    
    '''<summary>
    '''btnSearchforCampaignID control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents btnSearchforCampaignID As Global.System.Web.UI.HtmlControls.HtmlButton
    
    '''<summary>
    '''txtEIDSSCampaignID control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents txtEIDSSCampaignID As Global.System.Web.UI.WebControls.TextBox
    
    '''<summary>
    '''ddlStatusTypeID control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents ddlStatusTypeID As Global.System.Web.UI.WebControls.DropDownList
    
    '''<summary>
    '''ddlDiseaseID control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents ddlDiseaseID As Global.System.Web.UI.WebControls.DropDownList
    
    '''<summary>
    '''txtDateEnteredFrom control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents txtDateEnteredFrom As Global.EIDSSControlLibrary.CalendarInput
    
    '''<summary>
    '''txtDateEnteredTo control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents txtDateEnteredTo As Global.EIDSSControlLibrary.CalendarInput
    
    '''<summary>
    '''Val_Entered_Date_Compare control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents Val_Entered_Date_Compare As Global.System.Web.UI.WebControls.CompareValidator
    
    '''<summary>
    '''ucLocation control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents ucLocation As Global.EIDSS.HorizontalLocationUserControl
    
    '''<summary>
    '''divHumanSessionSearchResults control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents divHumanSessionSearchResults As Global.System.Web.UI.HtmlControls.HtmlGenericControl
    
    '''<summary>
    '''upSearchResults control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents upSearchResults As Global.System.Web.UI.UpdatePanel
    
    '''<summary>
    '''gvHumanSessions control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents gvHumanSessions As Global.EIDSSControlLibrary.GridView
    
    '''<summary>
    '''lblNumberOfRecords control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents lblNumberOfRecords As Global.System.Web.UI.WebControls.Label
    
    '''<summary>
    '''lblPageNumber control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents lblPageNumber As Global.System.Web.UI.WebControls.Label
    
    '''<summary>
    '''rptPager control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents rptPager As Global.System.Web.UI.WebControls.Repeater
    
    '''<summary>
    '''btnCancel control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents btnCancel As Global.System.Web.UI.WebControls.Button
    
    '''<summary>
    '''btnClear control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents btnClear As Global.System.Web.UI.WebControls.Button
    
    '''<summary>
    '''btnSearch control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents btnSearch As Global.System.Web.UI.WebControls.Button
    
    '''<summary>
    '''btnAddHumanSession control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents btnAddHumanSession As Global.System.Web.UI.WebControls.Button
End Class