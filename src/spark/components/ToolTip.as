package spark.components
{
	import avmplus.getQualifiedClassName;
	
	import flashx.textLayout.elements.TextFlow;
	
	import mx.core.IDataRenderer;
	import mx.core.IFactory;
	import mx.core.IFlexModuleFactory;
	import mx.core.IToolTip;
	import mx.core.UIComponent;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.IStyleManager2;
	import mx.styles.StyleManager;
	
	import spark.components.supportClasses.SkinnableComponent;
	import spark.skins.spark.ToolTipSkin;
	import spark.utils.TextFlowUtil;
	
	public class ToolTip extends SkinnableComponent implements IToolTip
	{
		[SkinPart(required="false", type="spark.components.Label")]
		public var displayTitle:IFactory;
		[SkinPart(required="true")]
		public var displayText:RichText;
		[SkinPart(required="true")]
		public var tooltipGroup:Group;		
		[Bindable]
		public var textFlow:TextFlow;
		
		private var _isErrorTooltip:Boolean = false;

		public function get isErrorTooltip():Boolean
		{
			return _isErrorTooltip;
		}

		public function set isErrorTooltip(value:Boolean):void
		{			
			_isErrorTooltip = value;
			if (_isErrorTooltip)
			{				
				setStyle("color", getStyle("errorTipColor"));
				setStyle("chromeColor", getStyle("errorTipChromeColor"));
			}
		}
		
		private var displayTitleInstance:IDataRenderer;
		
		/**
		 * Text of the tooltip 
		 */
		private var _text:String;
		
		public function set text (value:String):void 
		{			
			if (_text != value && displayText && value) 
			{
				_text = value;
				if (value.indexOf("img src") > 0)
				{
					/**
					const imageData : XML = new XML(value);					
					imageSource = imageData.@src;
					tooltipImage.width = imageData.@width;
					tooltipImage.height = imageData.@height;				
					textFlow = TextFlowUtil.importFromString("");
					 */
				}
				else if (_text!="<dataTip>")
				{					
					try
					{
						textFlow = TextFlowUtil.importFromString(_text);
					}
					catch(er:Error)
					{
						trace(er.message + " => "+_text);
					}
				}
			}
		}
		
		public function get text ():String 
		{
			return _text;
		}
		
		
		/**
		 * Title of the tooltip if any 
		 */
		private var _title:String;
		
		public function set title (value:String):void
		{
			if (_title != value) 
			{
				_title = value;
				
				//See if we need to create a dynamic skin part
				if (!displayTitleInstance) 
				{
					//Create and add dynmic skin part. Push down relevant styles
					displayTitleInstance = IDataRenderer(this.createDynamicPartInstance("displayTitle"));
					UIComponent(displayTitleInstance).setStyle("color", this.getStyle("color"));
					tooltipGroup.addElementAt(UIComponent(displayTitleInstance), 0);
				}
				//Set the data to the title to be displayed				
				displayTitleInstance.data = TextFlowUtil.importFromString(_title); 
			}
		}
		
		public function get title ():String 
		{
			return _title;
		}	
		
		[Bindable]
		override public function set maxWidth(value:Number):void
		{
			
		}		
		override public function get maxWidth():Number
		{
			return getStyle("maxWidth");
		}		
		
		public function ToolTip()
		{
			super();
			mouseEnabled = false;
			mouseChildren = false;			
		}
		
		protected static var defaultStylesSet                : Boolean;
		
		override public function set moduleFactory(factory:IFlexModuleFactory):void
		{
			super.moduleFactory = factory;
			prototype.constructor.setDefaultStyles( factory );
		}		
		
		protected static function setDefaultStyles( factory:IFlexModuleFactory ):void
		{
			if( defaultStylesSet ) return;			
			defaultStylesSet = true;			
			var defaultStyleName:String = getQualifiedClassName( prototype.constructor ).replace( /::/, "." );
			var styleManager:IStyleManager2 = StyleManager.getStyleManager( factory );
			var style:CSSStyleDeclaration = styleManager.getStyleDeclaration( defaultStyleName );			
			if( !style )
			{
				style = new CSSStyleDeclaration();
				styleManager.setStyleDeclaration( defaultStyleName, style, true );
			}			
			if( style.defaultFactory == null )
			{
				style.defaultFactory = function():void
				{
					this.skinClass = spark.skins.spark.ToolTipSkin;
				};
			}
		}
	}
}