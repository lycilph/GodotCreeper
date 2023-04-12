extends Node2D

@export var landscape_generator : Node2D
@export var marching_square : Node2D
@export var prev_button : Button
@export var next_button : Button

var step = 0


func _ready():
	update_step()


func update_step():
	match step:
		0:
			landscape_generator.visible = true
			marching_square.visible = false
			prev_button.disabled = true
			next_button.disabled = false
		1:
			landscape_generator.visible = false
			marching_square.visible = true
			prev_button.disabled = false
			next_button.disabled = true


func _on_next_button_pressed():
	step += 1
	update_step()


func _on_previous_button_pressed():
	step -= 1
	update_step()
