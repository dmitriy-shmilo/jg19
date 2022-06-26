class_name MirrorTileMap
extends TileMap

export(NodePath) var original_tile_map = ""

onready var _crumble_tile = tile_set.find_tile_by_name("crumble")
var _tile_map: TileMap
var _crumbled_tiles: Dictionary = {}

func reset() -> void:
	for pos in _crumbled_tiles.keys():
		set_cellv(pos, _crumble_tile)

	_crumbled_tiles.clear()
	update_bitmask_region()


func collide(collision: KinematicCollision2D) -> void:
	var pos = collision.position - collision.normal
	pos = world_to_map(pos)


	var tile = get_cellv(pos)
	if tile != _crumble_tile:
		return

	if collision.normal.y >= 0 or abs(collision.normal.y) <= abs(collision.normal.x):
		return

	if _crumbled_tiles.has(pos):
		return

	_crumbled_tiles[pos] = true
	var timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "_on_timer_timeout", [timer, pos])
	timer.start(0.75)


func _on_timer_timeout(timer: Timer, pos: Vector2) -> void:
	timer.queue_free()
	if not _crumbled_tiles.has(pos):
		return

	set_cellv(pos, INVALID_CELL)

	var crumbles = preload("res://game_screen/crumbles.tscn").instance()
	crumbles.global_position = map_to_world(pos) + Vector2(8, 8)
	add_child(crumbles)
