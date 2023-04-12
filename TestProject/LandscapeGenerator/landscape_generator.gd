extends Node2D

@export var rect : TextureRect

@export var width_slider : Slider
@export var height_slider : Slider
@export var levels_slider : Slider

@export var width_label : Label
@export var height_label : Label
@export var levels_label : Label

var noise_map : Map
var map : Map

func _ready():
	width_slider.value = 5
	height_slider.value = 5
	levels_slider.value = 1
	update_labels()
	update_noise()
	# We wait here, to make sure the noise texture has been generated before continuing
	await get_tree().process_frame
	generate_map()


func update_noise():
	rect.texture.width = width_slider.value
	rect.texture.height = height_slider.value
	rect.texture.noise.seed = randi()


func generate_map():
	noise_map = Map.new(width_slider.value, height_slider.value, 1)
	
	var img = rect.texture.get_image()
	for y in img.get_height():
		for x in img.get_width():
			var pixel_value = img.get_pixel(x,y).r
			noise_map.set_node(x,y,0,pixel_value)
	
	noise_map.scale(levels_slider.value)
	noise_map.round()


func update_labels():
	width_label.text = str(width_slider.value)
	height_label.text = str(height_slider.value)
	levels_label.text = str(levels_slider.value)


func _on_width_slider_value_changed(value):
	update_labels()


func _on_height_slider_value_changed(value):
	update_labels()


func _on_levels_slider_value_changed(value):
	update_labels()


func _on_generate_button_pressed():
	update_noise()
	# We wait here, to make sure the noise texture has been generated before continuing
	for i in 3:
		await get_tree().process_frame
	generate_map()
