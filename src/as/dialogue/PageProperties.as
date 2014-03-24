// ********************
// PageProperties class
// ********************
class as.dialogue.PageProperties extends MovieClip
{
	// private variables
	private var mc_ref:MovieClip;					// reference to the movie clip
	
	private var temp_loop:Number;
	private var temp_interval:Number;
	private var last_select_mc:MovieClip;
	
	// ***********
	// constructor
	// ***********
	public function PageProperties ()
	{
		mc_ref = this;
		
		setup_component_object ();
	}
	
	// ********************
	// add preview interval
	// ********************
	private function add_preview_interval (i:Array, sx:Number, sy:Number, mx:Number, my:Number, ps:Number):Void
	{
		var temp_mc:MovieClip;
		temp_mc = mc_ref.library_scrollpane.content;
		
		// attach preview mc
		var temp_name:String;
		var temp_col:Number;
		var temp_row:Number;
		
		temp_col = temp_loop % 3;
		temp_row = Math.floor (temp_loop / 3);
		
		temp_name = "preview_mc_" + temp_loop;
		temp_mc.attachMovie ("lib_image_preview_mc", temp_name, temp_loop);
		temp_mc [temp_name]._x = sx + temp_col * ps + temp_col * mx;
		temp_mc [temp_name]._y = sy + temp_row * ps + temp_row * my;
		temp_mc [temp_name].set_size (ps);
		temp_mc [temp_name].set_clip (i [temp_loop], 0);
		
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
		
		// redraw scrollpane when row increase
		if (temp_col == 0)
		{
			mc_ref.library_scrollpane.redraw (true);
		}
		
		// advance loop
		temp_loop = temp_loop + 1;
		
		// leave interval
		if (temp_loop >= i.length)
		{
			clearInterval (temp_interval);
		}		
	}
	
	// *******************
	// setup image library
	// *******************
	public function setup_image_library ():Void
	{
		mc_ref.library_scrollpane.contentPath = "lib_empty_mc";
		mc_ref.library_scrollpane.hScrollPolicy = "off";
		
		var img_dir_array:Array;
		img_dir_array = new Array ();
		img_dir_array = _root.flaber.get_img_dir_array ();
		
		temp_loop = 0;
		temp_interval = setInterval (mc_ref, "add_preview_interval", 200, img_dir_array, 20, 20, 35, 45, 75);
	}
	
	// **********************
	// setup component object
	// **********************
	public function setup_component_object ():Void
	{
		mc_ref.createClassObject (mx.controls.TextInput, "background_x_textinput", 1, {_x:40, _y:35, _width:40, _height:20});
		mc_ref.createClassObject (mx.controls.TextInput, "background_y_textinput", 2, {_x:120, _y:35, _width:40, _height:20});
		
		mc_ref.createClassObject (mx.controls.TextInput, "image_x_textinput", 3, {_x:40, _y:95, _width:40, _height:20});
		mc_ref.createClassObject (mx.controls.TextInput, "image_y_textinput", 4, {_x:120, _y:95, _width:40, _height:20});
		mc_ref.createClassObject (mx.controls.TextInput, "image_alpha_textinput", 5, {_x:220, _y:95, _width:40, _height:20});
		
		mc_ref.createClassObject (mx.controls.TextInput, "url_textinput", 6, {_x:20, _y:155, _width:190, _height:20});
		mc_ref.attachMovie ("lib_button_mc", "url_button", 7, {_x:220, _y:155});
		mc_ref.createClassObject (mx.containers.ScrollPane, "library_scrollpane", 8, {_x:310, _y:40, _width:350, _height:380});
		mc_ref.attachMovie ("lib_image_preview_mc", "preview_mc", 9, {_x:50, _y:220});
		
		mc_ref.attachMovie ("lib_normal_palette", "background_color_palette", 10, {_x:220, _y:35});

		mc_ref.attachMovie ("lib_button_mc", "apply_button", 11, {_x:400, _y:440});
		mc_ref.attachMovie ("lib_button_mc", "ok_button", 12, {_x:490, _y:440});
		mc_ref.attachMovie ("lib_button_mc", "cancel_button", 13, {_x:580, _y:440});
		
		setup_component_style ();
		setup_image_library ();
		
		setup_current_data ();
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
		mc_ref.background_label.setStyle ("styleName", "label_style");
		mc_ref.background_x_label.setStyle ("styleName", "label_style");
		mc_ref.background_y_label.setStyle ("styleName", "label_style");
		mc_ref.background_color_label.setStyle ("styleName", "label_style");
		mc_ref.image_label.setStyle ("styleName", "label_style");
		mc_ref.image_x_label.setStyle ("styleName", "label_style");
		mc_ref.image_y_label.setStyle ("styleName", "label_style");
		mc_ref.image_alpha_label.setStyle ("styleName", "label_style");
		mc_ref.url_label.setStyle ("styleName", "label_style");
		mc_ref.preview_label.setStyle ("styleName", "label_style");
		mc_ref.image_library_label.setStyle ("styleName", "label_style");
		
		mc_ref.background_x_textinput.setStyle ("styleName", "textinput_style");
		mc_ref.background_y_textinput.setStyle ("styleName", "textinput_style");
		mc_ref.image_x_textinput.setStyle ("styleName", "textinput_style");
		mc_ref.image_y_textinput.setStyle ("styleName", "textinput_style");
		mc_ref.image_alpha_textinput.setStyle ("styleName", "textinput_style");
		mc_ref.url_textinput.setStyle ("styleName", "textinput_style");
	}
	
