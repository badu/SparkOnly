/**
 *  @private
 *  Whether this component needs to have its
 *  commitProperties() method called.
 */
mx_internal var invalidatePropertiesFlag:Boolean = false;

/**
 *  @private
 *  Whether this component needs to have its
 *  measure() method called.
 */
mx_internal var invalidateSizeFlag:Boolean = false;

/**
 *  @private
 *  Whether this component needs to be have its
 *  updateDisplayList() method called.
 */
mx_internal var invalidateDisplayListFlag:Boolean = false;

/**
 *  @private
 *  Whether setActualSize() has been called on this component
 *  at least once.  This is used in validateBaselinePosition()
 *  to resize the component to explicit or measured
 *  size if baselinePosition getter is called before the
 *  component has been resized by the layout.
 */
mx_internal var setActualSizeCalled:Boolean = false;

/**
 *  Marks a component so that its <code>commitProperties()</code>
 *  method gets called during a later screen update.
 *
 *  <p>Invalidation is a useful mechanism for eliminating duplicate
 *  work by delaying processing of changes to a component until a
 *  later screen update.
 *  For example, if you want to change the text color and size,
 *  it would be wasteful to update the color immediately after you
 *  change it and then update the size when it gets set.
 *  It is more efficient to change both properties and then render
 *  the text with its new size and color once.</p>
 *
 *  <p>Invalidation methods rarely get called.
 *  In general, setting a property on a component automatically
 *  calls the appropriate invalidation method.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function invalidateProperties():void
{
	if (!invalidatePropertiesFlag)
	{
		invalidatePropertiesFlag = true;
		
		if (nestLevel && UIComponentGlobals.layoutManager)
			UIComponentGlobals.layoutManager.invalidateProperties(this);
	}
}

/**
 *  Marks a component so that its <code>measure()</code>
 *  method gets called during a later screen update.
 *
 *  <p>Invalidation is a useful mechanism for eliminating duplicate
 *  work by delaying processing of changes to a component until a
 *  later screen update.
 *  For example, if you want to change the text and font size,
 *  it would be wasteful to update the text immediately after you
 *  change it and then update the size when it gets set.
 *  It is more efficient to change both properties and then render
 *  the text with its new size once.</p>
 *
 *  <p>Invalidation methods rarely get called.
 *  In general, setting a property on a component automatically
 *  calls the appropriate invalidation method.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function invalidateSize():void
{
	if (!invalidateSizeFlag)
	{
		invalidateSizeFlag = true;
		
		if (nestLevel && UIComponentGlobals.layoutManager)
			UIComponentGlobals.layoutManager.invalidateSize(this);
	}
}

/**
 *  Helper method to invalidate parent size and display list if
 *  this object affects its layout (includeInLayout is true).
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
protected function invalidateParentSizeAndDisplayList():void
{
	if (!includeInLayout)
		return;
	
	var p:IInvalidating = parent as IInvalidating;
	if (!p)
		return;
	
	p.invalidateSize();
	p.invalidateDisplayList();
}

/**
 *  Marks a component so that its <code>updateDisplayList()</code>
 *  method gets called during a later screen update.
 *
 *  <p>Invalidation is a useful mechanism for eliminating duplicate
 *  work by delaying processing of changes to a component until a
 *  later screen update.
 *  For example, if you want to change the width and height,
 *  it would be wasteful to update the component immediately after you
 *  change the width and then update again with the new height.
 *  It is more efficient to change both properties and then render
 *  the component with its new size once.</p>
 *
 *  <p>Invalidation methods rarely get called.
 *  In general, setting a property on a component automatically
 *  calls the appropriate invalidation method.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function invalidateDisplayList():void
{
	if (!invalidateDisplayListFlag)
	{
		invalidateDisplayListFlag = true;
		
		if (nestLevel && UIComponentGlobals.layoutManager)
			UIComponentGlobals.layoutManager.invalidateDisplayList(this);
	}
}

private function invalidateTransform():void
{
	if (_layoutFeatures && _layoutFeatures.updatePending == false)
	{
		_layoutFeatures.updatePending = true; 
		if (nestLevel && UIComponentGlobals.layoutManager &&
			invalidateDisplayListFlag == false)
		{
			UIComponentGlobals.layoutManager.invalidateDisplayList(this);
		}
	}
}

/**
 * @inheritDoc
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function invalidateLayoutDirection():void
{       
	const parentElt:ILayoutDirectionElement = parent as ILayoutDirectionElement;        
	const thisLayoutDirection:String = layoutDirection;
	
	// If this element's layoutDirection doesn't match its parent's, then
	// set the _layoutFeatures.mirror flag.  Similarly, if mirroring isn't 
	// required, then clear the _layoutFeatures.mirror flag.
	
	const mirror:Boolean = (parentElt) 
		? (parentElt.layoutDirection != thisLayoutDirection)
		: (LayoutDirection.LTR != thisLayoutDirection);
	
	if ((_layoutFeatures) ? (mirror != _layoutFeatures.mirror) : mirror)
	{
		if (_layoutFeatures == null)
			initAdvancedLayoutFeatures();
		_layoutFeatures.mirror = mirror;
		// width may have already been set
		_layoutFeatures.layoutWidth = _width;
		invalidateTransform();
	}
	
	// Children are notified only if the component's layoutDirection has changed.
	if (oldLayoutDirection != layoutDirection)
	{
		var i:int;
		
		//  If we have children, the styleChanged() machinery (via commitProperties()) will
		//  deal with UIComponent children. We have to deal with IVisualElement and
		//  ILayoutDirectionElement children that don't support styles, like GraphicElements, here.
		if (this is IVisualElementContainer)
		{
			const thisContainer:IVisualElementContainer = IVisualElementContainer(this);
			const thisContainerNumElements:int = thisContainer.numElements;
			
			for (i = 0; i < thisContainerNumElements; i++)
			{
				var elt:IVisualElement = thisContainer.getElementAt(i);
				// Can be null if IUITextField or IUIFTETextField.
				if (elt && !(elt is IStyleClient))
					elt.invalidateLayoutDirection();
			}
		}
		else
		{
			const thisNumChildren:int = numChildren;
			
			for (i = 0; i < thisNumChildren; i++)
			{
				var child:DisplayObject = getChildAt(i);
				if (!(child is IStyleClient) && child is ILayoutDirectionElement)
					ILayoutDirectionElement(child).invalidateLayoutDirection();
			}
		}
	}  
}  

private function transformOffsetsChangedHandler(e:Event):void
{
	invalidateTransform();
}


/**
 *  Flex calls the <code>stylesInitialized()</code> method when
 *  the styles for a component are first initialized.
 *
 *  <p>This is an advanced method that you might override
 *  when creating a subclass of UIComponent. Flex guarantees that
 *  your component's styles are fully initialized before
 *  the first time your component's <code>measure</code> and
 *  <code>updateDisplayList</code> methods are called.  For most
 *  components, that is sufficient. But if you need early access to
 *  your style values, you can override the stylesInitialized() function
 *  to access style properties as soon as they are initialized the first time.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function stylesInitialized():void
{
}

/**
 *  Detects changes to style properties. When any style property is set,
 *  Flex calls the <code>styleChanged()</code> method,
 *  passing to it the name of the style being set.
 *
 *  <p>This is an advanced method that you might override
 *  when creating a subclass of UIComponent. When you create a custom component,
 *  you can override the <code>styleChanged()</code> method
 *  to check the style name passed to it, and handle the change accordingly.
 *  This lets you override the default behavior of an existing style,
 *  or add your own custom style properties.</p>
 *
 *  <p>If you handle the style property, your override of
 *  the <code>styleChanged()</code> method should call the
 *  <code>invalidateDisplayList()</code> method to cause Flex to execute
 *  the component's <code>updateDisplayList()</code> method at the next screen update.</p>
 *
 *  @param styleProp The name of the style property, or null if all styles for this
 *  component have changed.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function styleChanged(styleProp:String):void
{
	var allStyles:Boolean = !styleProp || styleProp == "styleName";
	
	StyleProtoChain.styleChanged(this, styleProp);
	
	if (!allStyles)
	{
		if (hasEventListener(styleProp + "Changed"))
			dispatchEvent(new Event(styleProp + "Changed"));
	}
	else
	{
		if (hasEventListener("allStylesChanged"))
			dispatchEvent(new Event("allStylesChanged"));
	}
	
	if (allStyles || styleProp == "layoutDirection")
		layoutDirectionCachedValue = LAYOUT_DIRECTION_CACHE_UNSET;
}

/**
 *  Validate and update the properties and layout of this object
 *  and redraw it, if necessary.
 *
 *  Processing properties that require substantial computation are normally
 *  not processed until the script finishes executing.
 *  For example setting the <code>width</code> property is delayed, because it can
 *  require recalculating the widths of the objects children or its parent.
 *  Delaying the processing prevents it from being repeated
 *  multiple times if the script sets the <code>width</code> property more than once.
 *  This method lets you manually override this behavior.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function validateNow():void
{
	UIComponentGlobals.layoutManager.validateClient(this);
}

/**
 *  @private
 *  This method is called at the beginning of each getter
 *  for the baselinePosition property.
 *  If it returns false, the getter should return NaN
 *  because the baselinePosition can't be computed.
 *  If it returns true, the getter can do computations
 *  like textField.y + textField.baselinePosition
 *  because these properties will be valid.
 */
