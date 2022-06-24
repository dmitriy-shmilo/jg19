class_name Level
extends Node2D

onready var _darkness_tile_map: TileMap = $"Right/DarknessTileMap"
onready var _darkness_spawn: Position2D = $"Right/DarknessSpawn"
onready var _screen_shaker: Shaker = $"ScreenShaker"
onready var _right_player: KinematicBody2D = $"Right/RightPlayer"
onready var _left_player: KinematicBody2D = $"Left/LeftPlayer"
onready var _right_player_spawn: Position2D = $"Right/RightPlayerSpawn"
onready var _left_player_spawn: Position2D = $"Left/LeftPlayerSpawn"
onready var _tile_map: TileMap = $"TileMap"

func _ready() -> void:
	_mirror_map()
	_reset()


func _reset() -> void:
	_right_player_spawn.position = _left_player_spawn.position
	_left_player.position = _left_player_spawn.position
	_right_player.position = _right_player_spawn.position
	_left_player.reset()
	_right_player.reset()
	_darkness_tile_map.clear()
	var dark_tile = _darkness_tile_map.world_to_map(_darkness_spawn.position)
	_darkness_tile_map.set_cellv(dark_tile, 0)


func _mirror_map() -> void:
	var bounds = _tile_map.get_used_rect()
	var middle = bounds.size.x / 2

	for x in range(bounds.position.x, bounds.end.x / 2):
		for y in range(bounds.position.y, bounds.end.y):
			var target = Vector2(bounds.end.x - x - 2, y)
			_tile_map.set_cellv(target, _tile_map.get_cell(x, y))

	_tile_map.update_bitmask_region()


func _lose() -> void:
	_screen_shaker.shake_horizontal(self, "position", 8, 5, 0.25)
	_reset()

func _on_LeftPlayer_died(sender) -> void:
	_lose()


func _on_RightPlayer_died(sender) -> void:
	_lose()


func _on_SpreadingTimer_timeout() -> void:
	_darkness_tile_map.spread_towards(_right_player.position)
	_darkness_tile_map.spread_randomly()

func _on_LeftPlayer_joined() -> void:
	_reset()
