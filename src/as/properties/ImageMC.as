﻿// *************
// ImageMC class
// *************
class as.properties.ImageMC extends MovieClip
{
	// private variables
	private var mc_ref:MovieClip;					// reference to the movie clip
	private var target_ref:MovieClip;			// reference to the target
	
	private var last_select_mc:MovieClip;
	
	// ***********
	// constructor
	// ***********
	public function ImageMC ()
	{
		mc_ref = this;
		
		setup_component_object ();
		setup_component_style ();
		setup_image_library ();
	}
	
	// **************
	// set target ref
	// **************
	public function set_target_ref (m:MovieClip):Void
	{
		target_ref = m;
		
		// position
		mc_ref.x_textinput.text = target_ref._x;
		mc_ref.y_textinput.text = target_ref._y;
		
		// dimension
		mc_ref.width_textinput.text = target_ref.clip_mc._width;
		mc_ref.height_textinput.text = target_ref.clip_mc._height;
		
		// rotation
		mc_ref.rotation_textinput.text = target_ref.clip_mc._rotation;
		
		// url
		mc_ref.url_textinput.text = target_ref.get_mc_url ();
		
		// clip
		mc_ref.preview_mc.set_size (150);
		mc_ref.preview_mc.set_clip (target_ref.get_mc_url (), 0);
	}
	
	// *******************
	// setup image library
	// *******************
	public function setup_image_library ():Void
	{
		mc_ref.library_scrollpane.contentPath = "lib_empty_mc";
		mc_ref.library_scrollpane.hScrollPolicy = "off";
		
		var img_dir_array:Array;
		
		var row_counter:Number;
		var column_counter:Number;
		
		var start_x:Number;
		var start_y:Number;
		var move_x:Number;
		var move_y:Number;
		
		var preview_size:Number;
		
		var temp_mc:MovieClip;
		
		row_counter = 0;
		column_counter = 0;
		
		img_dir_array = new Array ();
		img_dir_array = _root.flaber.get_img_dir_array ();
		
		start_x = 20;
		start_y = 20;
		move_x = 35;
		move_y = 45;
		
		preview_size = 75;
		
		temp_mc = mc_ref.library_scrollpane.content;
		
		for (var i = 0; i < img_dir_array.length; i++)
		{
			// attach preview mc
			var temp_name;
			
			temp_name = "preview_mc_" + i;
			temp_mc.attachMovie ("lib_image_preview_mc", temp_name, i);
			temp_mc [temp_name]._x = start_x + column_counter * preview_size + column_counter * move_x;
			temp_mc [temp_name]._y = start_y + row_counter * preview_size + row_counter * move_y;
			temp_mc [temp_name].set_size (preview_size);
			temp_mc [temp_name].set_clip ("img/" + img_dir_array [i], 0);
			
			// onpress action
			temp_mc [temp_name] ["class_ref"] = mc_ref;
			temp_mc [temp_name].onPress = function ()
			{
				// remove last filter
				if (this.class_ref.last_select_mc != null)
				{
					_root.mc_filters.remove_filter (this.class_ref.last_select_mc);
				}
				
				// add current filter
				_root.mc_filters.set_contrast_filter (this);
				this.class_ref.last_select_mc = this;
				
				// change the url and preview
				this.class_ref.url_textinput.text = this.get_clip_url ();
				this.class_ref.url_button.onRelease ();
			}
			
			// counter advance
			column_counter = column_counter + 1;
			
			if (column_counter >= 3)
			{
				column_counter = 0;
				row_counter = row_counter + 1;
			}
		}
		
		// scrollpane dummy adjustment... make sure the scroll is enough to view all
		temp_mc.attachMovie ("lib_square_mc", "dummy_mc", 9999);
		temp_mc.dummy_mc._x = 0;
		temp_mc.dummy_mc._y = start_y + (row_counter + 1) * preview_size + (row_counter + 1) * move_y;
	}
	
	// **********************
	// setup component object
	// **********************
	public function setup_component_object ():Void
	{
		mc_ref.createClassObject (mx.controls.TextInput, "x_textinput", 1, {_x:50, _y:40, _width:40, _height:20});
		mc_ref.createClassObject (mx.controls.TextInput, "y_textinput", 2, {_x:130, _y:40, _width:40, _height:20});
		mc_ref.createClassObject (mx.controls.TextInput, "width_textinput", 3, {_x:100, _y:100, _width:40, _height:20});
		mc_ref.createClassObject (mx.controls.TextInput, "height_textinput", 4, {_x:100, _y:125, _width:40, _height:20});
		mc_ref.createClassObject (mx.controls.TextInput, "rotation_textinput", 5, {_x:100, _y:150, _width:40, _height:20});
		mc_ref.createClassObject (mx.controls.TextInput, "url_textinput", 6, {_x:20, _y:210, _width:150, _height:20});
		mc_ref.createClassObject (mx.controls.Button, "url_button", 7, {_x:180, _y:210, _width:20, _height:20});
		mc_ref.createClassObject (mx.containers.ScrollPane, "library_scrollpane", 8, {_x:240, _y:40, _width:350, _height:380});
		mc_ref.attachMovie ("lib_image_preview_mc", "preview_mc", 9, {_x:20, _y:270});
		
		setup_url_button ();
		
		setup_apply_button ();
		setup_ok_button ();
		setup_cancel_button ();
		
		mc_ref.preview_mc.set_panel_ref (mc_ref);
	}
	
