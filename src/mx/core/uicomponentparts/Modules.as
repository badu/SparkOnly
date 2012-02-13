//----------------------------------
//  moduleFactory
//----------------------------------

/**
 *  @private
 *  Storage for the moduleFactory property.
 */
private var _moduleFactory:IFlexModuleFactory;

[Inspectable(environment="none")]

/**
 *  A module factory is used as context for using embedded fonts and for
 *  finding the style manager that controls the styles for this 
 *  component. 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get moduleFactory():IFlexModuleFactory
{
	return _moduleFactory;
}

/**
 *  @private
 */
public function set moduleFactory(factory:IFlexModuleFactory):void
{
	_styleManager = null;
	
	var n:int = numChildren;
	for (var i:int = 0; i < n; i++)
	{
		var child:IFlexModule = getChildAt(i) as IFlexModule;
		if (!child)
			continue;
		
		if (child.moduleFactory == null || child.moduleFactory == _moduleFactory)
		{
			child.moduleFactory = factory;
		}
	}
	
	if (advanceStyleClientChildren != null)
	{
		for (var styleClient:Object in advanceStyleClientChildren)
		{
			var iAdvanceStyleClientChild:IFlexModule = styleClient
				as IFlexModule;
			
			if (iAdvanceStyleClientChild && 
				(iAdvanceStyleClientChild.moduleFactory == null 
					|| iAdvanceStyleClientChild.moduleFactory == _moduleFactory))
			{
				iAdvanceStyleClientChild.moduleFactory = factory;
			}
		}
	}
	_moduleFactory = factory;
	
	setDeferredStyles();
}