//----------------------------------
//  initialized
//----------------------------------

/**
 *  @private
 *  Storage for the initialized property.
 */
private var _initialized:Boolean = false;

[Inspectable(environment="none")]

/**
 *  A flag that determines if an object has been through all three phases
 *  of layout: commitment, measurement, and layout (provided that any were required).
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get initialized():Boolean
{
	return _initialized;
}

/**
 *  @private
 */
public function set initialized(value:Boolean):void
{
	_initialized = value;
	
	if (value)
	{
		setVisible(_visible, true);
		dispatchEvent(new FlexEvent(FlexEvent.CREATION_COMPLETE));
	}
}

//----------------------------------
//  processedDescriptors
//----------------------------------

/**
 *  @private
 *  Storage for the processedDescriptors property.
 */
private var _processedDescriptors:Boolean = false;

[Inspectable(environment="none")]

/**
 *  Set to <code>true</code> after immediate or deferred child creation,
 *  depending on which one happens. For a Container object, it is set
 *  to <code>true</code> at the end of
 *  the <code>createComponentsFromDescriptors()</code> method,
 *  meaning after the Container object creates its children from its child descriptors.
 *
 *  <p>For example, if an Accordion container uses deferred instantiation,
 *  the <code>processedDescriptors</code> property for the second pane of
 *  the Accordion container does not become <code>true</code> until after
 *  the user navigates to that pane and the pane creates its children.
 *  But, if the Accordion had set the <code>creationPolicy</code> property
 *  to <code>"all"</code>, the <code>processedDescriptors</code> property
 *  for its second pane is set to <code>true</code> during application startup.</p>
 *
 *  <p>For classes that are not containers, which do not have descriptors,
 *  it is set to <code>true</code> after the <code>createChildren()</code>
 *  method creates any internal component children.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get processedDescriptors():Boolean
{
	return _processedDescriptors;
}

/**
 *  @private
 */
public function set processedDescriptors(value:Boolean):void
{
	_processedDescriptors = value;
	
	if (value)
		dispatchEvent(new FlexEvent(FlexEvent.INITIALIZE));
}

//----------------------------------
//  updateCompletePendingFlag
//----------------------------------

/**
 *  @private
 *  Storage for the updateCompletePendingFlag property.
 */
private var _updateCompletePendingFlag:Boolean = false;

[Inspectable(environment="none")]

/**
 *  A flag that determines if an object has been through all three phases
 *  of layout validation (provided that any were required).
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get updateCompletePendingFlag():Boolean
{
	return _updateCompletePendingFlag;
}

/**
 *  @private
 */
public function set updateCompletePendingFlag(value:Boolean):void
{
	_updateCompletePendingFlag = value;
}