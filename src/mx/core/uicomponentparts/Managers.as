//----------------------------------
//  cursorManager
//----------------------------------

/**
 *  Gets the CursorManager that controls the cursor for this component
 *  and its peers.
 *  Each top-level window has its own instance of a CursorManager;
 *  To make sure you're talking to the right one, use this method.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get cursorManager():ICursorManager
{
	var o:DisplayObject = parent;
	
	while (o)
	{
		if (o is IUIComponent && "cursorManager" in o)
		{
			var cm:ICursorManager = o["cursorManager"];
			return cm;
		}
		
		o = o.parent;
	}
	
	return CursorManager.getInstance();
}

//----------------------------------
//  focusManager
//----------------------------------

/**
 *  @private
 *  Storage for the focusManager property.
 */
private var _focusManager:IFocusManager;

[Inspectable(environment="none")]

/**
 *  Gets the FocusManager that controls focus for this component
 *  and its peers.
 *  Each popup has its own focus loop and therefore its own instance
 *  of a FocusManager.
 *  To make sure you're talking to the right one, use this method.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get focusManager():IFocusManager
{
	if (_focusManager)
		return _focusManager;
	
	var o:DisplayObject = parent;
	
	while (o)
	{
		if (o is IFocusManagerContainer)
			return IFocusManagerContainer(o).focusManager;
		
		o = o.parent;
	}
	
	return null;
}

/**
 *  @private
 *  IFocusManagerContainers have this property assigned by the framework
 */
public function set focusManager(value:IFocusManager):void
{
	_focusManager = value;
	dispatchEvent(new FlexEvent(FlexEvent.ADD_FOCUS_MANAGER));
}	

//----------------------------------
//  styleManager
//----------------------------------

/**
 *  @private
 */
private var _styleManager:IStyleManager2;

/**
 *  Returns the StyleManager instance used by this component.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public function get styleManager():IStyleManager2
{
	if (!_styleManager)
		_styleManager = StyleManager.getStyleManager(moduleFactory);
	
	return _styleManager;
}

//----------------------------------
//  systemManager
//----------------------------------

/**
 *  @private
 *  Storage for the systemManager property.
 *  Set by the SystemManager so that each UIComponent
 *  has a references to its SystemManager
 */
private var _systemManager:ISystemManager;

/**
 *  @private
 *  if component has been reparented, we need to potentially
 *  reassign systemManager, cause we could be in a new Window.
 */
private var _systemManagerDirty:Boolean = false;

[Inspectable(environment="none")]

/**
 *  Returns the SystemManager object used by this component.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get systemManager():ISystemManager
{
	if (!_systemManager || _systemManagerDirty)
	{
		var r:DisplayObject = root;
		if (_systemManager && _systemManager.isProxy)
		{
			// keep the existing proxy
		}
		else if (r && !(r is Stage))
		{
			// If this object is attached to the display list, then
			// the root property holds its SystemManager.
			_systemManager = (r as ISystemManager);
		}
		else if (r)
		{
			// if the root is the Stage, then we are in a second AIR window
			_systemManager = Stage(r).getChildAt(0) as ISystemManager;
		}
		else
		{
			// If this object isn't attached to the display list, then
			// we need to walk up the parent chain ourselves.
			var o:DisplayObjectContainer = parent;
			while (o)
			{
				var ui:IUIComponent = o as IUIComponent;
				if (ui)
				{
					_systemManager = ui.systemManager;
					break;
				}
				else if (o is ISystemManager)
				{
					_systemManager = o as ISystemManager;
					break;
				}
				o = o.parent;
			}
		}
		_systemManagerDirty = false;
	}
	
	return _systemManager;
}

/**
 *  @private
 */
public function set systemManager(value:ISystemManager):void
{
	_systemManager = value;
	_systemManagerDirty = false;
}

/**
 *  @private
 *  Returns the current system manager, <code>systemManager</code>,
 *  unless it is null.
 *  If the current system manager is null,
 *  then search to find the correct system manager.
 *
 *  @return A system manager. This value is never null.
 */
mx_internal function getNonNullSystemManager():ISystemManager
{
	if (!systemManager)
		systemManager = ISystemManager(SystemManager.getSWFRoot(this));
	
	if (!systemManager)
		return SystemManagerGlobals.topLevelSystemManagers[0];
	
	return systemManager;
}

/**
 *  @private
 */
protected function invalidateSystemManager():void
{
	var childList:IChildList = (this is IRawChildrenContainer) ?
		IRawChildrenContainer(this).rawChildren : IChildList(this);
	
	var n:int = childList.numChildren;
	for (var i:int = 0; i < n; i++)
	{
		var child:UIComponent = childList.getChildAt(i) as UIComponent;
		if (child)
			child.invalidateSystemManager();
	}
	_systemManagerDirty = true;
}

//----------------------------------
//  nestLevel
//----------------------------------

/**
 *  @private
 *  Storage for the nestLevel property.
 */
private var _nestLevel:int = 0;

[Inspectable(environment="none")]

/**
 *  Depth of this object in the containment hierarchy.
 *  This number is used by the measurement and layout code.
 *  The value is 0 if this component is not on the DisplayList.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get nestLevel():int
{
	return _nestLevel;
}

/**
 *  @private
 */
public function set nestLevel(value:int):void
{
	// If my parent hasn't been attached to the display list, then its nestLevel
	// will be zero.  If it tries to set my nestLevel to 1, ignore it.  We'll
	// update nest levels again after the parent is added to the display list.
	if (value == 1)
		return;
	
	// Also punt if the new value for nestLevel is the same as my current value.
	// TODO: (aharui) add early exit if nestLevel isn't changing
	if (value > 1 && _nestLevel != value)
	{
		_nestLevel = value;
		
		updateCallbacks();
		
		value ++;
	}
	else if (value == 0)
		_nestLevel = value = 0;
	else
		value ++;
	
	var childList:IChildList = (this is IRawChildrenContainer) ?
		IRawChildrenContainer(this).rawChildren : IChildList(this);
	
	var n:int = childList.numChildren;
	for (var i:int = 0; i < n; i++)
	{
		var ui:ILayoutManagerClient  = childList.getChildAt(i) as ILayoutManagerClient;
		if (ui)
		{
			ui.nestLevel = value;
		}
	}
}