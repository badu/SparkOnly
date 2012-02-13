//----------------------------------
//  percentWidth
//----------------------------------

/**
 *  @private
 *  Storage for the percentWidth property.
 */
private var _percentWidth:Number;

[Bindable("resize")]
[Inspectable(environment="none")]

/**
 *  Specifies the width of a component as a percentage
 *  of its parent's size. Allowed values are 0-100. The default value is NaN.
 *  Setting the <code>width</code> or <code>explicitWidth</code> properties
 *  resets this property to NaN.
 *
 *  <p>This property returns a numeric value only if the property was
 *  previously set; it does not reflect the exact size of the component
 *  in percent.</p>
 *
 *  <p>This property is always set to NaN for the UITextField control.</p>
 * 
 *  <p>When used with Spark layouts, this property is used to calculate the
 *  width of the component's bounds after scaling and rotation. For example 
 *  if the component is rotated at 90 degrees, then specifying 
 *  <code>percentWidth</code> will affect the component's height.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get percentWidth():Number
{
	return _percentWidth;
}

/**
 *  @private
 */
public function set percentWidth(value:Number):void
{
	if (_percentWidth == value)
		return;
	
	if (!isNaN(value))
		_explicitWidth = NaN;
	
	_percentWidth = value;
	
	invalidateParentSizeAndDisplayList();
}

//----------------------------------
//  percentHeight
//----------------------------------

/**
 *  @private
 *  Storage for the percentHeight property.
 */
private var _percentHeight:Number;

[Bindable("resize")]
[Inspectable(environment="none")]

/**
 *  Specifies the height of a component as a percentage
 *  of its parent's size. Allowed values are 0-100. The default value is NaN.
 *  Setting the <code>height</code> or <code>explicitHeight</code> properties
 *  resets this property to NaN.
 *
 *  <p>This property returns a numeric value only if the property was
 *  previously set; it does not reflect the exact size of the component
 *  in percent.</p>
 *
 *  <p>This property is always set to NaN for the UITextField control.</p>
 *  
 *  <p>When used with Spark layouts, this property is used to calculate the
 *  height of the component's bounds after scaling and rotation. For example 
 *  if the component is rotated at 90 degrees, then specifying 
 *  <code>percentHeight</code> will affect the component's width.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get percentHeight():Number
{
	return _percentHeight;
}

/**
 *  @private
 */
public function set percentHeight(value:Number):void
{
	if (_percentHeight == value)
		return;
	
	if (!isNaN(value))
		_explicitHeight = NaN;
	
	_percentHeight = value;
	
	invalidateParentSizeAndDisplayList();
}

//----------------------------------
//  minWidth
//----------------------------------

[Bindable("explicitMinWidthChanged")]
[Inspectable(category="Size", defaultValue="0")]

/**
 *  The minimum recommended width of the component to be considered
 *  by the parent during layout. This value is in the
 *  component's coordinates, in pixels. The default value depends on
 *  the component's implementation.
 *
 *  <p>If the application developer sets the value of minWidth,
 *  the new value is stored in explicitMinWidth. The default value of minWidth
 *  does not change. As a result, at layout time, if
 *  minWidth was explicitly set by the application developer, then the value of
 *  explicitMinWidth is used for the component's minimum recommended width.
 *  If minWidth is not set explicitly by the application developer, then the value of
 *  measuredMinWidth is used.</p>
 *
 *  <p>This value is used by the container in calculating
 *  the size and position of the component.
 *  It is not used by the component itself in determining
 *  its default size.
 *  Thus this property may not have any effect if parented by
 *  Container, or containers that don't factor in
 *  this property.
 *  Because the value is in component coordinates,
 *  the true <code>minWidth</code> with respect to its parent
 *  is affected by the <code>scaleX</code> property.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get minWidth():Number
{
	if (!isNaN(explicitMinWidth))
		return explicitMinWidth;
	
	return measuredMinWidth;
}

/**
 *  @private
 */
