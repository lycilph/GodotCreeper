extends Node2D

@export var sprite : Sprite2D

var can_place_turret = true


func _on_area_2d_body_entered(body):
	sprite.modulate = Color.DARK_RED
	can_place_turret = false


func _on_area_2d_body_exited(body):
	sprite.modulate = Color.WHITE
	can_place_turret = true
