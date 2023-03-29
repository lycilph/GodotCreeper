class_name Grid


var cells : Array
var width
var height
var tile
var boundary


func _init(w : int, h : int, t : int, b : int):
	width = w
	height = h
	tile = t
	boundary = b
	
	create_cells()
	set_neighbors()


func create_cells():
	var img = load("res://Art/ca_sprite.png")
	cells.resize(size())
	for y in height:
		for x in width:
			var sprite = Sprite2D.new()
			sprite.texture = img
			sprite.hframes = 5
			sprite.frame = 3
			sprite.centered = false
			sprite.position = Vector2i(x*tile+boundary,y*tile+boundary)
			var cell = Cell.new(sprite)
			cells[y*width+x] = cell


func set_neighbors():
	# Center
	for y in range(1,height-1):
		for x in range(1,width-1):
			get_cell(x,y).up = get_cell(x,y-1)
			get_cell(x,y).down = get_cell(x,y+1)
			get_cell(x,y).left = get_cell(x-1,y)
			get_cell(x,y).right = get_cell(x+1,y)
	# Top
	for x in range(1,width-1):
		get_cell(x,0).down = get_cell(x,1)
		get_cell(x,0).left = get_cell(x-1,0)
		get_cell(x,0).right = get_cell(x+1,0)
	# Bottom
	for x in range(1,width-1):
		get_cell(x,height-1).up = get_cell(x,height-2)
		get_cell(x,height-1).left = get_cell(x-1,height-1)
		get_cell(x,height-1).right = get_cell(x+1,height-1)
	# Left
	for y in range(1,height-1):
		get_cell(0,y).up = get_cell(0,y-1)
		get_cell(0,y).down = get_cell(0,y+1)
		get_cell(0,y).right = get_cell(1,y)
	# Right
	for y in range(1,height-1):
		get_cell(width-1,y).up = get_cell(width-1,y-1)
		get_cell(width-1,y).down = get_cell(width-1,y+1)
		get_cell(width-1,y).left = get_cell(width-2,y)
	# Top-Left
	get_cell(0,0).down = get_cell(0,1)
	get_cell(0,0).right = get_cell(1,0)
	# Top-right
	get_cell(width-1,0).down = get_cell(width-1,1)
	get_cell(width-1,0).left = get_cell(width-2,0)
	# Bottom-Left
	get_cell(0,height-1).up = get_cell(0,height-2)
	get_cell(0,height-1).right = get_cell(1,height-1)
	# Bottom-right
	get_cell(width-1,height-1).up = get_cell(width-1,height-2)
	get_cell(width-1,height-1).left = get_cell(width-2,height-2)


func add_sprites(node : Node):
	for c in cells:
		node.add_child(c.sprite)


func update():
	for c in cells:
		c.update()


func clear():
	for c in cells:
		c.clear()
		c.update()


func size():
	return width*height


func set_cell_liquid(x : int, y : int, l : float):
	var cell = get_cell(x,y)
	cell.liquid = l
	cell.update()


func set_cell_type(x : int, y : int, t : Cell.CELL_TYPE):
	var cell = get_cell(x,y)
	cell.type = t
	cell.update()


func clear_cell(x : int, y : int):
	var cell = get_cell(x,y)
	cell.clear()
	cell.update()


func get_cell(x : int, y : int):
	return cells[y*width+x]
