class_name Grid

var cells : Array
var width : int
var height : int


func _init(w : int, h : int):
	width = w
	height = h
	cells.resize(width*height)
	for i in cells.size():
		cells[i] = Cell.new()
	set_neighbors()


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
	get_cell(width-1,height-1).left = get_cell(width-2,height-1)


func reset():
	for c in cells:
		c.reset()


func reset_buffer():
	for c in cells:
		c.buffer = 0.0


func update(min_value : float):
	for c in cells:
		c.fluid += c.buffer
		if (c.fluid < min_value):
			c.fluid = 0.0


func get_cell(x : int, y : int):
	return cells[y*width+x]
