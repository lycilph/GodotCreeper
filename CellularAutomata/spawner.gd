class_name Spawner extends Node2D

var grid : Grid


func _on_timer_timeout():
	var x = floori(position.x - grid.boundary) / grid.tile
	var y = floori(position.y - grid.boundary) / grid.tile
	grid.get_cell(x,y).liquid += 1
