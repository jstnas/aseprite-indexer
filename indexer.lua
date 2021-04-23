local pc = app.pixelColor

function get_color(value, colors, values)
	for i = 1, #colors do
		if value < values[i] then
			return colors[i]
		end
	end
	return colors[#colors]
end

return function(colors, values)
	local image = app.activeImage
	local width = image.width
	local height = image.height
	local new_image = Image(image)
	for it in new_image:pixels() do
		local pixelValue = it()
		local r = pc.rgbaR(pixelValue)
		local g = pc.rgbaG(pixelValue)
		local b = pc.rgbaB(pixelValue)
		local value = (r + g + b) / 3
		local new_color = get_color(value, colors, values).rgbaPixel
		it(new_color)
	end
	image:drawImage(new_image)
	app.refresh()
end
