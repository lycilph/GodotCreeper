class_name FluidSimulator

# Max and min cell liquid values
const MAX_VALUE : float = 1.0
const MIN_VALUE : float = 0.005
# Extra liquid a cell can store than the cell above it
const MAX_COMPRESSION : float = 0.25;
# Lowest and highest amount of liquids allowed to flow per iteration
const MIN_FLOW : float = 0.005;
const MAX_FLOW : float = 4.0;
# Adjusts flow speed (0.0f - 1.0f)
const FLOW_SPEED : float = 1;


var grid : Grid


func _init(g : Grid):
	grid = g


func step():
	grid.reset_buffer()

	var starting_value
	var remaining_value
	var flow
	var cell

	for y in range(grid.height-1,-1,-1):
		for x in grid.width:
			cell = grid.get_cell(x,y)
			cell.reset_flow()

			if (cell.type == Cell.TYPE.SOLID):
				continue
			if (cell.fluid == 0.0):
				continue
			if (cell.fluid < MIN_VALUE):
				cell.fluid = 0.0
				continue

			starting_value = cell.fluid
			remaining_value = cell.fluid
			flow = 0.0

			# Flow down
			if (cell.down != null and cell.down.type == Cell.TYPE.BLANK):
				flow = calculate_vertical_flow(cell.fluid, cell.down.fluid) - cell.down.fluid
				if (cell.down.fluid > 0.0 and flow > MIN_FLOW):
					flow *= FLOW_SPEED

				flow = clampf(flow, 0, minf(MAX_FLOW, cell.fluid))

				if (flow > 0):
					remaining_value -= flow
					cell.buffer -= flow
					cell.down.buffer += flow
					cell.add_flow(Cell.DOWN)

			if (remaining_value < MIN_VALUE):
				cell.buffer -= remaining_value
				continue

			# Flow left
			if (cell.left != null and cell.left.type == Cell.TYPE.BLANK):
				flow = (remaining_value - cell.left.fluid) / 4.0
				if (flow > MIN_FLOW):
					flow *= FLOW_SPEED

				flow = clampf(flow, 0, minf(MAX_FLOW, cell.fluid))

				if (flow > 0):
					remaining_value -= flow
					cell.buffer -= flow
					cell.left.buffer += flow
					cell.add_flow(Cell.LEFT)

			if (remaining_value < MIN_VALUE):
				cell.buffer -= remaining_value
				continue

			# Flow right
			if (cell.right != null and cell.right.type == Cell.TYPE.BLANK):
				flow = (remaining_value - cell.right.fluid) / 3.0
				if (flow > MIN_FLOW):
					flow *= FLOW_SPEED

				flow = clampf(flow, 0, minf(MAX_FLOW, cell.fluid))

				if (flow > 0):
					remaining_value -= flow
					cell.buffer -= flow
					cell.right.buffer += flow
					cell.add_flow(Cell.RIGHT)

			if (remaining_value < MIN_VALUE):
				cell.buffer -= remaining_value
				continue

			# Flow up
			if (cell.up != null and cell.up.type == Cell.TYPE.BLANK):
				flow = remaining_value - calculate_vertical_flow(remaining_value, cell.up.fluid)
				if (flow > MIN_FLOW):
					flow *= FLOW_SPEED

				flow = clampf(flow, 0, minf(MAX_FLOW, cell.fluid))

				if (flow > 0):
					remaining_value -= flow
					cell.buffer -= flow
					cell.up.buffer += flow
					cell.add_flow(Cell.UP)

			if (remaining_value < MIN_VALUE):
				cell.buffer -= remaining_value
				continue
			
			if (starting_value == remaining_value):
				cell.settle_count += 1
				if (cell.settle_count >= 10):
					cell.reset_flow()
					cell.settled = true
			else:
				cell.unsettle_neighbors()
	
	grid.update(MIN_VALUE)


# Calculate how much liquid should flow to destination with pressure
func calculate_vertical_flow(source : float, destination : float):
	var sum = source + destination

	if (sum <= MAX_VALUE):
		return MAX_VALUE
	elif (sum < 2*MAX_VALUE+MAX_COMPRESSION):
		return (MAX_VALUE*MAX_VALUE+sum*MAX_COMPRESSION) / (MAX_VALUE+MAX_COMPRESSION)
	else:
		return (sum+MAX_COMPRESSION)/2.0
