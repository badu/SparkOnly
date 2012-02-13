/**
 *  Returns <code>true</code> if the chain of <code>owner</code> properties
 *  points from <code>child</code> to this UIComponent.
 *
 *  @param child A UIComponent.
 *
 *  @return <code>true</code> if the child is parented or owned by this UIComponent.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function owns(child:DisplayObject):Boolean
{
	var childList:IChildList =
		this is IRawChildrenContainer ?
		IRawChildrenContainer(this).rawChildren :
		IChildList(this);
	
	if (childList.contains(child))
		return true;
	
	try
	{
		while (child && child != this)
		{
			// do a parent walk
			if (child is IUIComponent)
				child = IUIComponent(child).owner;
			else
				child = child.parent;
		}
	}
	catch (e:SecurityError)
	{
		// You can't own what you don't have access to.
		return false;
	}
	
	return child == this;
}

/**
 *  @private
 *  Finds a module factory that can create a TextField
 *  that can display the given font.
 *  This is important for embedded fonts, not for system fonts.
 *
 *  @param fontName The name of the fontFamily.
 *
 *  @param bold A flag which true if the font weight is bold,
 *  and false otherwise.
 *
 *  @param italic A flag which is true if the font style is italic,
 *  and false otherwise.
 *
 *  @return The IFlexModuleFactory that represents the context
 *  where an object wanting to  use the font should be created.
 */
mx_internal function getFontContext(fontName:String, bold:Boolean,
									italic:Boolean, embeddedCff:*=undefined):IFlexModuleFactory
{
	if (noEmbeddedFonts) 
		return null;
	
	var registry:IEmbeddedFontRegistry = embeddedFontRegistry;
	
	return registry ? registry.getAssociatedModuleFactory(
		fontName, bold, italic, this, moduleFactory, systemManager,
		embeddedCff) : null;
}

/**
 *  Creates a new object using a context
 *  based on the embedded font being used.
 *
 *  <p>This method is used to solve a problem
 *  with access to fonts embedded  in an application SWF
 *  when the framework is loaded as an RSL
 *  (the RSL has its own SWF context).
 *  Embedded fonts can only be accessed from the SWF file context
 *  in which they were created.
 *  By using the context of the application SWF,
 *  the RSL can create objects in the application SWF context
 *  that has access to the application's  embedded fonts.</p>
 *
 *  <p>Call this method only after the font styles
 *  for this object are set.</p>
 *
 *  @param class The class to create.
 *
 *  @return The instance of the class created in the context
 *  of the SWF owning the embedded font.
 *  If this object is not using an embedded font,
 *  the class is created in the context of this object.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
protected function createInFontContext(classObj:Class):Object
{
	hasFontContextBeenSaved = true;
	
	var fontName:String = StringUtil.trimArrayElements(getStyle("fontFamily"), ",");
	var fontWeight:String = getStyle("fontWeight");
	var fontStyle:String = getStyle("fontStyle");
	var bold:Boolean = (fontWeight == "bold");
	var italic:Boolean = (fontStyle == "italic");
	
	var className:String = getQualifiedClassName(classObj);
	
	// If the caller requests a UITextField,
	// we may actually return a UITLFTextField,
	// depending on the version number
	// and the value of the textFieldClass style.
	if (className == "mx.core::UITextField")
	{
		className = getTextFieldClassName();
		if (className == "mx.core::UIFTETextField")
			classObj = Class(ApplicationDomain.currentDomain.
				getDefinition(className));
	}
	
	// Save for hasFontContextChanged().
	oldEmbeddedFontContext = getFontContext(fontName, bold, italic, 
		className == "mx.core::UIFTETextField");
	
	var moduleContext:IFlexModuleFactory = oldEmbeddedFontContext ?
		oldEmbeddedFontContext :
		moduleFactory;
	
	// Not in font registry, so create in this font context.
	var obj:Object = createInModuleContext(moduleContext, className);
	
	if (obj == null)
		obj = new classObj();
	
	// If we just created a UITLFTextField, set its fontContext property
	// so that it knows what module to use for creating its TextLines.
	if (className == "mx.core::UIFTETextField")
		obj.fontContext = moduleContext;
	
	return obj;
}

/**
 *  @private
 *  Returns either "mx.core::UITextField" or "mx.core::UIFTETextField",
 *  based on the version number and the textFieldClass style.
 */
private function getTextFieldClassName():String
{
	var c:Class = getStyle("textFieldClass");			
	if (!c)
		return "mx.core::UITextField";			
	return getQualifiedClassName(c);
}

/**
 *  @private
 *  Returns either "mx.core::TextInput" or "mx.core::MXFTETextInput",
 *  based on the version number and the textInputClass style.
 */
private function getTextInputClassName():String
{
	var c:Class = getStyle("textInputClass");			
	if (!c)
		return "mx.core::TextInput";			
	return getQualifiedClassName(c);
}

