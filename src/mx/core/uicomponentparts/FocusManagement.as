//----------------------------------
//  focusPane
//----------------------------------

/**
 *  @private
 *  Storage for the focusPane property.
 */
private var _focusPane:Sprite;

[Inspectable(environment="none")]

/**
 *  The focus pane associated with this object.
 *  An object has a focus pane when one of its children has focus.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get focusPane():Sprite
{
	return _focusPane;
}

/**
 *  @private
 */
public function set focusPane(value:Sprite):void
{
	if (value)
	{
		addChild(value);
		
		value.x = 0;
		value.y = 0;
		value.scrollRect = null;
		
		_focusPane = value;
	}
	else
	{
		removeChild(_focusPane);
		
		_focusPane.mask = null;
		_focusPane = null;
	}
}

//----------------------------------
//  focusEnabled
//----------------------------------

/**
 *  @private
 *  Storage for the focusEnabled property.
 */
private var _focusEnabled:Boolean = true;

[Inspectable(defaultValue="true")]

/**
 *  Indicates whether the component can receive focus when tabbed to.
 *  You can set <code>focusEnabled</code> to <code>false</code>
 *  when a UIComponent is used as a subcomponent of another component
 *  so that the outer component becomes the focusable entity.
 *  If this property is <code>false</code>, focus is transferred to
 *  the first parent that has <code>focusEnable</code>
 *  set to <code>true</code>.
 *
 *  <p>The default value is <code>true</code>, except for the 
 *  spark.components.Scroller component. 
 *  For that component, the default value is <code>false</code>.</p>
 *
 *  @see spark.components.Scroller
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get focusEnabled():Boolean
{
	return _focusEnabled;
}

/**
 *  @private
 */
public function set focusEnabled(value:Boolean):void
{
	_focusEnabled =  value;
}

//----------------------------------
//  hasFocusableChildren
//----------------------------------

/**
 *  @private
 *  Storage for the hasFocusableChildren property.
 */
private var _hasFocusableChildren:Boolean = false;

[Bindable("hasFocusableChildrenChange")]
[Inspectable(defaultValue="false")]

/**
 *  A flag that indicates whether child objects can receive focus.
 * 
 *  <p><b>Note: </b>This property is similar to the <code>tabChildren</code> property
 *  used by Flash Player. 
 *  Use the <code>hasFocusableChildren</code> property with Flex applications.
 *  Do not use the <code>tabChildren</code> property.</p>
 * 
 *  <p>This property is usually <code>false</code> because most components
 *  either receive focus themselves or delegate focus to a single
 *  internal sub-component and appear as if the component has
 *  received focus. 
 *  For example, a TextInput control contains a focusable
 *  child RichEditableText control, but while the RichEditableText
 *  sub-component actually receives focus, it appears as if the
 *  TextInput has focus. TextInput sets <code>hasFocusableChildren</code>
 *  to <code>false</code> because TextInput is considered the
 *  component that has focus. Its internal structure is an
 *  abstraction.</p>
 *
 *  <p>Usually only navigator components, such as TabNavigator and
 *  Accordion, have this flag set to <code>true</code> because they
 *  receive focus on Tab but focus goes to components in the child
 *  containers on further Tabs.</p>
 *
 *  <p>The default value is <code>false</code>, except for the 
 *  spark.components.Scroller component. 
 *  For that component, the default value is <code>true</code>.</p>
 *
 *  @see spark.components.Scroller
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public function get hasFocusableChildren():Boolean
{
	return _hasFocusableChildren;
}

/**
 *  @private
 */
public function set hasFocusableChildren(value:Boolean):void
{
	if (value != _hasFocusableChildren)
	{
		_hasFocusableChildren = value;
		dispatchEvent(new Event("hasFocusableChildrenChange"));
	}
}

//----------------------------------
//  mouseFocusEnabled
//----------------------------------

/**
 *  @private
 *  Storage for the mouseFocusEnabled property.
 */
private var _mouseFocusEnabled:Boolean = true;

