extends Node2D

var grid : Grid
var boundary = Vector2(10,10)


func _ready():
	grid = Grid.new(50,50)
	grid.position = boundary
	add_child(grid)


func _input(event):
	if (event.is_action_pressed("ui_cancel")):
		get_tree().quit()
