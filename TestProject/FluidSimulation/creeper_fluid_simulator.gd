class_name CreeperFluidSimulator

const FLUID_STEP : float = 0.025
const MIN_VALUE : float = 0.005

var grid : Grid
var iteration : int


func _init(g : Grid):
	grid = g


func step() -> int:
	grid.reset_buffer()
	iteration += 1
	
	var cell
	var flow
	var cells_updated = 0
	for y in range(grid.height-1,-1,-1):
		for x in grid.width:
			cell = grid.get_cell(x,y)
			cell.reset_flow()

			if (cell.type == Cell.TYPE.SOLID):
				continue
			if (cell.fluid == 0.0):
				continue

			cells_updated += 1
			var remaining = cell.fluid

			# Flow down
			if (cell.down != null and cell.down.type == Cell.TYPE.BLANK):
				flow = 1.0 - cell.down.fluid
				flow = minf(flow,cell.fluid)
				flow = snappedf(flow, FLUID_STEP)
				
				if (flow > 0):
					remaining -= flow
					cell.buffer -= flow
					cell.down.buffer += flow
					cell.add_flow(Cell.DOWN)

			if (remaining < MIN_VALUE):
				cell.buffer -= remaining
				continue

			var horizontal_flow = 0

			# Flow left
			if (cell.left != null and cell.left.type == Cell.TYPE.BLANK):
				flow = (remaining - cell.left.fluid) / 4.0
				flow = maxf(0, flow)
				flow = snappedf(flow, FLUID_STEP)

				if (flow > 0):
					horizontal_flow -= flow
					cell.buffer -= flow
					cell.left.buffer += flow
					cell.add_flow(Cell.LEFT)

			# Flow right
			if (cell.right != null and cell.right.type == Cell.TYPE.BLANK):
				flow = (remaining - cell.right.fluid) / 4.0
				flow = maxf(0, flow)
				flow = snappedf(flow, FLUID_STEP)

				if (flow > 0):
					horizontal_flow -= flow
					cell.buffer -= flow
					cell.right.buffer += flow
					cell.add_flow(Cell.RIGHT)

			remaining += horizontal_flow
			if (remaining < MIN_VALUE):
				cell.buffer -= remaining
				continue

			# Flow up
			if (cell.up != null and cell.up.type == Cell.TYPE.BLANK):
				flow = (remaining - 1)
				flow = maxf(0, flow)
				flow = snappedf(flow, FLUID_STEP)
				
				if (flow > 0):
					remaining -= flow
					cell.buffer -= flow
					cell.up.buffer += flow
					cell.add_flow(Cell.UP)

			if (remaining < MIN_VALUE):
				cell.buffer -= remaining
				continue

	grid.update(0)
	
	return cells_updated
