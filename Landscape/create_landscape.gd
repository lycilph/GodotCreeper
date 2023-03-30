extends Control

@export var rect : TextureRect


func _on_generate_button_pressed():
	rect.texture.noise.seed = randi()
	pass # Replace with function body.


func _on_save_button_pressed():
	var img = rect.texture.get_image()
	print(img.get_height())
	print(img.get_width())
	for y in img.get_height():
		for x in img.get_width():
			print(img.get_pixel(x,y))
	pass # Replace with function body.
