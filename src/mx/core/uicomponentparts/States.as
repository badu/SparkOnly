//----------------------------------
//  currentState
//----------------------------------

/**
 *  @private
 *  Storage for the currentState property.
 */
private var _currentState:String;

/**
 *  @private
 *  Pending current state name.
 */
private var requestedCurrentState:String;

/**
 *  @private
 *  Flag to play state transition
 */
private var playStateTransition:Boolean = true;

/**
 *  @private
 *  Flag that is set when the currentState has changed and needs to be
 *  committed.
 *  This property name needs the initial underscore to avoid collisions
 *  with the "currentStateChange" event attribute.
 */
private var _currentStateChanged:Boolean;

[Bindable("currentStateChange")]

/**
 *  The current view state of the component.
 *  Set to <code>""</code> or <code>null</code> to reset
 *  the component back to its base state.
 *
 *  <p>When you use this property to set a component's state,
 *  Flex applies any transition you have defined.
 *  You can also use the <code>setCurrentState()</code> method to set the
 *  current state; this method can optionally change states without
 *  applying a transition.</p>
 *
 *  @see #setCurrentState()
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get currentState():String
{
	return _currentStateChanged ? requestedCurrentState : _currentState;
}

/**
 *  @private
 */
public function set currentState(value:String):void
{
	// We have a deferred state change currently queued up, let's override
	// the originally requested state with the newly requested. Otherwise
	// we'll synchronously assign our new state.
	if (_currentStateDeferred != null) 
		_currentStateDeferred = value;
	else
		setCurrentState(value, true);
}

/**
 *  @private
 *  Backing variable for currentStateDeferred property
 */
private var _currentStateDeferred:String;

/**
 *  @private
 *  Version of currentState property that defers setting currentState
 *  until commitProperties() time. This is used by SetProperty.remove()
 *  to avoid causing state transitions when currentState is being rolled
 *  back in a state change operation just to be set immediately after to the
 *  actual new currentState value. This avoids unnecessary, and sometimes
 *  incorrect, use of transitions based on this transient state of currentState.
 */
mx_internal function get currentStateDeferred():String
{
	return (_currentStateDeferred != null) ? _currentStateDeferred : currentState;
}

/**
 *  @private
 */
mx_internal function set currentStateDeferred(value:String):void
{
	_currentStateDeferred = value;
	if (value != null)
		invalidateProperties();
}


//----------------------------------
//  states
//----------------------------------

private var _states:Array /* of State */ = [];

[Inspectable(arrayType="mx.states.State")]
[ArrayElementType("mx.states.State")]

/**
 *  The view states that are defined for this component.
 *  You can specify the <code>states</code> property only on the root
 *  of the application or on the root tag of an MXML component.
 *  The compiler generates an error if you specify it on any other control.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get states():Array
{
	return _states;
}

/**
 *  @private
 */
public function set states(value:Array):void
{
	_states = value;
}

//----------------------------------
//  transitions
//----------------------------------

/**
 *  @private
 *  Transition currently playing.
 */
private var _currentTransition:Transition;

private var _transitions:Array /* of Transition */ = [];

[Inspectable(arrayType="mx.states.Transition")]
[ArrayElementType("mx.states.Transition")]

/**
 *  An Array of Transition objects, where each Transition object defines a
 *  set of effects to play when a view state change occurs.
 *
 *  @see mx.states.Transition
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function get transitions():Array
{
	return _transitions;
}

/**
 *  @private
 */