[Inspectable(defaultValue="true")]

/**
 *  Whether you can receive focus when clicked on.
 *  If <code>false</code>, focus is transferred to
 *  the first parent that is <code>mouseFocusEnable</code>
 *  set to <code>true</code>.
 *  For example, you can set this property to <code>false</code>
 *  on a Button control so that you can use the Tab key to move focus
 *  to the control, but not have the control get focus when you click on it.
 *
 * <p>The default value is <code>true</code> for most subclasses, except the Spark TabBar. In that case, the default is <code>false</code>.</p>
 *
 *  @default true
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get mouseFocusEnabled():Boolean
{
	return _mouseFocusEnabled;
}

/**
 *  @private
 */
public function set mouseFocusEnabled(value:Boolean):void
{
	_mouseFocusEnabled =  value;
}

//----------------------------------
//  tabFocusEnabled
//----------------------------------

/**
 *  @private
 *  Storage for the tabFocusEnabled property.
 */
private var _tabFocusEnabled:Boolean = true;

[Bindable("tabFocusEnabledChange")]
[Inspectable(defaultValue="true")]

/**
 *  A flag that indicates whether this object can receive focus
 *  via the TAB key
 * 
 *  <p>This is similar to the <code>tabEnabled</code> property
 *  used by the Flash Player.</p>
 * 
 *  <p>This is usually <code>true</code> for components that
 *  handle keyboard input, but some components in controlbars
 *  have them set to <code>false</code> because they should not steal
 *  focus from another component like an editor.
 *  </p>
 *
 *  @default true
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public function get tabFocusEnabled():Boolean
{
	return _tabFocusEnabled;
}

/**
 *  @private
 */
public function set tabFocusEnabled(value:Boolean):void
{
	if (value != _tabFocusEnabled)
	{
		_tabFocusEnabled = value;
		dispatchEvent(new Event("tabFocusEnabledChange"));
	}
}
/**
 *  The event handler called for a <code>keyDown</code> event.
 *  If you override this method, make sure to call the base class version.
 *
 *  @param event The event object.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
protected function keyDownHandler(event:KeyboardEvent):void
{
	// You must override this function if your component accepts focus
}

/**
 *  The event handler called for a <code>keyUp</code> event.
 *  If you override this method, make sure to call the base class version.
 *
 *  @param event The event object.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
protected function keyUpHandler(event:KeyboardEvent):void
{
	// You must override this function if your component accepts focus
}

/**
 *  Typically overridden by components containing UITextField objects,
 *  where the UITextField object gets focus.
 *
 *  @param target A UIComponent object containing a UITextField object
 *  that can receive focus.
 *
 *  @return Returns <code>true</code> if the UITextField object has focus.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
protected function isOurFocus(target:DisplayObject):Boolean
{
	return target == this;
}

/**
 *  The event handler called when a UIComponent object gets focus.
 *  If you override this method, make sure to call the base class version.
 *
 *  @param event The event object.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
protected function focusInHandler(event:FocusEvent):void
{
	if (isOurFocus(DisplayObject(event.target)))
	{
		if (focusManager && focusManager.showFocusIndicator)
			drawFocus(true);
		
		ContainerGlobals.checkFocus(event.relatedObject, this);
	}
}

/**
 *  The event handler called when a UIComponent object loses focus.
 *  If you override this method, make sure to call the base class version.
 *
 *  @param event The event object.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
protected function focusOutHandler(event:FocusEvent):void
{
	// We don't need to remove our event listeners here because we
	// won't receive keyboard events.
	if (isOurFocus(DisplayObject(event.target)))
		drawFocus(false);
}

/**
 *  @private
 *  The player dispatches an "added" event when the addChild()
 *  or addChildAt() method of DisplayObjectContainer is called,
 *  but handling this event at that time can be dangerous
 *  so we prevent the event dispatched then from propagating;
 *  we'll dispatch another "added" event later when it is safe.
 *  The reason the timing of this player event is dangerous
 *  is that the Flex framework overrides addChild() and addChildAt(),
 *  to perform important additional work after calling the super
 *  method, such as setting _parent to skip over the contentPane
 *  of a Container. So if an "added" handler executes too early,
 *  the child is in an inconsistent state. (For example, its
 *  toString() can be wrong because the contentPane is wrongly
 *  included when traversing the parent chain.) Our overrides
 *  delay dispatching the "added" event until the end of the
 *  override, as opposed to in the middle when super.addChild()
 *  is called.
 *  Note: This event handler is registered by the UIComponent
 *  constructor, which means it is registered before any
 *  other handlers for an "added" event.
 *  Therefore it can prevent all others from being called.
 */
