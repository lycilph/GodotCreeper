class_name CreeperFluidSimulator

const FLUID_STEP : float = 0.025

var grid : Grid
var iteration : int


func _init(g : Grid):
	grid = g


func step():
	grid.reset_buffer()
	iteration += 1
	
	var cell
	var flow
	for y in range(grid.height-1,-1,-1):
		for x in grid.width:
			cell = grid.get_cell(x,y)
			cell.reset_flow()

			if (cell.type == Cell.TYPE.SOLID):
				continue
			if (cell.fluid == 0.0):
				continue

			# Flow up
			if (cell.up != null and cell.up.type == Cell.TYPE.BLANK):
				var f = cell.fluid
				var cf = cell.up.fluid
				flow = (cell.fluid - 1)
				flow = maxf(0, flow)
				flow = snappedf(flow, FLUID_STEP)
				
				if (flow > 0):
					cell.buffer -= flow
					cell.up.buffer += flow
					cell.add_flow(Cell.UP)
					continue

			# Flow down
			if (cell.down != null and cell.down.type == Cell.TYPE.BLANK):
				var f = cell.fluid
				var cf = cell.down.fluid
				flow = 1.0 - cell.down.fluid
				flow = minf(flow,cell.fluid)
				flow = snappedf(flow, FLUID_STEP)
				
				if (flow > 0):
					cell.buffer -= flow
					cell.down.buffer += flow
					cell.add_flow(Cell.DOWN)

			# We continue if all fluid is used
			if (cell.fluid + cell.buffer == 0):
				continue

			# Flow left
			if (cell.left != null and cell.left.type == Cell.TYPE.BLANK):
				var f = cell.fluid
				var cf = cell.left.fluid
				flow = (cell.fluid - cell.left.fluid) / 4.0
				flow = maxf(0, flow)
				flow = snappedf(flow, FLUID_STEP)

				if (flow > 0):
					cell.buffer -= flow
					cell.left.buffer += flow
					cell.add_flow(Cell.LEFT)

			# Flow right
			if (cell.right != null and cell.right.type == Cell.TYPE.BLANK):
				var f = cell.fluid
				var cf = cell.right.fluid
				flow = (cell.fluid - cell.right.fluid) / 4.0
				flow = maxf(0, flow)
				flow = snappedf(flow, FLUID_STEP)

				if (flow > 0):
					cell.buffer -= flow
					cell.right.buffer += flow
					cell.add_flow(Cell.RIGHT)

	grid.update(0)
