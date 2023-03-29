class_name Buffer


var values : Array
var width
var height


func _init(w : int, h : int):
	width = w
	height = h
	values.resize(width*height)


func reset():
	for i in values.size():
		values[i] = 0.0


func get_value(x : int, y : int):
	return values[y*width+x]


func add(x : int, y : int, v : float):
	values[y*width+x] += v


func remove(x : int, y : int, v : float):
	values[y*width+x] -= v
