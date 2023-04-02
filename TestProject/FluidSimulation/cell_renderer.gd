class_name CellRenderer extends Node2D

const WATER : Color = Color.CORNFLOWER_BLUE
const SOLID : Color = Color.BLACK
const EMPTY : Color = Color.LIGHT_GRAY

@export var tile : Texture
@export var arrows : Texture
@export var settled : Texture

var grid : Grid
var tile_size : int


func _ready():
	tile_size = tile.get_width()


func _process(_delta):
	queue_redraw()


func _draw():
	var x
	var y
	var pos
	var cell
	for i in grid.cells.size():
		cell = grid.cells[i]
		x = i % grid.width
		y = i / grid.width
		pos = Vector2(x*tile_size, y*tile_size)
		if (cell.type == Cell.TYPE.SOLID):
			draw_texture(tile, pos, SOLID)
		elif (cell.fluid > 0.0):
			draw_texture(tile, pos, WATER)
	
#
#	draw_texture_rect_region(arrows, Rect2(50,50,16,16), Rect2(16,16,16,16))
#	draw_texture(settled, Vector2(50,66))
