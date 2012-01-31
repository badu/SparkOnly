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

package mx.styles
{
	
	import flash.utils.Dictionary;
	
	import mx.core.IFlexModuleFactory;
	import mx.core.Singleton;
	import mx.managers.SystemManagerGlobals;
	
	/**
	 *  The StyleManager class manages the following:
	 *  <ul>
	 *    <li>Which CSS style properties the class inherits</li>
	 *    <li>Which style properties are colors, and therefore get special handling</li>
	 *    <li>A list of strings that are aliases for color values</li>
	 *  </ul>
	 *
	 *  @see mx.styles.CSSStyleDeclaration
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public class StyleManager
	{
		include "../core/Version.as";
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  The <code>getColorName()</code> method returns this value if the passed-in
		 *  String is not a legitimate color name.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static const NOT_A_COLOR:uint = 0xFFFFFFFF;
		
		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Linker dependency on implementation class.
		 */
		private static var implClassDependency:StyleManagerImpl;
		
		/**
		 *  @private
		 *  Storage for the impl getter.
		 *  This gets initialized on first access,
		 *  not at static initialization time, in order to ensure
		 *  that the Singleton registry has already been initialized.
		 */
		private static var _impl:IStyleManager2;
		
		/**
		 *  @private
		 *  The singleton instance of StyleManagerImpl which was
		 *  registered as implementing the IStyleManager2 interface.
		 */
		private static function get impl():IStyleManager2
		{
			if (!_impl)
			{
				_impl = IStyleManager2(
					Singleton.getInstance("mx.styles::IStyleManager2"));
			}
			
			return _impl;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private 
		 *  Dictionary that maps a moduleFactory to its associated styleManager
		 */
		private static var styleManagerDictionary:Dictionary;
		
		/**
		 *  Returns the style manager for an object.
		 *
		 *  @param moduleFactory The module factory of an object you want the 
		 *  style manager for. If null, the top-level style manager is returned.
		 *
		 *  @return the style manager for the given module factory.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public static function getStyleManager(moduleFactory:IFlexModuleFactory):IStyleManager2
		{
			if (!moduleFactory)
			{
				moduleFactory = SystemManagerGlobals.topLevelSystemManagers[0];
				// trace("no style manager specified, using top-level style manager");
			}
			
			if (!styleManagerDictionary)
				styleManagerDictionary = new Dictionary(true);
			
			var styleManager:IStyleManager2;
			var dictionary:Dictionary = styleManagerDictionary[moduleFactory];
			if (dictionary == null)
			{
				styleManager = IStyleManager2(moduleFactory.getImplementation("mx.styles::IStyleManager2"));
				if (styleManager == null)
				{
					// All Flex 4 swfs should have a style manager. 
					// In the transition to multiple style managers, use the top-level style manager.
					// trace("no style manager found");
					styleManager = impl;
				}
				
				dictionary = new Dictionary(true);
				styleManagerDictionary[moduleFactory] = dictionary;
				dictionary[styleManager] = 1;
			}
			else 
			{
				for (var o:Object in dictionary)
				{
					styleManager = o as IStyleManager2;
					break;
				}
			}
			
			return styleManager;
		}   		
	}	
}