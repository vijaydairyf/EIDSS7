﻿Imports System.Reflection
Imports EIDSS.Client.API_Clients
Imports EIDSS.Client.Responses
Imports EIDSS.EIDSS
Imports EIDSSControlLibrary
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts

Public Class SearchVeterinarySessionUserControl
    Inherits UserControl

#Region "Global Values"

    Public fileName As String

    Private userSettingsFile As String

    Private Const SectionSearchCriteria As String = "Search Criteria"
    Private Const SectionSearchResults As String = "Search Results"
    Private Const SEARCH_FARM_TYPE As String = "SearchFarmType"
    Private Const PAGE_KEY As String = "Page"
    Private Const HIDE_SEARCH_CRITERIA_SCRIPT As String = "hideVeterinaryMonitoringSessionSearchCriteria();"
    Private Const SHOW_SEARCH_CRITERIA_SCRIPT As String = "showVeterinaryMonitoringSessionSearchCriteria();"
    Private Const SESSION_VETERINARY_SESSION_LIST As String = "gvVeterinarySessions_List"
    Private Const SORT_DIRECTION As String = "gvVeterinarySessions_SortDirection"
    Private Const SORT_EXPRESSION As String = "gvVeterinarySessions_SortExpression"
    Private Const PAGINATION_SET_NUMBER As String = "gvVeterinaryMonitoringSessions_PaginationSet"

    Public Event ValidatePage()
    Public Event ShowWarningModal(messageType As MessageType, isConfirm As Boolean)
    Public Event CreateVeterinarySessionRecord()
    Public Event CancelVeterinarySessionRecord()
    Public Event ViewVeterinarySessionRecord(veterinaryMonitoringSessionID As Long)
    Public Event EditVeterinarySessionRecord(veterinaryMonitoringSessionID As Long)
    Public Event DeleteVeterinarySessionRecord(veterinaryMonitoringSessionID As Long)
    Public Event SelectVeterinarySessionRecord(veterinaryMonitoringSessionID As Long, eidssSessionID As String, diseaseID As Long)
    Public Event SelectVeterinarySessionRecordData(veterinaryMonitoringSession As VctMonitoringSessionGetListModel)

    Private VeterinaryAPIService As VeterinaryServiceClient
    Private CrossCuttingAPIService As CrossCuttingServiceClient
    Private Shared Log = log4net.LogManager.GetLogger(GetType(SearchVeterinarySessionUserControl))

#End Region

#Region "Initialize Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load

        Try
            If (Not IsPostBack) Then
                Log.Info(MethodBase.GetCurrentMethod().Name & " entered.")
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        Finally
            Log.Info(MethodBase.GetCurrentMethod().Name & " exited.")
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="selectMode"></param>
    Public Sub Setup(Optional selectMode As SelectModes = SelectModes.Label)

        Try
            Log.Info(MethodBase.GetCurrentMethod().Name & " entered.")

            Reset()

            upSearchCriteria.Update()
            upSearchResults.Update()

            FillForm()

            ExtractViewStateSession()

            hdfSelectMode.Value = selectMode

            'Changing visibility of some functions, depending on situation
            'Leaving this case open for future expansion...if necessary.
            Select Case selectMode
                Case SelectModes.Selection
                    btnAddSession.Visible = False
                Case Else
            End Select

            Dim parameters = New MonitoringSessionGetListParameters()
            Scatter(divVeterinaryMonitoringSessionSearchUserControlCriteria, ReadSearchCriteriaJSON(parameters, CreateTempFile(EIDSSAuthenticatedUser.EIDSSUserId.ToString(), ID)), 3)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        Finally
            Log.Info(MethodBase.GetCurrentMethod().Name & " exited.")
        End Try

    End Sub

    Public Sub Reset()

        ResetForm(divVeterinaryMonitoringSessionSearchUserControlCriteria)
        ResetForm(ucLocation)

        ViewState(SORT_DIRECTION) = SortConstants.Descending
        ViewState(SORT_EXPRESSION) = "EIDSSSessionID"
        ViewState(PAGINATION_SET_NUMBER) = 1

        ToggleVisibility(SectionSearchCriteria)

        'Restore search filters
        userSettingsFile = CreateTempFile(EIDSSAuthenticatedUser.EIDSSUserId.ToString(), ID)

        txtEIDSSSessionID.Focus()

        gvVeterinaryMonitoringSessions.PageSize = ConfigurationManager.AppSettings("PageSize")

    End Sub