private function addedHandler(event:Event):void
{
	//reset systemManager in case we've been reparented to a new Window.
	//systemManager will be set on get systemManager()
	if (event.eventPhase != EventPhase.AT_TARGET)
		return;
	
	try
	{
		if (parent is IContainer && IContainer(parent).creatingContentPane)
		{
			event.stopImmediatePropagation();
			return;
		}
	}
	catch (error:SecurityError)
	{
		
	} 
}

/**
 *  @private
 *  See the comments for addedHandler() above.
 */
private function removedHandler(event:Event):void
{
	if (event.eventPhase != EventPhase.AT_TARGET)
		return;
	
	try
	{
		if (parent is IContainer && IContainer(parent).creatingContentPane)
		{
			event.stopImmediatePropagation();
			return;
		}
	}
	catch (error:SecurityError)
	{
		
	}
}

/**
 *  @private
 */
private function removedFromStageHandler(event:Event):void
{
	_systemManagerDirty = true;
}

/**
 *  @private
 *  There is a bug (139390) where setting focus from within callLaterDispatcher
 *  screws up the ActiveX player.  We defer focus until enterframe.
 */
private function setFocusLater(event:Event = null):void
{
	if (systemManager && systemManager.stage)
	{
		systemManager.stage.removeEventListener(Event.ENTER_FRAME, setFocusLater);
		if (UIComponentGlobals.nextFocusObject)
			systemManager.stage.focus = UIComponentGlobals.nextFocusObject;
		UIComponentGlobals.nextFocusObject = null;
	}
}

/**
 *  @private
 *  Called when this component moves. Adjust the focus rect.
 */
private function focusObj_scrollHandler(event:Event):void
{
	adjustFocusRect();
}

/**
 *  @private
 *  Called when this component moves. Adjust the focus rect.
 */
private function focusObj_moveHandler(event:MoveEvent):void
{
	adjustFocusRect();
}

/**
 *  @private
 *  Called when this component resizes. Adjust the focus rect.
 */
private function focusObj_resizeHandler(event:Event):void
{
	if (event is ResizeEvent)
		adjustFocusRect();
}

/**
 *  @private
 *  Called when this component is unloaded. Hide the focus rect.
 */
private function focusObj_removedHandler(event:Event):void
{
	// ignore if we captured on a child
	if (event.target != this)
		return;
	
	var focusObject:DisplayObject = getFocusObject();
	
	if (focusObject)
		focusObject.visible = false;
}

/**
 *  @private
 *  Called when our associated layer parent needs to inform us of 
 *  a change to it's visibility or alpha.
 */
