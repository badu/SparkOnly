//----------------------------------
//  baselinePosition
//----------------------------------

/**
 *  @inheritDoc
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get baselinePosition():Number
{
	if (!validateBaselinePosition())
		return NaN;
	
	// Unless the height is very small, the baselinePosition
	// of a generic UIComponent is calculated as if there was
	// a UITextField using the component's styles
	// whose top coincides with the component's top.
	// If the height is small, the baselinePosition is calculated
	// as if there were text within whose ascent the component
	// is vertically centered.
	// At the crossover height, these two calculations
	// produce the same result.
	
	/**
	 * Bogdan : removed
	var lineMetrics:TextLineMetrics = measureText("Wj");
	
	if (height < 2 + lineMetrics.ascent + 2)
		return int(height + (lineMetrics.ascent - height) / 2);
	
	return 2 + lineMetrics.ascent;
	*/
	
	if (height < 4)
		return 0;
	
	return 2;
}

//----------------------------------
//  className
//----------------------------------

/**
 *  The name of this instance's class, such as <code>"Button"</code>.
 *
 *  <p>This string does not include the package name.
 *  If you need the package name as well, call the
 *  <code>getQualifiedClassName()</code> method in the flash.utils package.
 *  It returns a string such as <code>"mx.controls::Button"</code>.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get className():String
{
	return NameUtil.getUnqualifiedClassName(this);
}

//----------------------------------
//  effectsStarted
//----------------------------------

/**
 *  The list of effects that are currently playing on the component,
 *  as an Array of EffectInstance instances.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get activeEffects():Array
{
	return _effectsStarted;
}

//----------------------------------
//  flexContextMenu
//----------------------------------

/**
 *  @private
 *  Storage for the flexContextMenu property.
 */
private var _flexContextMenu:IFlexContextMenu;

/**
 *  The context menu for this UIComponent.
 *
 *  @default null
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get flexContextMenu():IFlexContextMenu
{
	return _flexContextMenu;
}

/**
 *  @private
 */
public function set flexContextMenu(value:IFlexContextMenu):void
{
	if (_flexContextMenu)
		_flexContextMenu.unsetContextMenu(this);
	
	_flexContextMenu = value;
	
	if (value != null)
		_flexContextMenu.setContextMenu(this);
}

//----------------------------------
//  styleName
//----------------------------------

/**
 *  @private
 *  Storage for the styleName property.
 */
private var _styleName:Object /* String, CSSStyleDeclaration, or UIComponent */;

[Inspectable(category="General")]

/**
 *  The class style used by this component. This can be a String, CSSStyleDeclaration
 *  or an IStyleClient.
 *
 *  <p>If this is a String, it is the name of one or more whitespace delimited class
 *  declarations in an <code>&lt;fx:Style&gt;</code> tag or CSS file. You do not include the period
 *  in the <code>styleName</code>. For example, if you have a class style named <code>".bigText"</code>,
 *  set the <code>styleName</code> property to <code>"bigText"</code> (no period).</p>
 *
 *  <p>If this is an IStyleClient (typically a UIComponent), all styles in the
 *  <code>styleName</code> object are used by this component.</p>
 *
 *  @default null
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get styleName():Object /* String, CSSStyleDeclaration, or UIComponent */
{
	return _styleName;
}

/**
 *  @private
 */
public function set styleName(value:Object /* String, CSSStyleDeclaration, or UIComponent */):void
{
	if (_styleName === value)
		return;
	
	_styleName = value;
	
	// If inheritingStyles is undefined, then this object is being
	// initialized and we haven't yet generated the proto chain.
	// To avoid redundant work, don't bother to create
	// the proto chain here.
	if (inheritingStyles == StyleProtoChain.STYLE_UNINITIALIZED)
		return;
	
	regenerateStyleCache(true);
	
	styleChanged("styleName");
	
	notifyStyleChangeInChildren("styleName", true);
}

//----------------------------------
//  toolTip
//----------------------------------

/**
 *  @private
 *  Storage for the toolTip property.
 */
mx_internal var _toolTip:String;

[Bindable("toolTipChanged")]
[Inspectable(category="General", defaultValue="null")]

/**
 *  Text to display in the ToolTip.
 *
 *  @default null
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get toolTip():String
{
	return _toolTip;
}

/**
 *  @private
 */
public function set toolTip(value:String):void
{
	var oldValue:String = _toolTip;
	_toolTip = value;
	
	ToolTipManager.registerToolTip(this, oldValue, value);
	
	dispatchEvent(new Event("toolTipChanged"));
}

//----------------------------------
//  uid
//----------------------------------

/**
 *  @private
 */
private var _uid:String;

/**
 *  A unique identifier for the object.
 *  Flex data-driven controls, including all controls that are
 *  subclasses of List class, use a UID to track data provider items.
 *
 *  <p>Flex can automatically create and manage UIDs.
 *  However, there are circumstances when you must supply your own
 *  <code>uid</code> property by implementing the IUID interface,
 *  or when supplying your own <code>uid</code> property improves processing efficiency.
 *  UIDs do not need to be universally unique for most uses in Flex.
 *  One exception is for messages sent by data services.</p>
 *
 *  @see IUID
 *  @see mx.utils.UIDUtil
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get uid():String
{
	if (!_uid)
		_uid = toString();
	
	return _uid;
}

/**
 *  @private
 */
public function set uid(uid:String):void
{
	this._uid = uid;
}

//----------------------------------
//  indexedID
//----------------------------------

/**
 *  @private
 *  Utility getter used by uid. It returns an indexed id string
 *  such as "foo[1][2]" if this object is a repeated object,
 *  or a nonindexed id string like "bar" if it isn't.
 */
private function get indexedID():String
{
	var s:String = id;
	var indices:Array /* of int */ = instanceIndices;
	if (indices)
		s += "[" + indices.join("][") + "]";
	return s;
}