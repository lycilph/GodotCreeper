extends Node2D

@export var node : Node2D
@export var spawner_node : Node2D
@export var selection_sprite : Sprite2D
@export var block_sprite : Sprite2D
@export var run_button : Button
@export var liquid_label : Label
@export var fps_label : Label

var automata : CellularAutomata
var grid : Grid
var selection_pos : Vector2i
var running : bool = false


func _ready():
	grid = Grid.new(50,50,16,10)
	grid.add_sprites(node)
	
	automata = CellularAutomata.new(grid)
	selection_sprite.position = Vector2i(grid.boundary,grid.boundary)


func _physics_process(delta):
	if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		var pos = get_global_mouse_position()
		var x = floori(pos.x - grid.boundary) / grid.tile
		var y = floori(pos.y - grid.boundary) / grid.tile
		if (x >= 0 and x < grid.width and y >= 0 and y < grid.height):
			selection_pos = Vector2i(x,y)
			selection_sprite.position = Vector2i(x*grid.tile+grid.boundary,y*grid.tile+grid.boundary)
			match block_sprite.frame:
				0:
					grid.set_cell_liquid(x,y,1)
				2:
					grid.set_cell_type(x,y,Cell.CELL_TYPE.SOLID)
				3:
					grid.clear_cell(x,y)
	elif (Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)):
		var pos = get_global_mouse_position()
		var x = floori(pos.x - grid.boundary) / grid.tile
		var y = floori(pos.y - grid.boundary) / grid.tile
		if (x >= 0 and x < grid.width and y >= 0 and y < grid.height):
			selection_pos = Vector2i(x,y)
			selection_sprite.position = Vector2i(x*grid.tile+grid.boundary,y*grid.tile+grid.boundary)
	elif (Input.is_action_pressed("ui_accept")):
		automata.step()
	
	liquid_label.text = "%.2f" % grid.get_cell(selection_pos.x, selection_pos.y).liquid
	fps_label.text = "%.2f" % (1/delta)
	
	if (running):
		automata.step()


func add_remove_spawner(pos : Vector2i):
	for s in spawner_node.get_children():
		if (s.position == Vector2(pos)):
			s.queue_free()
			return
	
	var spawner_scene = load("res://CellularAutomata/spawner.tscn")
	var spawner = spawner_scene.instantiate()
	spawner.grid = grid
	spawner.position = pos
	spawner_node.add_child(spawner)


func toggle_simulation():
	running = !running
	if (running):
		run_button.text = "Stop"
	else:
		run_button.text = "Run"


func _unhandled_input(event):
	if (event.is_action_pressed("ui_cancel")):
		get_tree().quit()
	elif (event.is_action_pressed("block_water")):
		block_sprite.frame = 0
	elif (event.is_action_pressed("block_solid")):
		block_sprite.frame = 2
	elif (event.is_action_pressed("block_none")):
		block_sprite.frame = 3
	elif (event.is_action_pressed("add_remove_spawner")):
		add_remove_spawner(selection_sprite.position)
	elif (event.is_action_pressed("run")):
		toggle_simulation()
	elif (event.is_action_pressed("step")):
		automata.step()
	elif (event.is_action_pressed("clear")):
		grid.clear()


func _on_step_button_pressed():
	automata.step()


func _on_run_button_pressed():
	toggle_simulation()


func _on_clear_button_pressed():
	grid.clear()
