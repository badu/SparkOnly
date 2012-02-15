/**
 *  @private
 */
private var cachedTextFormat:UITextFormat;

//----------------------------------
//  inheritingStyles
//----------------------------------

/**
 *  @private
 *  Storage for the inheritingStyles property.
 */
private var _inheritingStyles:Object = StyleProtoChain.STYLE_UNINITIALIZED;

[Inspectable(environment="none")]

/**
 *  The beginning of this component's chain of inheriting styles.
 *  The <code>getStyle()</code> method simply accesses
 *  <code>inheritingStyles[styleName]</code> to search the entire
 *  prototype-linked chain.
 *  This object is set up by <code>initProtoChain()</code>.
 *  Developers typically never need to access this property directly.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get inheritingStyles():Object
{
	return _inheritingStyles;
}

/**
 *  @private
 */
public function set inheritingStyles(value:Object):void
{
	_inheritingStyles = value;
}

//----------------------------------
//  nonInheritingStyles
//----------------------------------

/**
 *  @private
 *  Storage for the nonInheritingStyles property.
 */
private var _nonInheritingStyles:Object =
	StyleProtoChain.STYLE_UNINITIALIZED;

[Inspectable(environment="none")]

/**
 *  The beginning of this component's chain of non-inheriting styles.
 *  The <code>getStyle()</code> method simply accesses
 *  <code>nonInheritingStyles[styleName]</code> to search the entire
 *  prototype-linked chain.
 *  This object is set up by <code>initProtoChain()</code>.
 *  Developers typically never need to access this property directly.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get nonInheritingStyles():Object
{
	return _nonInheritingStyles;
}

/**
 *  @private
 */
public function set nonInheritingStyles(value:Object):void
{
	_nonInheritingStyles = value;
}

//----------------------------------
//  styleDeclaration
//----------------------------------

/**
 *  @private
 *  Storage for the styleDeclaration property.
 */
private var _styleDeclaration:CSSStyleDeclaration;

[Inspectable(environment="none")]

/**
 *  Storage for the inline inheriting styles on this object.
 *  This CSSStyleDeclaration is created the first time that
 *  the <code>setStyle()</code> method
 *  is called on this component to set an inheriting style.
 *  Developers typically never need to access this property directly.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get styleDeclaration():CSSStyleDeclaration
{
	return _styleDeclaration;
}

/**
 *  @private
 */
public function set styleDeclaration(value:CSSStyleDeclaration):void
{
	_styleDeclaration = value;
}
/**
 *  The state to be used when matching CSS pseudo-selectors. By default
 *  this is the <code>currentState</code>.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */ 
protected function get currentCSSState():String
{
	return currentState;
}

/**
 *  A component's parent is used to evaluate descendant selectors. A parent
 *  must also be an IAdvancedStyleClient to participate in advanced style
 *  declarations.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */ 
public function get styleParent():IAdvancedStyleClient
{
	return parent as IAdvancedStyleClient;
}

public function set styleParent(parent:IAdvancedStyleClient):void
{
	
}

/**
 *  @inheritDoc
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function matchesCSSState(cssState:String):Boolean
{
	return currentCSSState == cssState;
}

/**
 *  @inheritDoc
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */ 
public function matchesCSSType(cssType:String):Boolean
{
	return StyleProtoChain.matchesCSSType(this, cssType);
}

/**
 *  @inheritDoc
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.6
 */
public function hasCSSState():Boolean
{
	return currentCSSState != null;
}

/**
 *  @private
 *  Sets up the inheritingStyles and nonInheritingStyles objects
 *  and their proto chains so that getStyle() can work.
 */
//  Note that initProtoChain is 99% copied into DataGridItemRenderer
mx_internal function initProtoChain():void
{
	StyleProtoChain.initProtoChain(this);
}

