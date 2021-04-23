indexer = dofile("./indexer.lua")

local defaultPaletteSize = 4
local maxPaletteSize = 24

-- Dialog helper functions.
function getValue(index, count)
	return (256 / count) * index - 1
end

function getColors()
	local colors = {}
	local palette = app.activeSprite.palettes[1]
	-- Return a default palette if too many colours.
	if #palette > maxPaletteSize then
		for i = 1, defaultPaletteSize do
			local value = getValue(i, defaultPaletteSize)
			local color = Color{ r = value, g = value, b = value, a = 255 }
			colors[i] = color
		end
		return colors
	end
	-- Otherwise return colors from the palette.
	for i = 1, #palette do
		colors[i] = palette:getColor(i - 1)
	end
	return colors
end

function updateValues(count, data)
	local values = {}
	for i = 1, count do
		values[i] = data["value" .. i]
	end
	return values
end

function getValues(count)
	values = {}
	for i = 1, count do
		values[i] = getValue(i, count)
	end
	return values
end

function getColorIndex(color, colors)
	for i = 1, #colors do
		if color == colors[i] then return i end
	end
	return nil
end

-- Mouse click functions.
function editColor(color, colors, values)
	local index = getColorIndex(color, colors)
	local editDialog = Dialog("Edit Color")
	:color {
		id = "color",
		label = "Color:",
		color = color
	}
	:slider {
		id = "value",
		label = "Value:",
		min = 0,
		max = 255,
		value = values[index]
	}
	:button {
		id = "ok",
		text = "OK",
	}
	:button {
		id = "cancel",
		text = "Cancel"
	}
	:button {
		id = "remove",
		text = "Remove"
	}
	:show()
	if editDialog.data.ok then
		colors[index] = editDialog.data.color
		values[index] = editDialog.data.value
	elseif editDialog.data.remove then
		colors, values = removeColor(color, colors, values)
	end
	return colors, values
end

function addColor(color, colors, values)
	local index = getColorIndex(color, colors)
	-- Shift colors forwards.
	for i = #colors, index, -1 do
		colors[i + 1] = colors[i]
		values[i + 1] = values[i]
	end
	return colors, values
end

function removeColor(color, colors, values)
	local index = getColorIndex(color, colors)
	-- Shift colors back.
	for i = index, #colors - 1 do
		colors[i] = colors[i + 1]
		values[i] = values[i + 1]
	end
	colors[#colors] = nil
	values[#values] = nil
	return colors, values
end

-- Dialog function.
function createDialog(colors, values, xPos, yPos)
	-- Check if UI is available.
	if not app.isUIAvailable then
		print("UI is not available!")
		return
	end
	-- Check is a sprite is active.
	if app.activeSprite == nil then
		app.alert {
			title = "Indexer",
			text = "No sprite active!"
		}
		return
	end
	-- Update values.
	if colors == nil then
		colors = getColors()
	end
	if values == nil then
		values = getValues(#colors)
	end
	-- Create dialog.
	local dialog = Dialog("Indexer")
	dialog
	:shades {
		id = "shades",
		mode = "pick",
		colors = colors,
		onclick = function(ev)
			values = updateValues(#values, dialog.data)
			local c, v = nil
			if ev.button == MouseButton.LEFT then
				c, v = editColor(ev.color, colors, values)
			elseif ev.button == MouseButton.RIGHT then
				c, v = addColor(ev.color, colors, values)
			elseif ev.button == MouseButton.MIDDLE then
				c, v = removeColor(ev.color, colors, values)
			end
			local b = dialog.bounds
			dialog:close()
			createDialog(c, v, b.x, b.y)
		end
	}
	for i = 1, #colors do
		dialog
		:number {
			id = "value" .. i,
			text = tostring(values[i]),
			decimans = 0
		}
	end
	dialog
	:button {
		text = "Index",
		onclick = function()
			values = updateValues(#values, dialog.data)
			indexer(colors, values)
		end
	}
	:button {
		text = "Undo",
		onclick = app.undo
	}
	:button {
		text = "Redo",
		onclick = app.redo
	}
	:show {
		wait = false
	}
	if xPos and yPos then
		local bounds = dialog.bounds
		dialog.bounds = Rectangle(xPos, yPos, bounds.width, bounds.height)
	end
	return dialog
end

return function(colors, values)
	return createDialog(colors, values)
end
