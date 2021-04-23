dialog = dofile("./dialog.lua")

function init(plugin)
	print("Initialising Indexer")
	plugin:newCommand {
		id = "indexer",
		title = "Indexer",
		group = "sprite_properties",
		onclick = function()
			dialog("Indexer");
		end
	}
end

function exit(plugin)
	print("Deinitialising Indexer")
end
