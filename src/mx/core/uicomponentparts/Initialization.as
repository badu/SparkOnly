/**
 *  @private
 */
mx_internal function updateCallbacks():void
{
	if (invalidateDisplayListFlag)
		UIComponentGlobals.layoutManager.invalidateDisplayList(this);
	
	if (invalidateSizeFlag)
		UIComponentGlobals.layoutManager.invalidateSize(this);
	
	if (invalidatePropertiesFlag)
		UIComponentGlobals.layoutManager.invalidateProperties(this);
	
	// systemManager getter tries to set the internal _systemManager varaible
	// if it is null. Hence a call to the getter is necessary.
	// Stage can be null when an untrusted application is loaded by an application
	// that isn't on stage yet.
	if (systemManager && (_systemManager.stage || usingBridge))
	{
		if (methodQueue.length > 0 && !listeningForRender)
		{
			_systemManager.addEventListener(FlexEvent.RENDER, callLaterDispatcher);
			_systemManager.addEventListener(FlexEvent.ENTER_FRAME, callLaterDispatcher);
			listeningForRender = true;
		}
		
		if (_systemManager.stage)
			_systemManager.stage.invalidate();
	}
}

/**
 *  Called by Flex when a UIComponent object is added to or removed from a parent.
 *  Developers typically never need to call this method.
 *
 *  @param p The parent of this UIComponent object.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function parentChanged(p:DisplayObjectContainer):void
{
	// trace("parentChanged: " + _parent + " of " + this + " changed to ");
	
	if (!p)
	{
		_parent = null;
		nestLevel = 0;
	}
	else if (p is IStyleClient)
	{
		_parent = p;
	}
	else if (p is ISystemManager)
	{
		_parent = p;
	}
	else
	{
		_parent = p.parent;
	}
	
	// trace("               " + p);
	parentChangedFlag = true;
}

/**
 *  @private
 */
mx_internal function addingChild(child:DisplayObject):void
{
	// If the document property isn't already set on the child,
	// set it to be the same as this component's document.
	// The document setter will recursively set it on any
	// descendants of the child that exist.
	if (child is IUIComponent &&
		!IUIComponent(child).document)
	{
		IUIComponent(child).document = document ?
			document :
			FlexGlobals.topLevelApplication;
	}
	
	// Propagate moduleFactory to the child, but don't overwrite an existing moduleFactory.
	if (child is IFlexModule && IFlexModule(child).moduleFactory == null)
	{
		if (moduleFactory != null)
			IFlexModule(child).moduleFactory = moduleFactory;
			
		else if (document is IFlexModule && document.moduleFactory != null)
			IFlexModule(child).moduleFactory = document.moduleFactory;
			
		else if (parent is IFlexModule && IFlexModule(parent).moduleFactory != null)
			IFlexModule(child).moduleFactory = IFlexModule(parent).moduleFactory;
	}
	
	// Set the font context in non-UIComponent children.
	// UIComponent children use moduleFactory.
	if (child is IFontContextComponent && !(child is UIComponent) &&
		IFontContextComponent(child).fontContext == null)
		IFontContextComponent(child).fontContext = moduleFactory;
	
	if (child is IUIComponent)
		IUIComponent(child).parentChanged(this);
	
	// Set the nestLevel of the child to be one greater
	// than the nestLevel of this component.
	// The nestLevel setter will recursively set it on any
	// descendants of the child that exist.
	if (child is ILayoutManagerClient)
		ILayoutManagerClient(child).nestLevel = nestLevel + 1;
	else if (child is IUITextField)
		IUITextField(child).nestLevel = nestLevel + 1;
	
	if (child is InteractiveObject)
		if (doubleClickEnabled)
			InteractiveObject(child).doubleClickEnabled = true;
	
	// Sets up the inheritingStyles and nonInheritingStyles objects
	// and their proto chains so that getStyle() works.
	// If this object already has some children,
	// then reinitialize the children's proto chains.
	if (child is IStyleClient)
		IStyleClient(child).regenerateStyleCache(true);
	else if (child is IUITextField && IUITextField(child).inheritingStyles)
		StyleProtoChain.initTextField(IUITextField(child));
	
	if (child is ISimpleStyleClient)
		ISimpleStyleClient(child).styleChanged(null);
	
	if (child is IStyleClient)
		IStyleClient(child).notifyStyleChangeInChildren(null, true);
		
	// Inform the component that it's style properties
	// have been fully initialized. Most components won't care,
	// but some need to react to even this early change.
	if (child is UIComponent)
		UIComponent(child).stylesInitialized();
}

/**
 *  @private
 */
mx_internal function childAdded(child:DisplayObject):void
{
	if (!UIComponentGlobals.designMode)
	{
		if (child is UIComponent)
		{
			if (!UIComponent(child).initialized)
				UIComponent(child).initialize();
		}
		else if (child is IUIComponent)
		{
			IUIComponent(child).initialize();
		}
	}
	else
	{
		try
		{
			if (child is UIComponent)
			{
				if (!UIComponent(child).initialized)
					UIComponent(child).initialize();
			}
			else if (child is IUIComponent)
			{
				IUIComponent(child).initialize();
			}               
		}
		catch (e:Error)
		{
			// Dispatch a initializeError dynamic event for tooling. 
			var initializeErrorEvent:DynamicEvent = new DynamicEvent("initializeError");
			initializeErrorEvent.error = e;
			initializeErrorEvent.source = child; 
			systemManager.dispatchEvent(initializeErrorEvent);
		}
	}
}

/**
 *  @private
 */
mx_internal function removingChild(child:DisplayObject):void
{
}

/**
 *  @private
 */
