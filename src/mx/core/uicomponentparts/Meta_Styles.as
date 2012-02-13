/**
 *  The main color for a component.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
[Style(name="chromeColor", type="uint", format="Color", inherit="yes", theme="spark")]

/**
 *  Color of the component highlight when validation fails.
 *  Flex also sets the <code>borderColor</code> style of the component to this
 *  <code>errorColor</code> on a validation failure.
 *
 *  The default value for the Halo theme is <code>0xFF0000</code>.
 *  The default value for the Spark theme is <code>0xFE0000</code>.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="errorColor", type="uint", format="Color", inherit="yes")]

/**
 *  The primary interaction mode for this component.  The acceptable values are: 
 *  <code>mouse</code> and <code>touch</code>.
 *
 *  The default value for the Halo theme is <code>mouse</code>.
 *  The default value for the Spark theme is <code>mouse</code>.
 *  The default value for the Mobile theme is <code>touch</code>.
 * 
 *  @see mx.core.InteractionMode#MOUSE
 *  @see mx.core.InteractionMode#TOUCH
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
[Style(name="interactionMode", type="String", enumeration="mouse,touch", inherit="yes")]

/**
 *  Blend mode used by the focus rectangle.
 *  For more information, see the <code>blendMode</code> property
 *  of the flash.display.DisplayObject class.
 *
 *  @default "normal"
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="focusBlendMode", type="String", inherit="no")]

/**
 *  Skin used to draw the focus rectangle.
 *
 *  The default value for Spark components is spark.skins.spark.FocusSkin.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="focusSkin", type="Class", inherit="no")]

/**
 *  Thickness, in pixels, of the focus rectangle outline.
 *
 *  @default 2
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="focusThickness", type="Number", format="Length", inherit="no", minValue="0.0")]

/**
 *  Specifies the desired layout direction of a component. The allowed values
 *  are <code>"ltr"</code> for left-to-right layout, used for 
 *  components using Latin-style scripts, and <code>"rtl"</code> for
 *  right-to-left layout, used for components using scripts such
 *  as Arabic and Hebrew.
 * 
 *  <p>In ActionScript you can set the layoutDirection using the values 
 *  <code>mx.core.LayoutDirection.LTR</code>, 
 *  <code>mx.core.LayoutDirection.RTL</code> or 
 *  <code>undefined</code>, to inherit the layoutDirection from the parent.</p>
 * 
 *  <p>The layoutDirection should typically be set on the 
 *  <code>Application</code> rather than on individual components. If the 
 *  layoutDirection is <code>"rtl"</code>, most visual elements, except text 
 *  and images, will be mirrored.  The directionality of text is determined 
 *  by the <code>direction</code> style.</p>
 * 
 *  <p>Components which handle Keyboard.LEFT and Keyboard.RIGHT events
 *  typically swap the key’s meaning when layoutDirection is 
 *  <code>“rtl”</code>.  In other words, left always means move left and
 *  right always means move right, regardless of the 
 *  <code>layoutDirection</code></p>
 * 
 *  <p>Note: This style applies to all Spark components and MX components that
 *  specify UIFTETextField as their textFieldClass.</p> 
 * 
 *  @default "ltr"
 * 
 *  @see MXFTEText.css
 *  @see mx.core.ILayoutDirectionElement
 *  @see mx.core.LayoutDirection
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4.1
 */
[Style(name="layoutDirection", type="String", enumeration="ltr,rtl", inherit="yes")]

/**
 *  Show the error border or skin when this component is invalid
 * 
 *  @default true
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4.5
 */
[Style(name="showErrorSkin", type="Boolean", inherit="yes")]

/**
 *  Show the error tip when this component is invalid and the user 
 *  rolls over it 
 * 
 *  @default true
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4.5
 */
[Style(name="showErrorTip", type="Boolean", inherit="yes")]

