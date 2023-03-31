class_name Grid extends Node2D

var tile : Texture
var arrows : Texture
var settled : Texture

var cells : Array
var width : int
var height : int
var tile_size : int


func _init(w : int, h : int):
	width = w
	height = h


func _ready():
	name = "Grid"
	tile = load("res://Assets/tile.png")
	arrows = load("res://Assets/arrows.png")
	settled = load("res://Assets/settled.png")
	tile_size = tile.get_width()


func _draw():
	draw_texture(tile, Vector2(0,0), Color.GREEN)
	
	draw_texture(tile, Vector2(50,50), Color.CORNFLOWER_BLUE)
	draw_texture(tile, Vector2(50,66), Color.BLUE)
	draw_texture(tile, Vector2(50,82), Color.BLACK)
	draw_texture_rect_region(arrows, Rect2(50,50,16,16), Rect2(16,16,16,16))
	draw_texture(settled, Vector2(50,66))
