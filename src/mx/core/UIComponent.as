////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////

package mx.core
{   
	import flash.accessibility.Accessibility;
	import flash.accessibility.AccessibilityProperties;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.InteractiveObject;
	import flash.display.Loader;
	import flash.display.Shader;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventPhase;
	import flash.events.FocusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	import flash.geom.Vector3D;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.text.TextFormatAlign;
	import flash.text.TextLineMetrics;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import mx.automation.IAutomationObject;
	import mx.binding.BindingManager;
	import mx.controls.IFlexContextMenu;
	import mx.effects.EffectManager;
	import mx.effects.IEffect;
	import mx.effects.IEffectInstance;
	import mx.events.ChildExistenceChangedEvent;
	import mx.events.DynamicEvent;
	import mx.events.EffectEvent;
	import mx.events.FlexEvent;
	import mx.events.MoveEvent;
	import mx.events.PropertyChangeEvent;
	import mx.events.ResizeEvent;
	import mx.events.StateChangeEvent;
	import mx.events.ValidationResultEvent;
	import mx.filters.BaseFilter;
	import mx.filters.IBitmapFilter;
	import mx.geom.RoundedRectangle;
	import mx.geom.Transform;
	import mx.geom.TransformOffsets;
	import mx.graphics.shaderClasses.ColorBurnShader;
	import mx.graphics.shaderClasses.ColorDodgeShader;
	import mx.graphics.shaderClasses.ColorShader;
	import mx.graphics.shaderClasses.ExclusionShader;
	import mx.graphics.shaderClasses.HueShader;
	import mx.graphics.shaderClasses.LuminosityShader;
	import mx.graphics.shaderClasses.SaturationShader;
	import mx.graphics.shaderClasses.SoftLightShader;
	import mx.managers.CursorManager;
	import mx.managers.ICursorManager;
	import mx.managers.IFocusManager;
	import mx.managers.IFocusManagerComponent;
	import mx.managers.IFocusManagerContainer;
	import mx.managers.ILayoutManagerClient;
	import mx.managers.ISystemManager;
	import mx.managers.IToolTipManagerClient;
	import mx.managers.SystemManager;
	import mx.managers.SystemManagerGlobals;
	import mx.managers.ToolTipManager;
	import mx.resources.ResourceManager;
	import mx.states.State;
	import mx.states.Transition;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.IAdvancedStyleClient;
	import mx.styles.ISimpleStyleClient;
	import mx.styles.IStyleClient;
	import mx.styles.IStyleManager2;
	import mx.styles.StyleManager;
	import mx.styles.StyleProtoChain;
	import mx.utils.ColorUtil;
	import mx.utils.GraphicsUtil;
	import mx.utils.MatrixUtil;
	import mx.utils.NameUtil;
	import mx.utils.StringUtil;
	import mx.utils.TransformUtil;
	import mx.validators.IValidatorListener;
	import mx.validators.ValidationResult;
	import mx.enums.LayoutDirection;
	
		
	use namespace mx_internal;
	
	// Excluding the property to enable code hinting for the layoutDirection style
	[Exclude(name="layoutDirection", kind="property")]
	
	//--------------------------------------
	//  Lifecycle events
	//--------------------------------------
	include "/uicomponentparts/Meta_Events.as";
	
	//--------------------------------------
	//  Styles
	//--------------------------------------
	
	include "../styles/metadata/AnchorStyles.as";
	include "/uicomponentparts/Meta_Styles.as";
	
	//--------------------------------------
	//  Effects
	//--------------------------------------
	include "/uicomponentparts/Meta_Effects.as";
	
	
	//--------------------------------------
	//  Other metadata
	//--------------------------------------
	
	[AccessibilityClass(implementation="mx.accessibility.UIComponentAccProps")]
	
	[ResourceBundle("core")]
	
	// skins resources aren't found because CSS visited by the compiler
	[ResourceBundle("skins")]
	
	/**
	 *  The UIComponent class is the base class for all visual components,
	 *  both interactive and noninteractive.
	 *
	 *  <p>An interactive component can participate in tabbing and other kinds of
	 *  keyboard focus manipulation, accept low-level events like keyboard and
	 *  mouse input, and be disabled so that it does not receive keyboard and
	 *  mouse input.
	 *  This is in contrast to noninteractive components, like Label and
	 *  ProgressBar, which simply display contents and are not manipulated by
	 *  the user.</p>
	 *  <p>The UIComponent class is not used as an MXML tag, but is used as a base
	 *  class for other classes.</p>
	 *
	 *  @mxml
	 *
	 *  <p>All user interface components in Flex extend the UIComponent class.
	 *  Flex components inherit the following properties from the UIComponent
	 *  class:</p>
	 *
	 *  <pre>
	 *  &lt;mx:<i>tagname</i>
	 *   <b>Properties </b>
	 *    accessibilityDescription="null"
	 *    accessibilityName="null"
	 *    accessibilityShortcut="null"
	 *    accessibilitySilent="true|false"
	 *    automationName="null"
	 *    cachePolicy="auto|on|off"
	 *    currentState="null"
	 *    doubleClickEnabled="false|true"
	 *    enabled="true|false"
	 *    explicitHeight="NaN"
	 *    explicitMaxHeight="NaN"
	 *    explicitMaxWidth="NaN"
	 *    explicitMinHeight="NaN"
	 *    explicitMinWidth="NaN"
	 *    explicitWidth="NaN"
	 *    focusEnabled="true|false"
	 *    hasFocusableChildren="false|true"
	 *    height="0"
	 *    id=""
	 *    includeInLayout="true|false"
	 *    maxHeight="10000"
	 *    maxWidth="10000"
	 *    measuredHeight=
	 *    measuredMinHeight=
	 *    measuredMinWidth=
	 *    measuredWidth=
	 *    minHeight="0"
	 *    minWidth="0"
	 *    mouseFocusEnabled="true|false"
	 *    percentHeight="NaN"
	 *    percentWidth="NaN"
	 *    scaleX="1.0"
	 *    scaleY="1.0"
	 *    states="null"
	 *    styleName="undefined"
	 *    toolTip="null"
	 *    transitions=""
	 *    validationSubField
	 *    width="0"
	 *    x="0"
	 *    y="0"
	 *
	 *  <b>Styles</b>
	 *    bottom="undefined"
	 *    errorColor="0xFF0000"
	 *    focusBlendMode="normal"
	 *    focusSkin="FocusSkin""
	 *    focusThickness="2"
	 *    horizontalCenter="undefined"
	 *    layoutDirection="ltr"
	 *    left="undefined"
	 *    right="undefined"	 
	 *    top="undefined"
	 *    verticalCenter="undefined"
	 *
	 *  <b>Effects</b>
	 *    addedEffect="<i>No default</i>"
	 *    creationCompleteEffect="<i>No default</i>"
	 *   focusInEffect="<i>No default</i>"
	 *    focusOutEffect="<i>No default</i>"
	 *    hideEffect="<i>No default</i>"
	 *    mouseDownEffect="<i>No default</i>"
	 *    mouseUpEffect="<i>No default</i>"
	 *    moveEffect="<i>No default</i>"
	 *    removedEffect="<i>No default</i>"
	 *    resizeEffect="<i>No default</i>"
	 *    rollOutEffect="<i>No default</i>"
	 *    rollOverEffect="<i>No default</i>"
	 *    showEffect="<i>No default</i>"
	 *
	 *  <b>Events</b>
	 *    add="<i>No default</i>"
	 *    creationComplete="<i>No default</i>"
	 *    currentStateChange="<i>No default</i>"
	 *    currentStateChanging="<i>No default</i>"
	 *    dragComplete="<i>No default</i>"
	 *    dragDrop="<i>No default</i>"
	 *    dragEnter="<i>No default</i>"
	 *    dragExit="<i>No default</i>"
	 *    dragOver="<i>No default</i>"
	 *    effectEnd="<i>No default</i>"
	 *    effectStart="<i>No default</i>"
	 *    enterState="<i>No default</i>"
	 *    exitState="<i>No default</i>"
	 *    hide="<i>No default</i>"
	 *    initialize="<i>No default</i>"
	 *    invalid="<i>No default</i>"
	 *    mouseDownOutside="<i>No default</i>"
	 *    mouseWheelOutside="<i>No default</i>"
	 *    move="<i>No default</i>"
	 *    preinitialize="<i>No default</i>"
	 *    remove="<i>No default</i>"
	 *    resize="<i>No default</i>"
	 *    show="<i>No default</i>"
	 *    toolTipCreate="<i>No default</i>"
	 *    toolTipEnd="<i>No default</i>"
	 *    toolTipHide="<i>No default</i>"
	 *    toolTipShow="<i>No default</i>"
	 *    toolTipShown="<i>No default</i>"
	 *    toolTipStart="<i>No default</i>"
	 *    updateComplete="<i>No default</i>"
	 *    valid="<i>No default</i>"
	 *    valueCommit="<i>No default</i>"
	 *  &gt;
	 *  </pre>
	 *
	 *  @see mx.core.UIComponent
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public class UIComponent extends FlexSprite
		implements 
		IAutomationObject, 
		IChildList, 
		IConstraintClient,
		IDeferredInstantiationUIComponent, 
		IFlexModule,
		IInvalidating, 
		ILayoutManagerClient, 
		IPropertyChangeNotifier,
		IStateClient2, 
		IAdvancedStyleClient, 
		IToolTipManagerClient,
		IValidatorListener, 
		IVisualElement
	{
		include "../core/Version.as";
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  The default value for the <code>measuredWidth</code> property.
		 *  Most components calculate a measuredWidth but some are flow-based and
		 *  have to pick a number that looks reasonable.
		 *
		 *  @default 160
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static const DEFAULT_MEASURED_WIDTH:Number = 160;
		
		/**
		 *  The default value for the <code>measuredMinWidth</code> property.
		 *  Most components calculate a measuredMinWidth but some are flow-based and
		 *  have to pick a number that looks reasonable.
		 *
		 *  @default 40
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static const DEFAULT_MEASURED_MIN_WIDTH:Number = 40;
		
		/**
		 *  The default value for the <code>measuredHeight</code> property.
		 *  Most components calculate a measuredHeight but some are flow-based and
		 *  have to pick a number that looks reasonable.
		 *
		 *  @default 22
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static const DEFAULT_MEASURED_HEIGHT:Number = 22;
		
		/**
		 *  The default value for the <code>measuredMinHeight</code> property.
		 *  Most components calculate a measuredMinHeight but some are flow-based and
		 *  have to pick a number that looks reasonable.
		 *
		 *  @default 22
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static const DEFAULT_MEASURED_MIN_HEIGHT:Number = 22;
		
		/**
		 *  The default value for the <code>maxWidth</code> property.
		 *
		 *  @default 10000
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static const DEFAULT_MAX_WIDTH:Number = 10000;
		// When changing this constant, make sure you change
		// the constant with the same name in LayoutElementUIComponentUtils
		
		/**
		 *  The default value for the <code>maxHeight</code> property.
		 *
		 *  @default 10000
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static const DEFAULT_MAX_HEIGHT:Number = 10000;
		// When changing this constant, make sure you change
		// the constant with the same name in LayoutElementUIComponentUtils
		
		/**
		 *  @private
		 *  Static constant representing no cached layout direction style value. 
		 */
		private static const LAYOUT_DIRECTION_CACHE_UNSET:String = "layoutDirectionCacheUnset";
		
		
		//--------------------------------------------------------------------------
		//
		//  Class mixins
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Placeholder for mixin by UIComponentAccProps.
		 */
		mx_internal static var createAccessibilityImplementation:Function;
		
		//--------------------------------------------------------------------------
		//
		//  Class properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  embeddedFontRegistry
		//----------------------------------
		
		private static var noEmbeddedFonts:Boolean;
		
		/**
		 *  @private
		 *  Storage for the _embeddedFontRegistry property.
		 *  Note: This gets initialized on first access,
		 *  not when this class is initialized, in order to ensure
		 *  that the Singleton registry has already been initialized.
		 */
		private static var _embeddedFontRegistry:IEmbeddedFontRegistry;
		
		/**
		 *  @private
		 *  A reference to the embedded font registry.
		 *  Single registry in the system.
		 *  Used to look up the moduleFactory of a font.
		 */
		mx_internal static function get embeddedFontRegistry():IEmbeddedFontRegistry
		{
			if (!_embeddedFontRegistry && !noEmbeddedFonts)
			{
				try
				{
					_embeddedFontRegistry = IEmbeddedFontRegistry(
						Singleton.getInstance("mx.core::IEmbeddedFontRegistry"));
				}
				catch (e:Error)
				{
					noEmbeddedFonts = true;
				}
			}
			
			return _embeddedFontRegistry;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Blocks the background processing of methods
		 *  queued by <code>callLater()</code>,
		 *  until <code>resumeBackgroundProcessing()</code> is called.
		 *
		 *  <p>These methods can be useful when you have time-critical code
		 *  which needs to execute without interruption.
		 *  For example, when you set the <code>suspendBackgroundProcessing</code>
		 *  property of an Effect to <code>true</code>,
		 *  <code>suspendBackgroundProcessing()</code> is automatically called
		 *  when it starts playing, and <code>resumeBackgroundProcessing</code>
		 *  is called when it stops, in order to ensure that the animation
		 *  is smooth.</p>
		 *
		 *  <p>Since the LayoutManager uses <code>callLater()</code>,
		 *  this means that <code>commitProperties()</code>,
		 *  <code>measure()</code>, and <code>updateDisplayList()</code>
		 *  is not called in between calls to
		 *  <code>suspendBackgroundProcessing()</code> and
		 *  <code>resumeBackgroundProcessing()</code>.</p>
		 *
		 *  <p>It is safe for both an outer method and an inner method
		 *  (i.e., one that the outer methods calls) to call
		 *  <code>suspendBackgroundProcessing()</code>
		 *  and <code>resumeBackgroundProcessing()</code>, because these
		 *  methods actually increment and decrement a counter
		 *  which determines whether background processing occurs.</p>
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function suspendBackgroundProcessing():void
		{
			UIComponentGlobals.callLaterSuspendCount++;
		}
		
		/**
		 *  Resumes the background processing of methods
		 *  queued by <code>callLater()</code>, after a call to
		 *  <code>suspendBackgroundProcessing()</code>.
		 *
		 *  <p>Refer to the description of
		 *  <code>suspendBackgroundProcessing()</code> for more information.</p>
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function resumeBackgroundProcessing():void
		{
			if (UIComponentGlobals.callLaterSuspendCount > 0)
			{
				UIComponentGlobals.callLaterSuspendCount--;
				
				// Once the suspend count gets back to 0, we need to
				// force a render event to happen
				if (UIComponentGlobals.callLaterSuspendCount == 0)
				{
					var sm:ISystemManager = SystemManagerGlobals.topLevelSystemManagers[0];
					if (sm && sm.stage)
						sm.stage.invalidate();
				}
			}
		}
		
		include "uicomponentparts/supers.as";
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function UIComponent()
		{
			super();
			
			// Override  variables in superclasses.
			focusRect = false; // We do our own focus drawing.
			// We are tab enabled by default if Component
			tabEnabled = (this is IFocusManagerComponent);
			tabFocusEnabled = (this is IFocusManagerComponent);
			
			// Whether the component can accept user interaction.
			// The default is true. If you set enabled to false for a container,
			// Flex dims the color of the container and of all of its children,
			// and blocks user input  to the container and to all of its children.
			// We set enabled to true here because some components keep their
			// own _enabled flag and may not initialize it to true.
			enabled = true;
			
			// Make the component invisible until the initialization sequence
			// is complete.
			// It will be set visible when the 'initialized' flag is set.
			$visible = false;
			
			addEventListener(Event.ADDED, addedHandler);
			addEventListener(Event.REMOVED, removedHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			
			// Register for focus and keyboard events.
			if (this is IFocusManagerComponent)
			{
				addEventListener(FocusEvent.FOCUS_IN, focusInHandler);
				addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
				addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
				addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			}
			
			resourcesChanged();
			
			// Register as a weak listener for "change" events from ResourceManager.
			// If UIComponents registered as a strong listener,
			// they wouldn't get garbage collected.
			ResourceManager.getInstance().addEventListener(
				Event.CHANGE, resourceManager_changeHandler, false, 0, true);
			
			_width = super.width;
			_height = super.height;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Temporarily stores the values of styles specified with setStyle() until 
		 *  moduleFactory is set.
		 */
		private var deferredSetStyles:Object;
		
		/**
		 *  @private
		 *  There is a bug (139381) where we occasionally get callLaterDispatcher()
		 *  even though we didn't expect it.
		 *  That causes us to do a removeEventListener() twice,
		 *  which messes up some internal thing in the player so that
		 *  the next addEventListener() doesn't actually get us the render event.
		 */
		private var listeningForRender:Boolean = false;
		
		/**
		 *  @private
		 *  List of methods used by callLater().
		 */
		private var methodQueue:Array /* of MethodQueueElement */ = [];
		
		/**
		 *  @private
		 *  Whether or not we "own" the focus graphic
		 */
		private var hasFocusRect:Boolean = false;
		
		/**
		 * @private
		 * These variables cache the transition state from/to information for
		 * the transition currently running. This information is used when
		 * determining what to do with a new transition that interrupts the
		 * running transition.
		 */
		private var transitionFromState:String;
		private var transitionToState:String;
		
		/**
		 *  @private
		 */
		private var parentChangedFlag:Boolean = false;
		
		/**
		 *  @private
		 *  Cached layout direction style
		 */
		private var layoutDirectionCachedValue:String = LAYOUT_DIRECTION_CACHE_UNSET;
		
		//--------------------------------------------------------------------------
		//
		//  Variables: Creation
		//
		//--------------------------------------------------------------------------		
		include "uicomponentparts/Creation.as";
		
		//------------------------------------------------------------------------
		//
		//  Properties: Accessibility
		//
		//------------------------------------------------------------------------
		
		include "uicomponentparts/Accessibility.as";
				
		//--------------------------------------------------------------------------
		//
		//  Variables: Invalidation
		//
		//--------------------------------------------------------------------------
		
		include "uicomponentparts/Invalidation.as";		
		
		//--------------------------------------------------------------------------
		//
		//  Variables: Measurement
		//
		//--------------------------------------------------------------------------
		
		include "uicomponentparts/Measurement.as";
		
		//--------------------------------------------------------------------------
		//
		//  Variables: Styles
		//
		//--------------------------------------------------------------------------
		
		include "uicomponentparts/Styles.as";
		
		//--------------------------------------------------------------------------
		//
		//  Variables: Effects
		//
		//--------------------------------------------------------------------------
		
		include "uicomponentparts/Effects.as";
		
		//--------------------------------------------------------------------------
		//
		//  Variables: Validation
		//
		//--------------------------------------------------------------------------
		
		include "uicomponentparts/Validation.as";
		
		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  owner
		//----------------------------------
		
		/**
		 *  @private
		 */
		mx_internal var _owner:DisplayObjectContainer;
		
		/**
		 *  @copy mx.core.IVisualElement#owner
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get owner():DisplayObjectContainer
		{
			return _owner ? _owner : parent;
		}
		
		public function set owner(value:DisplayObjectContainer):void
		{
			_owner = value;
		}
		
		//----------------------------------
		//  parent
		//----------------------------------
		
		/**
		 *  @private
		 *  Reference to this component's virtual parent container.
		 *  "Virtual" means that this parent may not be the same
		 *  as the one that the Player returns as the 'parent'
		 *  property of a DisplayObject.
		 *  For example, if a Container has created a contentPane
		 *  to improve scrolling performance,
		 *  then its "children" are really its grandchildren
		 *  and their "parent" is actually their grandparent,
		 *  because we don't want developers to be concerned with
		 *  whether a contentPane exists or not.
		 */
		mx_internal var _parent:DisplayObjectContainer;
		
		/**
		 *  @copy mx.core.IVisualElement#parent
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		override public function get parent():DisplayObjectContainer
		{
			// Flash PlaceObject tags can have super.parent set
			// before we get to setting the _parent property.
			try
			{
				return _parent ? _parent : super.parent;
			}
			catch (e:SecurityError)
			{
				// trace("UIComponent.get parent(): " + e);
			}
			
			return null;
		}
		
		//----------------------------------
		//  x
		//----------------------------------
		
		[Bindable("xChanged")]
		[Inspectable(category="General")]
		
		/**
		 *  Number that specifies the component's horizontal position,
		 *  in pixels, within its parent container.
		 *
		 *  <p>Setting this property directly or calling <code>move()</code>
		 *  has no effect -- or only a temporary effect -- if the
		 *  component is parented by a layout container such as HBox, Grid,
		 *  or Form, because the layout calculations of those containers
		 *  set the <code>x</code> position to the results of the calculation.
		 *  However, the <code>x</code> property must almost always be set
		 *  when the parent is a Canvas or other absolute-positioning
		 *  container because the default value is 0.</p>
		 *
		 *  @default 0
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		override public function get x():Number
		{
			return (_layoutFeatures == null) ? super.x : _layoutFeatures.layoutX;
		}
		
		/**
		 *  @private
		 */
		override public function set x(value:Number):void
		{
			if (x == value)
				return;
			
			if (_layoutFeatures == null)
			{
				super.x  = value;
			}
			else
			{
				_layoutFeatures.layoutX = value;
				invalidateTransform();
			}
			
			invalidateProperties();
			
			if (parent && parent is UIComponent)
				UIComponent(parent).childXYChanged();
			
			if (hasEventListener("xChanged"))
				dispatchEvent(new Event("xChanged"));
		}
		
		[Bindable("zChanged")]
		[Inspectable(category="General")]
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 3
		 */
		override public function get z():Number
		{
			return (_layoutFeatures == null) ? super.z : _layoutFeatures.layoutZ;
		}
		
		/**
		 *  @private
		 */
		override public function set z(value:Number):void
		{
			if (z == value)
				return;
			
			// validateMatrix when switching between 2D/3D, works around player bug
			// see sdk-23421 
			var was3D:Boolean = is3D;
			if (_layoutFeatures == null)
				initAdvancedLayoutFeatures();
			
			_layoutFeatures.layoutZ = value;
			invalidateTransform();
			invalidateProperties();
			if (was3D != is3D)
				validateMatrix();
			
			if (hasEventListener("zChanged"))
				dispatchEvent(new Event("zChanged"));
		}
		
		/**
		 *  Sets the x coordinate for the transform center of the component.
		 * 
		 *  <p>When this component is the target of a Spark transform effect, 
		 *  you can override this property by setting 
		 *  the <code>AnimateTransform.autoCenterTransform</code> property.
		 *  If <code>autoCenterTransform</code> is <code>false</code>, the transform
		 *  center is determined by the <code>transformX</code>,
		 *  <code>transformY</code>, and <code>transformZ</code> properties
		 *  of the effect target.
		 *  If <code>autoCenterTransform</code> is <code>true</code>, 
		 *  the effect occurs around the center of the target, 
		 *  <code>(width/2, height/2)</code>.</p>
		 *
		 *  <p>Setting this property on the Spark effect class 
		 *  overrides the setting on the target component.</p>
		 *  
		 *  @see spark.effects.AnimateTransform#autoCenterTransform 
		 *  @see spark.effects.AnimateTransform#transformX 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get transformX():Number
		{
			return (_layoutFeatures == null) ? 0 : _layoutFeatures.transformX;
		}
		
		/**
		 *  @private
		 */
		public function set transformX(value:Number):void
		{
			if (transformX == value)
				return;
			if (_layoutFeatures == null)
				initAdvancedLayoutFeatures();
			_layoutFeatures.transformX = value;
			invalidateTransform();
			invalidateProperties();
			invalidateParentSizeAndDisplayList();
		}
		
		/**
		 *  Sets the y coordinate for the transform center of the component.
		 * 
		 *  <p>When this component is the target of a Spark transform effect, 
		 *  you can override this property by setting 
		 *  the <code>AnimateTransform.autoCenterTransform</code> property.
		 *  If <code>autoCenterTransform</code> is <code>false</code>, the transform
		 *  center is determined by the <code>transformX</code>,
		 *  <code>transformY</code>, and <code>transformZ</code> properties
		 *  of the effect target.
		 *  If <code>autoCenterTransform</code> is <code>true</code>, 
		 *  the effect occurs around the center of the target, 
		 *  <code>(width/2, height/2)</code>.</p>
		 *
		 *  <p>Seeting this property on the Spark effect class 
		 *  overrides the setting on the target component.</p>
		 *  
		 *  @see spark.effects.AnimateTransform#autoCenterTransform 
		 *  @see spark.effects.AnimateTransform#transformY
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get transformY():Number
		{
			return (_layoutFeatures == null) ? 0 : _layoutFeatures.transformY;
		}
		
		/**
		 *  @private
		 */
		public function set transformY(value:Number):void
		{
			if (transformY == value)
				return;
			if (_layoutFeatures == null)
				initAdvancedLayoutFeatures();
			_layoutFeatures.transformY = value;
			invalidateTransform();
			invalidateProperties();
			invalidateParentSizeAndDisplayList();
		}
		
		/**
		 *  Sets the z coordinate for the transform center of the component.
		 * 
		 *  <p>When this component is the target of a Spark transform effect, 
		 *  you can override this property by setting 
		 *  the <code>AnimateTransform.autoCenterTransform</code> property.
		 *  If <code>autoCenterTransform</code> is <code>false</code>, the transform
		 *  center is determined by the <code>transformX</code>,
		 *  <code>transformY</code>, and <code>transformZ</code> properties
		 *  of the effect target.
		 *  If <code>autoCenterTransform</code> is <code>true</code>, 
		 *  the effect occurs around the center of the target, 
		 *  <code>(width/2, height/2)</code>.</p>
		 *
		 *  <p>Seeting this property on the Spark effect class 
		 *  overrides the setting on the target component.</p>
		 *  
		 *  @see spark.effects.AnimateTransform#autoCenterTransform 
		 *  @see spark.effects.AnimateTransform#transformZ
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get transformZ():Number
		{
			return (_layoutFeatures == null) ? 0 : _layoutFeatures.transformZ;
		}
		/**
		 *  @private
		 */
		public function set transformZ(value:Number):void
		{
			if (transformZ == value)
				return;
			if (_layoutFeatures == null)
				initAdvancedLayoutFeatures();
			
			_layoutFeatures.transformZ = value;
			invalidateTransform();
			invalidateProperties();
			invalidateParentSizeAndDisplayList();
		}
		
		/**
		 *  @copy mx.core.IFlexDisplayObject#rotation
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		override public function get rotation():Number
		{
			return (_layoutFeatures == null) ? super.rotation : _layoutFeatures.layoutRotationZ;
		}
		
		/**
		 * @private
		 */
		override public function set rotation(value:Number):void
		{			
			if (rotation == value)
				return;
			
			_hasComplexLayoutMatrix = true;
			if (_layoutFeatures == null)
			{
				// clamp the rotation value between -180 and 180.  This is what 
				// the Flash player does and what we mimic in CompoundTransform;
				// however, the Flash player doesn't handle values larger than 
				// 2^15 - 1 (FP-749), so we need to clamp even when we're 
				// just setting super.rotation.
				super.rotation = MatrixUtil.clampRotation(value);
			}
			else
			{
				_layoutFeatures.layoutRotationZ = value;
			}
			
			invalidateTransform();
			invalidateProperties();
			invalidateParentSizeAndDisplayList();
		}
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		override public function get rotationZ():Number
		{
			return rotation;
		}
		/**
		 *  @private
		 */
		override public function set rotationZ(value:Number):void
		{
			rotation = value;
		}
		
		/**
		 * Indicates the x-axis rotation of the DisplayObject instance, in degrees, from its original orientation 
		 * relative to the 3D parent container. Values from 0 to 180 represent clockwise rotation; values 
		 * from 0 to -180 represent counterclockwise rotation. Values outside this range are added to or subtracted from 
		 * 360 to obtain a value within the range.
		 * 
		 * This property is ignored during calculation by any of Flex's 2D layouts. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 3
		 */
		override public function get rotationX():Number
		{
			return (_layoutFeatures == null) ? super.rotationX : _layoutFeatures.layoutRotationX;
		}
		
		/**
		 *  @private
		 */
		override public function set rotationX(value:Number):void
		{
			if (rotationX == value)
				return;
			
			// validateMatrix when switching between 2D/3D, works around player bug
			// see sdk-23421 
			var was3D:Boolean = is3D;
			if (_layoutFeatures == null)
				initAdvancedLayoutFeatures();
			_layoutFeatures.layoutRotationX = value;
			invalidateTransform();
			invalidateProperties();
			invalidateParentSizeAndDisplayList();
			if (was3D != is3D)
				validateMatrix();
		}
		
		/**
		 * Indicates the y-axis rotation of the DisplayObject instance, in degrees, from its original orientation 
		 * relative to the 3D parent container. Values from 0 to 180 represent clockwise rotation; values 
		 * from 0 to -180 represent counterclockwise rotation. Values outside this range are added to or subtracted from 
		 * 360 to obtain a value within the range.
		 * 
		 * This property is ignored during calculation by any of Flex's 2D layouts. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		override public function get rotationY():Number
		{
			return (_layoutFeatures == null) ? super.rotationY : _layoutFeatures.layoutRotationY;
		}
		
		/**
		 *  @private
		 */
		override public function set rotationY(value:Number):void
		{
			if (rotationY == value)
				return;
			
			// validateMatrix when switching between 2D/3D, works around player bug
			// see sdk-23421 
			var was3D:Boolean = is3D;
			if (_layoutFeatures == null)
				initAdvancedLayoutFeatures();
			_layoutFeatures.layoutRotationY = value;
			invalidateTransform();
			invalidateProperties();
			invalidateParentSizeAndDisplayList();
			if (was3D != is3D)
				validateMatrix();
		}
		
		//----------------------------------
		//  y
		//----------------------------------
		
		[Bindable("yChanged")]
		[Inspectable(category="General")]
		
		/**
		 *  Number that specifies the component's vertical position,
		 *  in pixels, within its parent container.
		 *
		 *  <p>Setting this property directly or calling <code>move()</code>
		 *  has no effect -- or only a temporary effect -- if the
		 *  component is parented by a layout container such as HBox, Grid,
		 *  or Form, because the layout calculations of those containers
		 *  set the <code>x</code> position to the results of the calculation.
		 *  However, the <code>x</code> property must almost always be set
		 *  when the parent is a Canvas or other absolute-positioning
		 *  container because the default value is 0.</p>
		 *
		 *  @default 0
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		override public function get y():Number
		{
			return (_layoutFeatures == null) ? super.y : _layoutFeatures.layoutY;
		}
		
		/**
		 *  @private
		 */
		override public function set y(value:Number):void
		{
			if (y == value)
				return;
			
			if (_layoutFeatures == null)
			{
				super.y  = value;
			}
			else
			{
				_layoutFeatures.layoutY = value;
				invalidateTransform();
			}
			invalidateProperties();
			
			if (parent && parent is UIComponent)
				UIComponent(parent).childXYChanged();
			
			if (hasEventListener("yChanged"))
				dispatchEvent(new Event("yChanged"));
		}
		
		//----------------------------------
		//  width
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the width property. This should not be used to set the
		 *  width because it bypasses the mirroring transform in the setter.
		 */
		mx_internal var _width:Number;
		
		[Bindable("widthChanged")]
		[Inspectable(category="General")]
		[PercentProxy("percentWidth")]
		
		/**
		 *  Number that specifies the width of the component, in pixels,
		 *  in the parent's coordinates.
		 *  The default value is 0, but this property contains the actual component
		 *  width after Flex completes sizing the components in your application.
		 *
		 *  <p>Note: You can specify a percentage value in the MXML
		 *  <code>width</code> attribute, such as <code>width="100%"</code>,
		 *  but you cannot use a percentage value in the <code>width</code>
		 *  property in ActionScript.
		 *  Use the <code>percentWidth</code> property instead.</p>
		 *
		 *  <p>Setting this property causes a <code>resize</code> event to
		 *  be dispatched.
		 *  See the <code>resize</code> event for details on when
		 *  this event is dispatched.</p>
		 * 
		 *  @see #percentWidth
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		override public function get width():Number
		{
			return _width;
		}
		
		/**
		 *  @private
		 */
		override public function set width(value:Number):void
		{
			if (explicitWidth != value)
			{
				explicitWidth = value;
				
				// We invalidate size because locking in width
				// may change the measured height in flow-based components.
				invalidateSize();
			}
			
			if (_width != value)
			{
				invalidateProperties();
				invalidateDisplayList();
				invalidateParentSizeAndDisplayList();
				
				_width = value;
				
				// The width is needed for the _layoutFeatures' mirror transform.
				if (_layoutFeatures)
				{
					_layoutFeatures.layoutWidth = _width;
					invalidateTransform();
				}
				
				if (hasEventListener("widthChanged"))
					dispatchEvent(new Event("widthChanged"));
			}
		}
		
		//----------------------------------
		//  height
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the height property.
		 */
		mx_internal var _height:Number;
		
		[Bindable("heightChanged")]
		[Inspectable(category="General")]
		[PercentProxy("percentHeight")]
		
		/**
		 *  Number that specifies the height of the component, in pixels,
		 *  in the parent's coordinates.
		 *  The default value is 0, but this property contains the actual component
		 *  height after Flex completes sizing the components in your application.
		 *
		 *  <p>Note: You can specify a percentage value in the MXML
		 *  <code>height</code> attribute, such as <code>height="100%"</code>,
		 *  but you cannot use a percentage value for the <code>height</code>
		 *  property in ActionScript;
		 *  use the <code>percentHeight</code> property instead.</p>
		 *
		 *  <p>Setting this property causes a <code>resize</code> event to be dispatched.
		 *  See the <code>resize</code> event for details on when
		 *  this event is dispatched.</p>
		 * 
		 *  @see #percentHeight 
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		override public function get height():Number
		{
			return _height;
		}
		
		/**
		 *  @private
		 */
		override public function set height(value:Number):void
		{
			if (explicitHeight != value)
			{
				explicitHeight = value;
				
				// We invalidate size because locking in width
				// may change the measured height in flow-based components.
				invalidateSize();
			}
			
			if (_height != value)
			{
				invalidateProperties();
				invalidateDisplayList();
				invalidateParentSizeAndDisplayList();
				
				_height = value;
				
				if (hasEventListener("heightChanged"))
					dispatchEvent(new Event("heightChanged"));
			}
		}
		
		//----------------------------------
		//  scaleX
		//---------------------------------
		[Bindable("scaleXChanged")]
		[Inspectable(category="Size", defaultValue="1.0")]
		
		/**
		 *  Number that specifies the horizontal scaling factor.
		 *
		 *  <p>The default value is 1.0, which means that the object
		 *  is not scaled.
		 *  A <code>scaleX</code> of 2.0 means the object has been
		 *  magnified by a factor of 2, and a <code>scaleX</code> of 0.5
		 *  means the object has been reduced by a factor of 2.</p>
		 *
		 *  <p>A value of 0.0 is an invalid value.
		 *  Rather than setting it to 0.0, set it to a small value, or set
		 *  the <code>visible</code> property to <code>false</code> to hide the component.</p>
		 *
		 *  @default 1.0
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		
		override public function get scaleX():Number
		{
			return (_layoutFeatures == null) ? super.scaleX : _layoutFeatures.layoutScaleX;
		}
		
		/**
		 *  @private
		 *  Storage for the scaleX property.
		 */
		private var _scaleX:Number = 1.0;
		
		override public function set scaleX(value:Number):void
		{			
			var prevValue:Number = (_layoutFeatures == null) ? scaleX : _layoutFeatures.layoutScaleX;
			if (prevValue == value)
				return;
			
			_hasComplexLayoutMatrix = true;
			
			// trace("set scaleX:" + this + "value = " + value); 
			if (_layoutFeatures == null)
				super.scaleX = value;
			else
			{
				_layoutFeatures.layoutScaleX = value;
			}
			invalidateTransform();
			invalidateProperties();
			
			// If we're not compatible with Flex3 (measuredWidth is pre-scale always)
			// and scaleX is changing we need to invalidate parent size and display list
			// since we are not going to detect a change in measured sizes during measure.
			invalidateParentSizeAndDisplayList();			
			dispatchEvent(new Event("scaleXChanged"));
		}
		
		//----------------------------------
		//  scaleY
		//----------------------------------
		
		[Bindable("scaleYChanged")]
		[Inspectable(category="Size", defaultValue="1.0")]
		
		/**
		 *  Number that specifies the vertical scaling factor.
		 *
		 *  <p>The default value is 1.0, which means that the object
		 *  is not scaled.
		 *  A <code>scaleY</code> of 2.0 means the object has been
		 *  magnified by a factor of 2, and a <code>scaleY</code> of 0.5
		 *  means the object has been reduced by a factor of 2.</p>
		 *
		 *  <p>A value of 0.0 is an invalid value.
		 *  Rather than setting it to 0.0, set it to a small value, or set
		 *  the <code>visible</code> property to <code>false</code> to hide the component.</p>
		 *
		 *  @default 1.0
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		override public function get scaleY():Number
		{
			return (_layoutFeatures == null) ? super.scaleY : _layoutFeatures.layoutScaleY;
		}
		
		/**
		 *  @private
		 *  Storage for the scaleY property.
		 */
		private var _scaleY:Number = 1.0;
		
		
		override public function set scaleY(value:Number):void
		{
			var prevValue:Number = (_layoutFeatures == null) ? scaleY : _layoutFeatures.layoutScaleY;
			if (prevValue == value)
				return;
			
			_hasComplexLayoutMatrix = true;
			
			if (_layoutFeatures == null)
				super.scaleY = value;
			else
			{
				_layoutFeatures.layoutScaleY = value;
			}
			invalidateTransform();
			invalidateProperties();
			
			// If we're not compatible with Flex3 (measuredWidth is pre-scale always)
			// and scaleX is changing we need to invalidate parent size and display list
			// since we are not going to detect a change in measured sizes during measure.
			invalidateParentSizeAndDisplayList();
			
			dispatchEvent(new Event("scaleYChanged"));
		}
		
		//----------------------------------
		//  scaleZ
		//----------------------------------
		
		[Bindable("scaleZChanged")]
		[Inspectable(category="Size", defaultValue="1.0")]
		/**
		 *  Number that specifies the scaling factor along the z axis.
		 *
		 *  <p>A scaling along the z axis does not affect a typical component, which lies flat
		 *  in the z=0 plane.  components with children that have 3D transforms applied, or 
		 *  components with a non-zero transformZ, is affected.</p>
		 *  
		 *  <p>The default value is 1.0, which means that the object
		 *  is not scaled.</p>
		 * 
		 *  <p>This property is ignored during calculation by any of Flex's 2D layouts. </p>
		 *
		 *  @default 1.0
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		override public function get scaleZ():Number
		{
			return (_layoutFeatures == null) ? super.scaleZ : _layoutFeatures.layoutScaleZ;
		}
		
		/**
		 * @private
		 */
		override public function set scaleZ(value:Number):void
		{
			if (scaleZ == value)
				return;
			
			// validateMatrix when switching between 2D/3D, works around player bug
			// see sdk-23421 
			var was3D:Boolean = is3D;
			if (_layoutFeatures == null)
				initAdvancedLayoutFeatures();
			
			_hasComplexLayoutMatrix = true;
			_layoutFeatures.layoutScaleZ = value;
			invalidateTransform();
			invalidateProperties();
			invalidateParentSizeAndDisplayList();
			if (was3D != is3D)
				validateMatrix();
			dispatchEvent(new Event("scaleZChanged"));
		}
		
	
		
		//----------------------------------
		//  visible
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the visible property.
		 */
		private var _visible:Boolean = true;
		
		[Bindable("hide")]
		[Bindable("show")]
		[Inspectable(category="General", defaultValue="true")]
		
		/**
		 *  Whether or not the display object is visible. 
		 *  Display objects that are not visible are disabled. 
		 *  For example, if <code>visible=false</code> for an InteractiveObject instance, 
		 *  it cannot be clicked. 
		 *
		 *  <p>When setting to <code>true</code>, the object dispatches
		 *  a <code>show</code> event.
		 *  When setting to <code>false</code>, the object dispatches
		 *  a <code>hide</code> event.
		 *  In either case the children of the object does not emit a
		 *  <code>show</code> or <code>hide</code> event unless the object
		 *  has specifically written an implementation to do so.</p>
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		override public function get visible():Boolean
		{
			return _visible;
		}
		
		/**
		 *  @private
		 */
		override public function set visible(value:Boolean):void
		{
			setVisible(value);
		}
		
		/**
		 *  Called when the <code>visible</code> property changes.
		 *  Set the <code>visible</code> property to show or hide
		 *  a component instead of calling this method directly.
		 *
		 *  @param value The new value of the <code>visible</code> property.
		 *  Specify <code>true</code> to show the component, and <code>false</code> to hide it.
		 *
		 *  @param noEvent If <code>true</code>, do not dispatch an event.
		 *  If <code>false</code>, dispatch a <code>show</code> event when
		 *  the component becomes visible, and a <code>hide</code> event when
		 *  the component becomes invisible.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function setVisible(value:Boolean,
								   noEvent:Boolean = false):void
		{
			_visible = value;
			
			if (!initialized)
				return;
			
			if (designLayer && !designLayer.effectiveVisibility) 
				value = false; 
			
			if ($visible == value)
				return;
			
			$visible = value;
			
			if (!noEvent)
			{
				var eventType:String = value ? FlexEvent.SHOW :FlexEvent.HIDE;
				
				if (hasEventListener(eventType))
					dispatchEvent(new FlexEvent(eventType));
			}
		}
		
		//----------------------------------
		//  alpha
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the alpha property.
		 */
		private var _alpha:Number = 1.0;
		
		[Bindable("alphaChanged")]
		[Inspectable(defaultValue="1.0", category="General", verbose="1", minValue="0.0", maxValue="1.0")]
		
		/**
		 *  @private
		 */
		override public function get alpha():Number
		{
			// Here we roundtrip alpha in the same manner as the 
			// player (purposely introducing a rounding error).
			return int(_alpha * 256.0) / 256.0;
		}
		
		/**
		 *  @private
		 */
		override public function set alpha(value:Number):void
		{ 
			if (_alpha != value)
			{
				_alpha = value;
				
				if (designLayer)
					value = value * designLayer.effectiveAlpha; 
				
				$alpha = value;
				
				dispatchEvent(new Event("alphaChanged"));
			}
		}
		
		//----------------------------------
		//  blendMode
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the blendMode property.
		 */
		private var _blendMode:String = BlendMode.NORMAL; 
		private var blendShaderChanged:Boolean; 
		private var blendModeChanged:Boolean; 
		
		[Inspectable(category="General", enumeration="add,alpha,darken,difference,erase,hardlight,invert,layer,lighten,multiply,normal,subtract,screen,overlay,colordodge,colorburn,exclusion,softlight,hue,saturation,color,luminosity", defaultValue="normal")]
		
		/**
		 *  @private
		 */
		override public function get blendMode():String
		{
			return _blendMode; 
		}
		
		/**
		 *  @private
		 */
		override public function set blendMode(value:String):void
		{ 
			if (_blendMode != value)
			{
				_blendMode = value;
				blendModeChanged = true; 
				
				// If one of the non-native Flash blendModes is set, 
				// record the new value and set the appropriate 
				// blendShader on the display object. 
				if (value == "colordodge" || 
					value =="colorburn" || value =="exclusion" || 
					value =="softlight" || value =="hue" || 
					value =="saturation" || value =="color" ||
					value =="luminosity")
				{
					blendShaderChanged = true;
				}
				invalidateProperties();     
			}
		}
		
		//----------------------------------
		//  doubleClickEnabled
		//----------------------------------
		
		[Inspectable(enumeration="true,false", defaultValue="true")]
		
		/**
		 *  Specifies whether the UIComponent object receives <code>doubleClick</code> events.
		 *  The default value is <code>false</code>, which means that the UIComponent object
		 *  does not receive <code>doubleClick</code> events.
		 *
		 *  <p>The <code>mouseEnabled</code> property must also be set to <code>true</code>,
		 *  its default value, for the object to receive <code>doubleClick</code> events.</p>
		 *
		 *  @default false
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		override public function get doubleClickEnabled():Boolean
		{
			return super.doubleClickEnabled;
		}
		
		/**
		 *  @private
		 *  Propagate to children.
		 */
		override public function set doubleClickEnabled(value:Boolean):void
		{
			super.doubleClickEnabled = value;
			
			var childList:IChildList;
			
			if (this is IRawChildrenContainer)
				childList = IRawChildrenContainer(this).rawChildren;
			else
				childList = IChildList(this);
			
			for (var i:int = 0; i < childList.numChildren; i++)
			{
				var child:InteractiveObject = childList.getChildAt(i) as InteractiveObject;
				if (child)
					child.doubleClickEnabled = value;
			}
		}
		
		//----------------------------------
		//  enabled
		//----------------------------------
		
		/**
		 *  @private
		 */
		private var _enabled:Boolean = false;
		
		[Inspectable(category="General", enumeration="true,false", defaultValue="true")]
		[Bindable("enabledChanged")]
		
		/**
		 *  @copy mx.core.IUIComponent#enabled
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		/**
		 *  @private
		 */
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			
			// Need to flush the cached TextFormat
			// so it recalcs with the disabled color,
			cachedTextFormat = null;
			
			invalidateDisplayList();
			
			dispatchEvent(new Event("enabledChanged"));
		}
		
		//----------------------------------
		//  cacheAsBitmap
		//----------------------------------
		
		/**
		 *  @private
		 */
		override public function set cacheAsBitmap(value:Boolean):void
		{
			super.cacheAsBitmap = value;
			
			// If cacheAsBitmap is set directly,
			// reset the value of cacheAsBitmapCount.
			cacheAsBitmapCount = value ? 1 : 0;
		}
		
		//----------------------------------
		//  filters
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the filters property.
		 */
		private var _filters:Array;
		
		/**
		 *  @private
		 */
		override public function get filters():Array
		{
			return _filters ? _filters : super.filters;
		}
		
		/**
		 *  @private
		 */
		override public function set filters(value:Array):void
		{
			var n:int;
			var i:int;
			var e:IEventDispatcher;
			
			if (_filters)
			{
				n = _filters.length;
				for (i = 0; i < n; i++)
				{
					e = _filters[i] as IEventDispatcher;
					if (e)
						e.removeEventListener(BaseFilter.CHANGE, filterChangeHandler);
				}
			}
			
			_filters = value;
			
			var clonedFilters:Array = [];
			if (_filters)
			{
				n = _filters.length;
				for (i = 0; i < n; i++)
				{
					if (_filters[i] is IBitmapFilter)
					{
						e = _filters[i] as IEventDispatcher;
						if (e)
							e.addEventListener(BaseFilter.CHANGE, filterChangeHandler);
						clonedFilters.push(IBitmapFilter(_filters[i]).clone());
					}
					else
					{
						clonedFilters.push(_filters[i]);
					}
				}
			}
			
			super.filters = clonedFilters;
		}
		
		//----------------------------------
		//  layer
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the layer property.
		 */
		private var _designLayer:DesignLayer;
		
		[Inspectable (environment='none')]
		
		/**
		 *  @copy mx.core.IVisualElement#designLayer
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get designLayer():DesignLayer
		{
			return _designLayer;
		}
		
		/**
		 *  @private
		 */
		public function set designLayer(value:DesignLayer):void
		{
			if (_designLayer)
				_designLayer.removeEventListener("layerPropertyChange", layer_PropertyChange, false);
			
			_designLayer = value;
			
			if (_designLayer)
				_designLayer.addEventListener("layerPropertyChange", layer_PropertyChange, false, 0, true);
			
			$alpha = _designLayer ? _alpha * _designLayer.effectiveAlpha : _alpha;
			$visible = designLayer ? _visible && _designLayer.effectiveVisibility : _visible;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties: Display
		//
		//--------------------------------------------------------------------------
		
		include "uicomponentparts/Display.as";
		
		//--------------------------------------------------------------------------
		//
		//  Properties: Manager access
		//
		//--------------------------------------------------------------------------
		
		include "uicomponentparts/Managers.as";
		
		//--------------------------------------------------------------------------
		//
		//  Properties: MXML
		//
		//--------------------------------------------------------------------------
		
		include "uicomponentparts/MXML.as";
		
		//--------------------------------------------------------------------------
		//
		//  Properties: Modules
		//
		//--------------------------------------------------------------------------
		
		include "uicomponentparts/Modules.as";
			
		//--------------------------------------------------------------------------
		//
		//  Properties: Bitmap caching
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  cachePolicy
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for cachePolicy property.
		 */
		private var _cachePolicy:String = UIComponentCachePolicy.AUTO;
		
		[Inspectable(enumeration="on,off,auto", defaultValue="auto")]
		
		/**
		 *  Specifies the bitmap caching policy for this object.
		 *  Possible values in MXML are <code>"on"</code>,
		 *  <code>"off"</code> and
		 *  <code>"auto"</code> (default).
		 *
		 *  <p>Possible values in ActionScript are <code>UIComponentCachePolicy.ON</code>,
		 *  <code>UIComponentCachePolicy.OFF</code> and
		 *  <code>UIComponentCachePolicy.AUTO</code> (default).</p>
		 *
		 *  <p><ul>
		 *    <li>A value of <code>UIComponentCachePolicy.ON</code> means that
		 *      the object is always cached as a bitmap.</li>
		 *    <li>A value of <code>UIComponentCachePolicy.OFF</code> means that
		 *      the object is never cached as a bitmap.</li>
		 *    <li>A value of <code>UIComponentCachePolicy.AUTO</code> means that
		 *      the framework uses heuristics to decide whether the object should
		 *      be cached as a bitmap.</li>
		 *  </ul></p>
		 *
		 *  @default UIComponentCachePolicy.AUTO
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get cachePolicy():String
		{
			return _cachePolicy;
		}
		
		/**
		 *  @private
		 */
		public function set cachePolicy(value:String):void
		{
			if (_cachePolicy != value)
			{
				_cachePolicy = value;
				
				if (value == UIComponentCachePolicy.OFF)
					cacheAsBitmap = false;
				else if (value == UIComponentCachePolicy.ON)
					cacheAsBitmap = true;
				else
					cacheAsBitmap = (cacheAsBitmapCount > 0);
			}
		}
		
		//----------------------------------
		//  cacheHeuristic
		//----------------------------------
		
		/**
		 *  @private
		 *  Counter used by the cacheHeuristic property.
		 */
		private var cacheAsBitmapCount:int = 0;
		
		[Inspectable(environment="none")]
		
		/**
		 *  Used by Flex to suggest bitmap caching for the object.
		 *  If <code>cachePolicy</code> is <code>UIComponentCachePolicy.AUTO</code>,
		 *  then <code>cacheHeuristic</code>
		 *  is used to control the object's <code>cacheAsBitmap</code> property.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function set cacheHeuristic(value:Boolean):void
		{
			if (_cachePolicy == UIComponentCachePolicy.AUTO)
			{
				if (value)
					cacheAsBitmapCount++;
				else if (cacheAsBitmapCount != 0)
					cacheAsBitmapCount--;
				
				super.cacheAsBitmap = (cacheAsBitmapCount != 0);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties: Focus management
		//
		//--------------------------------------------------------------------------
		
		include "uicomponentparts/FocusManagement.as";
		
		//--------------------------------------------------------------------------
		//
		//  Properties: Layout
		//
		//--------------------------------------------------------------------------
		
		include "uicomponentparts/Layout.as";
		
		//--------------------------------------------------------------------------
		//
		//  Properties: States
		//
		//--------------------------------------------------------------------------
		
		include "uicomponentparts/States.as";
		
		//--------------------------------------------------------------------------
		//
		//  Properties: Other
		//
		//--------------------------------------------------------------------------
		
		include "uicomponentparts/Others.as";
		
		//--------------------------------------------------------------------------
		//
		//  Properties: Popups
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  isPopUp
		//----------------------------------
		
		/**
		 *  @private
		 */
		private var _isPopUp:Boolean;
		
		[Inspectable(environment="none")]
		
		/**
		 *  Set to <code>true</code> by the PopUpManager to indicate
		 *  that component has been popped up.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get isPopUp():Boolean
		{
			return _isPopUp;
		}
		public function set isPopUp(value:Boolean):void
		{
			_isPopUp = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties: Required to support automated testing
		//
		//--------------------------------------------------------------------------
		
		include "uicomponentparts/Automation.as";
				
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override public function addChild(child:DisplayObject):DisplayObject
		{
			var formerParent:DisplayObjectContainer = child.parent;
			if (formerParent && !(formerParent is Loader))
				formerParent.removeChild(child);
			
			
			var index:int = super.numChildren;
			
			// Do anything that needs to be done before the child is added.
			// When adding a child to UIComponent, this will set the child's
			// virtual parent, its nestLevel, its document, etc.
			// When adding a child to a Container, the override will also
			// invalidate the container, adjust its content/chrome partitions,
			// etc.
			addingChild(child);
			
			// Call a low-level player method in DisplayObjectContainer which
			// actually attaches the child to this component.
			// The player dispatches an "added" event from the child just after
			// it is attached, so all "added" handlers execute during this call.
			// UIComponent registers an addedHandler() in its constructor,
			// which makes it runs before any other "added" handlers except
			// capture-phase ones; it sets up the child's styles.
			$addChildAt(child, index);
			
			// Do anything that needs to be done after the child is added
			// and after all "added" handlers have executed.
			// This is where
			childAdded(child);
			
			return child;
		}
		
		/**
		 *  @private
		 */
		override public function addChildAt(child:DisplayObject,
											index:int):DisplayObject
		{
			var formerParent:DisplayObjectContainer = child.parent;
			if (formerParent && !(formerParent is Loader))
				formerParent.removeChild(child);
						
			addingChild(child);
			
			$addChildAt(child, index);
			
			childAdded(child);
			
			return child;
		}
		
		/**
		 *  @private
		 */
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			removingChild(child);
			
			$removeChild(child);
			
			childRemoved(child);
			
			return child;
		}
		
		
		/**
		 *  @private
		 */
		override public function removeChildAt(index:int):DisplayObject
		{
			var child:DisplayObject = getChildAt(index);
			
			removingChild(child);
			
			$removeChild(child);
			
			childRemoved(child);
			
			return child;
		}
		
		/**
		 *  @private
		 */
		override public function stopDrag():void
		{
			super.stopDrag();
			
			invalidateProperties();
			
			dispatchEvent(new Event("xChanged"));
			dispatchEvent(new Event("yChanged"));
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods: Initialization
		//
		//--------------------------------------------------------------------------
		
		include "uicomponentparts/Initialization.as";
		
		//--------------------------------------------------------------------------
		//
		//  Methods: Commitment
		//
		//--------------------------------------------------------------------------
		
		include "uicomponentparts/Commitment.as";	
		
		//--------------------------------------------------------------------------
		//
		//  Methods: Drawing and Child Layout
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		private var lastUnscaledWidth:Number;
		/**
		 *  @private
		 */
		private var lastUnscaledHeight:Number;
		
		/**
		 *  @private
		 */
		protected function validateMatrix():void
		{        
			if (_layoutFeatures != null && _layoutFeatures.updatePending == true)
			{
				applyComputedMatrix();
			}
			
			if (_maintainProjectionCenter)
			{
				var pmatrix:PerspectiveProjection = super.transform.perspectiveProjection;
				if (pmatrix != null)
				{
					pmatrix.projectionCenter = new Point(unscaledWidth/2,unscaledHeight/2);
				}
			}
		}
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function validateDisplayList():void
		{
			oldLayoutDirection = layoutDirection;
			
			if (invalidateDisplayListFlag)
			{
				// Check if our parent is the top level system manager
				var sm:ISystemManager = parent as ISystemManager;
				if (sm)
				{
					if (sm.isProxy || (sm == systemManager.topLevelSystemManager &&
						sm.document != this))
					{
						// Size ourself to the new measured width/height   This can
						// cause the _layoutFeatures computed matrix to become invalid 
						setActualSize(getExplicitOrMeasuredWidth(),
							getExplicitOrMeasuredHeight());
					}
				}
				
				// Don't validate transform.matrix until after setting actual size
				validateMatrix();
				
				var unscaledWidth:Number = width;
				var unscaledHeight:Number = height;
				
				updateDisplayList(unscaledWidth,unscaledHeight);
				lastUnscaledWidth = unscaledWidth;
				lastUnscaledHeight = unscaledHeight;
				
				invalidateDisplayListFlag = false;
				
				// LAYOUT_DEBUG
				// LayoutManager.debugHelper.addElement(ILayoutElement(this));
			}
			else
				validateMatrix();
			
		}
		
		/**
		 *  Draws the object and/or sizes and positions its children.
		 *  This is an advanced method that you might override
		 *  when creating a subclass of UIComponent.
		 *
		 *  <p>You do not call this method directly. Flex calls the
		 *  <code>updateDisplayList()</code> method when the component is added to a container
		 *  using the <code>addChild()</code> method, and when the component's
		 *  <code>invalidateDisplayList()</code> method is called. </p>
		 *
		 *  <p>If the component has no children, this method
		 *  is where you would do programmatic drawing
		 *  using methods on the component's Graphics object
		 *  such as <code>graphics.drawRect()</code>.</p>
		 *
		 *  <p>If the component has children, this method is where
		 *  you would call the <code>move()</code> and <code>setActualSize()</code>
		 *  methods on its children.</p>
		 *
		 *  <p>Components can do programmatic drawing even if
		 *  they have children. In doing either, use the
		 *  component's <code>unscaledWidth</code> and <code>unscaledHeight</code>
		 *  as its bounds.</p>
		 *
		 *  <p>It is important to use <code>unscaledWidth</code> and
		 *  <code>unscaledHeight</code> instead of the <code>width</code>
		 *  and <code>height</code> properties.</p>
		 *
		 *  @param unscaledWidth Specifies the width of the component, in pixels,
		 *  in the component's coordinates, regardless of the value of the
		 *  <code>scaleX</code> property of the component.
		 *
		 *  @param unscaledHeight Specifies the height of the component, in pixels,
		 *  in the component's coordinates, regardless of the value of the
		 *  <code>scaleY</code> property of the component.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		protected function updateDisplayList(unscaledWidth:Number,
											 unscaledHeight:Number):void
		{
		}
		
		/**
		 *  Returns a layout constraint value, which is the same as
		 *  getting the constraint style for this component.
		 *
		 *  @param constraintName The name of the constraint style, which
		 *  can be any of the following: left, right, top, bottom,
		 *  verticalCenter, horizontalCenter, baseline
		 *
		 *  @return Returns the layout constraint value, which can be
		 *  specified in either of two forms. It can be specified as a
		 *  numeric string, for example, "10" or it can be specified as
		 *  identifier:numeric string. For identifier:numeric string,
		 *  identifier is the <code>id</code> of a ConstraintRow or
		 *  ConstraintColumn. For example, a value of "cc1:10" specifies a
		 *  value of 10 for the ConstraintColumn that has the
		 *  <code>id</code> "cc1."
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function getConstraintValue(constraintName:String):*
		{
			return getStyle(constraintName);
		}
		
		/**
		 *  Sets a layout constraint value, which is the same as
		 *  setting the constraint style for this component.
		 *
		 *  @param constraintName The name of the constraint style, which
		 *  can be any of the following: left, right, top, bottom,
		 *  verticalCenter, horizontalCenter, baseline
		 *
		 *  @param value The value of the constraint can be specified in either
		 *  of two forms. It can be specified as a numeric string, for
		 *  example, "10" or it can be specified as identifier:numeric
		 *  string. For identifier:numeric string, identifier is the
		 *  <code>id</code> of a ConstraintRow or ConstraintColumn. For
		 *  example, a value of "cc1:10" specifies a value of 10 for the
		 *  ConstraintColumn that has the <code>id</code> "cc1."
		 *
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function setConstraintValue(constraintName:String, value:*):void
		{
			setStyle(constraintName, value);
		}
		
		[Inspectable(category="General")]
		
		/**
		 *  <p>For components, this layout constraint property is a
		 *  facade on top of the similarly-named style. To set
		 *  a state-specific value of the property in MXML to its default 
		 *  value of <code>undefined</code>,
		 *  use the &#64;Clear() directive. For example, in MXML code,
		 *  <code>left.s2="&#64;Clear()"</code> unsets the <code>left</code>
		 *  constraint in state s2. Or in ActionScript code, 
		 *  <code>button.left = undefined</code> unsets the <code>left</code>
		 *  constraint on <code>button</code>.</p>
		 * 
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get left():Object
		{
			return getConstraintValue("left");
		}
		public function set left(value:Object):void
		{
			setConstraintValue("left", value != null ? value : undefined);
		}
		
		[Inspectable(category="General")]
		
		/**
		 *  <p>For components, this layout constraint property is a
		 *  facade on top of the similarly-named style. To set
		 *  the property to its default value of <code>undefined</code>,
		 *  use the &#64;Clear() directive in MXML or the <code>undefined</code>
		 *  value in ActionScript code. For example, in MXML code,
		 *  <code>right.s2="&#64;Clear()"</code> unsets the <code>right</code>
		 *  constraint in state s2. Or in ActionScript code, 
		 *  <code>button.right = undefined</code> unsets the <code>right</code>
		 *  constraint on <code>button</code>.</p>
		 *  
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get right():Object
		{
			return getConstraintValue("right");
		}
		public function set right(value:Object):void
		{
			setConstraintValue("right", value != null ? value : undefined);
		}
		
		[Inspectable(category="General")]
		
		/**
		 *  <p>For components, this layout constraint property is a
		 *  facade on top of the similarly-named style. To set
		 *  the property to its default value of <code>undefined</code>,
		 *  use the &#64;Clear() directive in MXML or the <code>undefined</code>
		 *  value in ActionScript code. For example, in MXML code,
		 *  <code>top.s2="&#64;Clear()"</code> unsets the <code>top</code>
		 *  constraint in state s2. Or in ActionScript code, 
		 *  <code>button.top = undefined</code> unsets the <code>top</code>
		 *  constraint on <code>button</code>.</p>
		 *  
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get top():Object
		{
			return getConstraintValue("top");
		}
		public function set top(value:Object):void
		{
			setConstraintValue("top", value != null ? value : undefined);
		}
		
		[Inspectable(category="General")]
		
		/**
		 *  <p>For components, this layout constraint property is a
		 *  facade on top of the similarly-named style. To set
		 *  the property to its default value of <code>undefined</code>,
		 *  use the &#64;Clear() directive in MXML or the <code>undefined</code>
		 *  value in ActionScript code. For example, in MXML code,
		 *  <code>bottom.s2="&#64;Clear()"</code> unsets the <code>bottom</code>
		 *  constraint in state s2. Or in ActionScript code, 
		 *  <code>button.bottom = undefined</code> unsets the <code>bottom</code>
		 *  constraint on <code>button</code>.</p>
		 *  
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get bottom():Object
		{
			return getConstraintValue("bottom");
		}
		public function set bottom(value:Object):void
		{
			setConstraintValue("bottom", value != null ? value : undefined);
		}
		
		[Inspectable(category="General")]
		
		/**
		 *  <p>For components, this layout constraint property is a
		 *  facade on top of the similarly-named style. To set
		 *  the property to its default value of <code>undefined</code>,
		 *  use the &#64;Clear() directive in MXML or the <code>undefined</code>
		 *  value in ActionScript code. For example, in MXML code,
		 *  <code>horizontalCenter.s2="&#64;Clear()"</code> unsets the 
		 *  <code>horizontalCenter</code>
		 *  constraint in state s2. Or in ActionScript code, 
		 *  <code>button.horizontalCenter = undefined</code> unsets the 
		 *  <code>horizontalCenter</code> constraint on <code>button</code>.</p>
		 *  
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get horizontalCenter():Object
		{
			return getConstraintValue("horizontalCenter");
		}
		public function set horizontalCenter(value:Object):void
		{
			setConstraintValue("horizontalCenter", value != null ? value : undefined);
		}
		
		[Inspectable(category="General")]
		
		/**
		 *  <p>For components, this layout constraint property is a
		 *  facade on top of the similarly-named style. To set
		 *  the property to its default value of <code>undefined</code>,
		 *  use the &#64;Clear() directive in MXML or the <code>undefined</code>
		 *  value in ActionScript code. For example, in MXML code,
		 *  <code>verticalCenter.s2="&#64;Clear()"</code> unsets the <code>verticalCenter</code>
		 *  constraint in state s2. Or in ActionScript code, 
		 *  <code>button.verticalCenter = undefined</code> unsets the <code>verticalCenter</code>
		 *  constraint on <code>button</code>.</p>
		 *  
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get verticalCenter():Object
		{
			return getConstraintValue("verticalCenter");
		}
		public function set verticalCenter(value:Object):void
		{
			setConstraintValue("verticalCenter", value != null ? value : undefined);
		}
		
		[Inspectable(category="General")]
		
		/**
		 *  <p>For components, this layout constraint property is a
		 *  facade on top of the similarly-named style. To set
		 *  the property to its default value of <code>undefined</code>,
		 *  use the &#64;Clear() directive in MXML or the <code>undefined</code>
		 *  value in ActionScript code. For example, in MXML code,
		 *  <code>baseline.s2="&#64;Clear()"</code> unsets the <code>baseline</code>
		 *  constraint in state s2. Or in ActionScript code, 
		 *  <code>button.baseline = undefined</code> unsets the <code>baseline</code>
		 *  constraint on <code>button</code>.</p>
		 *  
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get baseline():Object
		{
			return getConstraintValue("baseline");
		}
		public function set baseline(value:Object):void
		{
			setConstraintValue("baseline", value != null ? value : undefined);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods: Drawing
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Returns a box Matrix which can be passed to the
		 *  <code>drawRoundRect()</code> method
		 *  as the <code>rot</code> parameter when drawing a horizontal gradient.
		 *
		 *  <p>For performance reasons, the Matrix is stored in a static variable
		 *  which is reused by all calls to <code>horizontalGradientMatrix()</code>
		 *  and <code>verticalGradientMatrix()</code>.
		 *  Therefore, pass the resulting Matrix
		 *  to <code>drawRoundRect()</code> before calling
		 *  <code>horizontalGradientMatrix()</code>
		 *  or <code>verticalGradientMatrix()</code> again.</p>
		 *
		 *  @param x The left coordinate of the gradient, in pixels.
		 *
		 *  @param y The top coordinate of the gradient, in pixels.
		 *
		 *  @param width The width of the gradient, in pixels.
		 *
		 *  @param height The height of the gradient, in pixels.
		 *
		 *  @return The Matrix for the horizontal gradient.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function horizontalGradientMatrix(x:Number, y:Number,
												 width:Number,
												 height:Number):Matrix
		{
			UIComponentGlobals.tempMatrix.createGradientBox(width, height, 0, x, y);
			return UIComponentGlobals.tempMatrix;
		}
		
		/**
		 *  Returns a box Matrix which can be passed to <code>drawRoundRect()</code>
		 *  as the <code>rot</code> parameter when drawing a vertical gradient.
		 *
		 *  <p>For performance reasons, the Matrix is stored in a static variable
		 *  which is reused by all calls to <code>horizontalGradientMatrix()</code>
		 *  and <code>verticalGradientMatrix()</code>.
		 *  Therefore, pass the resulting Matrix
		 *  to <code>drawRoundRect()</code> before calling
		 *  <code>horizontalGradientMatrix()</code>
		 *  or <code>verticalGradientMatrix()</code> again.</p>
		 *
		 *  @param x The left coordinate of the gradient, in pixels.
		 *
		 *  @param y The top coordinate of the gradient, in pixels.
		 *
		 *  @param width The width of the gradient, in pixels.
		 *
		 *  @param height The height of the gradient, in pixels.
		 *
		 *  @return The Matrix for the vertical gradient.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function verticalGradientMatrix(x:Number, y:Number,
											   width:Number,
											   height:Number):Matrix
		{
			UIComponentGlobals.tempMatrix.createGradientBox(width, height, Math.PI / 2, x, y);
			return UIComponentGlobals.tempMatrix;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods: Moving and sizing
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Moves the component to a specified position within its parent.
		 *  Calling this method is exactly the same as
		 *  setting the component's <code>x</code> and <code>y</code> properties.
		 *
		 *  <p>If you are overriding the <code>updateDisplayList()</code> method
		 *  in a custom component, call the <code>move()</code> method
		 *  rather than setting the <code>x</code> and <code>y</code> properties.
		 *  The difference is that the <code>move()</code> method changes the location
		 *  of the component and then dispatches a <code>move</code> event when you
		 *  call the method, while setting the <code>x</code> and <code>y</code>
		 *  properties changes the location of the component and dispatches
		 *  the event on the next screen refresh.</p>
		 *
		 *  @param x Left position of the component within its parent.
		 *
		 *  @param y Top position of the component within its parent.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function move(x:Number, y:Number):void
		{
			var changed:Boolean = false;
			
			if (x != this.x)
			{
				if (_layoutFeatures == null)
					super.x  = x;
				else
					_layoutFeatures.layoutX = x;
				
				if (hasEventListener("xChanged"))
					dispatchEvent(new Event("xChanged"));
				changed = true;
			}
			
			if (y != this.y)
			{
				if (_layoutFeatures == null)
					super.y  = y;
				else
					_layoutFeatures.layoutY = y;
				
				if (hasEventListener("yChanged"))
					dispatchEvent(new Event("yChanged"));
				changed = true;
			}
			
			if (changed)
			{
				invalidateTransform();
				dispatchMoveEvent();
			}
		}
		
		/**
		 *  Sizes the object.
		 *  Unlike directly setting the <code>width</code> and <code>height</code>
		 *  properties, calling the <code>setActualSize()</code> method
		 *  does not set the <code>explictWidth</code> and
		 *  <code>explicitHeight</code> properties, so a future layout
		 *  calculation can result in the object returning to its previous size.
		 *  This method is used primarily by component developers implementing
		 *  the <code>updateDisplayList()</code> method, by Effects,
		 *  and by the LayoutManager.
		 *
		 *  @param w Width of the object.
		 *
		 *  @param h Height of the object.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function setActualSize(w:Number, h:Number):void
		{
			// trace("setActualSize: " + this + " width = " + w + " height = " + h);
			
			var changed:Boolean = false;
			
			if (_width != w)
			{
				_width = w;
				if(_layoutFeatures)
				{
					_layoutFeatures.layoutWidth = w;  // for the mirror transform
					invalidateTransform();
				}           
				if (hasEventListener("widthChanged"))
					dispatchEvent(new Event("widthChanged"));
				changed = true;
			}
			
			if (_height != h)
			{
				_height = h;
				if (hasEventListener("heightChanged"))
					dispatchEvent(new Event("heightChanged"));
				changed = true;
			}
			
			if (changed)
			{
				invalidateDisplayList();
				dispatchResizeEvent();
			}
			
			setActualSizeCalled = true;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods: Content coordinate transformations
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Converts a <code>Point</code> object from content coordinates to global coordinates.
		 *  Content coordinates specify a pixel position relative to the upper left corner
		 *  of the component's content, and include all of the component's content area,
		 *  including any regions that are currently clipped and must be
		 *  accessed by scrolling the component.
		 *  You use the content coordinate system to set and get the positions of children
		 *  of a container that uses absolute positioning.
		 *  Global coordinates specify a pixel position relative to the upper-left corner
		 *  of the stage, that is, the outermost edge of the application.
		 *
		 *  @param point A Point object that
		 *  specifies the <i>x</i> and <i>y</i> coordinates in the content coordinate system
		 *  as properties.
		 *
		 *  @return A Point object with coordinates relative to the Stage.
		 *
		 *  @see #globalToContent()
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function contentToGlobal(point:Point):Point
		{
			return localToGlobal(point);
		}
		
		/**
		 *  Converts a <code>Point</code> object from global to content coordinates.
		 *  Global coordinates specify a pixel position relative to the upper-left corner
		 *  of the stage, that is, the outermost edge of the application.
		 *  Content coordinates specify a pixel position relative to the upper left corner
		 *  of the component's content, and include all of the component's content area,
		 *  including any regions that are currently clipped and must be
		 *  accessed by scrolling the component.
		 *  You use the content coordinate system to set and get the positions of children
		 *  of a container that uses absolute positioning.
		 *
		 *  @param point A Point object that
		 *  specifies the <i>x</i> and <i>y</i> coordinates in the global (Stage)
		 *  coordinate system as properties.
		 *
		 *  @return Point A Point object with coordinates relative to the component.
		 *
		 *  @see #contentToGlobal()
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function globalToContent(point:Point):Point
		{
			return globalToLocal(point);
		}
		
		/**
		 *  Converts a <code>Point</code> object from content to local coordinates.
		 *  Content coordinates specify a pixel position relative to the upper left corner
		 *  of the component's content, and include all of the component's content area,
		 *  including any regions that are currently clipped and must be
		 *  accessed by scrolling the component.
		 *  You use the content coordinate system to set and get the positions of children
		 *  of a container that uses absolute positioning.
		 *  Local coordinates specify a pixel position relative to the
		 *  upper left corner of the component.
		 *
		 *  @param point A Point object that specifies the <i>x</i> and <i>y</i>
		 *  coordinates in the content coordinate system as properties.
		 *
		 *  @return Point A Point object with coordinates relative to the
		 *  local coordinate system.
		 *
		 *  @see #contentToGlobal()
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function contentToLocal(point:Point):Point
		{
			return point;
		}
		
		/**
		 *  Converts a <code>Point</code> object from local to content coordinates.
		 *  Local coordinates specify a pixel position relative to the
		 *  upper left corner of the component.
		 *  Content coordinates specify a pixel position relative to the upper left corner
		 *  of the component's content, and include all of the component's content area,
		 *  including any regions that are currently clipped and must be
		 *  accessed by scrolling the component.
		 *  You use the content coordinate system to set and get the positions of children
		 *  of a container that uses absolute positioning.
		 *
		 *  @param point A Point object that specifies the <i>x</i> and <i>y</i>
		 *  coordinates in the local coordinate system as properties.
		 *
		 *  @return Point A Point object with coordinates relative to the
		 *  content coordinate system.
		 *
		 *  @see #contentToLocal()
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function localToContent(point:Point):Point
		{
			return point;
		}
				
		//--------------------------------------------------------------------------
		//
		//  Methods: Events
		//
		//--------------------------------------------------------------------------
		
		/** 
		 *  Helper method for dispatching a PropertyChangeEvent
		 *  when a property is updated.
		 * 
		 *  @param prop Name of the property that changed.
		 *
		 *  @param oldValue Old value of the property.
		 *
		 *  @param value New value of the property.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		protected function dispatchPropertyChangeEvent(prop:String, oldValue:*,
													   value:*):void
		{
			if (hasEventListener("propertyChange"))
				dispatchEvent(PropertyChangeEvent.createUpdateEvent(
					this, prop, oldValue, value));
		}
		
		/**
		 *  @private
		 */
		private function dispatchMoveEvent():void
		{
			if (hasEventListener(MoveEvent.MOVE))
			{
				var moveEvent:MoveEvent = new MoveEvent(MoveEvent.MOVE);
				moveEvent.oldX = oldX;
				moveEvent.oldY = oldY;
				dispatchEvent(moveEvent);
			}
			
			oldX = x;
			oldY = y;
		}
		
		/**
		 *  @private
		 */
		private function dispatchResizeEvent():void
		{
			if (hasEventListener(ResizeEvent.RESIZE))
			{
				var resizeEvent:ResizeEvent = new ResizeEvent(ResizeEvent.RESIZE);
				resizeEvent.oldWidth = oldWidth;
				resizeEvent.oldHeight = oldHeight;
				dispatchEvent(resizeEvent);
			}
			
			oldWidth = width;
			oldHeight = height;
		}
		
		/**
		 *  @private
		 *  Called when the child transform changes (currently x and y on UIComponent),
		 *  so that the Group has a chance to invalidate the layout.
		 */
		mx_internal function childXYChanged():void
		{
		}
		
		/**
		 *  @private
		 *  Typically, Keyboard.LEFT means go left, regardless of the 
		 *  layoutDirection, and similiarly for Keyboard.RIGHT.  When 
		 *  layoutDirection="rtl", rather than duplicating lots of code in the
		 *  switch statement of the keyDownHandler, map Keyboard.LEFT to
		 *  Keyboard.RIGHT, and similiarly for Keyboard.RIGHT.  
		 * 
		 *  Optionally, Keyboard.UP can be tied with Keyboard.LEFT and 
		 *  Keyboard.DOWN can be tied with Keyboard.RIGHT since some components 
		 *  do this.
		 * 
		 *  @return keyCode to use for the layoutDirection if always using ltr 
		 *  actions
		 */
		// TODO(cframpto): change to protected after getting PARB review of name.
		mx_internal function mapKeycodeForLayoutDirection(
			event:KeyboardEvent, 
			mapUpDown:Boolean=false):uint
		{
			var keyCode:uint = event.keyCode;
			
			// If rtl layout, left still means left and right still means right so
			// swap the keys to get the correct action.
			switch (keyCode)
			{
				case Keyboard.DOWN:
				{
					// typically, if ltr, the same as RIGHT
					if (mapUpDown && layoutDirection == LayoutDirection.RTL)
						keyCode = Keyboard.LEFT;
					break;
				}
				case Keyboard.RIGHT:
				{
					if (layoutDirection == LayoutDirection.RTL)
						keyCode = Keyboard.LEFT;
					break;
				}
				case Keyboard.UP:
				{
					// typically, if ltr, the same as LEFT
					if (mapUpDown && layoutDirection == LayoutDirection.RTL)
						keyCode = Keyboard.RIGHT;                
					break;
				}
				case Keyboard.LEFT:
				{
					if (layoutDirection == LayoutDirection.RTL)
						keyCode = Keyboard.RIGHT;                
					break;
				}
			}
			
			return keyCode;
		}			
		
		//--------------------------------------------------------------------------
		//
		//  Methods: Binding
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Executes all the bindings for which the UIComponent object is the destination.
		 *
		 *  @param recurse Recursively execute bindings for children of this component.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function executeBindings(recurse:Boolean = false):void
		{
			var bindingsHost:Object = descriptor && descriptor.document ? descriptor.document : parentDocument;
			BindingManager.executeBindings(bindingsHost, id, this);
		}
					
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function createReferenceOnParentDocument(
			parentDocument:IFlexDisplayObject):void
		{
			if (id && id != "")
			{
				var indices:Array = _instanceIndices;
				if (!indices)
				{
					parentDocument[id] = this;
				}
				else
				{
					var r:Object = parentDocument[id];
					
					if (! (r is Array))
					{
						r = parentDocument[id] = [];
					}
					
					var n:int = indices.length;
					for (var i:int = 0; i < n - 1; i++)
					{
						var s:Object = r[indices[i]];
						
						if (!(s is Array))
							s = r[indices[i]] = [];
						
						r = s;
					}
					
					r[indices[n - 1]] = this;
					
					if (parentDocument.hasEventListener("propertyChange")) 
					{
						var event:PropertyChangeEvent =
							PropertyChangeEvent.createUpdateEvent(parentDocument,
								id,
								parentDocument[id],
								parentDocument[id]);
						parentDocument.dispatchEvent(event);
					}
				}
			}
		}
		//----------------------------------
		//  instanceIndices
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the instanceIndices and index properties.
		 */
		private var _instanceIndices:Array /* of int */;
		
		[Inspectable(environment="none")]
		
		/**
		 *  An Array containing the indices required to reference
		 *  this UIComponent object from its parent document.
		 *  The Array is empty unless this UIComponent object is within one or more Repeaters.
		 *  The first element corresponds to the outermost Repeater.
		 *  For example, if the id is "b" and instanceIndices is [2,4],
		 *  you would reference it on the parent document as b[2][4].
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get instanceIndices():Array
		{
			// For efficiency, _instanceIndices starts out undefined rather than [].
			return _instanceIndices ? _instanceIndices.slice(0) : null;
		}
		
		/**
		 *  @private
		 */
		public function set instanceIndices(value:Array):void
		{
			_instanceIndices = value;
		}
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function deleteReferenceOnParentDocument(
			parentDocument:IFlexDisplayObject):void
		{
			if (id && id != "")
			{
				var indices:Array = _instanceIndices;
				if (!indices)
				{
					parentDocument[id] = null;
				}
				else
				{
					var r:Object = parentDocument[id];
					
					if (!r)
						return;
					
					var stack:Array = [];
					stack.push(r);
					
					var n:int = indices.length;
					for (var i:int = 0; i < n - 1; i++)
					{
						var s:Object = r[indices[i]];
						
						if (!s)
							return;
						
						r = s;
						stack.push(r);
					}
					
					r.splice(indices[n - 1], 1);
					
					for (var j:int = stack.length - 1; j > 0; j--)
					{
						if (stack[j].length == 0)
							stack[j - 1].splice(indices[j], 1);
					}
					
					if ((stack.length > 0) && (stack[0].length == 0))
					{
						parentDocument[id] = null;
					}
					else
					{
						if (parentDocument.hasEventListener("propertyChange")) 
						{
							var event:PropertyChangeEvent =
								PropertyChangeEvent.createUpdateEvent(parentDocument,
									id,
									parentDocument[id],
									parentDocument[id]);
							parentDocument.dispatchEvent(event);
						}
					}
				}
			}
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods: Resources
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  This method is called when a UIComponent is constructed,
		 *  and again whenever the ResourceManager dispatches
		 *  a <code>"change"</code> Event to indicate
		 *  that the localized resources have changed in some way.
		 *
		 *  <p>This event is dispatched when you set the ResourceManager's
		 *  <code>localeChain</code> property, when a resource module
		 *  has finished loading, and when you call the ResourceManager's
		 *  <code>update()</code> method.</p>
		 *
		 *  <p>Subclasses should override this method and, after calling
		 *  <code>super.resourcesChanged()</code>, do whatever is appropriate
		 *  in response to having new resource values.</p>
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		protected function resourcesChanged():void
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods: Printing
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Prepares an IFlexDisplayObject for printing.
		 *  For the UIComponent class, the method performs no action.
		 *  Flex containers override the method to prepare for printing;
		 *  for example, by removing scroll bars from the printed output.
		 *
		 *  <p>This method is normally not used by application developers. </p>
		 *
		 *  @param target The component to be printed.
		 *  It can be the current component or one of its children.
		 *
		 *  @return Object containing the properties of the current component
		 *  required by the <code>finishPrint()</code> method
		 *  to restore it to its previous state.
		 *
		 *  @see mx.printing.FlexPrintJob
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function prepareToPrint(target:IFlexDisplayObject):Object
		{
			return null;
		}
		
		/**
		 *  Called after printing is complete.
		 *  For the UIComponent class, the method performs no action.
		 *  Flex containers override the method to restore the container after printing.
		 *
		 *  <p>This method is normally not used by application developers. </p>
		 *
		 *  @param obj Contains the properties of the component that
		 *  restore it to its state before printing.
		 *
		 *  @param target The component that just finished printing.
		 *  It can be the current component or one of its children.
		 *
		 *  @see mx.printing.FlexPrintJob
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function finishPrint(obj:Object, target:IFlexDisplayObject):void
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers: Invalidation
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Callback that then calls queued functions.
		 */
		private function callLaterDispatcher(event:Event):void
		{
			// trace(">>calllaterdispatcher " + this);
			UIComponentGlobals.callLaterDispatcherCount++;
			
			// At run-time, callLaterDispatcher2() is called
			// without a surrounding try-catch.
			if (!UIComponentGlobals.catchCallLaterExceptions)
			{
				callLaterDispatcher2(event);
			}
				
				// At design-time, callLaterDispatcher2() is called
				// with a surrounding try-catch.
			else
			{
				try
				{
					callLaterDispatcher2(event);
				}
				catch(e:Error)
				{
					// Dispatch a callLaterError dynamic event for Design View. 
					var callLaterErrorEvent:DynamicEvent = new DynamicEvent("callLaterError");
					callLaterErrorEvent.error = e;
					callLaterErrorEvent.source = this; 
					systemManager.dispatchEvent(callLaterErrorEvent);
				}
			}
			// trace("<<calllaterdispatcher");
			UIComponentGlobals.callLaterDispatcherCount--;
		}
		
		/**
		 *  @private
		 *  Callback that then calls queued functions.
		 */
		private function callLaterDispatcher2(event:Event):void
		{
			if (UIComponentGlobals.callLaterSuspendCount > 0)
				return;
			
			// trace("  >>calllaterdispatcher2");
			
			// Stage can be null when an untrusted application is loaded by an application
			// that isn't on stage yet.
			if (systemManager && (systemManager.stage || usingBridge) && listeningForRender)
			{
				// trace("  removed");
				systemManager.removeEventListener(FlexEvent.RENDER, callLaterDispatcher);
				systemManager.removeEventListener(FlexEvent.ENTER_FRAME, callLaterDispatcher);
				listeningForRender = false;
			}
			
			// Move the method queue off to the side, so that subsequent
			// calls to callLater get added to a new queue that'll get handled
			// next time.
			var queue:Array = methodQueue;
			methodQueue = [];
			
			// Call each method currently in the method queue.
			// These methods can call callLater(), causing additional
			// methods to be queued, but these will get called the next
			// time around.
			var n:int = queue.length;
			//  trace("  queue length " + n);
			for (var i:int = 0; i < n; i++)
			{
				var mqe:MethodQueueElement = MethodQueueElement(queue[i]);
				
				mqe.method.apply(null, mqe.args);
			}
			
			// trace("  <<calllaterdispatcher2 " + this);
		}
				
		//--------------------------------------------------------------------------
		//
		//  Event handlers: Resources
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		private function resourceManager_changeHandler(event:Event):void
		{
			resourcesChanged();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers: Filters
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		private function filterChangeHandler(event:Event):void
		{
			filters = _filters;
		}
		
		//--------------------------------------------------------------------------
		//
		//  IUIComponent
		//
		//--------------------------------------------------------------------------
		
		include "uicomponentparts/IUIComponent.as";
		
		//--------------------------------------------------------------------------
		//
		//  Diagnostics
		//
		//--------------------------------------------------------------------------
		
		include "uicomponentparts/Diagnostics.as";
				
		
		//--------------------------------------------------------------------------
		//
		//  ILayoutElement
		//
		//--------------------------------------------------------------------------
		
		include "uicomponentparts/ILayoutElement.as";
	}
	
}

////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: MethodQueueElement
//
////////////////////////////////////////////////////////////////////////////////

/**
 *  @private
 *  An element of the methodQueue array.
 */
class MethodQueueElement
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  Constructor.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function MethodQueueElement(method:Function,
									   args:Array /* of Object */ = null)
	{
		super();
		
		this.method = method;
		this.args = args;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  method
	//----------------------------------
	
	/**
	 *  A reference to the method to be called.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var method:Function;
	
	//----------------------------------
	//  args
	//----------------------------------
	
	/**
	 *  The arguments to be passed to the method.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var args:Array /* of Object */;
}
