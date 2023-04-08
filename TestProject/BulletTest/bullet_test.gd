extends Node2D

const bullet = preload("res://BulletTest/bullet.tscn")

@export var shooter : Node2D
@export var timer : Timer

func _process(_delta):
	var pos = get_global_mouse_position()
	shooter.look_at(pos)
	
	if (Input.is_action_pressed("ui_accept") and timer.is_stopped()):
		shoot(pos)

func shoot(pos : Vector2):
	var instance = bullet.instantiate()
	instance.position = shooter.get_barrel_start()
	instance.direction = position.direction_to(pos)
	instance.target = pos
	add_child(instance)
	timer.start()