	// *********************
	// setup component style
	// *********************
	public function setup_component_style ():Void
	{
		mc_ref.position_label.setStyle ("styleName", "label_style");
		mc_ref.x_label.setStyle ("styleName", "label_style");
		mc_ref.y_label.setStyle ("styleName", "label_style");
		mc_ref.dimension_label.setStyle ("styleName", "label_style");
		mc_ref.width_label.setStyle ("styleName", "label_style");
		mc_ref.height_label.setStyle ("styleName", "label_style");
		mc_ref.rotation_label.setStyle ("styleName", "label_style");
		mc_ref.url_label.setStyle ("styleName", "label_style");
		mc_ref.preview_label.setStyle ("styleName", "label_style");
		mc_ref.image_library_label.setStyle ("styleName", "label_style");
		
		mc_ref.x_textinput.setStyle ("styleName", "textinput_style");
		mc_ref.y_textinput.setStyle ("styleName", "textinput_style");
		mc_ref.width_textinput.setStyle ("styleName", "textinput_style");
		mc_ref.height_textinput.setStyle ("styleName", "textinput_style");
		mc_ref.rotation_textinput.setStyle ("styleName", "textinput_style");
		mc_ref.url_textinput.setStyle ("styleName", "textinput_style");
	}
	
	// ***************
	// data validation
	// ***************
	public function data_validation ():Boolean
	{
		if (mc_ref.x_textinput.text == "")
		{
			mc_ref.x_textinput.text = "0";
		}
		
		if (mc_ref.y_textinput.text == "")
		{
			mc_ref.y_textinput.text = "0";
		}
		
		if (mc_ref.width_textinput.text == "")
		{
			mc_ref.width_textinput.text = "5";
		}
		
		if (mc_ref.height_textinput.text == "")
		{
			mc_ref.height_textinput.text = "5";
		}
		
		if (mc_ref.rotation_textinput.text == "")
		{
			mc_ref.rotation_textinput.text = "0";
		}
		
		return true;
	}
	
	// ****************
	// setup url button
	// ****************
	public function setup_url_button ():Void
	{
		mc_ref.url_button.icon = "lib_button_tick";
		
		mc_ref.url_button ["class_ref"] = mc_ref;
		
		mc_ref.url_button.onRelease = function ()
		{
			if (this.class_ref.url_textinput.text != "")
			{
				this.class_ref.preview_mc.set_clip (this.class_ref.url_textinput.text, 1);
			}
		}
	}
	
	// ******************
	// setup apply button
	// ******************
	public function setup_apply_button ():Void
	{
		mc_ref.apply_button ["class_ref"] = mc_ref;
		mc_ref.apply_button.onRelease = function ()
		{
			if (this.class_ref.data_validation () == true)
			{
				var item_xml:XML;
				var item_node:XMLNode;
				var temp_node:XMLNode;
				var temp_node_2:XMLNode;
				
				item_xml = new XML ();
				
				item_node = item_xml.createElement ("ImageMC");
				
				temp_node = item_xml.createElement ("x");
				temp_node_2 = item_xml.createTextNode (this.class_ref.x_textinput.text);
				temp_node.appendChild (temp_node_2);
				item_node.appendChild (temp_node);
				
				temp_node = item_xml.createElement ("y");
				temp_node_2 = item_xml.createTextNode (this.class_ref.y_textinput.text);
				temp_node.appendChild (temp_node_2);
				item_node.appendChild (temp_node);
				
				temp_node = item_xml.createElement ("width");
				temp_node_2 = item_xml.createTextNode (this.class_ref.width_textinput.text);
				temp_node.appendChild (temp_node_2);
				item_node.appendChild (temp_node);
				
				temp_node = item_xml.createElement ("height");
				temp_node_2 = item_xml.createTextNode (this.class_ref.height_textinput.text);
				temp_node.appendChild (temp_node_2);
				item_node.appendChild (temp_node);
				
				temp_node = item_xml.createElement ("rotation");
				temp_node_2 = item_xml.createTextNode (this.class_ref.rotation_textinput.text);
				temp_node.appendChild (temp_node_2);
				item_node.appendChild (temp_node);
				
				temp_node = item_xml.createElement ("url");
				temp_node_2 = item_xml.createTextNode (this.class_ref.url_textinput.text);
				temp_node.appendChild (temp_node_2);
				item_node.appendChild (temp_node);

				this.class_ref.target_ref.set_data_xml (item_node);
			}
		}
	}
	
	// ***************
	// setup ok button
	// ***************
	public function setup_ok_button ():Void
	{
		mc_ref.ok_button ["class_ref"] = mc_ref;
		mc_ref.ok_button.onRelease = function ()
		{
			this.class_ref.apply_button.onRelease ();
			this.class_ref._parent.close_window ();
		}
	}
	
	// *******************
	// setup cancel button
	// *******************
	public function setup_cancel_button ():Void
	{
		mc_ref.cancel_button ["class_ref"] = mc_ref;
		mc_ref.cancel_button.onRelease = function ()
		{
			this.class_ref._parent.close_window ();
		}
	}
}