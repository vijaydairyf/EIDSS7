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


Partial Public Class SearchPersonInformationUserControl
    
    '''<summary>
    '''upSearchPerson control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents upSearchPerson As Global.System.Web.UI.UpdatePanel
    
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
    '''hdfSelectMode control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents hdfSelectMode As Global.System.Web.UI.WebControls.HiddenField
    
    '''<summary>
    '''hdfUseHumanMasterIndicator control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents hdfUseHumanMasterIndicator As Global.System.Web.UI.WebControls.HiddenField
    
    '''<summary>
    '''divSelectedRecords control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents divSelectedRecords As Global.System.Web.UI.HtmlControls.HtmlGenericControl
    
    '''<summary>
    '''hdrSelectedRecords control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents hdrSelectedRecords As Global.System.Web.UI.HtmlControls.HtmlGenericControl
    
    '''<summary>
    '''upSelectedRecords control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents upSelectedRecords As Global.System.Web.UI.UpdatePanel
    
    '''<summary>
    '''gvSelectedRecords control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents gvSelectedRecords As Global.System.Web.UI.WebControls.GridView
    
    '''<summary>
    '''btnCancelForm control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents btnCancelForm As Global.System.Web.UI.WebControls.Button
    
    '''<summary>
    '''btnDeduplicate control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents btnDeduplicate As Global.System.Web.UI.WebControls.Button
    
    '''<summary>
    '''pnlSearchForm control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents pnlSearchForm As Global.System.Web.UI.WebControls.Panel
    
    '''<summary>
    '''divPersonSearchUserControlCriteria control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents divPersonSearchUserControlCriteria As Global.System.Web.UI.HtmlControls.HtmlGenericControl
    
    '''<summary>
    '''hdgSearchCriteria control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents hdgSearchCriteria As Global.System.Web.UI.HtmlControls.HtmlGenericControl
    
    '''<summary>
    '''toggleIcon control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents toggleIcon As Global.System.Web.UI.HtmlControls.HtmlGenericControl
    
    '''<summary>
    '''txtEIDSSPersonID control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents txtEIDSSPersonID As Global.System.Web.UI.WebControls.TextBox
    
    '''<summary>
    '''ddlPersonalIDType control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents ddlPersonalIDType As Global.System.Web.UI.WebControls.DropDownList
    
    '''<summary>
    '''txtPersonalID control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents txtPersonalID As Global.System.Web.UI.WebControls.TextBox
    
    '''<summary>
    '''txtLastOrSurname control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents txtLastOrSurname As Global.System.Web.UI.WebControls.TextBox
    
    '''<summary>
    '''txtSecondName control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents txtSecondName As Global.System.Web.UI.WebControls.TextBox
    
    '''<summary>
    '''txtFirstOrGivenName control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents txtFirstOrGivenName As Global.System.Web.UI.WebControls.TextBox
    
    '''<summary>
    '''txtDateOfBirthFrom control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents txtDateOfBirthFrom As Global.EIDSSControlLibrary.CalendarInput
    
    '''<summary>
    '''cvFutureBirthDateFrom control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents cvFutureBirthDateFrom As Global.System.Web.UI.WebControls.CompareValidator
    
    '''<summary>
    '''txtDateOfBirthTo control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents txtDateOfBirthTo As Global.EIDSSControlLibrary.CalendarInput
    
    '''<summary>
    '''cvDateOfBirthRange control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents cvDateOfBirthRange As Global.System.Web.UI.WebControls.CompareValidator
    
    '''<summary>
    '''cvFutureBirthDateTo control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents cvFutureBirthDateTo As Global.System.Web.UI.WebControls.CompareValidator
    
    '''<summary>
    '''ddlGenderTypeID control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents ddlGenderTypeID As Global.System.Web.UI.WebControls.DropDownList
    
    '''<summary>
    '''ucLocation control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents ucLocation As Global.EIDSS.HorizontalLocationUserControl
    
    '''<summary>
    '''divPersonSearchResults control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents divPersonSearchResults As Global.System.Web.UI.HtmlControls.HtmlGenericControl
    
    '''<summary>
    '''hdrSearchResults control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents hdrSearchResults As Global.System.Web.UI.HtmlControls.HtmlGenericControl
    
    '''<summary>
    '''upSearchResults control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents upSearchResults As Global.System.Web.UI.UpdatePanel
    
    '''<summary>
    '''gvHumanMaster control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents gvHumanMaster As Global.System.Web.UI.WebControls.GridView
    
    '''<summary>
    '''divPager control.
    '''</summary>
    '''<remarks>
    '''Auto-generated field.
    '''To modify move field declaration from designer file to code-behind file.
    '''</remarks>
    Protected WithEvents divPager As Global.System.Web.UI.HtmlControls.HtmlGenericControl
    
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
End Class
