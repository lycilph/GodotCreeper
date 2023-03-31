class_name CellRenderer extends Node2D

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
	for i in grid.cells.size():
		if (grid.cells[i].type == Cell.TYPE.SOLID):
			x = i % grid.width
			y = i / grid.width
			draw_texture(tile, Vector2(x*tile_size, y*tile_size), Color.BLACK)
	
#	draw_texture(tile, Vector2(0,0), Color.GREEN)
#
#	draw_texture(tile, Vector2(50,50), Color.CORNFLOWER_BLUE)
#	draw_texture(tile, Vector2(50,66), Color.BLUE)
#	draw_texture(tile, Vector2(50,82), Color.BLACK)
#	draw_texture_rect_region(arrows, Rect2(50,50,16,16), Rect2(16,16,16,16))
#	draw_texture(settled, Vector2(50,66))
