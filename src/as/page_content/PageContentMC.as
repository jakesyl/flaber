// *****************
// PageContent class
// *****************
class as.page_content.PageContentMC extends MovieClip
{
	// MC variables
	// MovieClip		bg_mc;
	
	// private variables
	private var content_mc_array:Array;							// array storing all the content items
	
	private var mc_ref:MovieClip;								// reference back to the page content mc
	
	private var FILE_NAME:String = "(PageContentMC.as)";		// for tracer
	private var loaded_file:String;								// loaded file name

	private var max_depth:Number;								// the maximum depth of the page content items

	// ***********
	// constructor
	// ***********
	public function PageContentMC ()
	{
		mc_ref = this; 
		
		content_mc_array = new Array ();
		max_depth = 0;
		
		// it is funny that not preloading all these with make the very first transition failed...
		// takes me 3 days to find out this bug.... sigh....
		mc_ref.attachMovie ("lib_frame_mc", "bg_color", -2);
		mc_ref.attachMovie ("lib_clip_loader_mc", "bg_image", -1);
		mc_ref.bg_color.draw_rect (-1, -1, Stage.width + 2, Stage.height + 2, 1, 0x666666, 100, 0xFFFFFF, 100);
		
		// remove any element handler if bg is clicked...
		mc_ref.bg_color.useHandCursor = false;
		mc_ref.bg_color.onPress = function ()
		{
			_root.handler_mc.throw_away ();
		}	
		
		mc_ref.bg_image.useHandCursor = false;
		mc_ref.bg_image.onPress = function ()
		{
			_root.handler_mc.throw_away ();
		}	
	}
	
	// **********
	// destructor
	// **********
	public function destroy ():Void
	{
		for (var i in content_mc_array)
		{
			_root.mode_broadcaster.remove_observer (content_mc_array [i]);
			content_mc_array [i].removeMovieClip ();
		}
		
		content_mc_array = new Array ();
		max_depth = 0;
	}
	
	// *********************
	// delete one content mc
	// *********************
	public function destroy_one (m:MovieClip):Void
	{
		for (var i in content_mc_array)
		{
			if (content_mc_array [i] == m)
			{
				_root.mode_broadcaster.remove_observer (content_mc_array [i]);
				content_mc_array [i].removeMovieClip ();
				content_mc_array.splice (i, 1);
				
				break;
			}
		}
	}
	
	// *************
	// load root_xml
	// *************
	public function load_root_xml (s:String):Void
	{
		loaded_file = s;
		
		// destroying old contents
		destroy ();
		
		// xml data loading
		var root_xml:as.datatype.XMLExtend;
		root_xml = new as.datatype.XMLExtend ();
		root_xml ["class_ref"] = mc_ref;
		root_xml.ignoreWhite = true;
		root_xml.sendAndLoad (s + _root.sys_func.get_break_cache (), root_xml, "POST");
		root_xml.check_progress ("Loading " + s + "...");
		
		root_xml.onLoad = function (b:Boolean)
		{
			// when xml loading is success
			if (b)
			{
				this.class_ref.set_root_xml (this);
			}
			else
			{
				this.stop_progress ();
				_root.status_mc.add_message (this.class_ref.FILE_NAME + " constructor load xml fail.", "critical");
			}
		}
	}
	
	// ************
	// set root_xml
	// ************
	public function set_root_xml (x:XML):Void
	{
		// try to find out the config node and data node
		for (var i in x.firstChild.childNodes)
		{
			var temp_node:XMLNode;
			var temp_name:String;
			
			temp_node = x.firstChild.childNodes [i];
			temp_name = temp_node.nodeName;
			
			switch (temp_name)
			{
				// config node
				case "config":
				{
					set_config_xml (temp_node);
					break;
				}
				// data node
				case "data":
				{
					set_data_xml (temp_node);
					break;
				}
				// exception
				default:
				{
					_root.status_mc.add_message (FILE_NAME + " node skipped with node name '" + temp_name + "'", "critical");
				}
			}
		}		
	}
	