public function set minWidth(value:Number):void
{
	if (explicitMinWidth == value)
		return;
	
	explicitMinWidth = value;
}

//----------------------------------
//  minHeight
//----------------------------------

[Bindable("explicitMinHeightChanged")]
[Inspectable(category="Size", defaultValue="0")]

/**
 *  The minimum recommended height of the component to be considered
 *  by the parent during layout. This value is in the
 *  component's coordinates, in pixels. The default value depends on
 *  the component's implementation.
 *
 *  <p>If the application developer sets the value of minHeight,
 *  the new value is stored in explicitMinHeight. The default value of minHeight
 *  does not change. As a result, at layout time, if
 *  minHeight was explicitly set by the application developer, then the value of
 *  explicitMinHeight is used for the component's minimum recommended height.
 *  If minHeight is not set explicitly by the application developer, then the value of
 *  measuredMinHeight is used.</p>
 *
 *  <p>This value is used by the container in calculating
 *  the size and position of the component.
 *  It is not used by the component itself in determining
 *  its default size.
 *  Thus this property may not have any effect if parented by
 *  Container, or containers that don't factor in
 *  this property.
 *  Because the value is in component coordinates,
 *  the true <code>minHeight</code> with respect to its parent
 *  is affected by the <code>scaleY</code> property.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get minHeight():Number
{
	if (!isNaN(explicitMinHeight))
		return explicitMinHeight;
	
	return measuredMinHeight;
}

/**
 *  @private
 */
public function set minHeight(value:Number):void
{
	if (explicitMinHeight == value)
		return;
	
	explicitMinHeight = value;
}

//----------------------------------
//  maxWidth
//----------------------------------

[Bindable("explicitMaxWidthChanged")]
[Inspectable(category="Size", defaultValue="10000")]

/**
 *  The maximum recommended width of the component to be considered
 *  by the parent during layout. This value is in the
 *  component's coordinates, in pixels. The default value of this property is
 *  set by the component developer.
 *
 *  <p>The component developer uses this property to set an upper limit on the
 *  width of the component.</p>
 *
 *  <p>If the application developer overrides the default value of maxWidth,
 *  the new value is stored in explicitMaxWidth. The default value of maxWidth
 *  does not change. As a result, at layout time, if
 *  maxWidth was explicitly set by the application developer, then the value of
 *  explicitMaxWidth is used for the component's maximum recommended width.
 *  If maxWidth is not set explicitly by the user, then the default value is used.</p>
 *
 *  <p>This value is used by the container in calculating
 *  the size and position of the component.
 *  It is not used by the component itself in determining
 *  its default size.
 *  Thus this property may not have any effect if parented by
 *  Container, or containers that don't factor in
 *  this property.
 *  Because the value is in component coordinates,
 *  the true <code>maxWidth</code> with respect to its parent
 *  is affected by the <code>scaleX</code> property.
 *  Some components have no theoretical limit to their width.
 *  In those cases their <code>maxWidth</code> is set to
 *  <code>UIComponent.DEFAULT_MAX_WIDTH</code>.</p>
 *
 *  @default 10000
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get maxWidth():Number
{
	return !isNaN(explicitMaxWidth) ?
		explicitMaxWidth :
		DEFAULT_MAX_WIDTH;
}

/**
 *  @private
 */
public function set maxWidth(value:Number):void
{
	if (explicitMaxWidth == value)
		return;
	
	explicitMaxWidth = value;
}

//----------------------------------
//  maxHeight
//----------------------------------

[Bindable("explicitMaxHeightChanged")]
[Inspectable(category="Size", defaultValue="10000")]

