/**
 *  @private
 *  Holds the last recorded value of the x property.
 *  Used in dispatching a MoveEvent.
 */
private var oldX:Number = 0;

/**
 *  @private
 *  Holds the last recorded value of the y property.
 *  Used in dispatching a MoveEvent.
 */
private var oldY:Number = 0;

/**
 *  @private
 *  Holds the last recorded value of the width property.
 *  Used in dispatching a ResizeEvent.
 */
private var oldWidth:Number = 0;

/**
 *  @private
 *  Holds the last recorded value of the height property.
 *  Used in dispatching a ResizeEvent.
 */
private var oldHeight:Number = 0;

/**
 *  @private
 *  Holds the last recorded value of the minWidth property.
 */
private var oldMinWidth:Number;

/**
 *  @private
 *  Holds the last recorded value of the minHeight property.
 */
private var oldMinHeight:Number;

/**
 *  @private
 *  Holds the last recorded value of the explicitWidth property.
 */
private var oldExplicitWidth:Number;

/**
 *  @private
 *  Holds the last recorded value of the explicitHeight property.
 */
private var oldExplicitHeight:Number;

/**
 *  @private
 *  Holds the last recorded value of the scaleX property.
 */
private var oldScaleX:Number = 1.0;

/**
 *  @private
 *  Holds the last recorded value of the scaleY property.
 */
private var oldScaleY:Number = 1.0;

/**
 *  @private
 * True if createInFontContext has been called.
 */
private var hasFontContextBeenSaved:Boolean = false;

/**
 *  @private
 * Holds the last recorded value of the module factory used to create the font.
 */
private var oldEmbeddedFontContext:IFlexModuleFactory = null;

/**
 * @private
 *
 * storage for advanced layout and transform properties.
 */
mx_internal var _layoutFeatures:AdvancedLayoutFeatures;

/**
 * @private
 *
 * storage for the modified Transform object that can dispatch change events correctly.
 */
private var _transform:flash.geom.Transform;

//----------------------------------
//  measuredMinWidth
//----------------------------------

/**
 *  @private
 *  Storage for the measuredMinWidth property.
 */
private var _measuredMinWidth:Number = 0;

[Inspectable(environment="none")]

/**
 *  The default minimum width of the component, in pixels.
 *  This value is set by the <code>measure()</code> method.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get measuredMinWidth():Number
{
	return _measuredMinWidth;
}

/**
 *  @private
 */
public function set measuredMinWidth(value:Number):void
{
	_measuredMinWidth = value;
}

//----------------------------------
//  measuredMinHeight
//----------------------------------

/**
 *  @private
 *  Storage for the measuredMinHeight property.
 */
private var _measuredMinHeight:Number = 0;

[Inspectable(environment="none")]

/**
 *  The default minimum height of the component, in pixels.
 *  This value is set by the <code>measure()</code> method.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get measuredMinHeight():Number
{
	return _measuredMinHeight;
}

/**
 *  @private
 */
public function set measuredMinHeight(value:Number):void
{
	_measuredMinHeight = value;
}

//----------------------------------
//  measuredWidth
//----------------------------------

/**
 *  @private
 *  Storage for the measuredWidth property.
 */
private var _measuredWidth:Number = 0;

[Inspectable(environment="none")]

/**
 *  The default width of the component, in pixels.
 *  This value is set by the <code>measure()</code> method.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get measuredWidth():Number
{
	return _measuredWidth;
}

/**
 *  @private
 */
public function set measuredWidth(value:Number):void
{
	_measuredWidth = value;
}

//----------------------------------
//  measuredHeight
//----------------------------------

/**
 *  @private
 *  Storage for the measuredHeight property.
 */
private var _measuredHeight:Number = 0;

[Inspectable(environment="none")]

/**
 *  The default height of the component, in pixels.
 *  This value is set by the <code>measure()</code> method.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get measuredHeight():Number
{
	return _measuredHeight;
}

/**
 *  @private
 */
public function set measuredHeight(value:Number):void
{
	_measuredHeight = value;
}
/**
 *  @inheritDoc
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function validateSize(recursive:Boolean = false):void
{
	if (recursive)
	{
		for (var i:int = 0; i < numChildren; i++)
		{
			var child:DisplayObject = getChildAt(i);
			if (child is ILayoutManagerClient )
				(child as ILayoutManagerClient ).validateSize(true);
		}
	}
	
	if (invalidateSizeFlag)
	{
		var sizeChanging:Boolean = measureSizes();
		
		if (sizeChanging && includeInLayout)
		{
			// TODO (egeorgie): we don't need this invalidateDisplayList() here
			// because we'll call it if the parent sets new actual size?
			invalidateDisplayList();
			invalidateParentSizeAndDisplayList();
		}
	}
}

/**
 *  Determines if the call to the <code>measure()</code> method can be skipped.
 *  
 *  @return Returns <code>true</code> when the <code>measureSizes()</code> method can skip the call to
 *  the <code>measure()</code> method. For example this is usually <code>true</code> when both <code>explicitWidth</code> and
 *  <code>explicitHeight</code> are set. For paths, this is <code>true</code> when the bounds of the path
 *  have not changed.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 4
 */
