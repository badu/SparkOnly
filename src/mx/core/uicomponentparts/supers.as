/**
 *  This property allows access to the Player's native implementation
 *  of the <code>scaleX</code> property, which can be useful since components
 *  can override <code>scaleX</code> and thereby hide the native implementation.
 *  Note that this "base property" is final and cannot be overridden,
 *  so you can count on it to reflect what is happening at the player level.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
mx_internal final function get $scaleX():Number
{
	return super.scaleX;
}

mx_internal final function set $scaleX(value:Number):void
{
	super.scaleX = value;
}

/**
 *  This property allows access to the Player's native implementation
 *  of the <code>scaleY</code> property, which can be useful since components
 *  can override <code>scaleY</code> and thereby hide the native implementation.
 *  Note that this "base property" is final and cannot be overridden,
 *  so you can count on it to reflect what is happening at the player level.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
mx_internal final function get $scaleY():Number
{
	return super.scaleY;
}

mx_internal final function set $scaleY(value:Number):void
{
	super.scaleY = value;
}

//--------------------------------------------------------------------------
//
//  Methods: Access to overridden methods of base classes
//
//--------------------------------------------------------------------------

/**
 *  @private
 *  This method allows access to the Player's native implementation
 *  of addChild(), which can be useful since components
 *  can override addChild() and thereby hide the native implementation.
 *  Note that this "base method" is final and cannot be overridden,
 *  so you can count on it to reflect what is happening at the player level.
 */
mx_internal final function $addChild(child:DisplayObject):DisplayObject
{
	return super.addChild(child);
}

/**
 *  @private
 *  This method allows access to the Player's native implementation
 *  of addChildAt(), which can be useful since components
 *  can override addChildAt() and thereby hide the native implementation.
 *  Note that this "base method" is final and cannot be overridden,
 *  so you can count on it to reflect what is happening at the player level.
 */
mx_internal final function $addChildAt(child:DisplayObject,
									   index:int):DisplayObject
{
	return super.addChildAt(child, index);
}

/**
 *  @private
 *  This method allows access to the Player's native implementation
 *  of removeChild(), which can be useful since components
 *  can override removeChild() and thereby hide the native implementation.
 *  Note that this "base method" is final and cannot be overridden,
 *  so you can count on it to reflect what is happening at the player level.
 */
mx_internal final function $removeChild(child:DisplayObject):DisplayObject
{
	return super.removeChild(child);
}

/**
 *  @private
 *  This method allows access to the Player's native implementation
 *  of removeChildAt(), which can be useful since components
 *  can override removeChildAt() and thereby hide the native implementation.
 *  Note that this "base method" is final and cannot be overridden,
 *  so you can count on it to reflect what is happening at the player level.
 */
mx_internal final function $removeChildAt(index:int):DisplayObject
{
	return super.removeChildAt(index);
}

/**
 *  @private
 *  This method allows access to the Player's native implementation
 *  of setChildIndex(), which can be useful since components
 *  can override setChildIndex() and thereby hide the native implementation.
 *  Note that this "base method" is final and cannot be overridden,
 *  so you can count on it to reflect what is happening at the player level.
 */
mx_internal final function $setChildIndex(child:DisplayObject, index:int):void
{
	super.setChildIndex(child, index);
}
//----------------------------------
//  $alpha
//----------------------------------

/**
 *  @private
 *  This property allows access to the Player's native implementation
 *  of the 'alpha' property, which can be useful since components
 *  can override 'alpha' and thereby hide the native implementation.
 *  Note that this "base property" is final and cannot be overridden,
 *  so you can count on it to reflect what is happening at the player level.
 */
mx_internal final function get $alpha():Number
{
	return super.alpha;
}

/**
 *  @private
 */
mx_internal final function set $alpha(value:Number):void
{
	super.alpha = value;
}

//----------------------------------
//  $blendMode
//----------------------------------

