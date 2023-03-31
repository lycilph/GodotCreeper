extends Control

@export var label : Label



func _on_h_slider_value_changed(value):
	label.text = str(value)
	pass # Replace with function body.
