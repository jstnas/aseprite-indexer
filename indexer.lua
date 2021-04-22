local black = Color{ r=0, g=0, b=0, a=255 }
local prefs = nil
local dlg = nil

-- Plugin setup.
function init(plugin)
	print("Initialising Indexer")
	if not app.isUIAvailable then
		print("Ui not available")
		return
	end
	prefs = plugin.preferences
	-- Init prefs.
	if prefs.color_count == nil then
		init_prefs()
	end
	-- Create dialog.
	plugin:newCommand {
		id = "indexer",
		title = "Indexer",
		group = "sprite_properties",
		onclick = init_dlg
	}
end

function exit(plugin)
	print("Deinitialising Indexer")
	save_prefs()
end

-- Functions.
function get_prefix(index)
	return "color_" .. index .. "_"
end

function init_prefs()
	print("Initialising Indexer prefs")
	prefs.color_count = 1
	save_color(black, 1)
end

function init_dlg()
	-- Error if sprite not active.
	if app.activeSprite == nil then
		app.alert {
			title = "Indexer",
			text = "No sprite active!",
			buttons = "OK"
		}
		return
	end
	dlg = Dialog("Indexer")
	dlg
	:button {
		text = "+",
		onclick = add_color
	}
	:button {
		text = "-",
		onclick = remove_color
	}
	for i = 1, prefs.color_count do
		dlg
		:separator {
			label = "hey"
		}
		:color {
			id = "color_" .. i,
			label = "Color:",
			color = get_color(i)
		}
		:slider {
			label = "Value:",
			min = 0,
			max = 255,
			value = 128,
			onclick = function()
				print("hey")
			end
		}
	end
	dlg
	:show {
		wait = false
	}
	-- Update bounds.
	if prefs.bounds_x == nil then
		save_bounds()
	else
		dlg.bounds = get_bounds()
	end
end

function save_prefs()
	local data = dlg.data
	-- Save colours.
	for i = 1, prefs.color_count do
		save_color(data["color_" .. i], i)
	end
	-- Save bounds.
	save_bounds()
end

function get_bounds()
	return Rectangle {
		x = prefs.bounds_x,
		y = prefs.bounds_y,
		width = prefs.bounds_width,
		height = prefs.bounds_height
	}
end

function save_bounds()
	local bounds = dlg.bounds
	prefs.bounds_x = bounds.x
	prefs.bounds_y = bounds.x
	prefs.bounds_width = bounds.width
	prefs.bounds_height = bounds.height
end

function add_color()
	save_prefs()
	prefs.color_count = prefs.color_count + 1
	save_color(black, prefs.color_count)
	dlg:close()
	init_dlg()
end

function remove_color()
	save_prefs()
	prefs.color_count = prefs.color_count - 1
	dlg:close()
	init_dlg()
end

function get_color(index)
	local prefix = get_prefix(index)
	return Color {
		r=prefs[prefix .. "r"],
		g=prefs[prefix .. "g"],
		b=prefs[prefix .. "b"],
		a = 255
	}
end

function save_color(color, index)
	local prefix = get_prefix(index)
	prefs[prefix .. "r"] = color.red
	prefs[prefix .. "g"] = color.green
	prefs[prefix .. "b"] = color.blue
end

function clear_color(index)
	local prefix = get_prefix(index)
	prefs[prefix .. "r"] = nil
	prefs[prefix .. "g"] = nil
	prefs[prefix .. "b"] = nil
end