protected function canSkipMeasurement():Boolean
{
	// We can skip the measure function if the object's width and height
	// have been explicitly specified (e.g.: the object's MXML tag has
	// attributes like width="50" and height="100").
	//
	// If an object's width and height have been explicitly specified,
	// then the explicitWidth and explicitHeight properties contain
	// Numbers (as opposed to NaN)
	return !isNaN(explicitWidth) && !isNaN(explicitHeight);
}

/**
 *  @private
 */
mx_internal function measureSizes():Boolean
{
	var changed:Boolean = false;
	
	if (!invalidateSizeFlag)
		return changed;
	
	var scalingFactor:Number;
	var newValue:Number;
	
	if (canSkipMeasurement())
	{
		invalidateSizeFlag = false;
		_measuredMinWidth = 0;
		_measuredMinHeight = 0;
	}
	else
	{
		var xScale:Number = Math.abs(scaleX);
		var yScale:Number = Math.abs(scaleY);
		
		measure();
		
		invalidateSizeFlag = false;
		
		if (!isNaN(explicitMinWidth) && measuredWidth < explicitMinWidth)
			measuredWidth = explicitMinWidth;
		
		if (!isNaN(explicitMaxWidth) && measuredWidth > explicitMaxWidth)
			measuredWidth = explicitMaxWidth;
		
		if (!isNaN(explicitMinHeight) && measuredHeight < explicitMinHeight)
			measuredHeight = explicitMinHeight;
		
		if (!isNaN(explicitMaxHeight) && measuredHeight > explicitMaxHeight)
			measuredHeight = explicitMaxHeight;
	}
	
	adjustSizesForScaleChanges();
	
	if (isNaN(oldMinWidth))
	{
		// This branch does the same thing as the else branch,
		// but it is optimized for the first time that
		// measureSizes() is called on this object.
		oldMinWidth = !isNaN(explicitMinWidth) ?
			explicitMinWidth :
			measuredMinWidth;
		
		oldMinHeight = !isNaN(explicitMinHeight) ?
			explicitMinHeight :
			measuredMinHeight;
		
		oldExplicitWidth = !isNaN(explicitWidth) ?
			explicitWidth :
			measuredWidth;
		
		oldExplicitHeight = !isNaN(explicitHeight) ?
			explicitHeight :
			measuredHeight;
		
		changed = true;
	}
	else
	{
		newValue = !isNaN(explicitMinWidth) ?
			explicitMinWidth :
			measuredMinWidth;
		if (newValue != oldMinWidth)
		{
			oldMinWidth = newValue;
			changed = true;
		}
		
		newValue = !isNaN(explicitMinHeight) ?
			explicitMinHeight :
			measuredMinHeight;
		if (newValue != oldMinHeight)
		{
			oldMinHeight = newValue;
			changed = true;
		}
		
		newValue = !isNaN(explicitWidth) ?
			explicitWidth :
			measuredWidth;
		if (newValue != oldExplicitWidth)
		{
			oldExplicitWidth = newValue;
			changed = true;
		}
		
		newValue = !isNaN(explicitHeight) ?
			explicitHeight :
			measuredHeight;
		if (newValue != oldExplicitHeight)
		{
			oldExplicitHeight = newValue;
			changed = true;
		}
		
	}
	
	return changed;
}

