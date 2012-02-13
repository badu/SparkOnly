/**
 *  @inheritDoc
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public function getPreferredBoundsWidth(postLayoutTransform:Boolean=true):Number
{
	return LayoutElementUIComponentUtils.getPreferredBoundsWidth(this,postLayoutTransform? nonDeltaLayoutMatrix():null);
}

/**
 *  @inheritDoc
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public function getPreferredBoundsHeight(postLayoutTransform:Boolean=true):Number
{
	return LayoutElementUIComponentUtils.getPreferredBoundsHeight(this,postLayoutTransform? nonDeltaLayoutMatrix():null);
}

/**
 *  @inheritDoc
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public function getMinBoundsWidth(postLayoutTransform:Boolean=true):Number
{
	return LayoutElementUIComponentUtils.getMinBoundsWidth(this,postLayoutTransform? nonDeltaLayoutMatrix():null);
}

/**
 *  @inheritDoc
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public function getMinBoundsHeight(postLayoutTransform:Boolean=true):Number
{
	return LayoutElementUIComponentUtils.getMinBoundsHeight(this,postLayoutTransform? nonDeltaLayoutMatrix():null);
}

/**
 *  @inheritDoc
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public function getMaxBoundsWidth(postLayoutTransform:Boolean=true):Number
{
	return LayoutElementUIComponentUtils.getMaxBoundsWidth(this,postLayoutTransform? nonDeltaLayoutMatrix():null);
}

/**
 *  @inheritDoc
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public function getMaxBoundsHeight(postLayoutTransform:Boolean=true):Number
{
	return LayoutElementUIComponentUtils.getMaxBoundsHeight(this,postLayoutTransform? nonDeltaLayoutMatrix():null);
}

/**
 *  @inheritDoc
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public function getBoundsXAtSize(width:Number, height:Number, postLayoutTransform:Boolean = true):Number
{
	return LayoutElementUIComponentUtils.getBoundsXAtSize(this, width, height,
		postLayoutTransform ? nonDeltaLayoutMatrix() : null);
}

/**
 *  @inheritDoc
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public function getBoundsYAtSize(width:Number, height:Number, postLayoutTransform:Boolean = true):Number
{
	return LayoutElementUIComponentUtils.getBoundsYAtSize(this, width, height,
		postLayoutTransform ? nonDeltaLayoutMatrix() : null);
}

/**
 *  @inheritDoc
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public function getLayoutBoundsWidth(postLayoutTransform:Boolean=true):Number
{
	return LayoutElementUIComponentUtils.getLayoutBoundsWidth(this,postLayoutTransform? nonDeltaLayoutMatrix():null);
}

/**
 *  @inheritDoc
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public function getLayoutBoundsHeight(postLayoutTransform:Boolean=true):Number
{
	return LayoutElementUIComponentUtils.getLayoutBoundsHeight(this,postLayoutTransform? nonDeltaLayoutMatrix():null);
}

/**
 *  @inheritDoc
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public function getLayoutBoundsX(postLayoutTransform:Boolean=true):Number
{
	return LayoutElementUIComponentUtils.getLayoutBoundsX(this,postLayoutTransform? nonDeltaLayoutMatrix():null);
}

/**
 *  @inheritDoc
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public function getLayoutBoundsY(postLayoutTransform:Boolean=true):Number
{
	return LayoutElementUIComponentUtils.getLayoutBoundsY(this,postLayoutTransform? nonDeltaLayoutMatrix():null);
}

/**
 *  @inheritDoc
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public function setLayoutBoundsPosition(x:Number, y:Number, postLayoutTransform:Boolean=true):void
{
	LayoutElementUIComponentUtils.setLayoutBoundsPosition(this,x,y,postLayoutTransform? nonDeltaLayoutMatrix():null);
}

/**
 *  @inheritDoc
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public function setLayoutBoundsSize(width:Number,
									height:Number,
									postLayoutTransform:Boolean = true):void
{
	LayoutElementUIComponentUtils.setLayoutBoundsSize(this,width,height,postLayoutTransform? nonDeltaLayoutMatrix():null);
}

/**
 *  @inheritDoc
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public function getLayoutMatrix():Matrix
{
	if (_layoutFeatures != null || super.transform.matrix == null)
	{
		// TODO: this is a workaround for a situation in which the
		// object is in 2D, but used to be in 3D and the player has not
		// yet cleaned up the matrices. So the matrix property is null, but
		// the matrix3D property is non-null. layoutFeatures can deal with
		// that situation, so we allocate it here and let it handle it for
		// us. The downside is that we have now allocated layoutFeatures
		// forever and will continue to use it for future situations that
		// might not have required it. Eventually, we should recognize
		// situations when we can de-allocate layoutFeatures and back off
		// to letting the player handle transforms for us.
		if (_layoutFeatures == null)
			initAdvancedLayoutFeatures();
		
		// esg: _layoutFeatures keeps a single internal copy of the layoutMatrix.
		// since this is an internal class, we don't need to worry about developers
		// accidentally messing with this matrix, _unless_ we hand it out. Instead,
		// we hand out a clone.
		return _layoutFeatures.layoutMatrix.clone();            
	}
	else
	{
		// flash also returns copies.
		return super.transform.matrix;
	}
}

/**
 *  @inheritDoc
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public function get hasLayoutMatrix3D():Boolean
{
	return _layoutFeatures ? _layoutFeatures.layoutIs3D : false;
}

/**
 *  @inheritDoc
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public function get is3D():Boolean
{
	return _layoutFeatures ? _layoutFeatures.is3D : false;
}

/**
 *  @inheritDoc
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public function getLayoutMatrix3D():Matrix3D
{
	if (_layoutFeatures == null)
		initAdvancedLayoutFeatures();
	// esg: _layoutFeatures keeps a single internal copy of the layoutMatrix.
	// since this is an internal class, we don't need to worry about developers
	// accidentally messing with this matrix, _unless_ we hand it out. Instead,
	// we hand out a clone.
	return _layoutFeatures.layoutMatrix3D.clone();          
}

/**
 *  @private
 */
protected function nonDeltaLayoutMatrix():Matrix
{
	if (!hasComplexLayoutMatrix)
		return null;
	if (_layoutFeatures != null)
	{
		return _layoutFeatures.layoutMatrix;            
	}
	else
	{
		return super.transform.matrix;
	}
}