/**
 *  Finds the type selectors for this UIComponent instance.
 *  The algorithm walks up the superclass chain.
 *  For example, suppose that class MyButton extends Button.
 *  A MyButton instance first looks for a MyButton type selector
 *  then, it looks for a Button type selector.
 *  then, it looks for a UIComponent type selector.
 *  (The superclass chain is considered to stop at UIComponent, not Object.)
 *
 *  @return An Array of type selectors for this UIComponent instance.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function getClassStyleDeclarations():Array
{
	return StyleProtoChain.getClassStyleDeclarations(this);
}

/**
 *  Builds or rebuilds the CSS style cache for this component
 *  and, if the <code>recursive</code> parameter is <code>true</code>,
 *  for all descendants of this component as well.
 *
 *  <p>The Flex framework calls this method in the following
 *  situations:</p>
 *
 *  <ul>
 *    <li>When you add a UIComponent to a parent using the
 *    <code>addChild()</code> or <code>addChildAt()</code> methods.</li>
 *    <li>When you change the <code>styleName</code> property
 *    of a UIComponent.</li>
 *    <li>When you set a style in a CSS selector using the
 *    <code>setStyle()</code> method of CSSStyleDeclaration.</li>
 *  </ul>
 *
 *  <p>Building the style cache is a computation-intensive operation,
 *  so avoid changing <code>styleName</code> or
 *  setting selector styles unnecessarily.</p>
 *
 *  <p>This method is not called when you set an instance style
 *  by calling the <code>setStyle()</code> method of UIComponent.
 *  Setting an instance style is a relatively fast operation
 *  compared with setting a selector style.</p>
 *
 *  <p>You do not need to call or override this method.</p>
 *
 *  @param recursive Recursively regenerates the style cache for
 *  all children of this component.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function regenerateStyleCache(recursive:Boolean):void
{
	// Regenerate the proto chain for this object
	initProtoChain();
	
	var childList:IChildList =
		this is IRawChildrenContainer ?
		IRawChildrenContainer(this).rawChildren :
		IChildList(this);
	
	// Recursively call this method on each child.
	var n:int = childList.numChildren;
	
	for (var i:int = 0; i < n; i++)
	{
		var child:Object = childList.getChildAt(i);
		
		if (child is IStyleClient)
		{
			// Does this object already have a proto chain?
			// If not, there's no need to regenerate a new one.
			if (IStyleClient(child).inheritingStyles !=
				StyleProtoChain.STYLE_UNINITIALIZED)
			{
				IStyleClient(child).regenerateStyleCache(recursive);
			}
		}		
	}
	
	// Call this method on each non-visual StyleClient
	if (advanceStyleClientChildren != null)
	{
		for (var styleClient:Object in advanceStyleClientChildren)
		{
			var iAdvanceStyleClientChild:IAdvancedStyleClient = styleClient
				as IAdvancedStyleClient;
			
			if (iAdvanceStyleClientChild && 
				iAdvanceStyleClientChild.inheritingStyles !=
				StyleProtoChain.STYLE_UNINITIALIZED)
			{
				iAdvanceStyleClientChild.regenerateStyleCache(recursive);
			}
		}
	}
}
/**
 *  This method is called when a state changes to check whether
 *  state-specific styles apply to this component. If there is a chance
 *  of a matching CSS pseudo-selector for the current state, the style
 *  cache needs to be regenerated for this instance and, potentially all
 *  children, if the <code>recursive</code> param is set to <code>true</code>.
 *
 *  @param oldState The name of th eold state.
 *
 *  @param newState The name of the new state.
 *
 *  @param recursive Set to <code>true</code> to perform a recursive check.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
protected function stateChanged(oldState:String, newState:String, recursive:Boolean):void
{
	// This test only checks for pseudo conditions on the subject of the selector.
	// Pseudo conditions on ancestor selectors are not detected - eg:
	//    List ScrollBar:inactive #track
	// The track styles will not change when the scrollbar is in the inactive state.
	if (currentCSSState && oldState != newState &&
		(styleManager.hasPseudoCondition(oldState) ||
			styleManager.hasPseudoCondition(newState)))
	{
		regenerateStyleCache(recursive);
		
		styleChanged(null);
		notifyStyleChangeInChildren(null, recursive);
	}
}

[Bindable(style="true")]
/**
 *  Gets a style property that has been set anywhere in this
 *  component's style lookup chain.
 *
 *  <p>This same method is used to get any kind of style property,
 *  so the value returned can be a Boolean, String, Number, int,
 *  uint (for an RGB color), Class (for a skin), or any kind of object.
 *  Therefore the return type is simply specified as ~~.</p>
 *
 *  <p>If you are getting a particular style property, you 
 *  know its type and often want to store the result in a
 *  variable of that type.
 *  No casting from ~~ to that type is necessary.</p>
 *
 *  <p>
 *  <code>
 *  var backgroundColor:uint = getStyle("backgroundColor");
 *  </code>
 *  </p>
 *
 *  <p>If the style property has not been set anywhere in the
 *  style lookup chain, the value returned by <code>getStyle()</code>
 *  is <code>undefined</code>.
 *  Note that <code>undefined</code> is a special value that is
 *  not the same as <code>false</code>, <code>""</code>,
 *  <code>NaN</code>, <code>0</code>, or <code>null</code>.
 *  No valid style value is ever <code>undefined</code>.
 *  You can use the method
 *  <code>IStyleManager2.isValidStyleValue()</code>
 *  to test whether the value was set.</p>
 *
 *  @param styleProp Name of the style property.
 *
 *  @return Style value.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function getStyle(styleProp:String):*
{
	// If a moduleFactory has not be set yet, first check for any deferred
	// styles. If there are no deferred styles or the styleProp is not in 
	// the deferred styles, the look in the proto chain.
	if (!moduleFactory)
	{
		if (deferredSetStyles && deferredSetStyles[styleProp] !== undefined)
			return deferredSetStyles[styleProp];
	}
	
	return styleManager.inheritingStyles[styleProp] ?
		_inheritingStyles[styleProp] :
		_nonInheritingStyles[styleProp];
}

/**
 *  Sets a style property on this component instance.
 *
 *  <p>This can override a style that was set globally.</p>
 *
 *  <p>Calling the <code>setStyle()</code> method can result in decreased performance.
 *  Use it only when necessary.</p>
 *
 *  @param styleProp Name of the style property.
 *
 *  @param newValue New value for the style.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function setStyle(styleProp:String, newValue:*):void
{
	// If there is no module factory then defer the set
	// style until a module factory is set.
	if (moduleFactory)
	{
		StyleProtoChain.setStyle(this, styleProp, newValue);
	}
	else
	{
		if (!deferredSetStyles)
			deferredSetStyles = new Object();
		deferredSetStyles[styleProp] = newValue;
	}   
}


/**
 *  @private
 *  Set styles that were deferred because a module factory was not
 *  set yet.
 */
