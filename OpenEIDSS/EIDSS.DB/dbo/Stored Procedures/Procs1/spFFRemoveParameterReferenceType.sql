﻿

-- =============================================
-- Author:		Leonov E.N.
-- Create date:
-- Description:
-- =============================================
Create Procedure dbo.spFFRemoveParameterReferenceType
(
	@idfsParameterType Bigint
)
AS
BEGIN
	Set Nocount On;	
	
	declare	@ErrorMessage nvarchar(400)
	Select @ErrorMessage = [ErrorMessage] From dbo.fnFFCheckForRemoveParameterType(@ErrorMessage);
	If (@ErrorMessage Is Not Null) Exec dbo.spThrowException @ErrorMessage
	
	-- удаляем все содержимое справочника
	Delete from dbo.ffParameterFixedPresetValue Where idfsParameterType= @idfsParameterType
	
	Delete from dbo.ffParameterType	Where [idfsParameterType] = @idfsParameterType
		
END

