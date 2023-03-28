extends Node2D

@export var run_button : Button
@export var add_button : Button
@export var ground_node : Node2D
@export var fluid_node : Node2D
@export var fluid_debug_node : Control
@export var ground_debug_node : Control
@export var total_debug_node : Control
@export var selection_sprite : Sprite2D
@export var simulation_timer : Timer
@export var iteration_label : Label

var fluid_debug_labels : Array
var ground_debug_labels : Array
var total_debug_labels : Array

var map : Array
var width = 60
var height = 40
var boundary = 10
var tile = 16
var selection = 0
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
	var ground_img = load("res://Art/landscape.png")
	for y in height:
		for x in width:
			var sprite = Sprite2D.new()
			sprite.texture = creeper_img
			sprite.centered = false
			sprite.position = Vector2i(x*tile + boundary, y*tile+boundary)
			fluid_node.add_child(sprite)
			map[y*width+x].fluid_sprite = sprite
			
			sprite = Sprite2D.new()
			sprite.texture = ground_img
			sprite.hframes = 10
			sprite.frame = 0
			sprite.centered = false
			sprite.position = Vector2i(x*tile + boundary, y*tile+boundary)
			ground_node.add_child(sprite)
			map[y*width+x].ground_sprite = sprite

	create_map()

	create_fluid_debug_labels()
	update_sprites()

func create_map():
	map[10*width+10].ground_level = 2
	map[10*width+11].ground_level = 2
	map[10*width+12].ground_level = 2
	map[10*width+13].ground_level = 2
	map[10*width+14].ground_level = 2
	
	map[11*width+10].ground_level = 2
	map[11*width+14].ground_level = 2
	
	map[12*width+10].ground_level = 2
	map[12*width+14].ground_level = 2
	
	map[13*width+10].ground_level = 2
	map[13*width+14].ground_level = 2
	
	map[14*width+10].ground_level = 2
	map[14*width+11].ground_level = 2
	map[14*width+12].ground_level = 2	
	map[14*width+13].ground_level = 2
	map[14*width+14].ground_level = 2

func create_fluid_debug_labels():
	fluid_debug_labels.resize(25)
	for a in 5:
		var hbox = HBoxContainer.new()
		fluid_debug_node.add_child(hbox)
		for b in 5:
			var label = Label.new()
			label.text = "0.0"
			label.custom_minimum_size.x = 30
			hbox.add_child(label)
			fluid_debug_labels[a*5+b] = label
	
	ground_debug_labels.resize(25)
	for a in 5:
		var hbox = HBoxContainer.new()
		ground_debug_node.add_child(hbox)
		for b in 5:
			var label = Label.new()
			label.text = "0.0"
			label.custom_minimum_size.x = 30
			hbox.add_child(label)
			ground_debug_labels[a*5+b] = label
	
	total_debug_labels.resize(25)
	for a in 5:
		var hbox = HBoxContainer.new()
		total_debug_node.add_child(hbox)
		for b in 5:
			var label = Label.new()
			label.text = "0.0"
			label.custom_minimum_size.x = 30
			hbox.add_child(label)
			total_debug_labels[a*5+b] = label

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
		map[i].ground_sprite.frame = map[i].ground_level
	
	# Update fluid
	for i in map.size():
		map[i].fluid_sprite.modulate.a = map[i].fluid_level * 10.0
		#map[i].fluid_sprite.modulate.a = snapped(map[i].fluid_level, 0.2) * 10.0
	
	# Debug
	var x = selection % width
	var y = selection / width
	selection_sprite.position = Vector2i(x*tile + boundary, y*tile+boundary)
	iteration_label.text = "%04d" % iteration
	
	for yy in range(5):
		for xx in range(5):
			var value = get_fluid(xx+x-2, yy+y-2)
			if (value is String):
				fluid_debug_labels[yy*5+xx].text = value
			else:
				fluid_debug_labels[yy*5+xx].text = "%.2f" % value
	
	for yy in range(5):
		for xx in range(5):
			var value = get_ground(xx+x-2, yy+y-2)
			if (value is String):
				ground_debug_labels[yy*5+xx].text = value
			else:
				ground_debug_labels[yy*5+xx].text = "%.2f" % value
	
	for yy in range(5):
		for xx in range(5):
			var value = get_total(xx+x-2, yy+y-2)
			if (value is String):
				total_debug_labels[yy*5+xx].text = value
			else:
				total_debug_labels[yy*5+xx].text = "%.2f" % value

func step():
	step_simulation_including_ground()

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

func step_simulation_including_ground():
	iteration += 1
	for i in (width*height):
		var cell = map[i]
		var f = 0
		var active_neighbors = 0
		for n in cell.neighbors:
			var neighbor = map[n]
			if (neighbor.has_fluid() and neighbor.level() > cell.level()):
				f += map[n].fluid_level
				active_neighbors += 1
		f -= active_neighbors*cell.fluid_level
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

func get_fluid(x : int, y : int):
	if (x < 0 or x >= width or y < 0 or y >= height):
		return "-"
	return get_cell(x,y).fluid_level

func get_ground(x : int, y : int):
	if (x < 0 or x >= width or y < 0 or y >= height):
		return "-"
	return get_cell(x,y).ground_level

func get_total(x : int, y : int):
	if (x < 0 or x >= width or y < 0 or y >= height):
		return "-"
	return get_cell(x,y).ground_level + get_cell(x,y).fluid_level

func _unhandled_input(event):
	if (event.is_action_pressed("ui_cancel")):
		get_tree().quit()
	elif event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		if (event.position.x > boundary and event.position.x <= (width*tile+boundary) and event.position.y > boundary and event.position.y <= (height*tile+boundary)):
			var x = floori(event.position.x - boundary) / tile
			var y = floori(event.position.y - boundary) / tile
			selection = (y*width)+x
			if (add_button.button_pressed):
				map[selection].fluid_level = 10
			update_sprites()
	elif event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
		if (event.position.x > boundary and event.position.x <= (width*tile+boundary) and event.position.y > boundary and event.position.y <= (height*tile+boundary)):
			var x = floori(event.position.x - boundary) / tile
			var y = floori(event.position.y - boundary) / tile
			get_cell(x,y).ground_level += 1
			update_sprites()

func _on_clear_button_pressed():
	iteration = 0
	for i in map.size():
		map[i].fluid_level = 0
		map[i].velocity = 0
	update_sprites()

func _on_quit_button_pressed():
	get_tree().quit()

func _on_check_button_pressed():
	if (run_button.button_pressed):
		simulation_timer.start()
	else:
		simulation_timer.stop()

func _on_step_button_pressed():
	step()
	update_sprites()

func _on_timer_timeout():
	step()
	update_sprites()
