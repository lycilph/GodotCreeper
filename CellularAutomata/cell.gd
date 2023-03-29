class_name Cell

enum CELL_TYPE {BLANK, SOLID}

var sprite : Sprite2D

var liquid : float = 0.0
var type : CELL_TYPE = CELL_TYPE.BLANK
# Neighbors
var up : Cell
var right : Cell
var down : Cell
var left : Cell


func _init(s : Sprite2D):
	sprite = s
	clear()


func clear():
	type = CELL_TYPE.BLANK
	liquid = 0.0


func update():
	if (type == CELL_TYPE.SOLID):
		sprite.frame = 2
		sprite.scale.y = 1
		sprite.offset.y = 0
		sprite.modulate = Color.WHITE
	elif (liquid > 0):
		sprite.frame = 0
		if (liquid < 1.0):
			sprite.scale.y = liquid
			sprite.offset.y = 16*(1/liquid-1)
			sprite.modulate = Color.WHITE
		else:
			sprite.scale.y = 1
			sprite.offset.y = 0
			sprite.modulate = Color.WHITE.darkened(1-1/liquid)
	else:
		sprite.frame = 3
		sprite.scale.y = 1
		sprite.offset.y = 0
		sprite.modulate = Color.WHITE