	// **************
	// set config_xml
	// **************
	public function set_config_xml (x:XMLNode):Void
	{
		// ensure they are removed first
		if (mc_ref.bg_color != null)
		{
			mc_ref.bg_color.clear_frame ();
		}

		if (mc_ref.bg_image != null)
		{
			mc_ref.bg_image.unload_clip ();
		}

		// try to parse the config node
		for (var i in x.childNodes)
		{
			var temp_node:XMLNode;
			var temp_name:String;
			var temp_value:String;
			
			temp_node = x.childNodes [i];
			temp_name = temp_node.nodeName;
			
			// since bg_image have additional nodes
			if (temp_name != "bg_image")
			{
				temp_value = temp_node.firstChild.nodeValue;			
			}
			
			switch (temp_name)
			{
				// x position of the page content
				case "x":
				{
					mc_ref._x = parseInt (temp_value);
					break;
				}
				// y position of the page content
				case "y":
				{
					mc_ref._y = parseInt (temp_value);
					break;
				}
				// background color of the page content
				case "bg_color":
				{
					mc_ref.bg_color.clear_frame ();
					mc_ref.bg_color.draw_rect (-1, -1, Stage.width + 2, Stage.height + 2, 1, 0x666666, 100, parseInt (temp_value), 100);
					break;
				}
				// background image of the page content
				case "bg_image":
				{
					// since background image still have many nodes, so need to iterate again
					for (var j in temp_node.childNodes)
					{
						var temp_name_2:String;
						var temp_value_2:String;
						
						temp_name_2 = temp_node.childNodes [j].nodeName;
						temp_value_2 = temp_node.childNodes [j].firstChild.nodeValue;
						
						switch (temp_name_2)
						{
							// x position of the bg image
							case "x":
							{
								mc_ref.bg_image._x = parseInt (temp_value_2);
								break;
							}
							// y position of the bg image
							case "y":
							{
								mc_ref.bg_image._y = parseInt (temp_value_2);
								break;
							}
							// path of the bg image
							case "url":
							{
								mc_ref.bg_image.set_clip_mc (temp_value_2);
								break;
							}
							// alpha of the bg image
							case "alpha":
							{
								mc_ref.bg_image._alpha = parseInt (temp_value_2);
								break;
							}
							// exception
							default:
							{
								_root.status_mc.add_message (FILE_NAME + " node skipped with node name '" + temp_name_2 + "'", "critical");
							}
						}
					}
					break;
				}
				// exception
				default:
				{
					_root.status_mc.add_message (FILE_NAME + " node skipped with node name '" + temp_name_2 + "'", "critical");
				}
			}
		}
	}
	
	// ************
	// add new item
	// ************
	public function add_new_item (s:String, x:XMLNode):Void
	{
		var lib_name:String;
		var temp_name:String;
		
		switch (s)
		{
			// TextField
			case "TextFieldMC":
			{
				lib_name = "lib_page_content_textfield";
				temp_name = "text_field_";
				break;
			}
			// Image
			case "ImageMC":
			{
				lib_name = "lib_page_content_image";
				temp_name = "image_";
				break;
			}
			// Link
			case "LinkMC":
			{
				lib_name = "lib_page_content_link";
				temp_name = "link_";
				break;
			}
			// Rectangle Shape
			case "RectangleMC":
			{
				lib_name = "lib_shape_rectangle";
				temp_name = "rectangle_";
				break;
			}
			// Oval Shape
			case "OvalMC":
			{
				lib_name = "lib_shape_oval";
				temp_name = "oval_";
				break;
			}
			// exception
			default:
			{
				_root.status_mc.add_message (FILE_NAME + " item skipped with item name '" + s + "'", "critical");
			}
		}
		
		var temp_id:Number;
		var temp_mc:MovieClip;
		
		if (x != null)
		{
			// if it is added by loading data, then must have depth data
			temp_id = parseInt (x.attributes.depth);
			max_depth = Math.max (max_depth, temp_id);
			temp_mc = mc_ref.attachMovie (lib_name, temp_name + temp_id, temp_id, {_x: 100, _y:100});
			
			// if it is added by loading data, then set the xml data
			temp_mc.broadcaster_event (_root.menu_mc.get_edit_mode ());
			temp_mc.set_data_xml (x);

			content_mc_array.push (temp_mc);
		}
		else	
		{
			// else it means this is brand new item
			temp_id = max_depth + 1;
			max_depth = max_depth + 1;
			temp_mc = mc_ref.attachMovie (lib_name, temp_name + temp_id, temp_id, {_x: 100, _y:100});
			
			// else try to open the properties window, because this is brand new item
			temp_mc.broadcaster_event (_root.menu_mc.get_edit_mode ());
			temp_mc.properties_function ();
			
			content_mc_array.push (temp_mc);
		}
		
		_root.mode_broadcaster.add_observer (temp_mc);
	}
	
	// ***************
	// rearrange depth
	// ***************
	public function rearrange_depth ():Void
	{
		// negative or zero depth fixer
		if (content_mc_array [0].getDepth () <= 0)
		{
			var temp_fixer:Number = 0;
			temp_fixer = Math.abs (content_mc_array [0].getDepth ()) + 1;
			
			for (var i in content_mc_array)
			{
				content_mc_array [i].swapDepths (content_mc_array [i].getDepth () + temp_fixer);
			}
		}
	
		// the first depth must be 1.... because 0 depth thing will crash page transition
		var j:Number = 1;
		var l:Number = content_mc_array.length;
		
		for (var i = 0; i < l; i++)
		{
			if (content_mc_array [i] != undefined)
			{
				// if spaces presents, rearrange to remove the spaces
				if (content_mc_array [i].getDepth () != j)
				{
					content_mc_array [i].swapDepths (j);
				}
				
				j = j + 1;
			}
		}

		// update back the maximum depth
		max_depth = j - 1;
		
		// splice the array
		content_mc_array.splice (max_depth + 1, 9999);
	}
	
	// ************
	// change depth
	// ************
	public function change_depth (i:Number, n:Number):Void
	{
		var temp_num:Number = Number (i) + Number (n);
		var temp_mc:MovieClip;
		
		content_mc_array [i].swapDepths (content_mc_array [temp_num]);
		
		temp_mc = content_mc_array [i];
		content_mc_array [i] = content_mc_array [temp_num];
		content_mc_array [temp_num] = temp_mc;
	}
	
