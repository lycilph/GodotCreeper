extends Node2D

@export var node : Node2D
@export var selection_sprite : Sprite2D
@export var block_sprite : Sprite2D

var automata : CellularAutomata
var grid : Grid
var width = 50
var height = 50
var tile = 16
var boundary = 10

func _ready():
	grid = Grid.new(width,height,tile,boundary)
	grid.add_sprites(node)
	
	automata = CellularAutomata.new(grid)
	
	selection_sprite.position = Vector2i(boundary,boundary)

func _process(_delta):
	if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		var pos = get_global_mouse_position()
		var x = floori(pos.x - boundary) / tile
		var y = floori(pos.y - boundary) / tile
		if (x >= 0 and x < width and y >= 0 and y < height):
			selection_sprite.position = Vector2i(x*tile+boundary,y*tile+boundary)
			grid.set_cell(x,y,block_sprite.frame)

func _unhandled_input(event):
	if (event.is_action_pressed("ui_cancel")):
		get_tree().quit()
	elif (event.is_action_pressed("block_1")):
		block_sprite.frame = 0
	elif (event.is_action_pressed("block_2")):
		block_sprite.frame = 1
	elif (event.is_action_pressed("block_3")):
		block_sprite.frame = 2
	elif (event.is_action_pressed("block_4")):
		block_sprite.frame = 3

func _on_step_button_pressed():
	automata.step()