/**
 *  Calculates the default size, and optionally the default minimum size,
 *  of the component. This is an advanced method that you might override when
 *  creating a subclass of UIComponent.
 *
 *  <p>You do not call this method directly. Flex calls the
 *  <code>measure()</code> method when the component is added to a container
 *  using the <code>addChild()</code> method, and when the component's
 *  <code>invalidateSize()</code> method is called. </p>
 *
 *  <p>When you set a specific height and width of a component,
 *  Flex does not call the <code>measure()</code> method,
 *  even if you explicitly call the <code>invalidateSize()</code> method.
 *  That is, Flex only calls the <code>measure()</code> method if
 *  the <code>explicitWidth</code> property or the <code>explicitHeight</code>
 *  property of the component is NaN. </p>
 *
 *  <p>In your override of this method, you must set the
 *  <code>measuredWidth</code> and <code>measuredHeight</code> properties
 *  to define the default size.
 *  You can optionally set the <code>measuredMinWidth</code> and
 *  <code>measuredMinHeight</code> properties to define the default
 *  minimum size.</p>
 *
 *  <p>Most components calculate these values based on the content they are
 *  displaying, and from the properties that affect content display.
 *  A few components simply have hard-coded default values. </p>
 *
 *  <p>The conceptual point of <code>measure()</code> is for the component to provide
 *  its own natural or intrinsic size as a default. Therefore, the
 *  <code>measuredWidth</code> and <code>measuredHeight</code> properties
 *  should be determined by factors such as:</p>
 *  <ul>
 *     <li>The amount of text the component needs to display.</li>
 *     <li>The styles, such as <code>fontSize</code>, for that text.</li>
 *     <li>The size of a JPEG image that the component displays.</li>
 *     <li>The measured or explicit sizes of the component's children.</li>
 *     <li>Any borders, margins, and gaps.</li>
 *  </ul>
 *
 *  <p>In some cases, there is no intrinsic way to determine default values.
 *  For example, a simple GreenCircle component might simply set
 *  measuredWidth = 100 and measuredHeight = 100 in its <code>measure()</code> method to
 *  provide a reasonable default size. In other cases, such as a TextArea,
 *  an appropriate computation (such as finding the right width and height
 *  that would just display all the text and have the aspect ratio of a Golden Rectangle)
 *  might be too time-consuming to be worthwhile.</p>
 *
 *  <p>The default implementation of <code>measure()</code>
 *  sets <code>measuredWidth</code>, <code>measuredHeight</code>,
 *  <code>measuredMinWidth</code>, and <code>measuredMinHeight</code>
 *  to <code>0</code>.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
protected function measure():void
{
	measuredMinWidth = 0;
	measuredMinHeight = 0;
	measuredWidth = 0;
	measuredHeight = 0;
}

/**
 *  @private
 */
mx_internal function adjustSizesForScaleChanges():void
{
	var xScale:Number = scaleX;
	var yScale:Number = scaleY;
	
	var scalingFactor:Number;
	
	if (xScale != oldScaleX)
	{	
		oldScaleX = xScale;
	}
	
	if (yScale != oldScaleY)
	{				
		oldScaleY = yScale;
	}
}

/**
 *  A convenience method for determining whether to use the
 *  explicit or measured width
 *
 *  @return A Number which is explicitWidth if defined
 *  or measuredWidth if not.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function getExplicitOrMeasuredWidth():Number
{
	return !isNaN(explicitWidth) ? explicitWidth : measuredWidth;
}

/**
 *  A convenience method for determining whether to use the
 *  explicit or measured height
 *
 *  @return A Number which is explicitHeight if defined
 *  or measuredHeight if not.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function getExplicitOrMeasuredHeight():Number
{
	return !isNaN(explicitHeight) ? explicitHeight : measuredHeight;
}

/**
 *  A convenience method for determining the unscaled width
 *  of the component
 *  All of a component's drawing and child layout should be done
 *  within a bounding rectangle of this width, which is also passed
 *  as an argument to <code>updateDisplayList()</code>.
 *
 *  @return A Number which is unscaled width of the component.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
protected function get unscaledWidth():Number
{
	return width;
}

/**
 *  @private
 */
mx_internal function getUnscaledWidth():Number { return unscaledWidth; }

/**
 *  A convenience method for setting the unscaledWidth of a
 *  component.
 *
 *  Setting this sets the width of the component as desired
 *  before any transformation is applied.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
mx_internal function setUnscaledWidth(value:Number):void
{
	var newValue:Number = value;			
	if (_explicitWidth == newValue)
		return;
	
	// width can be pixel or percent not both
	if (!isNaN(newValue))
		_percentWidth = NaN;
	
	_explicitWidth = newValue;
	
	// We invalidate size because locking in width
	// may change the measured height in flow-based components.
	invalidateSize();
	
	invalidateParentSizeAndDisplayList();
}

/**
 *  A convenience method for determining the unscaled height
 *  of the component.
 *  All of a component's drawing and child layout should be done
 *  within a bounding rectangle of this height, which is also passed
 *  as an argument to <code>updateDisplayList()</code>.
 *
 *  @return A Number which is unscaled height of the component.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
protected function get unscaledHeight():Number
{
	return height;
}

/**
 *  @private
 */
mx_internal function getUnscaledHeight():Number { return unscaledHeight; }

/**
 *  A convenience method for setting the unscaledHeight of a
 *  component.
 *
 *  Setting this sets the height of the component as desired
 *  before any transformation is applied.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
mx_internal function setUnscaledHeight(value:Number):void
{
	var newValue:Number = value;
	if (_explicitHeight == newValue)
		return;
	
	// height can be pixel or percent, not both
	if (!isNaN(newValue))
		_percentHeight = NaN;
	
	_explicitHeight = newValue;
	
	// We invalidate size because locking in height
	// may change the measured width in flow-based components.
	invalidateSize();
	
	invalidateParentSizeAndDisplayList();
}