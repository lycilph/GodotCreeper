extends Node2D

func _ready():
	var level = Global.load_map("res://Data/level1.json")
	print(level.width)
	print(level.height)
	print(level.map)

func _unhandled_input(event):
	if (event.is_action_pressed("ui_cancel")):
		get_tree().quit()
