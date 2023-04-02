class_name SelectionSprite2D extends Sprite2D

enum {WATER, SOLID, EMPTY}

@export var renderer : CellRenderer
@export var block : ColorRect
@export var label : Label

var type = WATER


func _ready():
	type = WATER
	update()


func update():
	match type:
		WATER:
			label.text = "Water"
			modulate = renderer.WATER
			block.color = renderer.WATER
		SOLID:
			label.text = "Solid"
			modulate = renderer.SOLID
			block.color = renderer.SOLID
		EMPTY:
			label.text = "Empty"
			modulate = renderer.EMPTY
			block.color = renderer.EMPTY


func _unhandled_input(event):
	if (event.is_action_pressed("select_block_1")):
		type = WATER
		update()
	elif (event.is_action_pressed("select_block_2")):
		type = SOLID
		update()
	elif (event.is_action_pressed("select_block_3")):
		type = EMPTY
		update()


func _on_select_water_button_pressed():
	type = WATER
	update()


func _on_select_solid_button_pressed():
	type = SOLID
	update()


func _on_select_empty_button_pressed():
	type = EMPTY
	update()
