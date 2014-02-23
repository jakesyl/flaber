﻿// ***************
// MenuBarMC class
// ***************
class as.menu.MenuBarMC extends MovieClip
{
	// private variables
	private var mc_ref:MovieClip;						// interface for the navigation item mc

	private var file_name:String;						// for tracer
	
	// ***********
	// constructor
	// ***********
	public function MenuBarMC ()
	{
		mc_ref = this;
		
		file_name = "(MenuBarMC.as)";
		
		build_menu ();
		hide_menu ();
	}
	
	// **********
	// build menu
	// **********
	public function build_menu ():Void
	{
		mc_ref.createClassObject (mx.controls.MenuBar, "menu_mc", 1, {_x:0, _y:0, _width:Stage.width, _height:20});
		
		var menu_xml:XML;
		
		menu_xml = new XML ();
		menu_xml.ignoreWhite = true;
		menu_xml ["class_ref"] = mc_ref;
		
		menu_xml.onLoad = function (s:Boolean)
		{
			if (s)
			{
				this.class_ref.menu_mc.dataProvider = this.firstChild;
				this.class_ref.setup_menu_action ();
			}
		}
		
		menu_xml.load ("MenuBar.xml");
	}
	
	// ***************
	// setup file menu
	// ***************
	public function setup_menu_action ():Void
	{
		// reference http://www.darronschall.com/weblog/archives/000062.cfm
		var temp_listener:Object;
		
		temp_listener = new Object ();
		temp_listener ["class_ref"] = mc_ref;
		temp_listener.change = function (o:Object)
		{
			switch (o.menuItem)
			{
				// *********
				// File Menu
				// *********
				
				// New Page
				case o.menu.file_new:
				{
					trace ("new file");
					break;
				}

				// Open Page
				case o.menu.file_open:
				{
					trace ("open file");
					break;
				}

				// Save Page
				case o.menu.file_save:
				{
					_root.save_broadcaster.set_changed_flag ();
					_root.save_broadcaster.broadcast ();
					break;
				}

				// Logout Admin
				case o.menu.file_logout:
				{
					//TODO should have some mechanism stating that the file is not saved
					this.class_ref.hide_menu ();
					
					// return to action mode if currently in edit mode
					this.class_ref.change_mode (0);
					
					break;
				}
				
				// ***********
				// Insert Menu
				// ***********
				
				// Textfield
				case o.menu.insert_textfield:
				{
					_root.page_mc.add_new_item ("TextFieldMC", null);
					break;
				}
				
				// Image
				case o.menu.insert_image:
				{
					_root.page_mc.add_new_item ("ImageMC", null);
					break;
				}
				
				// Link
				case o.menu.insert_link:
				{
					_root.page_mc.add_new_item ("LinkMC", null);
					break;
				}
				
				// Shape Rectangle
				case o.menu.insert_shape_rectangle:
				{
					_root.page_mc.add_new_item ("RectangleMC", null);
					break;
				}
				
				// *********
				// Mode Menu
				// *********
				
				// Action Mode
				case o.menu.mode_action:
				{
					this.class_ref.change_mode (0);
					break;
				}
				
				// Edit Mode
				case o.menu.mode_edit:
				{
					this.class_ref.change_mode (1);
					break;
				}
			}
		}
		
		mc_ref.menu_mc.addEventListener("change", temp_listener);
	}
	
	// *********
	// hide menu
	// *********
	public function hide_menu ():Void
	{
		mc_ref._visible = false;
		mc_ref.enabled = false;
	}
	
	// *********
	// show menu
	// *********
	public function show_menu ():Void
	{
		mc_ref._visible = true;
		mc_ref.enabled = true;
	}

	// ***********
	// change mode
	// ***********
	public function change_mode (b:Boolean):Void
	{
		switch (b)
		{
			// change to action mode
			case 0:
			{
				if (_root.sys_func.get_edit_mode () == true)
				{
					_root.sys_func.set_edit_mode (false);
					
					_root.mode_broadcaster.set_changed_flag ();
					_root.mode_broadcaster.broadcast (false);
					
					_root.edit_panel_mc.throw_away ();
					
					if (_root.window_mc)
					{
						_root.window_mc.close_window ();
					}
				}
				
				break;
			}
			
			// change to edit mode
			case 1:
			{
				if (_root.sys_func.get_edit_mode () == false)
				{
					_root.sys_func.set_edit_mode (true);
					
					_root.mode_broadcaster.set_changed_flag ();
					_root.mode_broadcaster.broadcast (true);
				}
				
				break;
			}
		}
	}
}
