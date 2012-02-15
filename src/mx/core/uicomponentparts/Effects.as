import mx.enums.EventPriority;

/**
 *  For each effect event, registers the EffectManager
 *  as one of the event listeners.
 *  You typically never need to call this method.
 *
 *  @param effects The names of the effect events.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function registerEffects(effects:Array /* of String */):void
{
	var n:int = effects.length;
	for (var i:int = 0; i < n; i++)
	{
		// Ask the EffectManager for the event associated with this effectTrigger
		var event:String = EffectManager.getEventForEffectTrigger(effects[i]);
		
		if (event != null && event != "")
		{
			addEventListener(event, EffectManager.eventHandler, false, EventPriority.EFFECT);
		}
	}
}

/**
 *  @private
 */
mx_internal var _effectsStarted:Array = [];

/**
 *  @private
 */
mx_internal var _affectedProperties:Object = {};

/**
 *  Contains <code>true</code> if an effect is currently playing on the component.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
private var _isEffectStarted:Boolean = false;
mx_internal function get isEffectStarted():Boolean
{
	return _isEffectStarted;
}
mx_internal function set isEffectStarted(value:Boolean):void
{
	_isEffectStarted = value;
}

private var preventDrawFocus:Boolean = false;

/**
 *  Called by the effect instance when it starts playing on the component.
 *  You can use this method to perform a modification to the component as part
 *  of an effect. You can use the <code>effectFinished()</code> method
 *  to restore the modification when the effect ends.
 *
 *  @param effectInst The effect instance object playing on the component.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function effectStarted(effectInst:IEffectInstance):void
{
	// Check that the instance isn't already in our list
	_effectsStarted.push(effectInst);
	
	var aProps:Array = effectInst.effect.getAffectedProperties();
	for (var j:int = 0; j < aProps.length; j++)
	{
		var propName:String = aProps[j];
		if (_affectedProperties[propName] == undefined)
		{
			_affectedProperties[propName] = [];
		}
		
		_affectedProperties[propName].push(effectInst);
	}
	
	isEffectStarted = true;
	// Hide the focus ring if the target already has one drawn
	if (effectInst.hideFocusRing)
	{
		preventDrawFocus = true;
		drawFocus(false);
	}
}


private var _endingEffectInstances:Array = [];

/**
 *  Called by the effect instance when it stops playing on the component.
 *  You can use this method to restore a modification to the component made
 *  by the <code>effectStarted()</code> method when the effect started,
 *  or perform some other action when the effect ends.
 *
 *  @param effectInst The effect instance object playing on the component.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function effectFinished(effectInst:IEffectInstance):void
{
	_endingEffectInstances.push(effectInst);
	invalidateProperties();
	
	// weak reference
	UIComponentGlobals.layoutManager.addEventListener(
		FlexEvent.UPDATE_COMPLETE, updateCompleteHandler, false, 0, true);
}

/**
 *  Ends all currently playing effects on the component.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function endEffectsStarted():void
{
	var len:int = _effectsStarted.length;
	for (var i:int = 0; i < len; i++)
	{
		_effectsStarted[i].end();
	}
}

/**
 *  @private
 */
private function updateCompleteHandler(event:FlexEvent):void
{
	UIComponentGlobals.layoutManager.removeEventListener(
		FlexEvent.UPDATE_COMPLETE, updateCompleteHandler);
	processEffectFinished(_endingEffectInstances);
	_endingEffectInstances = [];
}

/**
 *  @private
 */
private function processEffectFinished(effectInsts:Array):void
{
	// Find the instance in our list.
	for (var i:int = _effectsStarted.length - 1; i >= 0; i--)
	{
		for (var j:int = 0; j < effectInsts.length; j++)
		{
			var effectInst:IEffectInstance = effectInsts[j];
			if (effectInst == _effectsStarted[i])
			{
				// Remove the effect from our array.
				var removedInst:IEffectInstance = _effectsStarted[i];
				_effectsStarted.splice(i, 1);
				
				// Remove the affected properties from our internal object
				var aProps:Array = removedInst.effect.getAffectedProperties();
				for (var k:int = 0; k < aProps.length; k++)
				{
					var propName:String = aProps[k];
					if (_affectedProperties[propName] != undefined)
					{
						for (var l:int = 0; l < _affectedProperties[propName].length; l++)
						{
							if (_affectedProperties[propName][l] == effectInst)
							{
								_affectedProperties[propName].splice(l, 1);
								break;
							}
						}
						
						if (_affectedProperties[propName].length == 0)
							delete _affectedProperties[propName];
					}
				}
				break;
			}
		}
	}
	
	isEffectStarted = _effectsStarted.length > 0 ? true : false;
	if (effectInst && effectInst.hideFocusRing)
	{
		preventDrawFocus = false;
	}
}

/**
 *  @private
 */
mx_internal function getEffectsForProperty(propertyName:String):Array
{
	return _affectedProperties[propertyName] != undefined ?
		_affectedProperties[propertyName] :
		[];
}