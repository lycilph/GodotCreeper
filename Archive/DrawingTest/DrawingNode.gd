extends Node2D

var text : Texture
var creep : Texture

func _ready():
	text = load("res://Art/ca_sprite.png")
	creep = load("res://Art/selection.png")

func _draw():
	draw_texture(text, Vector2(0,0))
	draw_texture(creep, Vector2(5,5))
