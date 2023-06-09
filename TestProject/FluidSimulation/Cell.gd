class_name Cell

enum TYPE {BLANK, SOLID}
enum {UP, RIGHT, DOWN, LEFT}

# Data per cell
var fluid : float
var buffer : float
var type : TYPE = TYPE.BLANK

# Other data
var settled : bool = false
var settle_count : int = 0
var flow_direction : int = 0

# neighbors
var up : Cell
var right : Cell
var down : Cell
var left : Cell


func reset():
	type = TYPE.BLANK
	fluid = 0.0
	buffer = 0.0
	settled = false
	settle_count = 0
	reset_flow()


func unsettle_neighbors():
	if (up != null):
		up.settled = false
		up.settle_count = 0
	if (right != null):
		right.settled = false
		right.settle_count = 0
	if (down != null):
		down.settled = false
		down.settle_count = 0
	if (left != null):
		left.settled = false
		left.settle_count = 0


func reset_flow():
	flow_direction = 0


func add_flow(direction):
	match direction:
		UP:
			flow_direction += 1
		RIGHT:
			flow_direction += 2
		DOWN:
			flow_direction += 4
		LEFT:
			flow_direction += 8


func add_fluid(value : float):
	fluid += value
	settled = false
	settle_count = 0
	unsettle_neighbors()


func set_fluid(value : float):
	fluid = value
	settled = false
	settle_count = 0
	unsettle_neighbors()
