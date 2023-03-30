extends Node

func load_map(filename : String):
	var f = FileAccess.open(filename, FileAccess.READ)
	var content = f.get_as_text()
	var js = JSON.new()
	var err = js.parse(content)
	if (err != Error.OK):
		print(err)
	return js.data
