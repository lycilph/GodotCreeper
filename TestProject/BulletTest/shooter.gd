extends Node2D

@export var marker : Marker2D

func get_barrel_start() -> Vector2:
	return to_global(marker.position)