	// ******************
	// setup current data
	// ******************
	public function setup_current_data ():Void
	{
		mc_ref.background_x_textinput.text = _root.page_mc._x;
		mc_ref.background_y_textinput.text = _root.page_mc._y;
		
		if (_root.page_mc.bg_color != null)
		{
			var temp_obj:Object = new Object ();
		
			temp_obj = _root.page_mc.bg_color.get_frame_param ();
			mc_ref.background_color_palette.set_color_num (temp_obj ["fc"]);
		}

		if (_root.page_mc.bg_image != null)
		{
			mc_ref.image_x_textinput.text = _root.page_mc.bg_image._x;
			mc_ref.image_y_textinput.text = _root.page_mc.bg_image._y;
			mc_ref.image_alpha_textinput.text = _root.page_mc.bg_image._alpha;
			mc_ref.url_textinput.text = _root.page_mc.bg_image.get_clip_mc_url ();
			mc_ref.preview_mc.set_clip (mc_ref.url_textinput.text, 0);
		}
		
		mc_ref.preview_mc.set_size (180);
	}
	
	// ***************
	// data validation
	// ***************
	public function data_validation ():Boolean
	{
		if (mc_ref.background_x_textinput.text == "")
		{
			mc_ref.background_x_textinput.text = "0";
		}
		
		if (mc_ref.background_y_textinput.text == "")
		{
			mc_ref.background_y_textinput.text = "0";
		}
		
		if (mc_ref.image_x_textinput.text == "")
		{
			mc_ref.image_x_textinput.text = "5";
		}
		
		if (mc_ref.image_y_textinput.text == "")
		{
			mc_ref.image_y_textinput.text = "5";
		}
		
		if (mc_ref.image_alpha_textinput.text == "")
		{
			mc_ref.image_alpha_textinput.text = "100";
		}
		
		return true;
	}
	
	// ****************
	// setup url button
	// ****************
	public function setup_url_button ():Void
	{
		mc_ref.url_button.set_toggle_flag (false);
		mc_ref.url_button.set_dimension (20, 20);
		mc_ref.url_button.set_clip_mc ("lib_button_tick");
		mc_ref.url_button.set_tooltip ("Accept");
		
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
		mc_ref.apply_button.set_toggle_flag (false);
		mc_ref.apply_button.set_dimension (80, 20);
		mc_ref.apply_button.set_text ("Apply");

		mc_ref.apply_button ["class_ref"] = mc_ref;
		mc_ref.apply_button.onRelease = function ()
		{
			if (this.class_ref.data_validation () == true)
			{
				var item_xml:XML;
				var item_node:XMLNode;
				var temp_node:XMLNode;
				var temp_node_2:XMLNode;
				var temp_node_3:XMLNode;
				
				item_xml = new XML ();
				
				item_node = item_xml.createElement ("config");
				
				temp_node = item_xml.createElement ("x");
				temp_node_2 = item_xml.createTextNode (this.class_ref.background_x_textinput.text);
				temp_node.appendChild (temp_node_2);
				item_node.appendChild (temp_node);
				
				temp_node = item_xml.createElement ("y");
				temp_node_2 = item_xml.createTextNode (this.class_ref.background_y_textinput.text);
				temp_node.appendChild (temp_node_2);
				item_node.appendChild (temp_node);
				
				// background color
				if (this.class_ref.background_color_palette.get_color_num () != null)
				{
					temp_node = item_xml.createElement ("bg_color");
					temp_node_2 = item_xml.createTextNode (this.class_ref.background_color_palette.get_color_string ());
					temp_node.appendChild (temp_node_2);
					item_node.appendChild (temp_node);
				}
				
				// background image
				if (this.class_ref.url_textinput.text != "")
				{
					temp_node = item_xml.createElement ("bg_image");
					
					temp_node_2 = item_xml.createElement ("x");
					temp_node_3 = item_xml.createTextNode (this.class_ref.image_x_textinput.text);
					temp_node_2.appendChild (temp_node_3);
					temp_node.appendChild (temp_node_2);
					
					temp_node_2 = item_xml.createElement ("y");
					temp_node_3 = item_xml.createTextNode (this.class_ref.image_y_textinput.text);
					temp_node_2.appendChild (temp_node_3);
					temp_node.appendChild (temp_node_2);
					
					temp_node_2 = item_xml.createElement ("url");
					temp_node_3 = item_xml.createTextNode (this.class_ref.url_textinput.text);
					temp_node_2.appendChild (temp_node_3);
					temp_node.appendChild (temp_node_2);
					
					temp_node_2 = item_xml.createElement ("alpha");
					temp_node_3 = item_xml.createTextNode (this.class_ref.image_alpha_textinput.text);
					temp_node_2.appendChild (temp_node_3);
					temp_node.appendChild (temp_node_2);
					
					item_node.appendChild (temp_node);
				}
				
				_root.page_mc.set_config_xml (item_node);
			}
		}
	}
	
	// ***************
	// setup ok button
	// ***************
	public function setup_ok_button ():Void
	{
		mc_ref.ok_button.set_toggle_flag (false);
		mc_ref.ok_button.set_dimension (80, 20);
		mc_ref.ok_button.set_text ("Ok");

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
		mc_ref.cancel_button.set_toggle_flag (false);
		mc_ref.cancel_button.set_dimension (80, 20);
		mc_ref.cancel_button.set_text ("Cancel");

		mc_ref.cancel_button ["class_ref"] = mc_ref;
		mc_ref.cancel_button.onRelease = function ()
		{
			this.class_ref._parent.close_window ();
		}
	}
}
