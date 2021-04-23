indexer = dofile("./indexer.lua")

local defaultPaletteSize = 4
local maxPaletteSize = 8

function getPalette()
	local palette = app.activeSprite.palettes[1]
	-- Return a default palette if too many colours.
	if #palette > maxPaletteSize then
		return Palette(defaultPaletteSize)
	end
	return palette
end

function updatePalette(count, data)
	local palette = Palette(count)
	for i = 1, count do
		palette:setColor(i - 1, data["color" .. i])
	end
	return palette
end

function updateValues(count, data)
	local values = {}
	for i = 1, count do
		values[i] = data["value" .. i]
	end
	return values
end

function getValue(index, count)
	return (256 / count) * (index)
end

function getValues(count)
	values = {}
	for i = 1, count do
		values[i] = getValue(i, count)
	end
	return values
end

return function(dialogTitle)
	-- Check if UI is available.
	if not app.isUIAvailable then
		print("UI is not available!")
		return
	end
	-- Check is a sprite is active.
	if app.activeSprite == nil then
		app.alert {
			title = "Indexer",
			text = "No sprite active!",
			buttons = "OK"
		}
		return
	end
	-- Create dialog.
	local palette = getPalette()
	local values = getValues(#palette)
	local dialog = Dialog(dialogTitle)
	-- Create colour settings.
	for i = 1, #palette do
		dialog
		:separator {
			text = tostring(i)
		}
		:color {
			id = "color" .. i,
			label = "Color:",
			color = palette:getColor(i - 1)
		}
		:slider {
			id = "value" .. i,
			label = "Value:",
			min = 0,
			max = 255,
			value = values[i],
			onclick = "hey"
		}
	end
	-- Create buttons.
	dialog
	:button {
		text = "Index",
		onclick = function()
			palette = updatePalette(#palette, dialog.data)
			values = updateValues(#palette, dialog.data)
			indexer(palette, values)
		end
	}
	:show {
		wait = false
	}
	return dialog
end
