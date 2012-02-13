//----------------------------------
//  contentMouseX
//----------------------------------

/**
 *  Returns the <i>x</i> position of the mouse, in the content coordinate system.
 *  Content coordinates specify a pixel position relative to the upper left
 *  corner of the component's content, and include all of the component's
 *  content area, including any regions that are currently clipped and must
 *  be accessed by scrolling the component.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get contentMouseX():Number
{
	return mouseX;
}

//----------------------------------
//  contentMouseY
//----------------------------------

/**
 *  Returns the <i>y</i> position of the mouse, in the content coordinate system.
 *  Content coordinates specify a pixel position relative to the upper left
 *  corner of the component's content, and include all of the component's
 *  content area, including any regions that are currently clipped and must
 *  be accessed by scrolling the component.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get contentMouseY():Number
{
	return mouseY;
}

//----------------------------------
//  tweeningProperties
//----------------------------------

/**
 *  @private
 */
private var _tweeningProperties:Array;

[Inspectable(environment="none")]

/**
 *  Array of properties that are currently being tweened on this object.
 *
 *  <p>Used to alert the EffectManager that certain properties of this object
 *  are being tweened, so that the EffectManger doesn't attempt to animate
 *  the same properties.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get tweeningProperties():Array
{
	return _tweeningProperties;
}

/**
 *  @private
 */
public function set tweeningProperties(value:Array):void
{
	_tweeningProperties = value;
}