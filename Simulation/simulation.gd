extends Node2D

@export var run_button : Button
@export var add_button : Button
@export var fluid_node : Node2D
@export var fluid_debug_node : Control
@export var selection_sprite : Sprite2D
@export var simulation_timer : Timer
@export var iteration_label : Label

var fluid_debug_dict : Dictionary

var map : Array
var width = 60
var height = 40
var boundary = 10
var tile = 16
var selection = 0
var adding = false
var iteration = 0

var c = 0.3
var dt = 1.0
var velocity_scale = 0.5

func _ready():
	map.resize(width*height)
	for y in height:
		for x in width:
			map[y*width+x] = Cell.new()
	set_neighbors()
	
	var creeper_img = load("res://Art/creeper.png")
	for y in height:
		for x in width:
			var sprite = Sprite2D.new()
			sprite.texture = creeper_img
			sprite.centered = false
			sprite.position = Vector2i(x*tile + boundary, y*tile+boundary)
			fluid_node.add_child(sprite)
			map[y*width+x].fluid_sprite = sprite
	
	update_sprites()
	
	create_fluid_debug_dictionary()

func create_fluid_debug_dictionary():
	var label = Label.new()
	label.text = "Fluid"
	fluid_debug_node.add_child(label)
	
	for y in range(-2,3):
		var hbox = HBoxContainer.new()
		fluid_debug_node.add_child(hbox)
		for x in range(-2,3):
			var pos = Vector2i(x,y)
			label = Label.new()
			label.text = "0.0"
			label.custom_minimum_size.x = 30
			hbox.add_child(label)
			fluid_debug_dict[pos] = label

func set_neighbors():
	# Center
	for y in range(1,height-1):
		for x in range(1,width-1):
			get_cell(x,y).neighbors.append(get_cell_index(x,y-1)) # Up
			get_cell(x,y).neighbors.append(get_cell_index(x,y+1)) # Down
			get_cell(x,y).neighbors.append(get_cell_index(x-1,y)) # Left
			get_cell(x,y).neighbors.append(get_cell_index(x+1,y)) # Right
	# Top
	for x in range(1,width-1):
		get_cell(x,0).neighbors.append(get_cell_index(x,1)) # Down
		get_cell(x,0).neighbors.append(get_cell_index(x-1,0)) # Left
		get_cell(x,0).neighbors.append(get_cell_index(x+1,0)) # Right
	# Bottom
	for x in range(1,width-1):
		get_cell(x,height-1).neighbors.append(get_cell_index(x,height-2)) # Up
		get_cell(x,height-1).neighbors.append(get_cell_index(x-1,height-1)) # Left
		get_cell(x,height-1).neighbors.append(get_cell_index(x+1,height-1)) # Right
	# Left
	for y in range(1,height-1):
		get_cell(0,y).neighbors.append(get_cell_index(0,y-1)) # Up
		get_cell(0,y).neighbors.append(get_cell_index(0,y+1)) # Down
		get_cell(0,y).neighbors.append(get_cell_index(1,y)) # Right
	# Right
	for y in range(1,height-1):
		get_cell(width-1,y).neighbors.append(get_cell_index(width-1,y-1)) # Up
		get_cell(width-1,y).neighbors.append(get_cell_index(width-1,y+1)) # Down
		get_cell(width-1,y).neighbors.append(get_cell_index(width-2,y)) # Right
	# Top-Left
	get_cell(0,0).neighbors.append(get_cell_index(0,1)) # Down
	get_cell(0,0).neighbors.append(get_cell_index(1,0)) # Right
	# Top-right
	get_cell(width-1,0).neighbors.append(get_cell_index(width-1,1)) # Down
	get_cell(width-1,0).neighbors.append(get_cell_index(width-2,0)) # Left
	# Bottom-Left
	get_cell(0,height-1).neighbors.append(get_cell_index(0,height-2)) # Up
	get_cell(0,height-1).neighbors.append(get_cell_index(1,height-1)) # Right
	# Bottom-right
	get_cell(width-1,height-1).neighbors.append(get_cell_index(width-1,height-2)) # Up
	get_cell(width-1,height-1).neighbors.append(get_cell_index(width-2,height-1)) # Left

func update_sprites():
	for i in map.size():
		map[i].fluid_sprite.modulate.a = map[i].fluid_level * 10
	
	# Debug
	var x = selection % width
	var y = selection / width
	selection_sprite.position = Vector2i(x*tile + boundary, y*tile+boundary)
	iteration_label.text = "%04d" % iteration
	
	for i in range(-2,3):
		for j in range(-2,3):
			var pos = Vector2i(i,j)
			fluid_debug_dict[pos].text = "f"
			

func step_simulation():
	iteration += 1
	for i in (width*height):
		var cell = map[i]
		var f = 0
		for n in cell.neighbors:
			f += map[n].fluid_level
		f -= cell.neighbors.size()*cell.fluid_level
		cell.velocity += c*c*f*dt
		cell.velocity *= velocity_scale
		cell.buffer = cell.fluid_level + cell.velocity*dt
		
	for i in (width*height):
		var cell = map[i]
		cell.fluid_level = cell.buffer

func get_cell(x : int, y : int):
	return map[y*width+x]

func get_cell_index(x : int, y : int):
	return y*width+x

func _unhandled_input(event):
	if (event.is_action_pressed("ui_cancel")):
		get_tree().quit()
	elif event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		var x = floori(event.position.x - boundary) / tile
		var y = floori(event.position.y - boundary) / tile
		selection = (y*width)+x
		if (adding):
			map[selection].fluid_level = 10
		update_sprites()

func _on_add_button_pressed():
	adding = add_button.button_pressed
	update_sprites()

func _on_clear_button_pressed():
	iteration = 0
	for i in map.size():
		map[i].fluid_level = 0
	update_sprites()

func _on_quit_button_pressed():
	get_tree().quit()

func _on_check_button_pressed():
	if (run_button.button_pressed):
		simulation_timer.start()
	else:
		simulation_timer.stop()

func _on_step_button_pressed():
	step_simulation()
	update_sprites()

func _on_timer_timeout():
	step_simulation()
	update_sprites()
