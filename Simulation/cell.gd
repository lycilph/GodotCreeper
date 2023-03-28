class_name Cell extends Node2D

var ground_level : float = 0.0
var fluid_level : float = 0.0
var velocity : float
var buffer : float
var neighbors : Array

var fluid_sprite : Sprite2D
var ground_sprite : Sprite2D

func has_fluid() -> bool:
	return fluid_level > 0

func level() -> float:
	return ground_level + fluid_level
