﻿

-- =============================================
-- Author:		Leonov E.N.
-- Create date:
-- Description:
-- =============================================
Create Procedure dbo.spFFSaveLine
(
	@idfDecorElement Bigint Output
   ,@idfsDecorElementType Bigint 
   ,@LangID Nvarchar(50) = Null
   ,@idfsFormTemplate Bigint
   ,@idfsSection Bigint
   ,@intLeft int
   ,@intTop int
   ,@intWidth int
   ,@intHeight int
   ,@intColor int
   ,@blnOrientation Bit = Null
)
AS
BEGIN
	Set Nocount On;
	
	If (@LangID Is Null) Set @LangID = 'en';
	Declare @langid_int Bigint
	Set @langid_int = dbo.fnGetLanguageCode(@LangID);
	
	-- если id < 0, значит, это временный id и нужно заменить его на настоящий
	If (@idfDecorElement < 0) Exec dbo.[spsysGetNewID] @idfDecorElement Output

	
	If Not Exists (Select Top 1 1 From dbo.ffDecorElement Where [idfDecorElement] = @idfDecorElement) BEGIN
		 Insert into [dbo].[ffDecorElement]
           (
           		[idfDecorElement]
				,[idfsDecorElementType]
				,[idfsLanguage]
				,[idfsFormTemplate]
				,[idfsSection]
           )
		Values
           (
           		@idfDecorElement
			   ,@idfsDecorElementType 
			   ,@langid_int
			   ,@idfsFormTemplate
			   ,@idfsSection
           )          
           Insert into [dbo].[ffDecorElementLine]
           (
           		[idfDecorElement]
           		,[intLeft]
				,[intTop]
				,[intWidth]
				,[intHeight]			
				,[intColor]
				,[blnOrientation]	
           )
           Values
           (
           		@idfDecorElement
           		,@intLeft
			    ,@intTop
				,@intWidth
				,@intHeight			 
			    ,@intColor
			    ,@blnOrientation
           )          
           
	End Else BEGIN
	      Update [dbo].[ffDecorElement]
           Set            		
				 [idfsDecorElementType] = @idfsDecorElementType
				,[idfsLanguage] = @langid_int
				,[idfsFormTemplate] = @idfsFormTemplate
				,[idfsSection] = @idfsSection
				,[intRowStatus] = 0
	      Where
				[idfDecorElement] = @idfDecorElement
				
		  Update [dbo].[ffDecorElementLine]
           Set
            	[intLeft] = @intLeft
				,[intTop] = @intTop
				,[intWidth] = @intWidth
				,[intHeight] = @intHeight			
				,[intColor] = @intColor
				,[blnOrientation]	 = @blnOrientation
				,[intRowStatus] = 0
			Where
				[idfDecorElement] = @idfDecorElement            
	End
	
END

