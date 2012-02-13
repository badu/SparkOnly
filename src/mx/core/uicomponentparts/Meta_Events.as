/**
 *  Dispatched when the component is added to a container as a content child
 *  by using the <code>addChild()</code>, <code>addChildAt()</code>, 
 *  <code>addElement()</code>, or <code>addElementAt()</code> method.
 *  If the component is added to the container as a noncontent child by
 *  using the <code>rawChildren.addChild()</code> or
 *  <code>rawChildren.addChildAt()</code> method, the event is not dispatched.
 *
 * <p>This event is only dispatched when there are one or more relevant listeners 
 * attached to the dispatching object.</p>
 * 
 *  @eventType mx.events.FlexEvent.ADD
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="add", type="mx.events.FlexEvent")]

/**
 *  Dispatched when the component has finished its construction,
 *  property processing, measuring, layout, and drawing.
 *
 *  <p>At this point, depending on its <code>visible</code> property,
 *  the component is not visible even though it has been drawn.</p>
 *
 *  @eventType mx.events.FlexEvent.CREATION_COMPLETE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="creationComplete", type="mx.events.FlexEvent")]

/**
 *  Dispatched when an object has had its <code>commitProperties()</code>,
 *  <code>measure()</code>, and
 *  <code>updateDisplayList()</code> methods called (if needed).
 *
 *  <p>This is the last opportunity to alter the component before it is
 *  displayed. All properties have been committed and the component has
 *  been measured and layed out.</p>
 *
 *  <p>This event is only dispatched when there are one or more 
 *  relevant listeners attached to the dispatching object.</p>
 * 
 *  @eventType mx.events.FlexEvent.UPDATE_COMPLETE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="updateComplete", type="mx.events.FlexEvent")]

/**
 *  Dispatched when an object's state changes from visible to invisible.
 * 
 *  <p>This event is only dispatched when there are one or more relevant listeners 
 *  attached to the dispatching object.</p>
 *
 *  @eventType mx.events.FlexEvent.HIDE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="hide", type="mx.events.FlexEvent")]

/**
 *  Dispatched when the component has finished its construction
 *  and has all initialization properties set.
 *
 *  <p>After the initialization phase, properties are processed, the component
 *  is measured, laid out, and drawn, after which the
 *  <code>creationComplete</code> event is dispatched.</p>
 * 
 *  @eventType mx.events.FlexEvent.INITIALIZE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="initialize", type="mx.events.FlexEvent")]

/**
 *  Dispatched when the object has moved.
 *
 *  <p>You can move the component by setting the <code>x</code>
 *  or <code>y</code> properties, by calling the <code>move()</code>
 *  method, by setting one
 *  of the following properties either on the component or on other
 *  components such that the LayoutManager needs to change the
 *  <code>x</code> or <code>y</code> properties of the component:</p>
 *
 *  <ul>
 *    <li><code>minWidth</code></li>
 *    <li><code>minHeight</code></li>
 *    <li><code>maxWidth</code></li>
 *    <li><code>maxHeight</code></li>
 *    <li><code>explicitWidth</code></li>
 *    <li><code>explicitHeight</code></li>
 *  </ul>
 *
 *  <p>When you call the <code>move()</code> method, the <code>move</code>
 *  event is dispatched before the method returns.
 *  In all other situations, the <code>move</code> event is not dispatched
 *  until after the property changes.</p>
 * 
 *  <p>This event only dispatched when there are one or more 
 *  relevant listeners attached to the dispatching object.</p>
 *
 *  @eventType mx.events.MoveEvent.MOVE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="move", type="mx.events.MoveEvent")]

/**
 *  Dispatched at the beginning of the component initialization sequence.
 *  The component is in a very raw state when this event is dispatched.
 *  Many components, such as the Button control, create internal child
 *  components to implement functionality; for example, the Button control
 *  creates an internal UITextField component to represent its label text.
 *  When Flex dispatches the <code>preinitialize</code> event,
 *  the children, including the internal children, of a component
 *  have not yet been created.
 * 
 *  @eventType mx.events.FlexEvent.PREINITIALIZE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="preinitialize", type="mx.events.FlexEvent")]

/**
 *  Dispatched when the component is removed from a container as a content child
 *  by using the <code>removeChild()</code>, <code>removeChildAt()</code>,
 *  <code>removeElement()</code>, or <code>removeElementAt()</code> method.
 *  If the component is removed from the container as a noncontent child by
 *  using the <code>rawChildren.removeChild()</code> or
 *  <code>rawChildren.removeChildAt()</code> method, the event is not dispatched.
 *
 * <p>This event only dispatched when there are one or more relevant listeners 
 * attached to the dispatching object.</p>
 * 
 *  @eventType mx.events.FlexEvent.REMOVE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="remove", type="mx.events.FlexEvent")]

/**
 *  Dispatched when the component is resized.
 *
 *  <p>You can resize the component by setting the <code>width</code> or
 *  <code>height</code> property, by calling the <code>setActualSize()</code>
 *  method, or by setting one of
 *  the following properties either on the component or on other components
 *  such that the LayoutManager needs to change the <code>width</code> or
 *  <code>height</code> properties of the component:</p>
 *
 *  <ul>
 *    <li><code>minWidth</code></li>
 *    <li><code>minHeight</code></li>
 *    <li><code>maxWidth</code></li>
 *    <li><code>maxHeight</code></li>
 *    <li><code>explicitWidth</code></li>
 *    <li><code>explicitHeight</code></li>
 *  </ul>
 *
 *  <p>The <code>resize</code> event is not
 *  dispatched until after the property changes.</p>
 * 
 *  <p>This event only dispatched when there are one or more 
 *  relevant listeners attached to the dispatching object.</p>
 *
 *  @eventType mx.events.ResizeEvent.RESIZE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="resize", type="mx.events.ResizeEvent")]

/**
 *  Dispatched when an object's state changes from invisible to visible.
 * 
 *  <p>This event is only dispatched when there are one or more relevant listeners 
 *  attached to the dispatching object.</p>
 *
 *  @eventType mx.events.FlexEvent.SHOW
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="show", type="mx.events.FlexEvent")]

//--------------------------------------
//  Mouse events
//--------------------------------------

/**
 *  Dispatched from a component opened using the PopUpManager
 *  when the user clicks outside it.
 *
 *  @eventType mx.events.FlexMouseEvent.MOUSE_DOWN_OUTSIDE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="mouseDownOutside", type="mx.events.FlexMouseEvent")]

/**
 *  Dispatched from a component opened using the PopUpManager
 *  when the user scrolls the mouse wheel outside it.
 *
 *  @eventType mx.events.FlexMouseEvent.MOUSE_WHEEL_OUTSIDE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="mouseWheelOutside", type="mx.events.FlexMouseEvent")]

//--------------------------------------
//  Validation events
//--------------------------------------

/**
 *  Dispatched when values are changed programmatically
 *  or by user interaction.
 *
 *  <p>Because a programmatic change triggers this event, make sure
 *  that any <code>valueCommit</code> event handler does not change
 *  a value that causes another <code>valueCommit</code> event.
 *  For example, do not change a control's <code>dataProvider</code>
 *  property in a <code>valueCommit</code> event handler. </p>
 *
 *  @eventType mx.events.FlexEvent.VALUE_COMMIT
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="valueCommit", type="mx.events.FlexEvent")]

/**
 *  Dispatched when a component is monitored by a Validator
 *  and the validation failed.
 *
 *  @eventType mx.events.FlexEvent.INVALID
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="invalid", type="mx.events.FlexEvent")]

/**
 *  Dispatched when a component is monitored by a Validator
 *  and the validation succeeded.
 *
 *  @eventType mx.events.FlexEvent.VALID
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="valid", type="mx.events.FlexEvent")]

//--------------------------------------
//  Drag-and-drop events
//--------------------------------------

/**
 *  Dispatched by a component when the user moves the mouse over the component
 *  during a drag operation.
 *  In an application running in Flash Player,
 *  the event is dispatched many times when you move the mouse over any component.
 *  In an application running in AIR, the event is dispatched only once.
 *
 *  <p>In order to be a valid drop target, you must define a handler
 *  for this event.
 *  In the handler, you can change the appearance of the drop target
 *  to provide visual feedback to the user that the component can accept
 *  the drag.
 *  For example, you could draw a border around the drop target,
 *  or give focus to the drop target.</p>
 *
 *  <p>If you want to accept the drag, you must call the
 *  <code>DragManager.acceptDragDrop()</code> method. If you don't
 *  call <code>acceptDragDrop()</code>, you do not get any of the
 *  other drag events.</p>
 *
 *  <p>In Flash Player, the value of the <code>action</code> property is always
 *  <code>DragManager.MOVE</code>, even if you are doing a copy.
 *  This is because the <code>dragEnter</code> event occurs before
 *  the control recognizes that the Control key is pressed to signal a copy.
 *  The <code>action</code> property of the event object for the
 *  <code>dragOver</code> event does contain a value that signifies the type of
 *  drag operation. You can change the type of drag action by calling the
 *  <code>DragManager.showFeedback()</code> method.</p>
 *
 *  <p>In AIR, the default value of the <code>action</code> property is
 *  <code>DragManager.COPY</code>.</p>
 *
 *  <p>Because of the way data to a Tree control is structured,
 *  the Tree control handles drag and drop differently from the other list-based controls.
 *  For the Tree control, the event handler for the <code>dragDrop</code> event
 *  only performs an action when you move or copy data in the same Tree control,
 *  or copy data to another Tree control.
 *  If you drag data from one Tree control and drop it onto another Tree control
 *  to move the data, the event handler for the <code>dragComplete</code> event
 *  actually performs the work to add the data to the destination Tree control,
 *  rather than the event handler for the dragDrop event,
 *  and also removes the data from the source Tree control.
 *  This is necessary because to reparent the data being moved,
 *  Flex must remove it first from the source Tree control.</p>
 *
 *  @see mx.managers.DragManager
 *
 *  @eventType mx.events.DragEvent.DRAG_ENTER
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="dragEnter", type="mx.events.DragEvent")]

/**
 *  Dispatched by a component when the user moves the mouse while over the component
 *  during a drag operation.
 *  In Flash Player, the event is dispatched
 *  when you drag an item over a valid drop target.
 *  In AIR, the event is dispatched when you drag an item over
 *  any component, even if the component is not a valid drop target.
 *
 *  <p>In the handler, you can change the appearance of the drop target
 *  to provide visual feedback to the user that the component can accept
 *  the drag.
 *  For example, you could draw a border around the drop target,
 *  or give focus to the drop target.</p>
 *
 *  <p>Handle this event to perform additional logic
 *  before allowing the drop, such as dropping data to various locations
 *  in the drop target, reading keyboard input to determine if the
 *  drag-and-drop action is a move or copy of the drag data, or providing
 *  different types of visual feedback based on the type of drag-and-drop
 *  action.</p>
 *
 *  <p>You can also change the type of drag action by changing the
 *  <code>DragManager.showFeedback()</code> method.
 *  The default value of the <code>action</code> property is
 *  <code>DragManager.MOVE</code>.</p>
 *
 *  @see mx.managers.DragManager
 *
 *  @eventType mx.events.DragEvent.DRAG_OVER
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="dragOver", type="mx.events.DragEvent")]

/**
 *  Dispatched by the component when the user drags outside the component,
 *  but does not drop the data onto the target.
 *
 *  <p>You use this event to restore the drop target to its normal appearance
 *  if you modified its appearance as part of handling the
 *  <code>dragEnter</code> or <code>dragOver</code> event.</p>
 *
 *  @eventType mx.events.DragEvent.DRAG_EXIT
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="dragExit", type="mx.events.DragEvent")]

/**
 *  Dispatched by the drop target when the user releases the mouse over it.
 *
 *  <p>You use this event handler to add the drag data to the drop target.</p>
 *
 *  <p>If you call <code>Event.preventDefault()</code> in the event handler
 *  for the <code>dragDrop</code> event for
 *  a Tree control when dragging data from one Tree control to another,
 *  it prevents the drop.</p>
 *
 *  @eventType mx.events.DragEvent.DRAG_DROP
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="dragDrop", type="mx.events.DragEvent")]

/**
 *  Dispatched by the drag initiator (the component that is the source
 *  of the data being dragged) when the drag operation completes,
 *  either when you drop the dragged data onto a drop target or when you end
 *  the drag-and-drop operation without performing a drop.
 *
 *  <p>You can use this event to perform any final cleanup
 *  of the drag-and-drop operation.
 *  For example, if you drag a List control item from one list to another,
 *  you can delete the List control item from the source if you no longer
 *  need it.</p>
 *
 *  <p>If you call <code>Event.preventDefault()</code> in the event handler
 *  for the <code>dragComplete</code> event for
 *  a Tree control when dragging data from one Tree control to another,
 *  it prevents the drop.</p>
 *
 *  @eventType mx.events.DragEvent.DRAG_COMPLETE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="dragComplete", type="mx.events.DragEvent")]

/**
 *  Dispatched by the drag initiator when starting a drag operation.
 *  This event is used internally by the list-based controls;
 *  you do not handle it when implementing drag and drop.
 *  If you want to control the start of a drag-and-drop operation,
 *  use the <code>mouseDown</code> or <code>mouseMove</code> event.
 *
 *  @eventType mx.events.DragEvent.DRAG_START
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="dragStart", type="mx.events.DragEvent")]

//--------------------------------------
//  Effect events
//--------------------------------------

/**
 *  Dispatched just before an effect starts.
 *
 *  <p>The effect does not start changing any visuals
 *  until after this event is fired.</p>
 *
 *  @eventType mx.events.EffectEvent.EFFECT_START
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="effectStart", type="mx.events.EffectEvent")]

/**
 *  Dispatched after an effect is stopped, which happens
 *  only by a call to <code>stop()</code> on the effect.
 *
 *  <p>The effect then dispatches the EFFECT_END event
 *  as the effect finishes. The purpose of the EFFECT_STOP
 *  event is to let listeners know that the effect came to
 *  a premature end, rather than ending naturally or as a 
 *  result of a call to <code>end()</code>.</p>
 *
 *  @eventType mx.events.EffectEvent.EFFECT_STOP
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="effectStop", type="mx.events.EffectEvent")]

/**
 *  Dispatched after an effect ends.
 *
 *  <p>The effect makes the last set of visual changes
 *  before this event is fired, but those changes are not 
 *  rendered on the screen.
 *  Thus, you might have to use the <code>callLater()</code> method
 *  to delay any other changes that you want to make until after the
 *  changes have been rendered onscreen.</p>
 *
 *  @eventType mx.events.EffectEvent.EFFECT_END
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="effectEnd", type="mx.events.EffectEvent")]


//--------------------------------------
//  State events
//--------------------------------------

/**
 *  Dispatched after the <code>currentState</code> property changes,
 *  but before the view state changes.
 * 
 *  <p>This event is only dispatched when there are one or more 
 *  relevant listeners attached to the dispatching object.</p>
 *
 *  @eventType mx.events.StateChangeEvent.CURRENT_STATE_CHANGING
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="currentStateChanging", type="mx.events.StateChangeEvent")]

/**
 *  Dispatched after the view state has changed.
 * 
 *  <p>This event is only dispatched when there are one or more 
 *  relevant listeners attached to the dispatching object.</p>
 *
 *  @eventType mx.events.StateChangeEvent.CURRENT_STATE_CHANGE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="currentStateChange", type="mx.events.StateChangeEvent")]

/**
 *  Dispatched after the component has entered a view state.
 * 
 *  <p>This event is only dispatched when there are one or more 
 *  relevant listeners attached to the dispatching object.</p>
 *
 *  @eventType mx.events.FlexEvent.ENTER_STATE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="enterState", type="mx.events.FlexEvent")]

/**
 *  Dispatched just before the component exits a view state.
 * 
 *  <p>This event is only dispatched when there are one or more 
 *  relevant listeners attached to the dispatching object.</p>
 *
 *  @eventType mx.events.FlexEvent.EXIT_STATE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="exitState", type="mx.events.FlexEvent")]

/**
 *  Dispatched after the component has entered a new state and
 *  any state transition animation to that state has finished playing.
 *
 *  The event is dispatched immediately if there's no transition playing
 *  between the states.
 *
 *  If the component switches to a different state while the transition is
 *  underway, this event will be dispatched after the component completes the
 *  transition to that new state.
 * 
 *  <p>This event is only dispatched when there are one or more 
 *  relevant listeners attached to the dispatching object.</p>
 *
 *  @eventType mx.events.FlexEvent.STATE_CHANGE_COMPLETE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
[Event(name="stateChangeComplete", type="mx.events.FlexEvent")]

/**
 *  Dispatched when a component interrupts a transition to its current
 *  state in order to switch to a new state. 
 * 
 *  <p>This event is only dispatched when there are one or more 
 *  relevant listeners attached to the dispatching object.</p>
 *
 *  @eventType mx.events.FlexEvent.STATE_CHANGE_INTERRUPTED
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
[Event(name="stateChangeInterrupted", type="mx.events.FlexEvent")]


//--------------------------------------
//  TouchInteraction events
//--------------------------------------

/**
 *  A cancellable event, dispatched by a component in an attempt to 
 *  respond to a touch interaction user gesture.
 * 
 *  <p>The event is a bubbling event dispatched on the 
 *  DisplayObject that the touch interaction
 *  started (where the mouseDown/touchBegin occurred).</p>
 * 
 *  <p>Components responding to touch interactions should listen for
 *  touch interaction events to coordinate with other components around 
 *  what type of touch interaction the user intended to make and which component 
 *  is responding to that touch interaction.</p>
 * 
 *  <p>A Scroller component will dispatch a touchInteractionStarting event 
 *  to alert other components that may be responding to the same user's 
 *  touch interaction that it would like to take control of this touch interaction.
 *  This is an opportunity for other components to cancel the Scroller's 
 *  action and to maintain control over this touch interaction.</p>
 *
 *  @eventType mx.events.TouchInteractionEvent.TOUCH_INTERACTION_STARTING
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
[Event(name="touchInteractionStarting", type="mx.events.TouchInteractionEvent")]

/**
 *  A non-cancellable event, dispatched by a component when it starts
 *  responding to a touch interaction user gesture.
 * 
 *  <p>The event is a bubbling event dispatched on the 
 *  DisplayObject that the touch interaction 
 *  started (where the mouseDown/touchBegin occurred).</p>
 * 
 *  <p>Components responding to touch interactions should listen for
 *  touch interaction events to coordinate with other components around 
 *  what type of touch interaction the user intended to make and which component 
 *  is responding to that touch interaction.</p>
 * 
 *  <p>A Scroller component will dispatch a touchInteractionStart event 
 *  to alert other components that may be responding to the same user's 
 *  touch interaction that it is taking control of this touch interaction.
 *  When they see this event, other components should stop responding 
 *  to the touch interaction, remove any visual indications that it is 
 *  responding to the touch interaction, and perform other clean up.</p>
 *
 *  @eventType mx.events.TouchInteractionEvent.TOUCH_INTERACTION_START
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
[Event(name="touchInteractionStart", type="mx.events.TouchInteractionEvent")]

/**
 *  A non-cancellable event, dispatched by a component when it is done
 *  responding to a touch interaction user gesture.
 * 
 *  <p>The event is a bubbling event dispatched on the 
 *  DisplayObject that the touch interaction 
 *  started (where the mouseDown/touchBegin occurred).</p>
 * 
 *  <p>Components responding to touch interactions should listen for
 *  touch interaction events to coordinate with other components around 
 *  what type of touch interaction the user intended to make and which component 
 *  is responding to that touch interaction.</p>
 * 
 *  <p>A Scroller component will dispatch a touchInteractionEnd event 
 *  to alert other components that it is done responding to the user's
 *  touch interaction.</p>
 *
 *  @eventType mx.events.TouchInteractionEvent.TOUCH_INTERACTION_END
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
[Event(name="touchInteractionEnd", type="mx.events.TouchInteractionEvent")]

//--------------------------------------
//  Tooltip events
//--------------------------------------

/**
 *  Dispatched by the component when it is time to create a ToolTip.
 *
 *  <p>If you create your own IToolTip object and place a reference
 *  to it in the <code>toolTip</code> property of the event object
 *  that is passed to your <code>toolTipCreate</code> handler,
 *  the ToolTipManager displays your custom ToolTip.
 *  Otherwise, the ToolTipManager creates an instance of
 *  <code>ToolTipManager.toolTipClass</code> to display.</p>
 *
 *  <p>The sequence of ToolTip events is <code>toolTipStart</code>,
 *  <code>toolTipCreate</code>, <code>toolTipShow</code>,
 *  <code>toolTipShown</code>, <code>toolTipHide</code>,
 *  and <code>toolTipEnd</code>.</p>
 *
 *  @eventType mx.events.ToolTipEvent.TOOL_TIP_CREATE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="toolTipCreate", type="mx.events.ToolTipEvent")]

/**
 *  Dispatched by the component when its ToolTip has been hidden
 *  and is to be discarded soon.
 *
 *  <p>If you specify an effect using the
 *  <code>ToolTipManager.hideEffect</code> property,
 *  this event is dispatched after the effect stops playing.</p>
 *
 *  <p>The sequence of ToolTip events is <code>toolTipStart</code>,
 *  <code>toolTipCreate</code>, <code>toolTipShow</code>,
 *  <code>toolTipShown</code>, <code>toolTipHide</code>,
 *  and <code>toolTipEnd</code>.</p>
 *
 *  @eventType mx.events.ToolTipEvent.TOOL_TIP_END
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="toolTipEnd", type="mx.events.ToolTipEvent")]

/**
 *  Dispatched by the component when its ToolTip is about to be hidden.
 *
 *  <p>If you specify an effect using the
 *  <code>ToolTipManager.hideEffect</code> property,
 *  this event is dispatched before the effect starts playing.</p>
 *
 *  <p>The sequence of ToolTip events is <code>toolTipStart</code>,
 *  <code>toolTipCreate</code>, <code>toolTipShow</code>,
 *  <code>toolTipShown</code>, <code>toolTipHide</code>,
 *  and <code>toolTipEnd</code>.</p>
 *
 *  @eventType mx.events.ToolTipEvent.TOOL_TIP_HIDE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="toolTipHide", type="mx.events.ToolTipEvent")]

/**
 *  Dispatched by the component when its ToolTip is about to be shown.
 *
 *  <p>If you specify an effect using the
 *  <code>ToolTipManager.showEffect</code> property,
 *  this event is dispatched before the effect starts playing.
 *  You can use this event to modify the ToolTip before it appears.</p>
 *
 *  <p>The sequence of ToolTip events is <code>toolTipStart</code>,
 *  <code>toolTipCreate</code>, <code>toolTipShow</code>,
 *  <code>toolTipShown</code>, <code>toolTipHide</code>,
 *  and <code>toolTipEnd</code>.</p>
 *
 *  @eventType mx.events.ToolTipEvent.TOOL_TIP_SHOW
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="toolTipShow", type="mx.events.ToolTipEvent")]

/**
 *  Dispatched by the component when its ToolTip has been shown.
 *
 *  <p>If you specify an effect using the
 *  <code>ToolTipManager.showEffect</code> property,
 *  this event is dispatched after the effect stops playing.</p>
 *
 *  <p>The sequence of ToolTip events is <code>toolTipStart</code>,
 *  <code>toolTipCreate</code>, <code>toolTipShow</code>,
 *  <code>toolTipShown</code>, <code>toolTipHide</code>,
 *  and <code>toolTipEnd</code>.</p>
 *
 *  @eventType mx.events.ToolTipEvent.TOOL_TIP_SHOWN
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="toolTipShown", type="mx.events.ToolTipEvent")]

/**
 *  Dispatched by a component whose <code>toolTip</code> property is set,
 *  as soon as the user moves the mouse over it.
 *
 *  <p>The sequence of ToolTip events is <code>toolTipStart</code>,
 *  <code>toolTipCreate</code>, <code>toolTipShow</code>,
 *  <code>toolTipShown</code>, <code>toolTipHide</code>,
 *  and <code>toolTipEnd</code>.</p>
 *
 *  @eventType mx.events.ToolTipEvent.TOOL_TIP_START
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="toolTipStart", type="mx.events.ToolTipEvent")]
