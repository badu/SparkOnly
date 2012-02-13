/**
 *  Used by layout logic to validate the properties of a component
 *  by calling the <code>commitProperties()</code> method.
 *  In general, subclassers should
 *  override the <code>commitProperties()</code> method and not this method.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function validateProperties():void
{
	if (invalidatePropertiesFlag)
	{
		commitProperties();
		
		invalidatePropertiesFlag = false;
	}
}

/**
 *  Processes the properties set on the component.
 *  This is an advanced method that you might override
 *  when creating a subclass of UIComponent.
 *
 *  <p>You do not call this method directly.
 *  Flex calls the <code>commitProperties()</code> method when you
 *  use the <code>addChild()</code> method to add a component to a container,
 *  or when you call the <code>invalidateProperties()</code> method of the component.
 *  Calls to the <code>commitProperties()</code> method occur before calls to the
 *  <code>measure()</code> method. This lets you set property values that might
 *  be used by the <code>measure()</code> method.</p>
 *
 *  <p>Some components have properties that affect the number or kinds
 *  of child objects that they need to create, or have properties that
 *  interact with each other, such as the <code>horizontalScrollPolicy</code>
 *  and <code>horizontalScrollPosition</code> properties.
 *  It is often best at startup time to process all of these
 *  properties at one time to avoid duplicating work.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
protected function commitProperties():void
{			
	// Handle a deferred state change request.
	if (_currentStateDeferred != null)
	{
		var newState:String = _currentStateDeferred;
		_currentStateDeferred = null;
		currentState = newState;
	}			
	oldScaleX = scaleX;
	oldScaleY = scaleY;			
	// Typically state changes occur immediately, but during
	// component initialization we defer until commitProperties to 
	// reduce a bit of the startup noise.
	if (_currentStateChanged && !initialized)
	{
		_currentStateChanged = false;
		commitCurrentState();
	}			
	// If this component's layout direction has changed, or its parent's layoutDirection
	// has changed, then call invalidateLayoutDirection().
	const parentUIC:UIComponent = parent as UIComponent;
	
	if ((oldLayoutDirection != layoutDirection) || parentChangedFlag ||
		(parentUIC && (parentUIC.layoutDirection != parentUIC.oldLayoutDirection)))
		invalidateLayoutDirection();
	
	
	if (x != oldX || y != oldY)
	{
		dispatchMoveEvent();
	}
	
	if (width != oldWidth || height != oldHeight)
		dispatchResizeEvent();
	
	if (errorStringChanged)
	{
		errorStringChanged = false;          
		if (getStyle("showErrorTip"))
			ToolTipManager.registerErrorString(this, oldErrorString, errorString);
		
		setBorderColorForErrorString();
	}
	
	if (blendModeChanged)
	{
		blendModeChanged = false; 
		
		if (!blendShaderChanged)
		{
			$blendMode = _blendMode; 
		}
		else
		{
			// The graphic element's blendMode was set to a non-Flash 
			// blendMode. We mimic the look by instantiating the 
			// appropriate shader class and setting the blendShader
			// property on the displayObject. 
			blendShaderChanged = false; 
			
			$blendMode = BlendMode.NORMAL; 
			
			switch(_blendMode)
			{
				case "color": 
				{
					$blendShader = new ColorShader();
					break; 
				}
				case "colordodge":
				{
					$blendShader = new ColorDodgeShader();
					break; 
				}
				case "colorburn":
				{
					$blendShader = new ColorBurnShader();
					break; 
				}
				case "exclusion":
				{
					$blendShader = new ExclusionShader();
					break; 
				}
				case "hue":
				{
					$blendShader = new HueShader();
					break; 
				}
				case "luminosity":
				{
					$blendShader = new LuminosityShader();
					break; 
				}
				case "saturation": 
				{
					$blendShader = new SaturationShader();
					break; 
				}
				case "softlight":
				{
					$blendShader = new SoftLightShader();
					break; 
				}
			}        
		}
	}
	
	parentChangedFlag = false;
}