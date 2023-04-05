extends Node2D

@export var renderer : CellRenderer
@export var selection : Sprite2D
@export var run_button : Button
@export var iteration_label : Label
@export var zoom_label : Label
@export var cells_updated_label : Label
@export var total_fluid_label : Label
@export var camera : Camera2D

var grid : Grid
var simulator : CreeperFluidSimulator
var boundary
var tile
var running
var original_camera_position


func _ready():
	grid = Grid.new(50,50)
	simulator = CreeperFluidSimulator.new(grid)
	renderer.grid = grid
	boundary = renderer.position
	tile = renderer.tile_size
	original_camera_position = camera.position
	start_stop_simulation()


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
				cell.set_fluid(1)
			SelectionSprite2D.SOLID:
				cell.type = Cell.TYPE.SOLID
				cell.unsettle_neighbors()
			SelectionSprite2D.EMPTY:
				cell.type = Cell.TYPE.BLANK
				cell.set_fluid(0)
	if (Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and selection.visible):
		var cell = grid.get_cell(x,y)
		cell.add_fluid(1)

	if (running):
		step_simulation()
	
	iteration_label.text = str(simulator.iteration)
	zoom_label.text = "%.2f" % camera.zoom.x
	total_fluid_label.text = "%.2f" % grid.get_total_fluid()
	renderer.zoom_level = camera.zoom.x


func _unhandled_input(event):
	if (event.is_action_pressed("ui_cancel")):
		get_tree().quit()
	if (event.is_action_pressed("run_simulation")):
		start_stop_simulation()
	if (event.is_action_pressed("step_simulation")):
		step_simulation()
	if (event.is_action_pressed("zoom_in")):
		camera.zoom.x *= 1.1
		camera.zoom.y *= 1.1
	if (event.is_action_pressed("zoom_out")):
		camera.zoom.x *= 0.9
		camera.zoom.y *= 0.9
	if (event.is_action("ui_up")):
		camera.position.y -= 20
	if (event.is_action("ui_down")):
		camera.position.y += 20
	if (event.is_action("ui_left")):
		camera.position.x -= 20
	if (event.is_action("ui_right")):
		camera.position.x += 20


func step_simulation():
	var cells_update = simulator.step()
	cells_updated_label.text = str(cells_update)


func start_stop_simulation():
	running = !running
	if (running):
		run_button.text = "Stop"
	else:
		run_button.text = "Run"


func _on_step_simulation_button_pressed():
	step_simulation()


func _on_run_simulation_button_pressed():
	start_stop_simulation()


func _on_reset_simulation_button_pressed():
	grid.reset()
	simulator.iteration = 0


func _on_reset_camera_button_pressed():
	camera.position = original_camera_position
	camera.zoom = Vector2(1,1)
