class_name CellularAutomata

var grid : Grid

func _init(g : Grid):
	grid = g

func step():
	for y in grid.height:
		for x in grid.width:
			var cell = grid.get_cell(x,y)
			if (cell.down != null and cell.liquid > 0):
				cell.down.liquid = cell.liquid
				cell.liquid = 0
	grid.update()