/**
 *  The maximum recommended height of the component to be considered
 *  by the parent during layout. This value is in the
 *  component's coordinates, in pixels. The default value of this property is
 *  set by the component developer.
 *
 *  <p>The component developer uses this property to set an upper limit on the
 *  height of the component.</p>
 *
 *  <p>If the application developer overrides the default value of maxHeight,
 *  the new value is stored in explicitMaxHeight. The default value of maxHeight
 *  does not change. As a result, at layout time, if
 *  maxHeight was explicitly set by the application developer, then the value of
 *  explicitMaxHeight is used for the component's maximum recommended height.
 *  If maxHeight is not set explicitly by the user, then the default value is used.</p>
 *
 *  <p>This value is used by the container in calculating
 *  the size and position of the component.
 *  It is not used by the component itself in determining
 *  its default size.
 * 
 *  Thus this property may not have any effect if parented by
 *  Container, or containers that don't factor in
 *  this property.
 *  Because the value is in component coordinates,
 *  the true <code>maxHeight</code> with respect to its parent
 *  is affected by the <code>scaleY</code> property.
 *  Some components have no theoretical limit to their height.
 *  In those cases their <code>maxHeight</code> is set to
 *  <code>UIComponent.DEFAULT_MAX_HEIGHT</code>.</p>
 *
 *  @default 10000
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get maxHeight():Number
{
	return !isNaN(explicitMaxHeight) ?
		explicitMaxHeight :
		DEFAULT_MAX_HEIGHT;
}

/**
 *  @private
 */
public function set maxHeight(value:Number):void
{
	if (explicitMaxHeight == value)
		return;
	
	explicitMaxHeight = value;
}

//----------------------------------
//  explicitMinWidth
//----------------------------------

/**
 *  @private
 *  Storage for the minWidth property.
 */
mx_internal var _explicitMinWidth:Number;

[Bindable("explicitMinWidthChanged")]
[Inspectable(environment="none")]

/**
 *  The minimum recommended width of the component to be considered
 *  by the parent during layout. This value is in the
 *  component's coordinates, in pixels.
 *
 *  <p>Application developers typically do not set the explicitMinWidth property. Instead, they
 *  set the value of the minWidth property, which sets the explicitMinWidth property. The
 *  value of minWidth does not change.</p>
 *
 *  <p>At layout time, if minWidth was explicitly set by the application developer, then
 *  the value of explicitMinWidth is used. Otherwise, the value of measuredMinWidth
 *  is used.</p>
 *
 *  <p>This value is used by the container in calculating
 *  the size and position of the component.
 *  It is not used by the component itself in determining
 *  its default size.
 *  Thus this property may not have any effect if parented by
 *  Container, or containers that don't factor in
 *  this property.
 *  Because the value is in component coordinates,
 *  the true <code>minWidth</code> with respect to its parent
 *  is affected by the <code>scaleX</code> property.</p>
 *
 *  @default NaN
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get explicitMinWidth():Number
{
	return _explicitMinWidth;
}

/**
 *  @private
 */
public function set explicitMinWidth(value:Number):void
{
	if (_explicitMinWidth == value)
		return;
	
	_explicitMinWidth = value;
	
	// We invalidate size because locking in width
	// may change the measured height in flow-based components.
	invalidateSize();
	invalidateParentSizeAndDisplayList();
	
	dispatchEvent(new Event("explicitMinWidthChanged"));
}

//----------------------------------
//  minHeight
//----------------------------------

/**
 *  @private
 *  Storage for the minHeight property.
 */
mx_internal var _explicitMinHeight:Number;

[Bindable("explictMinHeightChanged")]
[Inspectable(environment="none")]

