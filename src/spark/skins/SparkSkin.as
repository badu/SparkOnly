// Decompiled by AS3 Sorcerer 1.48
// http://www.as3sorcerer.com/

//spark.skins.SparkSkin

package spark.skins
{
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	
	import spark.components.supportClasses.Skin;
	import spark.primitives.supportClasses.GraphicElement;
	
	public class SparkSkin extends Skin 
	{
		
		private static const DEFAULT_COLOR_VALUE:uint = 204;
		private static const DEFAULT_COLOR:uint = 0xCCCCCC;
		private static const DEFAULT_SYMBOL_COLOR:uint = 0;
		
		private static var colorTransform:ColorTransform = new ColorTransform();
		private static var oldContentBackgroundAlpha:Number;
		private static var contentBackgroundAlphaSetLocally:Boolean;
		
		protected var useChromeColor:Boolean = false;
		private var colorized:Boolean = false;
		
		
		public function get colorizeExclusions():Array
		{
			return (null);
		}
		
		public function get symbolItems():Array
		{
			return (null);
		}
		
		public function get contentItems():Array
		{
			return (null);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			var i:int;
			var symbolColor:uint;
			var contentBackgroundColor:uint;
			var contentBackgroundAlpha:Number;
			var exclusions:Array;
			var exclusionObject:Object;
			var symbols:Array = this.symbolItems;
			if (((symbols) && ((symbols.length > 0))))
			{
				symbolColor = getStyle("symbolColor");
				i = 0;
				while (i < symbols.length)
				{
					if (this[symbols[i]])
					{
						this[symbols[i]].color = symbolColor;
					};
					i++;
				};
			};
			var content:Array = this.contentItems;
			if (((content) && ((content.length > 0))))
			{
				contentBackgroundColor = getStyle("contentBackgroundColor");
				contentBackgroundAlpha = getStyle("contentBackgroundAlpha");
				i = 0;
				while (i < content.length)
				{
					if (this[content[i]])
					{
						this[content[i]].color = contentBackgroundColor;
						this[content[i]].alpha = contentBackgroundAlpha;
					};
					i++;
				};
			};
			var chromeColor:uint = getStyle("chromeColor");
			if (((((!((chromeColor == DEFAULT_COLOR))) || (this.colorized))) && (this.useChromeColor)))
			{
				colorTransform.redOffset = (((chromeColor & (0xFF << 16)) >> 16) - DEFAULT_COLOR_VALUE);
				colorTransform.greenOffset = (((chromeColor & (0xFF << 8)) >> 8) - DEFAULT_COLOR_VALUE);
				colorTransform.blueOffset = ((chromeColor & 0xFF) - DEFAULT_COLOR_VALUE);
				colorTransform.alphaMultiplier = alpha;
				transform.colorTransform = colorTransform;
				exclusions = this.colorizeExclusions;
				if (((exclusions) && ((exclusions.length > 0))))
				{
					colorTransform.redOffset = -(colorTransform.redOffset);
					colorTransform.greenOffset = -(colorTransform.greenOffset);
					colorTransform.blueOffset = -(colorTransform.blueOffset);
					i = 0;
					while (i < exclusions.length)
					{
						exclusionObject = this[exclusions[i]];
						if (((exclusionObject) && ((((exclusionObject is DisplayObject)) || ((exclusionObject is GraphicElement))))))
						{
							colorTransform.alphaMultiplier = exclusionObject.alpha;
							exclusionObject.transform.colorTransform = colorTransform;
						};
						i++;
					};
				};
				this.colorized = true;
			};
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
		override public function beginHighlightBitmapCapture():Boolean
		{
			var needRedraw:Boolean = super.beginHighlightBitmapCapture();
			if (getStyle("contentBackgroundAlpha") < 0.5)
			{
				if (((styleDeclaration) && (!((styleDeclaration.getStyle("contentBackgroundAlpha") === null)))))
				{
					contentBackgroundAlphaSetLocally = true;
				}
				else
				{
					contentBackgroundAlphaSetLocally = false;
				};
				oldContentBackgroundAlpha = getStyle("contentBackgroundAlpha");
				setStyle("contentBackgroundAlpha", 0.5);
				needRedraw = true;
			};
			return (needRedraw);
		}
		
		override public function endHighlightBitmapCapture():Boolean
		{
			var needRedraw:Boolean = super.endHighlightBitmapCapture();
			if (!(isNaN(oldContentBackgroundAlpha)))
			{
				if (contentBackgroundAlphaSetLocally)
				{
					setStyle("contentBackgroundAlpha", oldContentBackgroundAlpha);
				}
				else
				{
					clearStyle("contentBackgroundAlpha");
				};
				needRedraw = true;
				oldContentBackgroundAlpha = NaN;
			};
			return (needRedraw);
		}
		
		
	}
}//package spark.skins