private function setDeferredStyles():void
{
	if (!deferredSetStyles)
		return;
	
	for (var styleProp:String in deferredSetStyles)
		StyleProtoChain.setStyle(this, styleProp, deferredSetStyles[styleProp]);
	
	deferredSetStyles = null;
}

/**
 *  Deletes a style property from this component instance.
 *
 *  <p>This does not necessarily cause the <code>getStyle()</code> method
 *  to return <code>undefined</code>.</p>
 *
 *  @param styleProp The name of the style property.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function clearStyle(styleProp:String):void
{
	setStyle(styleProp, undefined);
}

/**
 *  @private
 */
mx_internal var advanceStyleClientChildren:Dictionary = null;

/**
 *  Adds a non-visual style client to this component instance. Once 
 *  this method has been called, the style client will inherit style 
 *  changes from this component instance. Style clients that are
 *  DisplayObjects must use the <code>addChild</code> or 
 *  <code>addChildAt</code> methods to be added to a 
 *  <code>UIComponent</code>.
 *  
 *  As a side effect, this method will set the <code>styleParent</code> 
 *  property of the <code>styleClient</code> parameter to reference 
 *  this instance of the <code>UIComponent</code>.
 *  
 *  If the <code>styleClient</code> parameter already has a
 *  <code>styleParent</code>, this method will call
 *  <code>removeStyleClient</code> from this previous
 *  <code>styleParent</code>.  
 * 
 * 
 *  @param styleClient The <code>IAdvancedStyleClient</code> to 
 *  add to this component's list of non-visual style clients.
 * 
 *  @throws ArgumentError if the <code>styleClient</code> parameter
 *  is a <code>DisplayObject</code>. 
 * 
 *  @see removeStyleClient
 *  @see mx.styles.IAdvancedStyleClient
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 4.5
 */
