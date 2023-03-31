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


func set_cell(x : int, y : int):
	cells[y*width+x].type = Cell.TYPE.SOLID