#End Region

#Region "Common Methods"

    ''' <summary>
    ''' Retrieves and saves VieState file.
    ''' </summary>
    Private Sub ExtractViewStateSession()

        Try
            Dim nvcViewState As NameValueCollection = GetViewState(True)
            If Not nvcViewState Is Nothing Then
                For Each key As String In nvcViewState.Keys
                    ViewState(key) = nvcViewState.Item(key)
                Next
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="section"></param>
    Private Sub ToggleVisibility(ByVal section As String)

        divVeterinaryMonitoringSessionSearchResults.Visible = section.Equals(SectionSearchResults)
        toggleIcon.Visible = section.Equals(SectionSearchResults)
        btnAddSession.Visible = section.Equals(SectionSearchResults)
        btnPrintSearchResults.Visible = section.Equals(SectionSearchResults)
        btnCancelSearchResults.Visible = section.Equals(SectionSearchResults)

    End Sub

#End Region

#Region "Search Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub FillForm()

        FillBaseReferenceDropDownList(ddlStatusTypeID, BaseReferenceConstants.ASSessionStatus, (HACodeList.LivestockHACode + HACodeList.AvianHACode), True)
        FillBaseReferenceDropDownList(ddlDiseaseID, BaseReferenceConstants.Diagnosis, (HACodeList.LivestockHACode + HACodeList.AvianHACode), True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Search_Click(sender As Object, e As EventArgs) Handles btnSearch.Click

        Try
            If ValidateSearch() Then
                Dim parameters As New MonitoringSessionGetListParameters With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = 1}
                Dim controls As New List(Of Control)
                controls.Clear()
                For Each ddl As DropDownList In FindControlList(controls, ucLocation, GetType(DropDownList))
                    If ddl.ClientID.Contains("ddlucLocationidfsRegion") = True Then
                        If Not ddl.SelectedValue = GlobalConstants.NullValue.ToLower() Then
                            parameters.RegionID = CType(ddl.SelectedValue, Long)
                        End If
                    End If

                    If ddl.ClientID.Contains("ddlucLocationidfsRayon") = True Then
                        If Not ddl.SelectedValue = GlobalConstants.NullValue.ToLower() And Not ddl.SelectedValue = "" Then
                            parameters.RayonID = CType(ddl.SelectedValue, Long)
                        End If
                    End If
                Next

                If VeterinaryAPIService Is Nothing Then
                    VeterinaryAPIService = New VeterinaryServiceClient()
                End If
                Dim list = VeterinaryAPIService.GetMonitoringSessionCountAsync(Gather(divVeterinaryMonitoringSessionSearchUserControlCriteria, parameters, 3)).Result
                hdfSearchCount.Value = list.FirstOrDefault().RecordCount
                If list.FirstOrDefault().RecordCount = 1 Then
                    lblRecordCount.Text = list.FirstOrDefault().RecordCount & " " & Resources.Labels.Lbl_Record_Found_Text & list.FirstOrDefault().TotalCount & " " & Resources.Labels.Lbl_Total_Records_Text
                Else
                    lblRecordCount.Text = list.FirstOrDefault().RecordCount & " " & Resources.Labels.Lbl_Records_Found_Text & list.FirstOrDefault().TotalCount & " " & Resources.Labels.Lbl_Total_Records_Text
                End If
                lblPageNumber.Text = "1"
                FillVeterinaryMonitoringSessionsList(pageIndex:=1, paginationSetNumber:=1)
                gvVeterinaryMonitoringSessions.PageIndex = 0
                SaveSearchCriteriaJSON(parameters, CreateTempFile(EIDSSAuthenticatedUser.EIDSSUserId.ToString(), ID))
                ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), PAGE_KEY, HIDE_SEARCH_CRITERIA_SCRIPT, True)
                ToggleVisibility(SectionSearchResults)
                upSearchResultsCommands.Update()
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <returns></returns>
    Private Function ValidateSearch() As Boolean

        Dim validated As Boolean = False

        'Check if EIDSS Session ID is entered.
        'If Yes then ignore rest of the search fields.
        'If No, check if any other search criteria is entered, if not, raise error.
        validated = (Not txtEIDSSSessionID.Text.IsValueNullOrEmpty())

        If Not validated Then
            Dim controls As New List(Of Control)

            controls.Clear()
            For Each txt As TextBox In FindControlList(controls, divVeterinaryMonitoringSessionSearchUserControlCriteria, GetType(TextBox))
                If Not validated Then validated = (Not txt.Text.ToString().IsValueNullOrEmpty())
            Next

            If Not validated Then
                controls.Clear()
                For Each rdb As RadioButton In FindControlList(controls, divVeterinaryMonitoringSessionSearchUserControlCriteria, GetType(RadioButton))
                    If Not validated Then validated = (rdb.Checked)
                Next
            End If

            If Not validated Then
                controls.Clear()
                For Each ddl As WebControls.DropDownList In FindControlList(controls, divVeterinaryMonitoringSessionSearchUserControlCriteria, GetType(WebControls.DropDownList))
                    If Not validated Then validated = (Not ddl.SelectedValue.ToString().IsValueNullOrEmpty())
                Next
            End If

            If Not validated Then
                controls.Clear()
                For Each txt As CalendarInput In FindControlList(controls, divVeterinaryMonitoringSessionSearchUserControlCriteria, GetType(CalendarInput))
                    If Not validated Then validated = (Not txt.Text.ToString().IsValueNullOrEmpty())
                Next
            End If

            If Not validated Then
                controls.Clear()
                If Not validated Then validated = (Not ucLocation.SelectedRegionValue.EqualsAny({GlobalConstants.NullValue.ToLower(), "-1"}))
                If Not validated Then validated = (Not ucLocation.SelectedRayonValue.EqualsAny({GlobalConstants.NullValue.ToLower(), "-1"}))
            End If
        End If

        If validated Then
            ToggleVisibility(SectionSearchResults)
        Else
            RaiseEvent ShowWarningModal(MessageType.SearchCriteriaRequired, False)
            txtEIDSSSessionID.Focus()
        End If

        Return validated

    End Function

    Protected Sub GridViewSelection_OnDataBinding(sender As Object, e As EventArgs)

        Dim bHide As Boolean = True
        Dim sm As SelectModes = hdfSelectMode.Value

        Select Case sender.Id.ToString()
            Case "btnEdit"
            Case "btnDelete"
            Case Else
                bHide = False
        End Select

        If (bHide And sm = SelectModes.Selection) Then
            Dim lb As LinkButton = CType(sender, LinkButton)
            lb.Visible = False
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="pageIndex"></param>
    ''' <param name="paginationSetNumber"></param>
    Private Sub FillVeterinaryMonitoringSessionsList(pageIndex As Integer, paginationSetNumber As Integer)

        Try
            Dim list = New List(Of VctMonitoringSessionGetListModel)()
            Dim parameters = New MonitoringSessionGetListParameters With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = paginationSetNumber}
            parameters = Gather(Me, parameters)

            Dim controls As New List(Of Control)
            controls.Clear()
            For Each ddl As DropDownList In FindControlList(controls, ucLocation, GetType(DropDownList))
                If ddl.ClientID.Contains("ddlucLocationidfsRegion") = True Then
                    If Not ddl.SelectedValue = GlobalConstants.NullValue.ToLower() Then
                        parameters.RegionID = CType(ddl.SelectedValue, Long)
                    End If
                End If

                If ddl.ClientID.Contains("ddlucLocationidfsRayon") = True Then
                    If Not ddl.SelectedValue = GlobalConstants.NullValue.ToLower() And Not ddl.SelectedValue = "" Then
                        parameters.RayonID = CType(ddl.SelectedValue, Long)
                    End If
                End If
            Next
            If VeterinaryAPIService Is Nothing Then
                VeterinaryAPIService = New VeterinaryServiceClient()
            End If
            list = VeterinaryAPIService.GetMonitoringSessionListAsync(parameters).Result
            Session(SESSION_VETERINARY_SESSION_LIST) = list
            BindGridView()
            FillPager(hdfSearchCount.Value, pageIndex)
            ViewState(PAGINATION_SET_NUMBER) = paginationSetNumber
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="recordCount"></param>
    ''' <param name="currentPage"></param>
    Private Sub FillPager(ByVal recordCount As Integer, ByVal currentPage As Integer)

        Dim pages As New List(Of ListItem)()
        Dim startIndex As Integer, endIndex As Integer
        Dim pagerSpan As Integer = 5

        If recordCount > 0 Then
            divPager.Visible = True

            'Calculate the start and end index of pages to be displayed.
            Dim dblPageCount As Double = recordCount / Convert.ToDecimal(10)
            Dim pageCount As Integer = Math.Ceiling(dblPageCount)
            startIndex = If(currentPage > 1 AndAlso currentPage + pagerSpan - 1 < pagerSpan, currentPage, 1)
            endIndex = If(pageCount > pagerSpan, pagerSpan, pageCount)
            If currentPage > pagerSpan Mod 2 Then
                If currentPage = 2 Then
                    endIndex = 5
                Else
                    endIndex = currentPage + 2
                End If
            Else
                endIndex = (pagerSpan - currentPage) + 1
            End If

            If endIndex - (pagerSpan - 1) > startIndex Then
                startIndex = endIndex - (pagerSpan - 1)
            End If

            If endIndex > pageCount Then
                endIndex = pageCount
                startIndex = If(((endIndex - pagerSpan) + 1) > 0, (endIndex - pagerSpan) + 1, 1)
            End If

            'Add the First Page Button.
            If currentPage > 1 Then
                pages.Add(New ListItem(PagingConstants.FirstButtonText, "1"))
            End If

            'Add the Previous Button.
            If currentPage > 1 Then
                pages.Add(New ListItem(PagingConstants.PreviousButtonText, (currentPage - 1).ToString()))
            End If

            Dim paginationSetNumber As Integer = 1,
            pageCounter As Integer = 1

            For i As Integer = startIndex To endIndex
                pages.Add(New ListItem(i.ToString(), i.ToString(), i <> currentPage))
            Next

            'Add the Next Button.
            If currentPage < pageCount Then
                pages.Add(New ListItem(PagingConstants.NextButtonText, (currentPage + 1).ToString()))
            End If

            'Add the Last Button.
            If currentPage <> pageCount Then
                pages.Add(New ListItem(PagingConstants.LastButtonText, pageCount.ToString()))
            End If
            rptPager.DataSource = pages
            rptPager.DataBind()
        Else
            divPager.Visible = False
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Page_Changed(ByVal sender As Object, ByVal e As EventArgs)

        Dim pageIndex As Integer = Integer.Parse(CType(sender, LinkButton).CommandArgument)

        lblPageNumber.Text = pageIndex.ToString()

        Dim paginationSetNumber As Integer = Math.Ceiling(pageIndex / gvVeterinaryMonitoringSessions.PageSize)

        If Not ViewState(PAGINATION_SET_NUMBER) = paginationSetNumber Then
            Select Case CType(sender, LinkButton).Text
                Case PagingConstants.PreviousButtonText
                    gvVeterinaryMonitoringSessions.PageIndex = gvVeterinaryMonitoringSessions.PageSize - 1
                Case PagingConstants.NextButtonText
                    gvVeterinaryMonitoringSessions.PageIndex = 0
                Case PagingConstants.FirstButtonText
                    gvVeterinaryMonitoringSessions.PageIndex = 0
                Case PagingConstants.LastButtonText
                    gvVeterinaryMonitoringSessions.PageIndex = 0
                Case Else
                    If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                        gvVeterinaryMonitoringSessions.PageIndex = gvVeterinaryMonitoringSessions.PageSize - 1
                    Else
                        gvVeterinaryMonitoringSessions.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                    End If
            End Select

            FillVeterinaryMonitoringSessionsList(pageIndex, paginationSetNumber:=paginationSetNumber)
        Else
            If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                gvVeterinaryMonitoringSessions.PageIndex = gvVeterinaryMonitoringSessions.PageSize - 1
            Else
                gvVeterinaryMonitoringSessions.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
            End If
            BindGridView()
            FillPager(hdfSearchCount.Value, pageIndex)
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub BindGridView()

        Dim list As List(Of VctMonitoringSessionGetListModel) = CType(Session(SESSION_VETERINARY_SESSION_LIST), List(Of VctMonitoringSessionGetListModel))

        If (Not ViewState(SORT_EXPRESSION) Is Nothing) Then
            If ViewState(SORT_DIRECTION) = SortConstants.Ascending Then
                list = list.OrderBy(Function(x) x.GetType().GetProperty(ViewState(SORT_EXPRESSION)).GetValue(x)).ToList()
            Else
                list = list.OrderByDescending(Function(x) x.GetType().GetProperty(ViewState(SORT_EXPRESSION)).GetValue(x)).ToList()
            End If
        End If

        gvVeterinaryMonitoringSessions.DataSource = list
        gvVeterinaryMonitoringSessions.DataBind()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Clear_Click(sender As Object, e As EventArgs) Handles btnClear.Click

        Try
            Reset()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Cancel_Click(sender As Object, e As EventArgs) Handles btnCancelSearchCriteria.Click, btnCancelSearchResults.Click

        Try

            Dim sm As SelectModes = hdfSelectMode.Value

            If (sm = Global.EIDSS.EIDSS.SelectModes.Selection) Then
                RaiseEvent CancelVeterinarySessionRecord()
            End If

            SaveEIDSSViewState(ViewState)

            RaiseEvent ShowWarningModal(MessageType.CancelSearchConfirm, True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub VeterinaryMonitoringSessions_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvVeterinaryMonitoringSessions.Sorting

        Try
            ViewState(SORT_DIRECTION) = IIf(ViewState(SORT_DIRECTION) = SortConstants.Ascending, SortConstants.Descending, SortConstants.Ascending)
            ViewState(SORT_EXPRESSION) = e.SortExpression

            BindGridView()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub VeterinaryMonitoringSessions_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvVeterinaryMonitoringSessions.RowCommand

        Try
            If Not e.CommandName.ToString = GridViewCommandConstants.PageCommand And Not e.CommandName = GridViewCommandConstants.SortCommand Then
                e.Handled = True

                Select Case e.CommandName
                    Case GridViewCommandConstants.DeleteCommand
                        RaiseEvent DeleteVeterinarySessionRecord(e.CommandArgument)
                    Case GridViewCommandConstants.EditCommand
                        RaiseEvent EditVeterinarySessionRecord(e.CommandArgument)
                    Case GridViewCommandConstants.SelectCommand
                        Dim commandArguments As String() = e.CommandArgument.ToString().Split(",")
                        RaiseEvent SelectVeterinarySessionRecord(commandArguments(0), commandArguments(1), commandArguments(2))
                    Case GridViewCommandConstants.SelectRecordCommand
                        Dim monitoringSessions = CType(Session(SESSION_VETERINARY_SESSION_LIST), List(Of VctMonitoringSessionGetListModel))
                        RaiseEvent SelectVeterinarySessionRecordData(monitoringSessions.Where(Function(x) x.VeterinaryMonitoringSessionID = e.CommandArgument).FirstOrDefault())
                End Select
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub AddSession_Click(sender As Object, e As EventArgs) Handles btnAddSession.Click

        Try
            RaiseEvent CreateVeterinarySessionRecord()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

#End Region

End Class