/**
 *  @private
 *  This property allows access to the Player's native implementation
 *  of the 'blendMode' property, which can be useful since components
 *  can override 'alpha' and thereby hide the native implementation.
 *  Note that this "base property" is final and cannot be overridden,
 *  so you can count on it to reflect what is happening at the player level.
 */
mx_internal final function get $blendMode():String
{
	return super.blendMode;
}

/**
 *  @private
 */
mx_internal final function set $blendMode(value:String):void
{
	super.blendMode = value;
}

//----------------------------------
//  $blendShader
//----------------------------------

/**
 *  @private
 */
mx_internal final function set $blendShader(value:Shader):void
{
	super.blendShader = value;
}

//----------------------------------
//  $parent
//----------------------------------

/**
 *  @private
 *  This property allows access to the Player's native implementation
 *  of the 'parent' property, which can be useful since components
 *  can override 'parent' and thereby hide the native implementation.
 *  Note that this "base property" is final and cannot be overridden,
 *  so you can count on it to reflect what is happening at the player level.
 */
mx_internal final function get $parent():DisplayObjectContainer
{
	return super.parent;
}

//----------------------------------
//  $x
//----------------------------------

/**
 *  @private
 *  This property allows access to the Player's native implementation
 *  of the 'x' property, which can be useful since components
 *  can override 'x' and thereby hide the native implementation.
 *  Note that this "base property" is final and cannot be overridden,
 *  so you can count on it to reflect what is happening at the player level.
 */
mx_internal final function get $x():Number
{
	return super.x;
}

/**
 *  @private
 */
mx_internal final function set $x(value:Number):void
{
	super.x = value;
}

//----------------------------------
//  $y
//----------------------------------

/**
 *  @private
 *  This property allows access to the Player's native implementation
 *  of the 'y' property, which can be useful since components
 *  can override 'y' and thereby hide the native implementation.
 *  Note that this "base property" is final and cannot be overridden,
 *  so you can count on it to reflect what is happening at the player level.
 */
mx_internal final function get $y():Number
{
	return super.y;
}

/**
 *  @private
 */
mx_internal final function set $y(value:Number):void
{
	super.y = value;
}

//----------------------------------
//  $width
//----------------------------------

/**
 *  @private
 *  This property allows access to the Player's native implementation
 *  of the 'width' property, which can be useful since components
 *  can override 'width' and thereby hide the native implementation.
 *  Note that this "base property" is final and cannot be overridden,
 *  so you can count on it to reflect what is happening at the player level.
 */
mx_internal final function get $width():Number
{
	return super.width;
}

/**
 *  @private
 */
mx_internal final function set $width(value:Number):void
{
	super.width = value;
}

//----------------------------------
//  $height
//----------------------------------

/**
 *  @private
 *  This property allows access to the Player's native implementation
 *  of the 'height' property, which can be useful since components
 *  can override 'height' and thereby hide the native implementation.
 *  Note that this "base property" is final and cannot be overridden,
 *  so you can count on it to reflect what is happening at the player level.
 */
mx_internal final function get $height():Number
{
	return super.height;
}

/**
 *  @private
 */
mx_internal final function set $height(value:Number):void
{
	super.height = value;
}

//----------------------------------
//  $visible
//----------------------------------

/**
 *  @private
 *  This property allows access to the Player's native implementation
 *  of the 'visible' property, which can be useful since components
 *  can override 'visible' and thereby hide the native implementation.
 *  Note that this "base property" is final and cannot be overridden,
 *  so you can count on it to reflect what is happening at the player level.
 */
mx_internal final function get $visible():Boolean
{
	return super.visible;
}

/**
 *  @private
 */
mx_internal final function set $visible(value:Boolean):void
{
	super.visible = value;
}
/**
 * @private
 * Documentation is not currently available
 */
mx_internal function get $transform():flash.geom.Transform
{
	return super.transform;
}