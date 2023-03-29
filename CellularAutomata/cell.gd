class_name Cell

var sprite : Sprite2D

var liquid : float = 0.0

# Neighbors
var up : Cell
var right : Cell
var down : Cell
var left : Cell

func _init(s : Sprite2D):
	sprite = s

func update():
	if (liquid > 0):
		sprite.frame = 0
	else:
		sprite.frame = 3