/**
 *  Creates the object using a given moduleFactory.
 *  If the moduleFactory is null or the object
 *  cannot be created using the module factory,
 *  then fall back to creating the object using a systemManager.
 *
 *  @param moduleFactory The moduleFactory to create the class in;
 *  can be null.
 *
 *  @param className The name of the class to create.
 *
 *  @return The object created in the context of the moduleFactory.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
protected function createInModuleContext(moduleFactory:IFlexModuleFactory,
										 className:String):Object
{
	var newObject:Object = null;
	
	if (moduleFactory)
		newObject = moduleFactory.create(className);
	
	return newObject;
}

/**
 *  @private
 *
 *  Tests if the current font context has changed
 *  since that last time createInFontContext() was called.
 */
public function hasFontContextChanged():Boolean
{
	
	// If the font has not been set yet, then return false;
	// the font has not changed.
	if (!hasFontContextBeenSaved)
		return false;
	
	// Check if the module factory has changed.
	var fontName:String =
		StringUtil.trimArrayElements(getStyle("fontFamily"), ",");
	var fontWeight:String = getStyle("fontWeight");
	var fontStyle:String = getStyle("fontStyle");
	var bold:Boolean = fontWeight == "bold";
	var italic:Boolean = fontStyle == "italic";
	var fontContext:IFlexModuleFactory = noEmbeddedFonts ? null : 
		embeddedFontRegistry.getAssociatedModuleFactory(
			fontName, bold, italic, this, moduleFactory,
			systemManager);
	return fontContext != oldEmbeddedFontContext;
}

/**
 *  @inheritDoc
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function createAutomationIDPart(child:IAutomationObject):Object
{
	if (automationDelegate)
		return automationDelegate.createAutomationIDPart(child);
	return null;
}

/**
 *  @inheritDoc
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public function createAutomationIDPartWithRequiredProperties(child:IAutomationObject, 
															 properties:Array):Object
{
	if (automationDelegate)
		return automationDelegate.createAutomationIDPartWithRequiredProperties(child, properties);
	return null;
}

/**
 *  @inheritDoc
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function resolveAutomationIDPart(criteria:Object):Array
{
	if (automationDelegate)
		return automationDelegate.resolveAutomationIDPart(criteria);
	return [];
}

/**
 *  @inheritDoc
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function getAutomationChildAt(index:int):IAutomationObject
{
	if (automationDelegate)
		return automationDelegate.getAutomationChildAt(index);
	return null;
}

/**
 *  @inheritDoc
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public function getAutomationChildren():Array
{
	if (automationDelegate)
		return automationDelegate.getAutomationChildren();
	return null;
}

/**
 *  @inheritDoc
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get numAutomationChildren():int
{
	if (automationDelegate)
		return automationDelegate.numAutomationChildren;
	return 0;
}

/**
 *  @inheritDoc
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get automationTabularData():Object
{
	if (automationDelegate)
		return automationDelegate.automationTabularData;
	return null;
}

//----------------------------------
//  automationOwner
//----------------------------------

/**
 *  @inheritDoc
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 4
 */
public function get automationOwner():DisplayObjectContainer
{
	return owner;
}

//----------------------------------
//  automationParent
//----------------------------------

/**
 *  @inheritDoc
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 4
 */
public function get automationParent():DisplayObjectContainer
{
	return parent;
}

//----------------------------------
//  automationEnabled
//----------------------------------

/**
 *  @inheritDoc
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 4
 */
public function get automationEnabled():Boolean
{
	return enabled;
}

//----------------------------------
//  automationVisible
//----------------------------------

/**
 *  @inheritDoc
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 4
 */
public function get automationVisible():Boolean
{
	return visible;
}

/**
 *  @inheritDoc
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function replayAutomatableEvent(event:Event):Boolean
{
	if (automationDelegate)
		return automationDelegate.replayAutomatableEvent(event);
	return false;
}


/**
 *  @private
 *
 *  Get the bounds of this object that are visible to the user
 *  on the screen.
 *
 *  @param targetParent The parent to stop at when calculating the visible
 *  bounds. If null, this object's system manager will be used as
 *  the parent.
 *
 *  @return a <code>Rectangle</code> including the visible portion of the this
 *  object. The rectangle is in global coordinates.
 */
public function getVisibleRect(targetParent:DisplayObject = null):Rectangle
{
	if (!targetParent)
		targetParent = DisplayObject(systemManager);
	
	var thisParent:DisplayObject = $parent ? $parent : parent;
	
	//  If the object is not on the display list then it is not visible.
	if (!thisParent)
		return new Rectangle();
	
	var pt:Point = new Point(x, y);
	pt = thisParent.localToGlobal(pt);
	
	// bounds of this object to return. Keep in global coordinates
	// until the end and set back to targetParent coordinates.
	var bounds:Rectangle = new Rectangle(pt.x, pt.y, width, height);
	var current:DisplayObject = this;
	var currentRect:Rectangle = new Rectangle();
	
	do
	{
		if (current is UIComponent)
		{
			if (UIComponent(current).$parent)
				current = UIComponent(current).$parent;
			else
				current = UIComponent(current).parent;
		}
		else
			current = current.parent;
		
		if (current && current.scrollRect)
		{
			// clip the bounds by the scroll rect
			currentRect = current.scrollRect.clone();
			pt = current.localToGlobal(currentRect.topLeft);
			currentRect.x = pt.x;
			currentRect.y = pt.y;
			bounds = bounds.intersection(currentRect);
		}
	} while (current && current != targetParent);
	
	return bounds;
}