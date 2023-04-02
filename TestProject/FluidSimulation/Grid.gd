class_name Grid

var cells : Array
var width : int
var height : int


func _init(w : int, h : int):
	width = w
	height = h
	cells.resize(width*height)
	for i in cells.size():
		cells[i] = Cell.new()


func get_cell(x : int, y : int):
	return cells[y*width+x]