/**
 *  The minimum recommended height of the component to be considered
 *  by the parent during layout. This value is in the
 *  component's coordinates, in pixels.
 *
 *  <p>Application developers typically do not set the explicitMinHeight property. Instead, they
 *  set the value of the minHeight property, which sets the explicitMinHeight property. The
 *  value of minHeight does not change.</p>
 *
 *  <p>At layout time, if minHeight was explicitly set by the application developer, then
 *  the value of explicitMinHeight is used. Otherwise, the value of measuredMinHeight
 *  is used.</p>
 *
 *  <p>This value is used by the container in calculating
 *  the size and position of the component.
 *  It is not used by the component itself in determining
 *  its default size.
 *  Thus this property may not have any effect if parented by
 *  Container, or containers that don't factor in
 *  this property.
 *  Because the value is in component coordinates,
 *  the true <code>minHeight</code> with respect to its parent
 *  is affected by the <code>scaleY</code> property.</p>
 *
 *  @default NaN
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get explicitMinHeight():Number
{
	return _explicitMinHeight;
}

/**
 *  @private
 */
public function set explicitMinHeight(value:Number):void
{
	if (_explicitMinHeight == value)
		return;
	
	_explicitMinHeight = value;
	
	// We invalidate size because locking in height
	// may change the measured width in flow-based components.
	invalidateSize();
	invalidateParentSizeAndDisplayList();
	
	dispatchEvent(new Event("explicitMinHeightChanged"));
}

//----------------------------------
//  explicitMaxWidth
//----------------------------------

/**
 *  @private
 *  Storage for the maxWidth property.
 */
mx_internal var _explicitMaxWidth:Number;

[Bindable("explicitMaxWidthChanged")]
[Inspectable(environment="none")]

/**
 *  The maximum recommended width of the component to be considered
 *  by the parent during layout. This value is in the
 *  component's coordinates, in pixels.
 *
 *  <p>Application developers typically do not set the explicitMaxWidth property. Instead, they
 *  set the value of the maxWidth property, which sets the explicitMaxWidth property. The
 *  value of maxWidth does not change.</p>
 *
 *  <p>At layout time, if maxWidth was explicitly set by the application developer, then
 *  the value of explicitMaxWidth is used. Otherwise, the default value for maxWidth
 *  is used.</p>
 *
 *  <p>This value is used by the container in calculating
 *  the size and position of the component.
 *  It is not used by the component itself in determining
 *  its default size.
 *  Thus this property may not have any effect if parented by
 *  Container, or containers that don't factor in
 *  this property.
 *  Because the value is in component coordinates,
 *  the true <code>maxWidth</code> with respect to its parent
 *  is affected by the <code>scaleX</code> property.
 *  Some components have no theoretical limit to their width.
 *  In those cases their <code>maxWidth</code> is set to
 *  <code>UIComponent.DEFAULT_MAX_WIDTH</code>.</p>
 *
 *  @default NaN
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get explicitMaxWidth():Number
{
	return _explicitMaxWidth;
}

/**
 *  @private
 */
public function set explicitMaxWidth(value:Number):void
{
	if (_explicitMaxWidth == value)
		return;
	
	_explicitMaxWidth = value;
	
	// Se invalidate size because locking in width
	// may change the measured height in flow-based components.
	invalidateSize();
	invalidateParentSizeAndDisplayList();
	
	dispatchEvent(new Event("explicitMaxWidthChanged"));
}

//----------------------------------
//  explicitMaxHeight
//----------------------------------

/**
 *  @private
 *  Storage for the maxHeight property.
 */
mx_internal var _explicitMaxHeight:Number;

[Bindable("explicitMaxHeightChanged")]
[Inspectable(environment="none")]