public function set transitions(value:Array):void
{
	_transitions = value;
}
/**
 *  Set the current state.
 *
 *  @param stateName The name of the new view state.
 *
 *  @param playTransition If <code>true</code>, play
 *  the appropriate transition when the view state changes.
 *
 *  @see #currentState
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function setCurrentState(stateName:String,
								playTransition:Boolean = true):void
{
	// Flex 4 has no concept of an explicit base state, so ensure we
	// fall back to something appropriate.
	stateName = isBaseState(stateName) ? getDefaultState() : stateName;
	
	// Only change if the requested state is different. Since the root
	// state can be either null or "", we need to add additional check
	// to make sure we're not going from null to "" or vice-versa.
	if (stateName != currentState &&
		!(isBaseState(stateName) && isBaseState(currentState)))
	{
		requestedCurrentState = stateName;
		// Don't play transition if we're just getting started
		// In Flex4, there is no "base state", so if isBaseState() is true
		// then we're just going into our first real state
		playStateTransition =  
			(this is IStateClient2) && isBaseState(currentState) ?
			false : 
			playTransition;
		if (initialized)
		{
			commitCurrentState();
		}
		else
		{
			_currentStateChanged = true;
			invalidateProperties();
		}
	}
}

/**
 *  @copy mx.core.IStateClient2#hasState() 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public function hasState(stateName:String):Boolean
{
	return (getState(stateName, false) != null); 
}

/**
 *  @private
 *  Returns true if the passed in state name is the 'base' state, which
 *  is currently defined as null or ""
 */
private function isBaseState(stateName:String):Boolean
{
	return !stateName || stateName == "";
}

/**
 *  @private
 *  Returns the default state. For Flex 4 and later we return the base
 *  the first defined state, otherwise (Flex 3 and earlier), we return
 *  the base (null) state.
 */
private function getDefaultState():String
{
	return (this is IStateClient2 && (states.length > 0)) ? states[0].name : null;
}

// Used by commitCurrentState() to avoid hard-linking against Effect
private static var effectType:Class;
private static var effectLoaded:Boolean = false;

/**
 *  @private
 *  Commit a pending current state change.
 */
