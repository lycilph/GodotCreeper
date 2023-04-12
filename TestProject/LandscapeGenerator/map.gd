class_name Map

var width : int
var height : int
var levels : int

var nodes : Array

func _init(w : int, h : int, l : int):
	width = w
	height = h
	levels = l
	
	nodes.resize(width*height*levels)
	for i in nodes.size():
		nodes[i] = MapNode.new()


func get_node(x : int, y : int, l : int) -> MapNode:
	return nodes[l*(width*height)+y*width+x]


func set_node(x : int, y : int, l : int, val : float):
	nodes[l*(width*height)+y*width+x].value = val


func scale(scale : float):
	for i in nodes.size():
		nodes[i].value = nodes[i].value * scale


func round():
	for i in nodes.size():
		nodes[i].value = roundf(nodes[i].value)


func print():
	var min = 10000
	var max = 0
	for i in nodes.size():
		var val = nodes[i].value
		min = minf(min, val)
		max = maxf(max, val)
		print(val)
	print("min ", min, " max ", max)