/**
 *  The maximum recommended height of the component to be considered
 *  by the parent during layout. This value is in the
 *  component's coordinates, in pixels.
 *
 *  <p>Application developers typically do not set the explicitMaxHeight property. Instead, they
 *  set the value of the maxHeight property, which sets the explicitMaxHeight property. The
 *  value of maxHeight does not change.</p>
 *
 *  <p>At layout time, if maxHeight was explicitly set by the application developer, then
 *  the value of explicitMaxHeight is used. Otherwise, the default value for maxHeight
 *  is used.</p>
 *
 *  <p>This value is used by the container in calculating
 *  the size and position of the component.
 *  It is not used by the component itself in determining
 *  its default size.
 *  Thus this property may not have any effect if parented by
 *  Container, or containers that don't factor in
 *  this property.
 *  Because the value is in component coordinates,
 *  the true <code>maxHeight</code> with respect to its parent
 *  is affected by the <code>scaleY</code> property.
 *  Some components have no theoretical limit to their height.
 *  In those cases their <code>maxHeight</code> is set to
 *  <code>UIComponent.DEFAULT_MAX_HEIGHT</code>.</p>
 *
 *  @default NaN
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get explicitMaxHeight():Number
{
	return _explicitMaxHeight;
}

/**
 *  @private
 */
public function set explicitMaxHeight(value:Number):void
{
	if (_explicitMaxHeight == value)
		return;
	
	_explicitMaxHeight = value;
	
	// Se invalidate size because locking in height
	// may change the measured width in flow-based components.
	invalidateSize();
	invalidateParentSizeAndDisplayList();
	
	dispatchEvent(new Event("explicitMaxHeightChanged"));
}

//----------------------------------
//  explicitWidth
//----------------------------------

/**
 *  @private
 *  Storage for the explicitWidth property.
 */
private var _explicitWidth:Number;

[Bindable("explicitWidthChanged")]
[Inspectable(environment="none")]

/**
 *  Number that specifies the explicit width of the component,
 *  in pixels, in the component's coordinates.
 *
 *  <p>This value is used by the container in calculating
 *  the size and position of the component.
 *  It is not used by the component itself in determining
 *  its default size.
 *  Thus this property may not have any effect if parented by
 *  Container, or containers that don't factor in
 *  this property.
 *  Because the value is in component coordinates,
 *  the true <code>explicitWidth</code> with respect to its parent
 *  is affected by the <code>scaleX</code> property.</p>
 *  <p>Setting the <code>width</code> property also sets this property to
 *  the specified width value.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get explicitWidth():Number
{
	return _explicitWidth;
}

/**
 *  @private
 */
public function set explicitWidth(value:Number):void
{
	if (_explicitWidth == value)
		return;
	
	// width can be pixel or percent not both
	if (!isNaN(value))
		_percentWidth = NaN;
	
	_explicitWidth = value;
	
	// We invalidate size because locking in width
	// may change the measured height in flow-based components.
	invalidateSize();
	invalidateParentSizeAndDisplayList();
	
	dispatchEvent(new Event("explicitWidthChanged"));
}

//----------------------------------
//  explicitHeight
//----------------------------------

/**
 *  @private
 *  Storage for the explicitHeight property.
 */
private var _explicitHeight:Number;

[Bindable("explicitHeightChanged")]
[Inspectable(environment="none")]

/**
 *  Number that specifies the explicit height of the component,
 *  in pixels, in the component's coordinates.
 *
 *  <p>This value is used by the container in calculating
 *  the size and position of the component.
 *  It is not used by the component itself in determining
 *  its default size.
 *  Thus this property may not have any effect if parented by
 *  Container, or containers that don't factor in
 *  this property.
 *  Because the value is in component coordinates,
 *  the true <code>explicitHeight</code> with respect to its parent
 *  is affected by the <code>scaleY</code> property.</p>
 *  <p>Setting the <code>height</code> property also sets this property to
 *  the specified height value.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get explicitHeight():Number
{
	return _explicitHeight;
}

/**
 *  @private
 */
public function set explicitHeight(value:Number):void
{
	if (_explicitHeight == value)
		return;
	
	// height can be pixel or percent, not both
	if (!isNaN(value))
		_percentHeight = NaN;
	
	_explicitHeight = value;
	
	// We invalidate size because locking in height
	// may change the measured width in flow-based components.
	invalidateSize();
	invalidateParentSizeAndDisplayList();
	
	dispatchEvent(new Event("explicitHeightChanged"));
}