protected function layer_PropertyChange(event:PropertyChangeEvent):void
{
	switch (event.property)
	{
		case "effectiveVisibility":
		{
			var newValue:Boolean = (event.newValue && _visible);            
			if (newValue != $visible)
				$visible = newValue;
			break;
		}
		case "effectiveAlpha":
		{
			var newAlpha:Number = Number(event.newValue) * _alpha;
			if (newAlpha != $alpha)
				$alpha = newAlpha;
			break;
		}
	}
}
/**
 *  Gets the object that currently has focus.
 *  It might not be this object.
 *  Note that this method does not necessarily return the component
 *  that has focus.
 *  It can return the internal subcomponent of the component
 *  that has focus.
 *  To get the component that has focus, use the
 *  <code>focusManager.focus</code> property.
 *
 *  @return Object that has focus.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function getFocus():InteractiveObject
{
	if (!systemManager)
		return null;
	
	if (UIComponentGlobals.nextFocusObject)
		return UIComponentGlobals.nextFocusObject;
	
	if (systemManager.stage)
		return systemManager.stage.focus;
	
	return null;
}

/**
 *  Sets the focus to this component.
 *  The component can in turn pass focus to a subcomponent.
 *
 *  <p><b>Note:</b> Only the TextInput and TextArea controls show a highlight
 *  when this method sets the focus.
 *  All controls show a highlight when the user tabs to the control.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function setFocus():void
{
	if (systemManager && (systemManager.stage || usingBridge))
	{
		if (UIComponentGlobals.callLaterDispatcherCount == 0)
		{
			systemManager.stage.focus = this;
			UIComponentGlobals.nextFocusObject = null;
		}
		else
		{
			UIComponentGlobals.nextFocusObject = this;
			systemManager.addEventListener(FlexEvent.ENTER_FRAME, setFocusLater);
		}
	}
	else
	{
		UIComponentGlobals.nextFocusObject = this;
		callLater(setFocusLater);
	}
}

/**
 *  @private
 *  Returns the focus object
 */
mx_internal function getFocusObject():DisplayObject
{			
	if (!focusManager || !focusManager.focusPane)
		return null;
	
	return focusManager.focusPane.numChildren == 0 ?
		null :
		focusManager.focusPane.getChildAt(0);
}

