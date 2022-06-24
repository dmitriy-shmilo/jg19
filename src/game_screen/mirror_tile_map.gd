class_name MirrorTileMap
extends TileMap

export(NodePath) var original_tile_map = ""

var _tile_map: TileMap

func _ready() -> void:
	_tile_map = get_node(original_tile_map) as TileMap
	tile_set = _tile_map.tile_set
	for cell in _tile_map.get_used_cells():
		set_cellv(cell, _tile_map.get_cellv(cell))
