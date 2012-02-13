mx_internal static var dispatchEventHook:Function;

/**
 *  Dispatches an event into the event flow.
 *  The event target is the EventDispatcher object upon which
 *  the <code>dispatchEvent()</code> method is called.
 *
 *  @param event The Event object that is dispatched into the event flow.
 *  If the event is being redispatched, a clone of the event is created automatically.
 *  After an event is dispatched, its <code>target</code> property cannot be changed,
 *  so you must create a new copy of the event for redispatching to work.
 *
 *  @return A value of <code>true</code> if the event was successfully dispatched.
 *  A value of <code>false</code> indicates failure or that
 *  the <code>preventDefault()</code> method was called on the event.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
override public function dispatchEvent(event:Event):Boolean
{
	if (dispatchEventHook != null)
		dispatchEventHook(event, this);
	
	return super.dispatchEvent(event);
}

private static var fakeMouseX:QName = new QName(mx_internal, "_mouseX");
private static var fakeMouseY:QName = new QName(mx_internal, "_mouseY");

/**
 *  @private
 */
override public function get mouseX():Number
{
	if (!root || root is Stage || root[fakeMouseX] === undefined)
		return super.mouseX;
	return globalToLocal(new Point(root[fakeMouseX], 0)).x;
}

/**
 *  @private
 */
override public function get mouseY():Number
{
	if (!root || root is Stage || root[fakeMouseY] === undefined)
		return super.mouseY;
	return globalToLocal(new Point(0, root[fakeMouseY])).y;
}


/**
 *  Initializes the implementation and storage of some of the less frequently
 *  used advanced layout features of a component.
 *  
 *  Call this function before attempting to use any of the features implemented
 *  by the AdvancedLayoutFeatures object.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
protected function initAdvancedLayoutFeatures():void
{
	internal_initAdvancedLayoutFeatures();
}


/**
 *  @private
 */
mx_internal function transformRequiresValidations():Boolean
{
	return (_layoutFeatures != null);        
}

/**
 *  @private
 */
mx_internal function clearAdvancedLayoutFeatures():void
{
	if (_layoutFeatures)
	{
		// Make sure the matrix is validated before we free the 
		// layout features. 
		validateMatrix();
		_layoutFeatures = null;
	}
}

/**
 *  Passed to TransformUtil to create the layout features when performing
 *  transformation operations.
 */
private function internal_initAdvancedLayoutFeatures():AdvancedLayoutFeatures
{
	var features:AdvancedLayoutFeatures = new AdvancedLayoutFeatures();
	
	_hasComplexLayoutMatrix = true;
	
	features.layoutScaleX = scaleX;
	features.layoutScaleY = scaleY;
	features.layoutScaleZ = scaleZ;
	features.layoutRotationX = rotationX;
	features.layoutRotationY = rotationY;
	features.layoutRotationZ = rotation;
	features.layoutX = x;
	features.layoutY = y;
	features.layoutZ = z;
	features.layoutWidth = width;  // for the mirror transform      
	_layoutFeatures = features;
	invalidateTransform();
	return features;
}

/**
 *  @private
 *  Helper function to update the storage vairable _transform.
 *  Also updates the <code>target</code> property of the new and the old
 *  values.
 */
private function setTransform(value:flash.geom.Transform):void
{
	// Clean up the old transform
	var oldTransform:mx.geom.Transform = _transform as mx.geom.Transform;
	if (oldTransform)
		oldTransform.target = null;
	
	var newTransform:mx.geom.Transform = value as mx.geom.Transform;
	
	if (newTransform)
		newTransform.target = this;
	
	_transform = value;
}



