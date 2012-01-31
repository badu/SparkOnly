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

package
{

internal class SparkClasses
{

/**
 *  @private
 *  This class is used to link additional classes into spark.swc
 *  beyond those that are found by dependecy analysis starting
 *  from the classes specified in manifest.xml.
 *  For example, Button does not have a reference to ButtonSkin,
 *  but ButtonSkin needs to be in framework.swc along with Button.
 */

import mx.core.UIFTETextField; UIFTETextField;
import spark.core.ContentCache; ContentCache;
import spark.core.IDisplayText; IDisplayText;
import spark.core.IEditableText; IEditableText;
import spark.core.SpriteVisualElement; SpriteVisualElement;
import spark.collections.OnDemandDataProvider; OnDemandDataProvider;
import spark.components.IconPlacement; IconPlacement;
import spark.components.calendarClasses.DateSelectorDisplayMode; DateSelectorDisplayMode;
import spark.components.gridClasses.CellPosition; CellPosition;
import spark.components.gridClasses.CellRegion; CellRegion;
import spark.components.supportClasses.ListItemDragProxy; ListItemDragProxy;
import spark.components.supportClasses.InteractionStateDetector; InteractionStateDetector;
import spark.globalization.supportClasses.CalendarDate; CalendarDate;
import spark.globalization.supportClasses.DateTimeFormatterEx; DateTimeFormatterEx;
import spark.utils.TextFlowUtil; TextFlowUtil;
}

}
