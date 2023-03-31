extends Node2D

@export var camera : Camera2D

func _input(event):
	if (event.is_action_pressed("zoom_in")):
		camera.zoom.x *= 1.1
		camera.zoom.y *= 1.1
	if (event.is_action_pressed("zoom_out")):
		camera.zoom.x *= 0.9
		camera.zoom.y *= 0.9
	pass