private function commitCurrentState():void
{
	var nextTransition:Transition =
		playStateTransition ?
		getTransition(_currentState, requestedCurrentState) :
		null;
	var commonBaseState:String = findCommonBaseState(_currentState, requestedCurrentState);
	var event:StateChangeEvent;
	var oldState:String = _currentState ? _currentState : "";
	var destination:State = getState(requestedCurrentState);
	var prevTransitionEffect:Object;
	var tmpPropertyChanges:Array;
	
	// First, make sure we've loaded the Effect class - some of the logic 
	// below requires it
	if (nextTransition && !effectLoaded)
	{
		effectLoaded = true;
		if (ApplicationDomain.currentDomain.hasDefinition("mx.effects.Effect"))
			effectType = Class(ApplicationDomain.currentDomain.
				getDefinition("mx.effects.Effect"));
	}
	
	// Stop any transition that may still be playing
	var prevTransitionFraction:Number;
	if (_currentTransition)
	{
		// Remove the event listener, we don't want to trigger it as it
		// dispatches FlexEvent.STATE_CHANGE_COMPLETE and we are
		// interrupting _currentTransition instead.
		_currentTransition.effect.removeEventListener(EffectEvent.EFFECT_END, transition_effectEndHandler);
		
		// 'stop' interruptions take precedence over autoReverse behavior
		if (nextTransition && _currentTransition.interruptionBehavior == "stop")
		{
			prevTransitionEffect = _currentTransition.effect;
			prevTransitionEffect.transitionInterruption = true;
			// This logic stops the effect from applying the end values
			// so that we can capture the interrupted values correctly
			// in captureStartValues() below. Save the values in the
			// tmp variable because stop() clears out propertyChangesArray
			// from the effect.
			tmpPropertyChanges = prevTransitionEffect.propertyChangesArray;
			prevTransitionEffect.applyEndValuesWhenDone = false;
			prevTransitionEffect.stop();
			prevTransitionEffect.applyEndValuesWhenDone = true;
		}
		else
		{
			if (_currentTransition.autoReverse &&
				transitionFromState == requestedCurrentState &&
				transitionToState == _currentState)
			{
				if (_currentTransition.effect.duration == 0)
					prevTransitionFraction = 0;
				else
					prevTransitionFraction = 
						_currentTransition.effect.playheadTime /
						getTotalDuration(_currentTransition.effect);
			}
			_currentTransition.effect.end();
		}
		
		// The current transition is being interrupted, dispatch an event
		if (hasEventListener(FlexEvent.STATE_CHANGE_INTERRUPTED))
			dispatchEvent(new FlexEvent(FlexEvent.STATE_CHANGE_INTERRUPTED));
		_currentTransition = null;
	}
	
	// Initialize the state we are going to.
	initializeState(requestedCurrentState);
	
	// Capture transition start values
	if (nextTransition)
		nextTransition.effect.captureStartValues();
	
	// Now that we've captured the start values, apply the end values of
	// the effect as normal. This makes sure that objects unaffected by the
	// next transition have their correct end values from the previous
	// transition
	if (tmpPropertyChanges)
		prevTransitionEffect.applyEndValues(tmpPropertyChanges,
			prevTransitionEffect.targets);
	
	// Dispatch currentStateChanging event
	if (hasEventListener(StateChangeEvent.CURRENT_STATE_CHANGING)) 
	{
		event = new StateChangeEvent(StateChangeEvent.CURRENT_STATE_CHANGING);
		event.oldState = oldState;
		event.newState = requestedCurrentState ? requestedCurrentState : "";
		dispatchEvent(event);
	}
	
	// If we're leaving the base state, send an exitState event
	if (isBaseState(_currentState) && hasEventListener(FlexEvent.EXIT_STATE))
		dispatchEvent(new FlexEvent(FlexEvent.EXIT_STATE));
	
	// Remove the existing state
	removeState(_currentState, commonBaseState);
	_currentState = requestedCurrentState;
	
	// Check for state specific styles
	stateChanged(oldState, _currentState, true);
	
	// If we're going back to the base state, dispatch an
	// enter state event, otherwise apply the state.
	if (isBaseState(currentState)) 
	{
		if (hasEventListener(FlexEvent.ENTER_STATE))
			dispatchEvent(new FlexEvent(FlexEvent.ENTER_STATE)); 
	}
	else
		applyState(_currentState, commonBaseState);
	
	// Dispatch currentStateChange
	if (hasEventListener(StateChangeEvent.CURRENT_STATE_CHANGE))
	{
		event = new StateChangeEvent(StateChangeEvent.CURRENT_STATE_CHANGE);
		event.oldState = oldState;
		event.newState = _currentState ? _currentState : "";
		dispatchEvent(event);
	}
	
	if (nextTransition)
	{
		var reverseTransition:Boolean =  
			nextTransition && nextTransition.autoReverse &&
			(nextTransition.toState == oldState ||
				nextTransition.fromState == _currentState);
		// Force a validation before playing the transition effect
		UIComponentGlobals.layoutManager.validateNow();
		_currentTransition = nextTransition;
		transitionFromState = oldState;
		transitionToState = _currentState;
		// Tell the effect whether it is running in interruption mode, in which
		// case it should grab values from the states instead of from current
		// property values
		Object(nextTransition.effect).transitionInterruption = 
			(prevTransitionEffect != null);
		nextTransition.effect.addEventListener(EffectEvent.EFFECT_END, 
			transition_effectEndHandler);
		nextTransition.effect.play(null, reverseTransition);
		if (!isNaN(prevTransitionFraction) && 
			nextTransition.effect.duration != 0)
			nextTransition.effect.playheadTime = (1 - prevTransitionFraction) * 
				getTotalDuration(nextTransition.effect);
	}
	else
	{
		// Dispatch an event that the transition has completed.
		if (hasEventListener(FlexEvent.STATE_CHANGE_COMPLETE))
			dispatchEvent(new FlexEvent(FlexEvent.STATE_CHANGE_COMPLETE));
	}
}

// Used by getTotalDuration() to avoid hard-linking against
// CompositeEffect
private static var compositeEffectType:Class;
private static var compositeEffectLoaded:Boolean = false;

