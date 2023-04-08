extends Node2D

@export var turret : Node2D

func _process(_delta):
	var pos = get_global_mouse_position()
	turret.position = pos
	pass