	// ************
	// set data_xml
	// ************
	public function set_data_xml (x:XMLNode):Void
	{
		// try to find out the page content mc nodes
		for (var i in x.childNodes)
		{
			var temp_node:XMLNode;
			
			temp_node = x.childNodes [i];
			
			var lib_name:String;
			var temp_name:String;
			
			add_new_item (temp_node.nodeName, temp_node);
		}
	}

	// ********
	// save_xml
	// ********
	public function save_xml ():Void
	{
		var out_xml:XML;
		var out_string:String;
		var return_xml:as.datatype.XMLExtend;
		
		var root_node:XMLNode;
		var config_node:XMLNode;
		var data_node:XMLNode;
		
		var temp_node:XMLNode;
		var temp_node_2:XMLNode;
		var temp_node_3:XMLNode;
		
		out_string = "<?xml version='1.0'?>";
		
		out_xml = new XML ();
		
		// building root node
		root_node = out_xml.createElement ("PageContent");
		root_node.attributes ["xmlns"] = "http://www.w3schools.com";
		root_node.attributes ["xmlns:xsi"] ="http://www.w3.org/2001/XMLSchema-instance";
		out_xml.appendChild (root_node);
		
		// building config node
		config_node = out_xml.createElement ("config");
			
			// x of page content
			temp_node = out_xml.createElement ("x");
			temp_node_2 = out_xml.createTextNode (mc_ref._x.toString ());
			temp_node.appendChild (temp_node_2);
			config_node.appendChild (temp_node);
			
			// y of page content
			temp_node = out_xml.createElement ("y");
			temp_node_2 = out_xml.createTextNode (mc_ref._y.toString ());
			temp_node.appendChild (temp_node_2);
			config_node.appendChild (temp_node);
			
			// bg color of page content
			if (mc_ref.bg_color != null)
			{
				var temp_obj:Object = new Object ();
				
				temp_obj = mc_ref.bg_color.get_frame_param ();
				
				temp_node = out_xml.createElement ("bg_color");
				temp_node_2 = out_xml.createTextNode ("0x" + temp_obj ["fc"].toString (16));
				temp_node.appendChild (temp_node_2);
				config_node.appendChild (temp_node);
			}
			
			// bg image of page content
			if (mc_ref.bg_image != null)
			{
				temp_node = out_xml.createElement ("bg_image");
				
				temp_node_2 = out_xml.createElement ("x");
				temp_node_3 = out_xml.createTextNode (mc_ref.bg_image._x);
				temp_node_2.appendChild (temp_node_3);
				temp_node.appendChild (temp_node_2);
				
				temp_node_2 = out_xml.createElement ("y");
				temp_node_3 = out_xml.createTextNode (mc_ref.bg_image._y);
				temp_node_2.appendChild (temp_node_3);
				temp_node.appendChild (temp_node_2);
				
				temp_node_2 = out_xml.createElement ("url");
				temp_node_3 = out_xml.createTextNode (mc_ref.bg_image.get_clip_mc_url ());
				temp_node_2.appendChild (temp_node_3);
				temp_node.appendChild (temp_node_2);
				
				temp_node_2 = out_xml.createElement ("alpha");
				temp_node_3 = out_xml.createTextNode (mc_ref.bg_image._alpha);
				temp_node_2.appendChild (temp_node_3);
				temp_node.appendChild (temp_node_2);
				
				config_node.appendChild (temp_node);
			}
			
		root_node.appendChild (config_node);
		
		// building data node
		data_node = out_xml.createElement ("data");
			
			// calling each navigation item instance to return their xml
			for (var i in content_mc_array)
			{
				if (content_mc_array [i] != undefined && content_mc_array [i] != null)
				{
					temp_node = content_mc_array [i].export_xml ();
					data_node.appendChild (temp_node);
				}
			}
			
		root_node.appendChild (data_node);
		
		return_xml = new as.datatype.XMLExtend ();
		return_xml.onLoad = function (b: Boolean)
		{
			if (b)
			{
				this.stop_progress ();
				_root.status_mc.add_message (return_xml.toString (), "");
				
				// update the page dir array to ensure up to date
				_root.flaber.load_page_dir_array ();
			}
		}
		
		// append those string contents to the xml and rebuild it
		out_string = out_string + out_xml.toString ();
		out_xml = new XML (out_string);
		out_xml.contentType = "text/xml";
		
		out_xml.sendAndLoad ("function/update_xml.php?target_file=" + loaded_file, return_xml);
		return_xml.check_progress ("Saving page content...");
	}

	// ***************
	// get loaded file
	// ***************
	public function get_loaded_file ():String
	{
		return (loaded_file);
	}

	// ***************
	// set loaded file
	// ***************
	public function set_loaded_file (s:String):Void
	{
		loaded_file = s;
	}
	
	// ********************
	// get content mc array
	// ********************
	public function get_content_mc_array ():Array
	{
	trace (this + " " + content_mc_array);
		return (content_mc_array);
	}
}