/**
 * @private
 * returns the 'total' duration of an effect. This value
 * takes into account any startDelay and repetition data.
 * For CompositeEffect objects, it also accounts for the
 * total duration of that effect's children.
 */
private function getTotalDuration(effect:IEffect):Number
{
	// TODO (chaase): we should add timing properties to some
	// interface to avoid these hacks
	var duration:Number = 0;
	var effectObj:Object = Object(effect);
	if (!compositeEffectLoaded)
	{
		compositeEffectLoaded = true;
		if (ApplicationDomain.currentDomain.hasDefinition("mx.effects.CompositeEffect"))
			compositeEffectType = Class(ApplicationDomain.currentDomain.
				getDefinition("mx.effects.CompositeEffect"));
	}
	if (compositeEffectType && (effect is compositeEffectType))
		duration = effectObj.compositeDuration;
	else
		duration = effect.duration;
	var repeatDelay:int = ("repeatDelay" in effect) ?
		effectObj.repeatDelay : 0;
	var repeatCount:int = ("repeatCount" in effect) ?
		effectObj.repeatCount : 0;
	var startDelay:int = ("startDelay" in effect) ?
		effectObj.startDelay : 0;
	// Now add in startDelay/repeat info
	duration = 
		duration * repeatCount +
		(repeatDelay * (repeatCount - 1)) +
		startDelay;
	return duration;
}

/**
 *  @private
 */
private function transition_effectEndHandler(event:EffectEvent):void
{
	_currentTransition = null;
	
	// Dispatch an event that the transition has completed.
	if (hasEventListener(FlexEvent.STATE_CHANGE_COMPLETE))
		dispatchEvent(new FlexEvent(FlexEvent.STATE_CHANGE_COMPLETE));
}

/**
 *  @private
 *  Returns the state with the specified name, or null if it doesn't exist.
 *  If multiple states have the same name the first one will be returned.
 */
private function getState(stateName:String, throwOnUndefined:Boolean=true):State
{
	if (!states || isBaseState(stateName))
		return null;
	
	// Do a simple linear search for now. This can
	// be optimized later if needed.
	for (var i:int = 0; i < states.length; i++)
	{
		if (states[i].name == stateName)
			return states[i];
	}
	
	if (throwOnUndefined)
	{
		var message:String = ResourceManager.getInstance().getString(
			"core", "stateUndefined", [ stateName ]);
		throw new ArgumentError(message);
	}
	return null;
}

/**
 *  @private
 *  Find the deepest common state between two states. For example:
 *
 *  State A
 *  State B basedOn A
 *  State C basedOn A
 *
 *  findCommonBaseState(B, C) returns A
 *
 *  If there are no common base states, the root state ("") is returned.
 */
private function findCommonBaseState(state1:String, state2:String):String
{
	var firstState:State = getState(state1);
	var secondState:State = getState(state2);
	
	// Quick exit if either state is the base state
	if (!firstState || !secondState)
		return "";
	
	// Quick exit if both states are not based on other states
	if (isBaseState(firstState.basedOn) && isBaseState(secondState.basedOn))
		return "";
	
	// Get the base states for each state and walk from the top
	// down until we find the deepest common base state.
	var firstBaseStates:Array = getBaseStates(firstState);
	var secondBaseStates:Array = getBaseStates(secondState);
	var commonBase:String = "";
	
	while (firstBaseStates[firstBaseStates.length - 1] ==
		secondBaseStates[secondBaseStates.length - 1])
	{
		commonBase = firstBaseStates.pop();
		secondBaseStates.pop();
		
		if (!firstBaseStates.length || !secondBaseStates.length)
			break;
	}
	
	// Finally, check to see if one of the states is directly based on the other.
	if (firstBaseStates.length &&
		firstBaseStates[firstBaseStates.length - 1] == secondState.name)
	{
		commonBase = secondState.name;
	}
	else if (secondBaseStates.length &&
		secondBaseStates[secondBaseStates.length - 1] == firstState.name)
	{
		commonBase = firstState.name;
	}
	
	return commonBase;
}

