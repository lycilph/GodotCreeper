extends Node2D

@export var timer : Timer

var ground_sprites : Array
var fluid_sprites : Array

var ground : Array
var fluid : Array
var velocity : Array
var buffer : Array
var c = 0.3
var h = 1
var dt = 1
var s = 0.4

func _ready():
	ground = [0,0,1,0,0,0,2,0,0]
	fluid = [0,0,0,0,8,0,1,0,0]
	velocity = [0,0,0,0,0,0,0,0,0]
	buffer = [0,0,0,0,0,0,0,0,0]
	
	var img = load("res://Art/landscape.png")
	for i in range(9):
		var sprite = Sprite2D.new()
		sprite.texture = img
		sprite.centered = false
		sprite.hframes = 10
		sprite.frame = 5
		sprite.position = Vector2(i*16,0)
		ground_sprites.append(sprite)
		get_parent().add_child.call_deferred(sprite)
		
	img = load("res://Art/creeper.png")
	for i in range(9):
		var sprite = Sprite2D.new()
		sprite.texture = img
		sprite.centered = false
		sprite.position = Vector2(i*16,0)
		fluid_sprites.append(sprite)
		get_parent().add_child.call_deferred(sprite)
	
	update()

func update():
	for i in range(9):
		ground_sprites[i].scale.y = -ground[i]
	for i in range(9):
		fluid_sprites[i].scale.y = -fluid[i]
		fluid_sprites[i].position.y = -(ground[i]*16)
	print(fluid)

func step():
	fluid[0] = fluid[1] # Boundary
	fluid[8] = fluid[7] # Boundary

	for i in range(1,8):
		var left = fluid[i-1] + ground[i-1]
		var center = fluid[i] + ground[i]
		var right = fluid[i+1] + ground[i+1]
		var output = 0
		var input = 0
		
		# Input
		if (left > center and fluid[i-1] > 0):
			input += (left - ground[i])
		if (right > center and fluid[i+1] > 0):
			input += (right - ground[i])
		
		# Output
		if (center > left and fluid[i] > 0):
			output += (center-ground[i-1])
		if (center > right and fluid[i] > 0):
			output += (center-ground[i+1])
		
		var f = c*c*(input - output)/(h*h)
		velocity[i] += f*dt
		velocity[i] *= s
		buffer[i] = fluid[i] + velocity[i]*dt
	var total = 0
	for i in range(1,8):
		fluid[i] = snapped(buffer[i], 0.1)
		if (fluid[i] < 0):
			fluid[i] = 0
		total += fluid[i]
	update()
	print(total)

func _unhandled_input(event):
	if (event.is_action_pressed("ui_right")):
		step()
	elif (event.is_action_pressed("ui_cancel")):
		get_tree().quit()
	elif (event.is_action_pressed("ui_accept")):
		timer.start()


func _on_timer_timeout():
	step()
