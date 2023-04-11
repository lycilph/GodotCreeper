extends Node2D

@export var rect : TextureRect

@export var width_slider : Slider
@export var height_slider : Slider
@export var levels_slider : Slider

@export var width_label : Label
@export var height_label : Label
@export var levels_label : Label

func _ready():
	width_slider.value = 50
	height_slider.value = 50
	levels_slider.value = 5

func _on_width_slider_value_changed(value):
	width_label.text = str(value)

func _on_height_slider_value_changed(value):
	height_label.text = str(value)

func _on_levels_slider_value_changed(value):
	levels_label.text = str(value)

func _on_generate_button_pressed():
	rect.texture.width = width_slider.value
	rect.texture.height = height_slider.value
	rect.texture.noise.seed = randi()
