SRC = ./package.json ./main.lua ./dialog.lua ./indexer.lua
ARCHIVE = indexer.aseprite-extension
SCRIPT_DIR = ~/.config/aseprite/scripts
PLUGIN_DIR = ~/.config/aseprite/extensions

plugin: clean
	zip $(ARCHIVE) $(SRC)

clean:
	rm $(ARCHIVE)
