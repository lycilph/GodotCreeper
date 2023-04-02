class_name CellRenderer extends Node2D

const WATER : Color = Color.CORNFLOWER_BLUE
const DARK_WATER : Color = Color.MIDNIGHT_BLUE
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
	var size
	var pos
	var cell
	var col
	for i in grid.cells.size():
		cell = grid.cells[i]
		x = i % grid.width
		y = i / grid.width
		pos = Vector2(x*tile_size, y*tile_size)
		
		if (cell.type == Cell.TYPE.SOLID):
			draw_texture(tile, pos, SOLID)
		elif (cell.fluid > 0.0):
			# Don't render "floating" fluids
			if (cell.down != null and cell.down.type == Cell.TYPE.BLANK and cell.down.fluid <= 0.99):
				size = 0

			if (cell.type == Cell.TYPE.BLANK and cell.up != null and cell.up.fluid > 0.05):
				size = tile_size
			else:
				size = minf(1, cell.fluid)*tile_size
				
			if (cell.fluid > 1.0):
				col = WATER.lerp(DARK_WATER, (cell.fluid-1)/2.0)
			else:
				col = WATER
				
			draw_texture_rect(tile, Rect2(pos.x, (tile_size-size)+pos.y, tile_size, size), false, col)
		
	# Add flow
	var flow_x
	var flow_y
	for i in grid.cells.size():
		cell = grid.cells[i]
		flow_x = cell.flow_direction % 4
		flow_y = cell.flow_direction / 4
		x = i % grid.width
		y = i / grid.width
		draw_texture_rect_region(arrows, Rect2(x*tile_size,y*tile_size,tile_size,tile_size), Rect2(flow_x*tile_size,flow_y*tile_size,tile_size,tile_size))
	
	for i in grid.cells.size():
		cell = grid.cells[i]
		if (cell.settled):
			x = i % grid.width
			y = i / grid.width
			pos = Vector2(x*tile_size, y*tile_size)
			draw_texture(settled, pos)