/**
 *  Shows or hides the focus indicator around this component.
 *
 *  <p>UIComponent implements this by creating an instance of the class
 *  specified by the <code>focusSkin</code> style and positioning it
 *  appropriately.</p>
 *
 *  @param isFocused Determines if the focus indicator should be displayed. Set to
 *  <code>true</code> to display the focus indicator. Set to <code>false</code> to hide it.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function drawFocus(isFocused:Boolean):void
{
	// Gets called by removeChild() after un-parented.
	if (!parent)
		return;
	
	var focusObj:DisplayObject = getFocusObject();
	var focusPane:Sprite = focusManager ? focusManager.focusPane : null;
	
	if (isFocused && !preventDrawFocus) //&& !isEffectStarted
	{
		var focusOwner:DisplayObjectContainer = focusPane.parent;
		
		if (focusOwner != parent)
		{
			if (focusOwner)
			{
				if (focusOwner is ISystemManager)
					ISystemManager(focusOwner).focusPane = null;
				else
					IUIComponent(focusOwner).focusPane = null;
			}
			if (parent is ISystemManager)
				ISystemManager(parent).focusPane = focusPane;
			else
				IUIComponent(parent).focusPane = focusPane;
		}
		
		var focusClass:Class = getStyle("focusSkin");
		
		if (!focusClass)
			return;
		
		if (focusObj && !(focusObj is focusClass))
		{
			focusPane.removeChild(focusObj);
			focusObj = null;
		}
		
		if (!focusObj)
		{
			focusObj = new focusClass();
			
			focusObj.name = "focus";
			
			focusPane.addChild(focusObj);
		}
		
		if (focusObj is ILayoutManagerClient )
			ILayoutManagerClient (focusObj).nestLevel = nestLevel;
		
		if (focusObj is ISimpleStyleClient)
			ISimpleStyleClient(focusObj).styleName = this;
		
		addEventListener(MoveEvent.MOVE, focusObj_moveHandler, true);
		addEventListener(MoveEvent.MOVE, focusObj_moveHandler);
		addEventListener(ResizeEvent.RESIZE, focusObj_resizeHandler, true);
		addEventListener(ResizeEvent.RESIZE, focusObj_resizeHandler);
		addEventListener(Event.REMOVED, focusObj_removedHandler, true);
		
		focusObj.visible = true;
		hasFocusRect = true;
		
		adjustFocusRect();
	}
	else if (hasFocusRect)
	{
		hasFocusRect = false;
		
		if (focusObj)
		{
			focusObj.visible = false;
			
			if (focusObj is ISimpleStyleClient)
				ISimpleStyleClient(focusObj).styleName = null;
		}
		
		removeEventListener(MoveEvent.MOVE, focusObj_moveHandler);
		removeEventListener(MoveEvent.MOVE, focusObj_moveHandler, true);
		removeEventListener(ResizeEvent.RESIZE, focusObj_resizeHandler, true);
		removeEventListener(ResizeEvent.RESIZE, focusObj_resizeHandler);
		removeEventListener(Event.REMOVED, focusObj_removedHandler, true);
	}
}

/**
 *  Adjust the focus rectangle.
 *
 *  @param The component whose focus rectangle to modify.
 *  If omitted, the default value is this UIComponent object.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
protected function adjustFocusRect(obj:DisplayObject = null):void
{
	if (!obj)
		obj = this;
	
	// Make sure that when we calculate the size of the Focus rect we
	// work with post-scale width & height.
	var width:Number;
	var height:Number;
	if (obj is UIComponent)
	{
		width = UIComponent(obj).unscaledWidth * Math.abs(obj.scaleX);
		height = UIComponent(obj).unscaledHeight * Math.abs(obj.scaleY);
	}
	else
	{
		width = obj.width;
		height = obj.height;
	}
	
	// Something inside the lisder has a width and height of NaN
	if (isNaN(width) || isNaN(height))
		return;
	
	if (!focusManager)
		return; // we've been unparented so ignore
	
	var focusObj:IFlexDisplayObject = IFlexDisplayObject(getFocusObject());
	if (focusObj)
	{
		var rectCol:Number;
		var showErrorSkin:Boolean = getStyle("showErrorSkin");
		if (errorString && errorString != "" && showErrorSkin)
			rectCol = getStyle("errorColor");
		else 
			rectCol = getStyle("focusColor");
		
		var thickness:Number = getStyle("focusThickness");
		
		if (focusObj is IStyleClient)
		{
			IStyleClient(focusObj).setStyle("focusColor", rectCol);
		}
		//if (getStyle("focusColor") != rectCol)
		//  setStyle("focusColor", rectCol);
		
		focusObj.setActualSize(width + 2 * thickness,
			height + 2 * thickness);
		
		var pt:Point;
		
		if (rotation)
		{
			var rotRad:Number = rotation * Math.PI / 180;
			pt = new Point(obj.x - thickness * (Math.cos(rotRad) - Math.sin(rotRad)),
				obj.y - thickness * (Math.cos(rotRad) + Math.sin(rotRad)));
			DisplayObject(focusObj).rotation = rotation;
		}
		else
		{
			pt = new Point(obj.x - thickness, obj.y - thickness);
			DisplayObject(focusObj).rotation = 0;
		}
		
		if (obj.parent == this)
		{
			// This adjustment only works if obj is a direct child of this.
			pt.x += x;
			pt.y += y;
		}
		
		// If necessary, compenstate for mirroring, if the obj to receive
		// focus isn't this component.  It is likely to be an icon within
		// the component such as a radio button or check box.  This works
		// as long as the focusObj is symmetric.
		// ToDo(cframpto):ProgrammaticSkin implement ILayoutDirectionElement.
		if (obj != this)
		{
			// The focusObj is attached to this component's parent.  Assume
			// the focusObj is a class which doesn't support layoutDirection
			// and will be laid out like the component's parent.  If the 
			// component is being mirrored it means its layout differs from 
			// its parent and we need to compenstate.
			if (_layoutFeatures && _layoutFeatures.mirror)
				pt.x += this.width - obj.width;      
		}
		
		pt = parent.localToGlobal(pt);                
		pt = parent.globalToLocal(pt);
		focusObj.move(pt.x, pt.y);
		
		if (focusObj is IInvalidating)
			IInvalidating(focusObj).validateNow();
			
	}
}