﻿// *****************
// EditPanelMC class
// *****************
class as.global.EditPanelMC extends MovieClip
{
	// private variables
	private var mc_ref:MovieClip;						// interface for the edit panel mc
	private var target_ref:MovieClip;				// reference to the controlling mc
	
	// ***********
	// constructor
	// ***********
	public function EditPanelMC ()
	{
		mc_ref = this;
		
		setup_move_button ();
		setup_resize_button ();
		setup_rotate_button ();
		setup_properties_button ();
	}
	
	// **************
	// set target ref
	// **************
	public function set_target_ref (m:MovieClip):Void
	{
		target_ref = m;
	}

	// ************
	// set position
	// ************
	public function set_position (x:Number, y:Number):Void
	{
		// fix position if out bound
		if (x < 0)	{ x = 0; }
		if (y < 0)	{ y = 0; }
		if (x + mc_ref._width > Stage.width)		{ x = Stage.width - mc_ref._width; }
		if (y + mc_ref._height > Stage.height)		{ y = Stage.height - mc_ref._height; }
		
		x = x + 5;
		y = y - 5;
		
		mc_ref._x = x;
		mc_ref._y = y;
		
		// show the edit panel
		mc_ref._visible = true;
		mc_ref.enabled = false;
	}

	// ************
	// set function
	// ************
	public function set_function (m:Boolean, z:Boolean, r:Boolean, p:Boolean):Void
	{
		if (m == true)
		{
			mc_ref.move_button.enabled = true;
			mc_ref.move_button._alpha = 100;
		}
		else
		{
			mc_ref.move_button.enabled = false;
			mc_ref.move_button._alpha = 25;
		}
		
		if (z == true)
		{
			mc_ref.resize_button.enabled = true;
			mc_ref.resize_button._alpha = 100;
		}
		else
		{
			mc_ref.resize_button.enabled = false;
			mc_ref.resize_button._alpha = 25;
		}
		
		if (r == true)
		{
			mc_ref.rotate_button.enabled = true;
			mc_ref.rotate_button._alpha = 100;
		}
		else
		{
			mc_ref.rotate_button.enabled = false;
			mc_ref.rotate_button._alpha = 25;
		}
		
		if (p == true)
		{
			mc_ref.properties_button.enabled = true;
			mc_ref.properties_button._alpha = 100;
		}
		else
		{
			mc_ref.properties_button.enabled = false;
			mc_ref.properties_button._alpha = 25;
		}
	}

	// **********
	// throw away
	// **********
	public function throw_away ():Void
	{
		mc_ref._x = 0;
		mc_ref._y = -30;
		
		mc_ref._visible = false;
		mc_ref.enabled = false;
	}
	
	// *****************
	// setup move button
	// *****************
	public function setup_move_button ():Void
	{
		mc_ref.move_button ["class_ref"] = mc_ref;
		
		// onpress override
		mc_ref.move_button.onPress = function ()
		{
			this.class_ref.target_ref.startDrag ();
			
			this.class_ref.onMouseMove = function ()
			{
				target_ref.pull_edit_panel ();
			}
		}
		
		// onrelease override
		mc_ref.move_button.onRelease = function ()
		{
			this.class_ref.target_ref.stopDrag ();
			
			delete this.class_ref.onMouseMove;
		}
		
		// onreleaseoutside override
		mc_ref.move_button.onReleaseOutside = function ()
		{
			this.onRelease ();
		}
	}
	
	// *******************
	// setup resize button
	// *******************
	public function setup_resize_button ():Void
	{
		mc_ref.resize_button ["class_ref"] = mc_ref;
		
		// onpress override
		mc_ref.resize_button.onPress = function ()
		{
			this.class_ref.target_ref.resize_function (1);
			
			this.class_ref.onMouseMove = function ()
			{
				target_ref.pull_edit_panel ();
			}
		}
		
		// onrelease override
		mc_ref.resize_button.onRelease = function ()
		{
			this.class_ref.target_ref.resize_function (-1);
				
			delete this.class_ref.onMouseMove;
		}
		
		// onreleaseoutside override
		mc_ref.resize_button.onReleaseOutside = function ()
		{
			this.onRelease ();
		}
	}

	// *******************
	// setup rotate button
	// *******************
	public function setup_rotate_button ():Void
	{
		mc_ref.rotate_button ["class_ref"] = mc_ref;
		
		// onpress override
		mc_ref.rotate_button.onPress = function ()
		{
			this.class_ref.target_ref.rotate_function (1);
			
			this.class_ref.onMouseMove = function ()
			{
				target_ref.pull_edit_panel ();
			}
		}
		
		// onrelease override
		mc_ref.rotate_button.onRelease = function ()
		{
			this.class_ref.target_ref.rotate_function (-1);
				
			delete this.class_ref.onMouseMove;
		}
		
		// onreleaseoutside override
		mc_ref.rotate_button.onReleaseOutside = function ()
		{
			this.onRelease ();
		}
	}

	// ***********************
	// setup properties button
	// ***********************
	public function setup_properties_button ():Void
	{
		mc_ref.properties_button ["class_ref"] = mc_ref;
		
		// onrelease override
		mc_ref.properties_button.onRelease = function ()
		{
			this.class_ref.target_ref.properties_function ();
		}
	}
}