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

package spark.skins.spark
{
	import flash.display.Graphics;
	
	import mx.core.FlexShape;
	import mx.core.IFlexDisplayObject;
	import mx.core.IInvalidating;
	import mx.core.UIComponentGlobals;
	import mx.core.mx_internal;
	import mx.managers.ILayoutManagerClient;
	
	use namespace mx_internal;
	
	/**
	 *  The default skin for the drop indicator of a List component in case 
	 *  List doesn't have a <code>dropIndicator</code> part defined in its skin.
	 *
	 *  @see spark.components.List
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public class ListDropIndicator extends FlexShape
		implements IFlexDisplayObject, IInvalidating, ILayoutManagerClient
	{
		include "../../core/Version.as";
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function ListDropIndicator()
		{
			super();
			_width = measuredWidth;
			_height = measuredHeight;
		}
		//----------------------------------
		//  nestLevel
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the nestLevel property.
		 */
		private var _nestLevel:int = 0;
		
		/**
		 *  @copy mx.core.UIComponent#nestLevel
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
			_nestLevel = value;
			
			// After nestLevel is initialized, add this object to the
			// LayoutManager's queue, so that it is drawn at least once
			invalidateDisplayList();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  height
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the height property.
		 */
		private var _height:Number;
		
		/**
		 *  @private
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
			_height = value;
			
			invalidateDisplayList();
		}
		
		//----------------------------------
		//  width
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the width property.
		 */
		private var _width:Number;
		
		/**
		 *  @private
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
			_width = value;
			
			invalidateDisplayList();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		private var invalidateDisplayListFlag:Boolean = false;
		/**
		 *  This function is called by the LayoutManager
		 *  when it's time for this control to draw itself.
		 *  The actual drawing happens in the <code>updateDisplayList</code>
		 *  function, which is called by this function.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function validateDisplayList():void
		{
			invalidateDisplayListFlag = false;
			
			updateDisplayList(width, height);
		}
		/**
		 *  Validate and update the properties and layout of this object
		 *  and redraw it, if necessary.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function validateNow():void
		{
			// Since we don't have commit/measure/layout phases,
			// all we need to do here is the draw phase
			if (invalidateDisplayListFlag)
				validateDisplayList();
		}
		//--------------------------------------------------------------------------
		//
		//  Methods: IFlexDisplayObject
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Moves this object to the specified x and y coordinates.
		 *
		 *  @param x The horizontal position, in pixels.
		 *
		 *  @param y The vertical position, in pixels.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function move(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		/**
		 *  Sets the height and width of this object.
		 *
		 *  @param newWidth The width, in pixels, of this object.
		 *
		 *  @param newHeight The height, in pixels, of this object.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function setActualSize(newWidth:Number, newHeight:Number):void
		{
			var changed:Boolean = false;
			
			if (_width != newWidth)
			{
				_width = newWidth;
				changed = true;
			}
			
			if (_height != newHeight)
			{
				_height = newHeight;
				changed = true;
			}
			
			if (changed)
				invalidateDisplayList();
		}
		
		
		/**
		 *  @copy mx.core.UIComponent#invalidateDisplayList()
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function invalidateDisplayList():void
		{
			// Don't try to add the object to the display list queue until we've
			// been assigned a nestLevel, or we'll get added at the wrong place in
			// the LayoutManager's priority queue.
			if (!invalidateDisplayListFlag && nestLevel > 0)
			{
				invalidateDisplayListFlag = true;
				UIComponentGlobals.layoutManager.invalidateDisplayList(this);
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
		public function invalidateSize():void
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
		public function invalidateProperties():void
		{
		}
		/**
		 *  The measured height of this object.
		 *  This should be overridden by subclasses to return the preferred height for
		 *  the skin.
		 *
		 *  @return The measured height of the object, in pixels.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get measuredHeight():Number
		{
			return 0;
		}
		
		//----------------------------------
		//  measuredWidth
		//----------------------------------
		
		/**
		 *  The measured width of this object.
		 *  This should be overridden by subclasses to return the preferred width for
		 *  the skin.
		 *
		 *  @return The measured width of the object, in pixels.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get measuredWidth():Number
		{
			return 0;
		}
		//=================================================================
		// ILayoutManagerClient implementation
		//=================================================================
		private var _initialized:Boolean = false;
		public function get initialized():Boolean
		{
			return _initialized;
		}		
		public function set initialized(value:Boolean):void
		{
			_initialized = value;
		}
		
		private var _processedDescriptors:Boolean = false;
		public function get processedDescriptors():Boolean
		{
			return _processedDescriptors;
		}
		
		public function set processedDescriptors(value:Boolean):void
		{
			_processedDescriptors = value;			
		}
		
		private var _updateCompletePendingFlag:Boolean = true;
		public function get updateCompletePendingFlag():Boolean
		{
			return _updateCompletePendingFlag;
		}		
		public function set updateCompletePendingFlag(value:Boolean):void
		{
			_updateCompletePendingFlag = value;			
		}
		
		public function validateProperties():void
		{			
		}
		
		public function validateSize(recursive:Boolean=false):void
		{			
		}
		
		/**
		 * Original
		 *  @private
		 */
		protected function updateDisplayList(w:Number, h:Number):void
		{   
			
			// If the gap is 0 or negative, the layout would size us as 0 width/height,
			// we need some minimum to ensure drawing.
			var width:Number = Math.max(2, w);
			var height:Number = Math.max(2, h);
			
			// Make the shorter side 2 pixels so that the drop indicator is always 
			// a 2 pixel thick line regardless of vertical/horizontal orientation.
			if (width < height)
				width = 2;
			else
				height = 2;         
			
			// Center the drawing within the bounds
			var x:Number = Math.round((w - width) / 2);
			var y:Number = Math.round((h - height) / 2);
			
			var g:Graphics = graphics;
			g.clear();
			g.beginFill(0x2B333C);
			g.drawRect(x, y, width, height);
			g.endFill();
		}
	}
}
