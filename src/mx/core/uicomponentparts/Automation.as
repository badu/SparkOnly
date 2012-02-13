//----------------------------------
//  automationDelegate
//----------------------------------

/**
 *  @private
 */
private var _automationDelegate:IAutomationObject;

/**
 *  The delegate object that handles the automation-related functionality.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get automationDelegate():Object
{
	return _automationDelegate;
}

/**
 *  @private
 */
public function set automationDelegate(value:Object):void
{
	_automationDelegate = value as IAutomationObject;
}

//----------------------------------
//  automationName
//----------------------------------

/**
 *  @private
 *  Storage for the <code>automationName</code> property.
 */
private var _automationName:String = null;

/**
 *  @inheritDoc
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get automationName():String
{
	if (_automationName)
		return _automationName;
	if (automationDelegate)
		return automationDelegate.automationName;
	
	return "";
}

/**
 *  @private
 */
public function set automationName(value:String):void
{
	_automationName = value;
}

/**
 *  @copy mx.automation.IAutomationObject#automationValue
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get automationValue():Array
{
	if (automationDelegate)
		return automationDelegate.automationValue;
	
	return [];
}

//----------------------------------
//  showInAutomationHierarchy
//----------------------------------

/**
 *  @private
 *  Storage for the <code>showInAutomationHierarchy</code> property.
 */
private var _showInAutomationHierarchy:Boolean = true;

/**
 *  @inheritDoc
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get showInAutomationHierarchy():Boolean
{
	return _showInAutomationHierarchy;
}

/**
 *  @private
 */
public function set showInAutomationHierarchy(value:Boolean):void
{
	_showInAutomationHierarchy = value;
}