//----------------------------------
//  hasComplexLayoutMatrix
//----------------------------------

/**
 * @private
 *
 * when false, the transform on this component consists only of translation.  Otherwise, it may be arbitrarily complex.
 */
private var _hasComplexLayoutMatrix:Boolean = false;

/**
 *  Returns <code>true</code> if the UIComponent has any non-translation (x,y) transform properties.
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
protected function get hasComplexLayoutMatrix():Boolean
{
	// we set _hasComplexLayoutMatrix when any scale or rotation transform gets set
	// because sometimes when those are set, we don't allocate a layoutFeatures object.
	
	// if the flag isn't set, we def. don't have a complex layout matrix.
	// if the flag is set and we don't have an AdvancedLayoutFeatures object, 
	// then we'll check the transform and see if it's actually transformed.
	// otherwise we'll check the layoutMatrix on the AdvancedLayoutFeatures object, 
	// to see if we're actually transformed.
	if (!_hasComplexLayoutMatrix)
		return false;
	else
	{
		if (_layoutFeatures == null)
		{
			_hasComplexLayoutMatrix = !MatrixUtil.isDeltaIdentity(super.transform.matrix);
			return _hasComplexLayoutMatrix;
		}
		else
		{
			return !MatrixUtil.isDeltaIdentity(_layoutFeatures.layoutMatrix);
		}
	}
}

//----------------------------------
//  includeInLayout
//----------------------------------

/**
 *  @private
 *  Storage for the includeInLayout property.
 */
private var _includeInLayout:Boolean = true;

[Bindable("includeInLayoutChanged")]
[Inspectable(category="General", defaultValue="true")]

/**
 *  Specifies whether this component is included in the layout of the
 *  parent container.
 *  If <code>true</code>, the object is included in its parent container's
 *  layout and is sized and positioned by its parent container as per its layout rules.
 *  If <code>false</code>, the object size and position are not affected by its parent container's
 *  layout.
 * 
 *  @default true
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get includeInLayout():Boolean
{
	return _includeInLayout;
}

/**
 *  @private
 */
public function set includeInLayout(value:Boolean):void
{
	if (_includeInLayout != value)
	{
		_includeInLayout = value;
		
		var p:IInvalidating = parent as IInvalidating;
		if (p)
		{
			p.invalidateSize();
			p.invalidateDisplayList();
		}
		
		dispatchEvent(new Event("includeInLayoutChanged"));
	}
}

//----------------------------------
//  layoutDirection
//----------------------------------

/**
 *  Checked at commitProperties() time to see if our layoutDirection has changed,
 *  or our parent's layoutDirection has changed.  This variable is reset after the 
 *  entire validateProperties() phase is complete so that it's possible for a child
 *  to check if its parent's layoutDirection has changed, see commitProperties().
 *  The flag is cleared in validateDisplayList().
 */
mx_internal var oldLayoutDirection:String = LayoutDirection.LTR;

/**
 *  @inheritDoc
 */
public function get layoutDirection():String
{
	if (layoutDirectionCachedValue == LAYOUT_DIRECTION_CACHE_UNSET)
	{
		layoutDirectionCachedValue = getStyle("layoutDirection");
	}
	return layoutDirectionCachedValue;
}

/**
 *  @private
 *  Changes to the layoutDirection style cause an invalidateProperties() call,
 *  see StyleProtoChain/styleChanged().  At commitProperties() time we use
 *  invalidateLayoutDirection() to add/remove the mirroring transform.
 * 
 *  layoutDirection=undefined or layoutDirection=null has the same effect
 *  as setStyle(“layoutDirection”, undefined).
 */
public function set layoutDirection(value:String):void
{
	// Set the value to null to inherit the layoutDirection.
	if (value == null)
		setStyle("layoutDirection", undefined);
	else
		setStyle("layoutDirection", value);
}