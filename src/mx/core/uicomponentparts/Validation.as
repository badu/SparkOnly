/**
 *  @private
 */
mx_internal var saveBorderColor:Boolean = true;

/**
 *  @private
 */
mx_internal var origBorderColor:Number;

//--------------------------------------------------------------------------
//
//  Variables: Other
//
//--------------------------------------------------------------------------

/**
 *  @private
 *  Storage for automatically-created RadioButtonGroups.
 *  If a RadioButton's groupName isn't the id of a RadioButtonGroup tag,
 *  we automatically create a RadioButtonGroup and store it here as
 *  document.automaticRadioButtonGroups[groupName] = theRadioButtonGroup;
 */
mx_internal var automaticRadioButtonGroups:Object;

private var _usingBridge:int = -1;

/**
 *  @private
 */
private function get usingBridge():Boolean
{
	if (_usingBridge == 0) return false;
	if (_usingBridge == 1) return true;
	
	if (!_systemManager) return false;
	
	// no types so no dependencies
	var mp:Object = _systemManager.getImplementation("mx.managers::IMarshalSystemManager");
	if (!mp)
	{
		_usingBridge = 0;
		return false;
	}
	if (mp.useSWFBridge())
	{
		_usingBridge = 1;
		return true;
	}
	_usingBridge = 0;
	return false;
}
//----------------------------------
//  errorString
//----------------------------------

/**
 *  @private
 *  Storage for errorString property.
 */
mx_internal var _errorString:String = "";

/**
 *  @private
 *  Storage for previous errorString property.
 */
private var oldErrorString:String = "";

/**
 *  @private
 *  Individual error messages from validators
 */
private var errorArray:Array;

/**
 *  @private
 *  Array of validators who gave error messages
 */
private var errorObjectArray:Array;

/**
 *  @private
 *  Flag set when error string changes.
 */
private var errorStringChanged:Boolean = false;

[Bindable("errorStringChanged")]

/**
 *  The text that displayed by a component's error tip when a
 *  component is monitored by a Validator and validation fails.
 *
 *  <p>You can use the <code>errorString</code> property to show a
 *  validation error for a component, without actually using a validator class.
 *  When you write a String value to the <code>errorString</code> property,
 *  Flex draws a red border around the component to indicate the validation error,
 *  and the String appears in a tooltip as the validation error message when you move
 *  the mouse over the component, just as if a validator detected a validation error.</p>
 *
 *  <p>To clear the validation error, write an empty String, "",
 *  to the <code>errorString</code> property.</p>
 *
 *  <p>Note that writing a value to the <code>errorString</code> property
 *  does not trigger the valid or invalid events; it only changes the border
 *  color and displays the validation error message.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get errorString():String
{
	return _errorString;
}

/**
 *  @private
 */
public function set errorString(value:String):void
{
	if (value == _errorString)
		return;
	
	oldErrorString = _errorString;
	_errorString = value;
	
	errorStringChanged = true;
	invalidateProperties();
	dispatchEvent(new Event("errorStringChanged"));
}

/**
 *  @private
 *  Set the appropriate borderColor based on errorString.
 *  If we have an errorString, use errorColor. If we don't
 *  have an errorString, restore the original borderColor.
 */
private function setBorderColorForErrorString():void
{
	var showErrorSkin:Boolean = getStyle("showErrorSkin");
	
	if (showErrorSkin)
	{
		
		if (!_errorString || _errorString.length == 0)
		{
			if (!isNaN(origBorderColor))
			{
				setStyle("borderColor", origBorderColor);
				saveBorderColor = true;
			}
		}
		else
		{
			// Remember the original border color
			if (saveBorderColor)
			{
				saveBorderColor = false;
				origBorderColor = getStyle("borderColor");
			}
			
			setStyle("borderColor", getStyle("errorColor"));
		}
				
		var focusObj:DisplayObject = focusManager ?
			DisplayObject(focusManager.getFocus()) :
			null;
		if (focusManager && focusManager.showFocusIndicator &&
			focusObj == this)
		{
			drawFocus(true);
		}
		
	}
}

//----------------------------------
//  validationSubField
//----------------------------------

/**
 *  @private
 *  Storage for the validationSubField property.
 */
private var _validationSubField:String;

/**
 *  Used by a validator to associate a subfield with this component.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get validationSubField():String
{
	return _validationSubField;
}

/**
 *  @private
 */
public function set validationSubField(value:String):void
{
	_validationSubField = value;
}

/**
 *  Handles both the <code>valid</code> and <code>invalid</code> events from a
 *  validator assigned to this component.
 *
 *  <p>You typically handle the <code>valid</code> and <code>invalid</code> events
 *  dispatched by a validator by assigning event listeners to the validators.
 *  If you want to handle validation events directly in the component that is being validated,
 *  you can override this method to handle the <code>valid</code>
 *  and <code>invalid</code> events. You typically call
 *  <code>super.validationResultHandler(event)</code> in your override.</p>
 *
 *  @param event The event object for the validation.
 *
 *  @see mx.events.ValidationResultEvent
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function validationResultHandler(event:ValidationResultEvent):void
{
	if (errorObjectArray === null)
	{
		errorObjectArray = new Array();
		errorArray = new Array();
	}
	
	var validatorIndex:int = errorObjectArray.indexOf(event.target);
	// If we are valid, then clear the error string
	if (event.type == ValidationResultEvent.VALID)
	{
		if (validatorIndex != -1)
		{
			errorObjectArray.splice(validatorIndex, 1);
			errorArray.splice(validatorIndex, 1);
			errorString = errorArray.join("\n");
			if (errorArray.length == 0)
				dispatchEvent(new FlexEvent(FlexEvent.VALID));
		}
	}
	else // If we get an invalid event
	{
		var msg:String;
		var result:ValidationResult;
		
		// We are associated with a subfield
		if (validationSubField != null && validationSubField != "" && event.results)
		{
			for (var i:int = 0; i < event.results.length; i++)
			{
				result = event.results[i];
				// Find the result that is meant for us
				if (result.subField == validationSubField)
				{
					if (result.isError)
					{
						msg = result.errorMessage;
					}
					else
					{
						if (validatorIndex != -1)
						{
							errorObjectArray.splice(validatorIndex, 1);
							errorArray.splice(validatorIndex, 1);
							errorString = errorArray.join("\n");
							if (errorArray.length == 0)
								dispatchEvent(new FlexEvent(FlexEvent.VALID));
						}
					}
					break;
				}
			}
		}
		else if (event.results && event.results.length > 0)
		{
			msg = event.results[0].errorMessage;
		}
		
		if (msg && validatorIndex != -1)
		{
			// Handle the case where this target already had this invalid
			// event and the errorString has been cleared.
			errorArray[validatorIndex] = msg;
			errorString = errorArray.join("\n");
			dispatchEvent(new FlexEvent(FlexEvent.INVALID));
		}
		else if (msg && validatorIndex == -1)
		{
			errorObjectArray.push(event.target);
			errorArray.push(msg);
			errorString = errorArray.join("\n");
			dispatchEvent(new FlexEvent(FlexEvent.INVALID));
		}
	}
}