/**
 *  @private
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
override public function get transform():flash.geom.Transform
{
	if (_transform == null)
	{
		setTransform(new mx.geom.Transform(this));
	}
	return _transform;
}

/**
 *  An object with properties pertaining to a display object's matrix, color transform, 
 *  and pixel bounds.  The specific properties — matrix, colorTransform, and three read-only 
 *  properties (<code>concatenatedMatrix</code>, <code>concatenatedColorTransform</code>, and <code>pixelBounds</code>) — 
 *  are described in the entry for the <code>Transform</code> class.  
 *  
 *  <p>Each of the transform object's properties is itself an object.  This concept is 
 *  important because the only way to set new values for the matrix or colorTransform 
 *  objects is to create a new object and copy that object into the transform.matrix or
 *  transform.colorTransform property.</p>
 * 
 *  <p>For example, to increase the tx value of a display object's matrix, you must make a copy
 *  of the entire matrix object, then copy the new object into the matrix property of the 
 *  transform object:</p>
 *
 *  <pre>
 *  var myMatrix:Matrix = myUIComponentObject.transform.matrix;  
 *  myMatrix.tx += 10; 
 *  myUIComponent.transform.matrix = myMatrix;
 *  </pre>
 *   
 *  You cannot directly set the tx property. The following code has no effect on myUIComponent:
 * 
 *  <pre>
 *  myUIComponent.transform.matrix.tx += 10;
 *  </pre>
 *
 *  <p>Note that for <code>UIComponent</code>, unlike <code>DisplayObject</code>, the <code>transform</code>
 *  keeps the <code>matrix</code> and <code>matrix3D</code> values in sync and <code>matrix3D</code> is not null
 *  even when the component itself has no 3D properties set.  Developers should use the <code>is3D</code> property 
 *  to check if the component has 3D propertis set.  If the component has 3D properties, the transform's 
 *  <code>matrix3D</code> should be used instead of transform's <code>matrix</code>.</p>
 *
 *  @see #setLayoutMatrix
 *  @see #setLayoutMatrix3D
 *  @see #getLayoutMatrix
 *  @see #getLayoutMatrix3D
 *  @see #is3D
 *  @see mx.geom.Transform
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
override public function set transform(value:flash.geom.Transform):void
{
	var m:Matrix = value.matrix;
	var m3:Matrix3D =  value.matrix3D;
	var ct:ColorTransform = value.colorTransform;
	var pp:PerspectiveProjection = value.perspectiveProjection;
	
	// validateMatrix when switching between 2D/3D, works around player bug
	// see sdk-23421 
	var was3D:Boolean = is3D;
	
	var mxTransform:mx.geom.Transform = value as mx.geom.Transform;
	if (mxTransform)
	{
		if (!mxTransform.applyMatrix)
			m = null;
		
		if (!mxTransform.applyMatrix3D)
			m3 = null;
	}
	
	setTransform(value);
	
	if (m != null)
		setLayoutMatrix(m.clone(), true /*triggerLayoutPass*/);
	else if (m3 != null)
		setLayoutMatrix3D(m3.clone(), true /*triggerLayoutPass*/);
	
	super.transform.colorTransform = ct;
	super.transform.perspectiveProjection = pp;
	if (maintainProjectionCenter)
		invalidateDisplayList(); 
	if (was3D != is3D)
		validateMatrix();
}

/**
 *  @copy mx.core.IVisualElement#postLayoutTransformOffsets
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public function get postLayoutTransformOffsets():TransformOffsets
{
	return (_layoutFeatures != null)? _layoutFeatures.postLayoutTransformOffsets:null;
}

/**
 * @private
 */
public function set postLayoutTransformOffsets(value:TransformOffsets):void
{
	// validateMatrix when switching between 2D/3D, works around player bug
	// see sdk-23421 
	var was3D:Boolean = is3D;
	
	if (_layoutFeatures == null)
		initAdvancedLayoutFeatures();
	
	if (_layoutFeatures.postLayoutTransformOffsets != null)
		_layoutFeatures.postLayoutTransformOffsets.removeEventListener(Event.CHANGE,transformOffsetsChangedHandler);
	_layoutFeatures.postLayoutTransformOffsets = value;
	if (_layoutFeatures.postLayoutTransformOffsets != null)
		_layoutFeatures.postLayoutTransformOffsets.addEventListener(Event.CHANGE,transformOffsetsChangedHandler);
	if (was3D != is3D)
		validateMatrix();
	
	invalidateTransform();
}

/**
 * @private
 */
private var _maintainProjectionCenter:Boolean = false;

/**
 *  When true, the component keeps its projection matrix centered on the
 *  middle of its bounding box.  If no projection matrix is defined on the
 *  component, one is added automatically.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public function set maintainProjectionCenter(value:Boolean):void
{
	_maintainProjectionCenter = value;
	if (value && super.transform.perspectiveProjection == null)
	{
		super.transform.perspectiveProjection = new PerspectiveProjection();
	}
	invalidateDisplayList();
}
/**
 * @private
 */
