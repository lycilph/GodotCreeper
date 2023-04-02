extends Node2D

@export var renderer : CellRenderer
@export var selection : Sprite2D
@export var run_button : Button

var grid : Grid
var simulator : FluidSimulator
var boundary
var tile
var running


func _ready():
	grid = Grid.new(50,50)
	simulator = FluidSimulator.new(grid)
	renderer.grid = grid
	boundary = renderer.position
	tile = renderer.tile_size


func _process(_delta):
	var pos = get_global_mouse_position()
	var x = floori(pos.x - boundary.x) / tile
	var y = floori(pos.y - boundary.y) / tile
	if (x >= 0 and x < grid.width and y >= 0 and y < grid.height):
		selection.visible = true
		selection.position = Vector2(x*tile,y*tile) + boundary
	else:
		selection.visible = false
	
	if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and selection.visible):
		var cell = grid.get_cell(x,y)
		match selection.type:
			SelectionSprite2D.WATER:
				cell.type = Cell.TYPE.BLANK
				cell.fluid = 1.0
			SelectionSprite2D.SOLID:
				cell.type = Cell.TYPE.SOLID
			SelectionSprite2D.EMPTY:
				cell.type = Cell.TYPE.BLANK
				cell.fluid = 0.0
	
	if (running):
		simulator.step()


func _input(event):
	if (event.is_action_pressed("ui_cancel")):
		get_tree().quit()


func _on_step_simulation_button_pressed():
	simulator.step()


func _on_run_simulation_button_pressed():
	running = !running
	if (running):
		run_button.text = "Stop"
	else:
		run_button.text = "Run"


func _on_reset_simulation_button_pressed():
	grid.reset()