mx_internal function validateBaselinePosition():Boolean
{
	// If this component isn't parented,
	// then it doesn't know its text styles
	// and we can't compute a baselinePosition.
	if (!parent)
		return false;
	
	// If this component hasn't been sized yet, assign it
	// an actual size that's based on its explicit or measured size.
	//
	// TODO (egeorgie): remove this code when all SDK clients
	// follow the rule to size first and query baselinePosition later.
	if (!setActualSizeCalled && (width == 0 || height == 0))
	{
		validateNow();
		
		var w:Number = getExplicitOrMeasuredWidth();
		var h:Number = getExplicitOrMeasuredHeight();
		
		setActualSize(w, h);
	}
	
	// Ensure that this component's internal TextFields
	// are properly laid out, so that we can use
	// their locations to compute a baselinePosition.
	validateNow();
	
	
	return true;
}

/**
 *  Queues a function to be called later.
 *
 *  <p>Before each update of the screen, Flash Player or AIR calls
 *  the set of functions that are scheduled for the update.
 *  Sometimes, a function should be called in the next update
 *  to allow the rest of the code scheduled for the current
 *  update to be executed.
 *  Some features, like effects, can cause queued functions to be
 *  delayed until the feature completes.</p>
 *
 *  @param method Reference to a method to be executed later.
 *
 *  @param args Array of Objects that represent the arguments to pass to the method.
 *
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function callLater(method:Function,
						  args:Array /* of Object */ = null):void
{
	// trace(">>calllater " + this)
	// Push the method and the arguments onto the method queue.
	methodQueue.push(new MethodQueueElement(method, args));
	
	// Register to get the next "render" event
	// just before the next rasterization.
	
	// Stage can be null when an untrusted application is loaded by an application
	// that isn't on stage yet.
	if (systemManager && (systemManager.stage || usingBridge))
	{
		if (!listeningForRender)
		{
			// trace("  added");
			systemManager.addEventListener(FlexEvent.RENDER, callLaterDispatcher);
			systemManager.addEventListener(FlexEvent.ENTER_FRAME, callLaterDispatcher);
			listeningForRender = true;
		}
		
		// Force a "render" event to happen soon
		if (systemManager.stage)
			systemManager.stage.invalidate();
	}
	
	// trace("<<calllater " + this)
}

/**
 *  @private
 *  Cancels all queued functions.
 */
mx_internal function cancelAllCallLaters():void
{			
	// Stage can be null when an untrusted application is loaded by an application
	// that isn't on stage yet.
	if (systemManager && (systemManager.stage || usingBridge))
	{
		if (listeningForRender)
		{
			systemManager.removeEventListener(FlexEvent.RENDER, callLaterDispatcher);
			systemManager.removeEventListener(FlexEvent.ENTER_FRAME, callLaterDispatcher);
			listeningForRender = false;
		}
	}
	
	// Empty the method queue.
	methodQueue.splice(0);
}