/**
 *  @private
 *  Returns the base states for a given state.
 *  This Array is in high-to-low order - the first entry
 *  is the immediate basedOn state, the last entry is the topmost
 *  basedOn state.
 */
private function getBaseStates(state:State):Array
{
	var baseStates:Array = [];
	
	// Push each basedOn name
	while (state && state.basedOn)
	{
		baseStates.push(state.basedOn);
		state = getState(state.basedOn);
	}
	
	return baseStates;
}

/**
 *  @private
 *  Remove the overrides applied by a state, and any
 *  states it is based on.
 */
private function removeState(stateName:String, lastState:String):void
{
	var state:State = getState(stateName);
	
	if (stateName == lastState)
		return;
	
	// Remove existing state overrides.
	// This must be done in reverse order
	if (state)
	{
		// Dispatch the "exitState" event
		state.dispatchExitState();
		
		var overrides:Array = state.overrides;
		
		for (var i:int = overrides.length; i; i--)
			overrides[i-1].remove(this);
		
		// Remove any basedOn deltas last
		if (state.basedOn != lastState)
			removeState(state.basedOn, lastState);
	}
}

/**
 *  @private
 *  Apply the overrides from a state, and any states it
 *  is based on.
 */
private function applyState(stateName:String, lastState:String):void
{
	var state:State = getState(stateName);
	
	if (stateName == lastState)
		return;
	
	if (state)
	{
		// Apply "basedOn" overrides first
		if (state.basedOn != lastState)
			applyState(state.basedOn, lastState);
		
		// Apply new state overrides
		var overrides:Array = state.overrides;
		
		for (var i:int = 0; i < overrides.length; i++)
			overrides[i].apply(this);
		
		// Dispatch the "enterState" event
		state.dispatchEnterState();
	}
}

/**
 *  @private
 *  Initialize the state, and any states it is based on
 */
private function initializeState(stateName:String):void
{
	var state:State = getState(stateName);
	
	while (state)
	{
		state.initialize();
		state = getState(state.basedOn);
	}
}

/**
 *  @private
 *  Find the appropriate transition to play between two states.
 */
private function getTransition(oldState:String, newState:String):Transition
{
	var result:Transition = null;   // Current candidate
	var priority:int = 0;           // Priority     fromState   toState
	//    1             *           *
	//    2          reverse        *
	//    3             *        reverse
	//    4          reverse     reverse
	//    5           match         *
	//    6             *         match
	//    7           match       match
	
	if (!transitions)
		return null;
	
	if (!oldState)
		oldState = "";
	
	if (!newState)
		newState = "";
	
	for (var i:int = 0; i < transitions.length; i++)
	{
		var t:Transition = transitions[i];
		
		if (t.fromState == "*" && t.toState == "*" && priority < 1)
		{
			result = t;
			priority = 1;
		}
		else if (t.toState == oldState && t.fromState == "*" && t.autoReverse && priority < 2)
		{
			result = t;
			priority = 2;
		}
		else if (t.toState == "*" && t.fromState == newState && t.autoReverse && priority < 3)
		{
			result = t;
			priority = 3;
		}
		else if (t.toState == oldState && t.fromState == newState && t.autoReverse && priority < 4)
		{
			result = t;
			priority = 4;
		}
		else if (t.fromState == oldState && t.toState == "*" && priority < 5)
		{
			result = t;
			priority = 5;
		}
		else if (t.fromState == "*" && t.toState == newState && priority < 6)
		{
			result = t;
			priority = 6;
		}
		else if (t.fromState == oldState && t.toState == newState && priority < 7)
		{
			result = t;
			priority = 7;
			
			// Can't get any higher than this, let's go.
			break;
		}
	}
	// If Transition does not contain an effect, then don't return it
	// because there is no transition effect to run
	if (result && !result.effect)
		result = null;
	
	return result;
}