public function addStyleClient(styleClient:IAdvancedStyleClient):void
{
	if(!(styleClient is DisplayObject))
	{
		if(styleClient.styleParent!=null)
		{
			var parentComponent:UIComponent = styleClient.styleParent as UIComponent;
			if (parentComponent)
				parentComponent.removeStyleClient(styleClient);
		}
		// Create a dictionary with weak references to the key
		if (advanceStyleClientChildren == null)
			advanceStyleClientChildren = new Dictionary(true);
		// Add the styleClient as a key in the dictionary. 
		// The value assigned to this key entry is currently not used.
		advanceStyleClientChildren[styleClient] = true;  
		styleClient.styleParent=this;
		
		styleClient.regenerateStyleCache(true);
		
		styleClient.styleChanged(null);
	}
	else
	{
		var message:String = ResourceManager.getInstance().getString(
			"core", "badParameter", [ styleClient ]);
		throw new ArgumentError(message);
	}
}

/**
 *  Removes a non-visual style client from this component instance. 
 *  Once this method has been called, the non-visual style client will
 *  no longer inherit style changes from this component instance.
 *  
 *  As a side effect, this method will set the 
 *  <code>styleParent</code> property of the <code>styleClient</code>
 *  parameter to <code>null</code>. 
 * 
 *  If the <code>styleClient</code> has not been added to this
 *  component instance, no action will be taken. 
 * 
 *  @param styleClient The <code>IAdvancedStyleClient</code> to remove
 *  from this component's list of non-visual style clients.
 * 
 *  @return The non-visual style client that was passed in as the
 *  <code>styleClient</code> parameter. 
 * 
 *  @see addStyleClient
 *  @see mx.styles.IAdvancedStyleClient
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 4.5
 */
public function removeStyleClient(styleClient:IAdvancedStyleClient):void
{
	if(advanceStyleClientChildren && 
		advanceStyleClientChildren[styleClient])
	{
		delete advanceStyleClientChildren[styleClient];
		
		styleClient.styleParent = null;
		
		styleClient.regenerateStyleCache(true);
		
		styleClient.styleChanged(null);
	}
}

/**
 *  Propagates style changes to the children.
 *  You typically never need to call this method.
 *
 *  @param styleProp String specifying the name of the style property.
 *
 *  @param recursive Recursivly notify all children of this component.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function notifyStyleChangeInChildren(
	styleProp:String, recursive:Boolean):void
{
	cachedTextFormat = null;
	
	var n:int = numChildren;
	for (var i:int = 0; i < n; i++)
	{
		var child:ISimpleStyleClient = getChildAt(i) as ISimpleStyleClient;
		
		if (child)
		{
			child.styleChanged(styleProp);
			
			// Always recursively call this function because of my
			// descendants might have a styleName property that points
			// to this object.  The recursive flag is respected in
			// Container.notifyStyleChangeInChildren.
			if (child is IStyleClient)
				IStyleClient(child).notifyStyleChangeInChildren(styleProp, recursive);
		}
	}
	
	if (advanceStyleClientChildren != null)
	{
		for (var styleClient:Object in advanceStyleClientChildren)
		{
			var iAdvanceStyleClientChild:IAdvancedStyleClient = styleClient
				as IAdvancedStyleClient;
			
			if (iAdvanceStyleClientChild)
			{
				iAdvanceStyleClientChild.styleChanged(styleProp);
			}
		}
	}
}