'------------------------------------------------------------------------------
' <auto-generated>
'     This code was generated by a tool.
'     Runtime Version:4.0.30319.42000
'
'     Changes to this file may cause incorrect behavior and will be lost if
'     the code is regenerated.
' </auto-generated>
'------------------------------------------------------------------------------

Option Strict On
Option Explicit On

Imports System

Namespace Resources
    
    'This class was auto-generated by the StronglyTypedResourceBuilder
    'class via a tool like ResGen or Visual Studio.
    'To add or remove a member, edit your .ResX file then rerun ResGen
    'with the /str option or rebuild the Visual Studio project.
    '''<summary>
    '''  A strongly-typed resource class, for looking up localized strings, etc.
    '''</summary>
    <Global.System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.VisualStudio.Web.Application.StronglyTypedResourceProxyBuilder", "15.0.0.0"),  _
     Global.System.Diagnostics.DebuggerNonUserCodeAttribute(),  _
     Global.System.Runtime.CompilerServices.CompilerGeneratedAttribute()>  _
    Friend Class WarningMessages
        
        Private Shared resourceMan As Global.System.Resources.ResourceManager
        
        Private Shared resourceCulture As Global.System.Globalization.CultureInfo
        
        <Global.System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1811:AvoidUncalledPrivateCode")>  _
        Friend Sub New()
            MyBase.New
        End Sub
        
        '''<summary>
        '''  Returns the cached ResourceManager instance used by this class.
        '''</summary>
        <Global.System.ComponentModel.EditorBrowsableAttribute(Global.System.ComponentModel.EditorBrowsableState.Advanced)>  _
        Friend Shared ReadOnly Property ResourceManager() As Global.System.Resources.ResourceManager
            Get
                If Object.ReferenceEquals(resourceMan, Nothing) Then
                    Dim temp As Global.System.Resources.ResourceManager = New Global.System.Resources.ResourceManager("Resources.WarningMessages", Global.System.Reflection.[Assembly].Load("App_GlobalResources"))
                    resourceMan = temp
                End If
                Return resourceMan
            End Get
        End Property
        
        '''<summary>
        '''  Overrides the current thread's CurrentUICulture property for all
        '''  resource lookups using this strongly typed resource class.
        '''</summary>
        <Global.System.ComponentModel.EditorBrowsableAttribute(Global.System.ComponentModel.EditorBrowsableState.Advanced)>  _
        Friend Shared Property Culture() As Global.System.Globalization.CultureInfo
            Get
                Return resourceCulture
            End Get
            Set
                resourceCulture = value
            End Set
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to Unable to delete this record as it is dependent on another object..
        '''</summary>
        Friend Shared ReadOnly Property Another_Object_Message() As String
            Get
                Return ResourceManager.GetString("Another_Object_Message", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to The lab test record has associated interpretation records. Please delete the interpretation records first..
        '''</summary>
        Friend Shared ReadOnly Property Associated_Interpretations() As String
            Get
                Return ResourceManager.GetString("Associated_Interpretations", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to The sample record has associated test records. Please delete the test records first..
        '''</summary>
        Friend Shared ReadOnly Property Associated_Lab_Test_Records() As String
            Get
                Return ResourceManager.GetString("Associated_Lab_Test_Records", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to The sample record has associated penside test records. Please delete the penside test records first..
        '''</summary>
        Friend Shared ReadOnly Property Associated_Penside_Tests() As String
            Get
                Return ResourceManager.GetString("Associated_Penside_Tests", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to The species record has associated records. Please delete the associated records first..
        '''</summary>
        Friend Shared ReadOnly Property Associated_Records_To_Species() As String
            Get
                Return ResourceManager.GetString("Associated_Records_To_Species", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to The test record has associated result summary records. Please delete the result summary records first..
        '''</summary>
        Friend Shared ReadOnly Property Associated_Result_Summaries() As String
            Get
                Return ResourceManager.GetString("Associated_Result_Summaries", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to A veterinary disease report record is associated with this selection..
        '''</summary>
        Friend Shared ReadOnly Property Associated_Sessions() As String
            Get
                Return ResourceManager.GetString("Associated_Sessions", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to The flock record has associated species records. Please delete the species records first..
        '''</summary>
        Friend Shared ReadOnly Property Associated_Species_Records_Flock() As String
            Get
                Return ResourceManager.GetString("Associated_Species_Records_Flock", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to The herd record has associated species records. Please delete the species records first..
        '''</summary>
        Friend Shared ReadOnly Property Associated_Species_Records_Herd() As String
            Get
                Return ResourceManager.GetString("Associated_Species_Records_Herd", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to Are you sure you want to cancel all changes and leave this record?.
        '''</summary>
        Friend Shared ReadOnly Property Cancel_Add_Update_Confirm() As String
            Get
                Return ResourceManager.GetString("Cancel_Add_Update_Confirm", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to Are you sure you want to cancel this selection?.
        '''</summary>
        Friend Shared ReadOnly Property Cancel_Confirm() As String
            Get
                Return ResourceManager.GetString("Cancel_Confirm", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to Do you want to cancel all changes and close this form?.
        '''</summary>
        Friend Shared ReadOnly Property Cancel_Form_Confirm() As String
            Get
                Return ResourceManager.GetString("Cancel_Form_Confirm", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to Are you sure you want to cancel the search?.
        '''</summary>
        Friend Shared ReadOnly Property Cancel_Search_Confirm() As String
            Get
                Return ResourceManager.GetString("Cancel_Search_Confirm", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to An error occurred while deleting.  If this continues, please contact the website&apos;s administrator..
        '''</summary>
        Friend Shared ReadOnly Property Cannot_Delete() As String
            Get
                Return ResourceManager.GetString("Cannot_Delete", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to An error occurred while saving.  If this continues, please contact the website&apos;s administrator..
        '''</summary>
        Friend Shared ReadOnly Property Cannot_Save() As String
            Get
                Return ResourceManager.GetString("Cannot_Save", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to Session’s {Disease, Species-Sample Type combination, Start Date} does not match the Campaign and cannot be selected..
        '''</summary>
        Friend Shared ReadOnly Property Cannot_Select_Veterinary_Monitoring_Session_To_Campaign_Messgage() As String
            Get
                Return ResourceManager.GetString("Cannot_Select_Veterinary_Monitoring_Session_To_Campaign_Messgage", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to Unable to delete this record as it contains dependent child objects..
        '''</summary>
        Friend Shared ReadOnly Property Child_Objects_Message() As String
            Get
                Return ResourceManager.GetString("Child_Objects_Message", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to You are about to delete this {1}. Do you wish to continue?.
        '''</summary>
        Friend Shared ReadOnly Property Confirm_Delete() As String
            Get
                Return ResourceManager.GetString("Confirm_Delete", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to Are you sure you want to delete this record?.
        '''</summary>
        Friend Shared ReadOnly Property Confirm_Delete_Message() As String
            Get
                Return ResourceManager.GetString("Confirm_Delete_Message", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to You are about to delete this Farm. Do you wish to continue?.
        '''</summary>
        Friend Shared ReadOnly Property Confirm_Farm_Delete() As String
            Get
                Return ResourceManager.GetString("Confirm_Farm_Delete", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to The Farm address does not match the Session location. Do you want to continue?.
        '''</summary>
        Friend Shared ReadOnly Property Confirm_Farm_Monitoring_Session_Address_Mismatch() As String
            Get
                Return ResourceManager.GetString("Confirm_Farm_Monitoring_Session_Address_Mismatch", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to Do you want to merge record?.
        '''</summary>
        Friend Shared ReadOnly Property Confirm_Merge_Record() As String
            Get
                Return ResourceManager.GetString("Confirm_Merge_Record", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to You are about to delete this Person. Do you wish to continue?.
        '''</summary>
        Friend Shared ReadOnly Property Confirm_Person_Delete() As String
            Get
                Return ResourceManager.GetString("Confirm_Person_Delete", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to You are about to delete this session. Do you wish to continue?.
        '''</summary>
        Friend Shared ReadOnly Property Confirm_Session_Delete() As String
            Get
                Return ResourceManager.GetString("Confirm_Session_Delete", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to You are about to delete this Species Sample. Do you wish to continue?.
        '''</summary>
        Friend Shared ReadOnly Property Confirm_Species_Samples_Delete() As String
            Get
                Return ResourceManager.GetString("Confirm_Species_Samples_Delete", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to Duplicate record(s) have been found: .
        '''</summary>
        Friend Shared ReadOnly Property Duplicate_Record_Found() As String
            Get
                Return ResourceManager.GetString("Duplicate_Record_Found", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to . Do you want to continue saving this record?.
        '''</summary>
        Friend Shared ReadOnly Property Duplicate_Record_Found_Closing_Question() As String
            Get
                Return ResourceManager.GetString("Duplicate_Record_Found_Closing_Question", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to Duplicate Record Found.
        '''</summary>
        Friend Shared ReadOnly Property Duplicate_Record_SubHeading() As String
            Get
                Return ResourceManager.GetString("Duplicate_Record_SubHeading", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to The species type selected has already been added to the selected flock..
        '''</summary>
        Friend Shared ReadOnly Property Duplicate_Species_Flock() As String
            Get
                Return ResourceManager.GetString("Duplicate_Species_Flock", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to The species type selected has already been added to the selected herd..
        '''</summary>
        Friend Shared ReadOnly Property Duplicate_Species_Herd() As String
            Get
                Return ResourceManager.GetString("Duplicate_Species_Herd", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to EIDSS Error Message.
        '''</summary>
        Friend Shared ReadOnly Property Error_Message_Text() As String
            Get
                Return ResourceManager.GetString("Error_Message_Text", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to The farm record does not have a selected Farm Type (Avian or Livestock).  Please select the Farm Type on the Farm Information Section..
        '''</summary>
        Friend Shared ReadOnly Property Farm_Type_Unselected() As String
            Get
                Return ResourceManager.GetString("Farm_Type_Unselected", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to Field-value pair(s) found with no selection. All field-value pairs must contain a selected value to survive..
        '''</summary>
        Friend Shared ReadOnly Property Field_Value_Pair_Found_No_Selection() As String
            Get
                Return ResourceManager.GetString("Field_Value_Pair_Found_No_Selection", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to There are no flocks / livestock associated with this farm. Do you wish to continue?.
        '''</summary>
        Friend Shared ReadOnly Property Flock_Herd_Species() As String
            Get
                Return ResourceManager.GetString("Flock_Herd_Species", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to Unable to Delete Record.
        '''</summary>
        Friend Shared ReadOnly Property Has_Child_Records_SubHeading() As String
            Get
                Return ResourceManager.GetString("Has_Child_Records_SubHeading", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to Date of birth is not valid..
        '''</summary>
        Friend Shared ReadOnly Property Invalid_DOB() As String
            Get
                Return ResourceManager.GetString("Invalid_DOB", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to Please enter at least one search parameter..
        '''</summary>
        Friend Shared ReadOnly Property Search_Criteria_Required() As String
            Get
                Return ResourceManager.GetString("Search_Criteria_Required", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to An error occurred on this page. Please verify your information to resolve the issue..
        '''</summary>
        Friend Shared ReadOnly Property Unhandled_Exception() As String
            Get
                Return ResourceManager.GetString("Unhandled_Exception", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to The validation error could not be determined.  Please contact the website&apos;s administrator for further assistance..
        '''</summary>
        Friend Shared ReadOnly Property Validator_Section() As String
            Get
                Return ResourceManager.GetString("Validator_Section", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to Unable to Get Validator Section.
        '''</summary>
        Friend Shared ReadOnly Property Validator_Section_SubHeading() As String
            Get
                Return ResourceManager.GetString("Validator_Section_SubHeading", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to EIDSS Warning Message.
        '''</summary>
        Friend Shared ReadOnly Property Warning_Message_Alert() As String
            Get
                Return ResourceManager.GetString("Warning_Message_Alert", resourceCulture)
            End Get
        End Property
    End Class
End Namespace