public function get maintainProjectionCenter():Boolean
{
	return _maintainProjectionCenter;
}

/**
 *  @inheritDoc 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public function setLayoutMatrix(value:Matrix, invalidateLayout:Boolean):void
{
	var previousMatrix:Matrix = _layoutFeatures ? 
		_layoutFeatures.layoutMatrix : super.transform.matrix;
	
	// validateMatrix when switching between 2D/3D, works around player bug
	// see sdk-23421 
	var was3D:Boolean = is3D;
	_hasComplexLayoutMatrix = true;
	
	if (_layoutFeatures == null)
	{
		// flash will make a copy of this on assignment.
		super.transform.matrix = value;
	}
	else
	{
		// layout features will internally make a copy of this matrix rather than
		// holding onto a reference to it.
		_layoutFeatures.layoutMatrix = value;
		invalidateTransform();
	}
	
	// Early exit if possible. We don't want to invalidate unnecessarily.
	// We need to do the check here, after our new value has been applied
	// because our matrix components are rounded upon being applied to a
	// DisplayObject.
	if (MatrixUtil.isEqual(previousMatrix, _layoutFeatures ? 
		_layoutFeatures.layoutMatrix : super.transform.matrix))
	{    
		return;
	} 
	
	invalidateProperties();
	
	if (invalidateLayout)
		invalidateParentSizeAndDisplayList();
	
	if (was3D != is3D)
		validateMatrix();
}

/**
 *  @inheritDoc 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public function setLayoutMatrix3D(value:Matrix3D, invalidateLayout:Boolean):void
{
	// Early exit if possible. We don't want to invalidate unnecessarily.
	if (_layoutFeatures && MatrixUtil.isEqual3D(_layoutFeatures.layoutMatrix3D, value))
		return;
	
	// validateMatrix when switching between 2D/3D, works around player bug
	// see sdk-23421 
	var was3D:Boolean = is3D;
	
	if (_layoutFeatures == null)
		initAdvancedLayoutFeatures();
	// layout features will internally make a copy of this matrix rather than
	// holding onto a reference to it.
	_layoutFeatures.layoutMatrix3D = value;
	invalidateTransform();
	
	invalidateProperties();
	
	if (invalidateLayout)
		invalidateParentSizeAndDisplayList();
	
	if (was3D != is3D)
		validateMatrix();
}

/**
 *  @copy mx.core.ILayoutElement#transformAround()
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public function transformAround(transformCenter:Vector3D,
								scale:Vector3D = null,
								rotation:Vector3D = null,
								translation:Vector3D = null,
								postLayoutScale:Vector3D = null,
								postLayoutRotation:Vector3D = null,
								postLayoutTranslation:Vector3D = null,
								invalidateLayout:Boolean = true):void
{
	// Make sure that no transform setters will trigger parent invalidation.
	// Reset the flag at the end of the method.
	var oldIncludeInLayout:Boolean;
	if (!invalidateLayout)
	{
		oldIncludeInLayout = _includeInLayout;
		_includeInLayout = false;
	}
	
	var prevX:Number = x;
	var prevY:Number = y;
	var prevZ:Number = z;
	
	TransformUtil.transformAround(this,
		transformCenter,
		scale,
		rotation,
		translation,
		postLayoutScale,
		postLayoutRotation,
		postLayoutTranslation,
		_layoutFeatures,
		internal_initAdvancedLayoutFeatures);
	
	if (_layoutFeatures != null)
	{
		invalidateTransform();
		
		// Will not invalidate parent if we have set _includeInLayout to false
		// in the beginning of the method
		invalidateParentSizeAndDisplayList();
		
		if (prevX != _layoutFeatures.layoutX)
			dispatchEvent(new Event("xChanged"));
		if (prevY != _layoutFeatures.layoutY)
			dispatchEvent(new Event("yChanged"));
		if (prevZ != _layoutFeatures.layoutZ)
			dispatchEvent(new Event("zChanged"));
	}
	
	if (!invalidateLayout)
		_includeInLayout = oldIncludeInLayout;
}

/**
 *  A utility method to transform a point specified in the local
 *  coordinates of this object to its location in the object's parent's 
 *  coordinates. The pre-layout and post-layout result is set on 
 *  the <code>position</code> and <code>postLayoutPosition</code>
 *  parameters, if they are non-null.
 *  
 *  @param localPosition The point to be transformed, specified in the
 *  local coordinates of the object.
 * 
 *  @param position A Vector3D point that holds the pre-layout
 *  result. If null, the parameter is ignored.
 * 
 *  @param postLayoutPosition A Vector3D point that holds the post-layout
 *  result. If null, the parameter is ignored.
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public function transformPointToParent(localPosition:Vector3D,
									   position:Vector3D, 
									   postLayoutPosition:Vector3D):void
{
	TransformUtil.transformPointToParent(this,
		localPosition,
		position,
		postLayoutPosition,
		_layoutFeatures);
}

/**
 *  The transform matrix that is used to calculate a component's layout
 *  relative to its siblings. This matrix is defined by the component's
 *  3D properties (which include the 2D properties such as <code>x</code>,
 *  <code>y</code>, <code>rotation</code>, <code>scaleX</code>,
 *  <code>scaleY</code>, <code>transformX</code>, and 
 *  <code>transformY</code>, as well as <code>rotationX</code>, 
 *  <code>rotationY</code>, <code>scaleZ</code>, <code>z</code>, and
 *  <code>transformZ</code>.
 *  
 *  <p>Most components do not have any 3D transform properties set on them.</p>
 *  
 *  <p>This layout matrix is combined with the values of the 
 *  <code>postLayoutTransformOffsets</code> property to determine the
 *  component's final, computed matrix.</p>
 * 
 *  @see #postLayoutTransformOffsets
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public function set layoutMatrix3D(value:Matrix3D):void
{
	setLayoutMatrix3D(value, true /*invalidateLayout*/);
}

