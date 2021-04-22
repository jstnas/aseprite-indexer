SRC = indexer.lua package.json
ARCHIVE = indexer.aseprite-extension
SCRIPT_DIR = ~/.config/aseprite/scripts
PLUGIN_DIR = ~/.config/aseprite/extensions

plugin:
	zip $(ARCHIVE) $(SRC)

script:
	cp ./indexer.lua $(SCRIPT_DIR)