mx_internal function childRemoved(child:DisplayObject):void
{
	if (child is IUIComponent)
	{
		// only reset document if the child isn't
		// a document itself
		if (IUIComponent(child).document != child)
			IUIComponent(child).document = null;
		IUIComponent(child).parentChanged(null);
	}
}

/**
 *  Initializes the internal structure of this component.
 *
 *  <p>Initializing a UIComponent is the fourth step in the creation
 *  of a visual component instance, and happens automatically
 *  the first time that the instance is added to a parent.
 *  Therefore, you do not generally need to call
 *  <code>initialize()</code>; the Flex framework calls it for you
 *  from UIComponent's override of the <code>addChild()</code>
 *  and <code>addChildAt()</code> methods.</p>
 *
 *  <p>The first step in the creation of a visual component instance
 *  is construction, with the <code>new</code> operator:</p>
 *
 *  <pre>
 *  var okButton:Button = new Button();</pre>
 *
 *  <p>After construction, the new Button instance is a solitary
 *  DisplayObject; it does not yet have a UITextField as a child
 *  to display its label, and it doesn't have a parent.</p>
 *
 *  <p>The second step is configuring the newly-constructed instance
 *  with the appropriate properties, styles, and event handlers:</p>
 *
 *  <pre>
 *  okButton.label = "OK";
 *  okButton.setStyle("cornerRadius", 0);
 *  okButton.addEventListener(MouseEvent.CLICK, clickHandler);</pre>
 *
 *  <p>The third step is adding the instance to a parent:</p>
 *
 *  <pre>
 *  someContainer.addChild(okButton);</pre>
 *
 *  <p>A side effect of calling <code>addChild()</code>
 *  or <code>addChildAt()</code>, when adding a component to a parent
 *  for the first time, is that <code>initialize</code> gets
 *  automatically called.</p>
 *
 *  <p>This method first dispatches a <code>preinitialize</code> event,
 *  giving developers using this component a chance to affect it
 *  before its internal structure has been created.
 *  Next it calls the <code>createChildren()</code> method
 *  to create the component's internal structure; for a Button,
 *  this method creates and adds the UITextField for the label.
 *  Then it dispatches an <code>initialize</code> event,
 *  giving developers a chance to affect the component
 *  after its internal structure has been created.</p>
 *
 *  <p>Note that it is the act of attaching a component to a parent
 *  for the first time that triggers the creation of its internal structure.
 *  If its internal structure includes other UIComponents, then this is a
 *  recursive process in which the tree of DisplayObjects grows by one leaf
 *  node at a time.</p>
 *
 *  <p>If you are writing a component, you do not need
 *  to override this method.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function initialize():void
{
	if (initialized)
		return;
	
	// The "preinitialize" event gets dispatched after everything about this
	// DisplayObject has been initialized, and it has been attached to
	// its parent, but before any of its children have been created.
	// This allows a "preinitialize" event handler to set properties which
	// affect child creation.
	// Note that this implies that "preinitialize" handlers are called
	// top-down; i.e., parents before children.
	dispatchEvent(new FlexEvent(FlexEvent.PREINITIALIZE));
	
	// Create child objects.
	
	CONFIG::performanceInstrumentation
	{
		var perfUtil:mx.utils.PerfUtil = mx.utils.PerfUtil.getInstance();
		var token:int = perfUtil.markStart();
	}
	
	createChildren();
	
	CONFIG::performanceInstrumentation
	{
		perfUtil.markEnd(".createChildren()", token, 2 /*tolerance*/, this);
	}
	
	childrenCreated();
	
	// Create and initialize the accessibility implementation.
	// for this component. For some components accessible object is attached
	// to child component so it should be called after createChildren
	initializeAccessibility();
	
	// This should always be the last thing that initialize() calls.
	initializationComplete();
}

/**
 *  Finalizes the initialization of this component.
 *
 *  <p>This method is the last code that executes when you add a component
 *  to a parent for the first time using <code>addChild()</code>
 *  or <code>addChildAt()</code>.
 *  It handles some housekeeping related to dispatching
 *  the <code>initialize</code> event.
 *  If you are writing a component, you do not need
 *  to override this method.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
protected function initializationComplete():void
{
	processedDescriptors = true;
}

/**
 *  Initializes this component's accessibility code.
 *
 *  <p>This method is called by the <code>initialize()</code> method to hook in the
 *  component's accessibility code, which resides in a separate class
 *  in the mx.accessibility package.
 *  Each subclass that supports accessibility must override this method
 *  because the hook-in process uses a different static variable
 *  in each subclass.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
protected function initializeAccessibility():void
{
	if (UIComponent.createAccessibilityImplementation != null)
		UIComponent.createAccessibilityImplementation(this);
}

/**
 *  Create child objects of the component.
 *  This is an advanced method that you might override
 *  when creating a subclass of UIComponent.
 *
 *  <p>A component that creates other components or objects within it is called a composite component.
 *  For example, the Flex ComboBox control is actually made up of a TextInput control
 *  to define the text area of the ComboBox, and a Button control to define the ComboBox arrow.
 *  Components implement the <code>createChildren()</code> method to create child
 *  objects (such as other components) within the component.</p>
 *
 *  <p>From within an override of the <code>createChildren()</code> method,
 *  you call the <code>addChild()</code> method to add each child object. </p>
 *
 *  <p>You do not call this method directly. Flex calls the
 *  <code>createChildren()</code> method in response to the call to
 *  the <code>addChild()</code> method to add the component to its parent. </p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
protected function createChildren():void
{
}

/**
 *  Performs any final processing after child objects are created.
 *  This is an advanced method that you might override
 *  when creating a subclass of UIComponent.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
protected function childrenCreated():void
{
	invalidateProperties();
	invalidateSize();
	invalidateDisplayList();
}