//----------------------------------
//  depth
//----------------------------------  

/**
 *  @inheritDoc
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public function get depth():Number
{
	return (_layoutFeatures == null) ? 0 : _layoutFeatures.depth;
}

/**
 * @private
 */
public function set depth(value:Number):void
{
	if (value == depth)
		return;
	if (_layoutFeatures == null)
		initAdvancedLayoutFeatures();
	
	_layoutFeatures.depth = value;      
	if (parent is UIComponent)
		UIComponent(parent).invalidateLayering();
}

/**
 *  Called by a component's items to indicate that their <code>depth</code>
 *  property has changed. Note that while this function is defined on
 *  <code>UIComponent</code>, it is up to subclasses to implement support
 *  for complex layering.
 *
 *  By default, only <code>Group</code> and <code>DataGroup</code> support
 *  arbitrary layering of their children.
 * 
 *  @see #depth
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.4
 *  @productversion Flex 4
 */
public function invalidateLayering():void
{
}

/**
 *  Commits the computed matrix built from the combination of the layout
 *  matrix and the transform offsets to the flash displayObject's transform.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
protected function applyComputedMatrix():void
{
	_layoutFeatures.updatePending = false;
	if (_layoutFeatures.is3D)
	{
		super.transform.matrix3D = _layoutFeatures.computedMatrix3D;
	}
	else
	{
		super.transform.matrix = _layoutFeatures.computedMatrix;
	}
}

mx_internal function get computedMatrix():Matrix
{
	return (_layoutFeatures) ?  _layoutFeatures.computedMatrix : transform.matrix;
}

/**
 *  Specifies a transform stretch factor in the horizontal and vertical direction.
 *  The stretch factor is applied to the computed matrix before any other transformation.
 *  @param stretchX The horizontal component of the stretch factor.
 *  @param stretchY The vertical component of the stretch factor.
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
protected function setStretchXY(stretchX:Number, stretchY:Number):void
{
	if (_layoutFeatures == null)
		initAdvancedLayoutFeatures();
	if (stretchX != _layoutFeatures.stretchX ||
		stretchY != _layoutFeatures.stretchY)
	{            
		_layoutFeatures.stretchX = stretchX;
		_layoutFeatures.stretchY = stretchY;
		invalidateTransform();
	}
}