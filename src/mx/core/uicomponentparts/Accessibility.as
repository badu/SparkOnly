/**
 *  A convenience accessor for the <code>silent</code> property
 *  in this UIComponent's <code>accessibilityProperties</code> object.
 *
 *  <p>Note that <code>accessibilityEnabled</code> has the opposite sense from silent;
 *  <code>accessibilityEnabled</code> is <code>true</code> 
 *  when <code>silent</code> is <code>false</code>.</p>
 *
 *  <p>The getter simply returns <code>accessibilityProperties.silent</code>,
 *  or <code>true</code> if <code>accessibilityProperties</code> is null.
 *  The setter first checks whether <code>accessibilityProperties</code> is null, 
 *  and if it is, sets it to a new AccessibilityProperties instance.
 *  Then it sets <code>accessibilityProperties.silent</code>.</p>
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get accessibilityEnabled():Boolean
{
	return accessibilityProperties ? !accessibilityProperties.silent : true;
}

public function set accessibilityEnabled(value:Boolean):void
{
	if (!Capabilities.hasAccessibility)
		return;
	
	if (!accessibilityProperties) 
		accessibilityProperties = new AccessibilityProperties();
	
	accessibilityProperties.silent = !value;
	Accessibility.updateProperties();
}

/**
 *  A convenience accessor for the <code>name</code> property
 *  in this UIComponent's <code>accessibilityProperties</code> object.
 *
 *  <p>The getter simply returns <code>accessibilityProperties.name</code>,
 *  or "" if accessibilityProperties is null.
 *  The setter first checks whether <code>accessibilityProperties</code> is null, 
 *  and if it is, sets it to a new AccessibilityProperties instance.
 *  Then it sets <code>accessibilityProperties.name</code>.</p>
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get accessibilityName():String
{
	return accessibilityProperties ? accessibilityProperties.name : "";
}

public function set accessibilityName(value:String):void 
{
	if (!Capabilities.hasAccessibility)
		return;
	
	if (!accessibilityProperties)
		accessibilityProperties = new AccessibilityProperties();
	
	accessibilityProperties.name = value;
	Accessibility.updateProperties();
}

/**
 *  A convenience accessor for the <code>description</code> property
 *  in this UIComponent's <code>accessibilityProperties</code> object.
 *
 *  <p>The getter simply returns <code>accessibilityProperties.description</code>,
 *  or "" if <code>accessibilityProperties</code> is null.
 *  The setter first checks whether <code>accessibilityProperties</code> is null, 
 *  and if it is, sets it to a new AccessibilityProperties instance.
 *  Then it sets <code>accessibilityProperties.description</code>.</p>
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get accessibilityDescription():String 
{
	return accessibilityProperties ? accessibilityProperties.description : "";
}

public function set accessibilityDescription(value:String):void
{
	if (!Capabilities.hasAccessibility)
		return;
	
	if (!accessibilityProperties)
		accessibilityProperties = new AccessibilityProperties();
	
	accessibilityProperties.description = value;
	Accessibility.updateProperties();
}

/**
 *  A convenience accessor for the <code>shortcut</code> property
 *  in this UIComponent's <code>accessibilityProperties</code> object.
 *
 *  <p>The getter simply returns <code>accessibilityProperties.shortcut</code>,
 *  or "" if <code>accessibilityProperties</code> is null.
 *  The setter first checks whether <code>accessibilityProperties</code> is null, 
 *  and if it is, sets it to a new AccessibilityProperties instance.
 *  Then it sets <code>accessibilityProperties.shortcut</code>.</p>
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get accessibilityShortcut():String
{
	return accessibilityProperties ? accessibilityProperties.shortcut : "";
}

public function set accessibilityShortcut(value:String):void
{
	if (!Capabilities.hasAccessibility)
		return;
	
	if (!accessibilityProperties)
		accessibilityProperties = new AccessibilityProperties();
	
	accessibilityProperties.shortcut = value;
	Accessibility.updateProperties();
}