class_name Darkness
extends TileMap

onready var _marker = $Marker

var _tile_id = INVALID_CELL

func _ready() -> void:
	_tile_id = tile_set.find_tile_by_name("darkness_a")


func spread_randomly() -> void:
	var bounds = get_used_rect()
	var cells = get_used_cells()
	var cell = cells[randi() % cells.size()]
	var directions = []

	if cell.x + 1 < bounds.size.x and get_cell(cell.x + 1, cell.y) == INVALID_CELL:
		directions.append(Vector2(1, 0))
	if cell.x - 1 > 0 and get_cell(cell.x - 1, cell.y) == INVALID_CELL:
		directions.append(Vector2(-1, 0))
	if cell.y + 1 < bounds.size.y and get_cell(cell.x, cell.y + 1) == INVALID_CELL:
		directions.append(Vector2(0, 1))
	if cell.y - 1 > 0 and get_cell(cell.x, cell.y - 1) == INVALID_CELL:
		directions.append(Vector2(0, -1))

	if directions.size() == 0:
		return

	var dir = directions[randi() % directions.size()]
	set_cellv(cell + dir, _tile_id)


func spread_towards(to: Vector2) -> void:
	var target_cell = world_to_map(to)
	var source_cell = Vector2.ZERO
	var min_distance = -1
	for cell in get_used_cells():
		var dist = target_cell.distance_squared_to(cell)
		if min_distance < 0 \
			or dist <= min_distance:
				min_distance = dist
				source_cell = cell

	var direction: Vector2 = target_cell - source_cell

	if abs(direction.x) > abs(direction.y):
		direction.y = 0
	else:
		direction.x = 0

	direction = direction.normalized()

	_marker.position = map_to_world(source_cell) + Vector2(8,8)
	set_cellv(source_cell + direction, _tile_id)
	update_dirty_quadrants()
	update_bitmask_region()
