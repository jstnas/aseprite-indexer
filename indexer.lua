local pc = app.pixelColor

function getColor(value, colors, values)
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
	local newImage = Image(image)
	for it in newImage:pixels() do
		local pixelValue = it()
		local r = pc.rgbaR(pixelValue)
		local g = pc.rgbaG(pixelValue)
		local b = pc.rgbaB(pixelValue)
		local value = (r + g + b) / 3
		local newColor = getColor(value, colors, values).rgbaPixel
		it(newColor)
	end
	image:drawImage(newImage)
	app.refresh()
end
