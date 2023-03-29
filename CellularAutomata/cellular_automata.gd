class_name CellularAutomata

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
var buffer : Buffer


func _init(g : Grid):
	grid = g
	buffer = Buffer.new(grid.width,grid.height)


func step():
	buffer.reset()
	
	#var starting_value
	var remaining_value
	var flow
	var temp
	var cell
	
	for y in range(grid.height-1,-1,-1):
		for x in grid.width:
			cell = grid.get_cell(x,y)
			
			if (cell.type == Cell.CELL_TYPE.SOLID):
				continue
			if (cell.liquid == 0.0):
				continue
			if (cell.liquid < MIN_VALUE):
				cell.liquid = 0.0
				continue
			
			#starting_value = cell.liquid
			remaining_value = cell.liquid
			flow = 0.0
			
			# Flow down
			if (cell.down != null and cell.down.type == Cell.CELL_TYPE.BLANK):
				flow = calculate_vertical_flow(cell.liquid, cell.down.liquid) - cell.down.liquid
				if (flow > MIN_FLOW):
					flow *= FLOW_SPEED
				
				flow = maxf(flow,0)
				temp = minf(MAX_FLOW,cell.liquid)
				if (flow > temp):
					flow = temp
				
				if (flow > 0):
					remaining_value -= flow
					buffer.remove(x,y,flow)
					buffer.add(x,y+1,flow)
			
			if (remaining_value < MIN_VALUE):
				buffer.remove(x,y,remaining_value)
				continue
			
			# Flow left
			if (cell.left != null and cell.left.type == Cell.CELL_TYPE.BLANK):
				flow = (remaining_value - cell.left.liquid) / 4.0
				if (flow > MIN_FLOW):
					flow *= FLOW_SPEED
				
				flow = maxf(flow,0)
				temp = minf(MAX_FLOW,cell.liquid)
				if (flow > temp):
					flow = temp
				
				if (flow > 0):
					remaining_value -= flow
					buffer.remove(x,y,flow)
					buffer.add(x-1,y,flow)
			
			if (remaining_value < MIN_VALUE):
				buffer.remove(x,y,remaining_value)
				continue
			
			# Flow right
			if (cell.right != null and cell.right.type == Cell.CELL_TYPE.BLANK):
				flow = (remaining_value - cell.right.liquid) / 3.0
				if (flow > MIN_FLOW):
					flow *= FLOW_SPEED
				
				flow = maxf(flow,0)
				temp = minf(MAX_FLOW,cell.liquid)
				if (flow > temp):
					flow = temp
				
				if (flow > 0):
					remaining_value -= flow
					buffer.remove(x,y,flow)
					buffer.add(x+1,y,flow)
			
			if (remaining_value < MIN_VALUE):
				buffer.remove(x,y,remaining_value)
				continue
			
			# Flow up
			if (cell.up != null and cell.up.type == Cell.CELL_TYPE.BLANK):
				flow = remaining_value - calculate_vertical_flow(remaining_value, cell.up.liquid)
				if (flow > MIN_FLOW):
					flow *= FLOW_SPEED
				
				flow = maxf(flow,0)
				temp = minf(MAX_FLOW,cell.liquid)
				if (flow > temp):
					flow = temp
				
				if (flow > 0):
					remaining_value -= flow
					buffer.remove(x,y,flow)
					buffer.add(x,y-1,flow)
			
			if (remaining_value < MIN_VALUE):
				buffer.remove(x,y,remaining_value)
				continue
	
	for i in grid.cells.size():
		grid.cells[i].liquid += buffer.values[i]
		if (grid.cells[i].liquid < MIN_VALUE):
			grid.cells[i].liquid = 0
	
	grid.update()


# Calculate how much liquid should flow to destination with pressure
func calculate_vertical_flow(source : float, destination : float):
	var sum = source + destination
	
	if (sum <= MAX_VALUE):
		return MAX_VALUE
	elif (sum < 2*MAX_VALUE+MAX_COMPRESSION):
		return (MAX_VALUE*MAX_VALUE+sum*MAX_COMPRESSION) / (MAX_VALUE+MAX_COMPRESSION)
	else:
		return (sum+MAX_COMPRESSION)/2.0
