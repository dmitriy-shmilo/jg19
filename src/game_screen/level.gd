class_name Level
extends Node2D

onready var _screen_shaker: Shaker = $"ScreenShaker"
onready var _right_player: KinematicBody2D = $"Right/RightPlayer"
onready var _left_player: KinematicBody2D = $"Left/LeftPlayer"
onready var _right_player_spawn: Position2D = $"Right/RightPlayerSpawn"
onready var _left_player_spawn: Position2D = $"Left/LeftPlayerSpawn"
onready var _left_tile_map: TileMap = $"Left/LeftTileMap"
onready var _right_tile_map: TileMap = $"Right/RightTileMap"
onready var _hazard: TileMap = $"Right/Darkness"

func _ready() -> void:
	_reset()

func _reset() -> void:
	_right_player_spawn.position = _left_player_spawn.position
	_left_player.position = _left_player_spawn.position
	_right_player.position = _right_player_spawn.position
	_left_player.reset()
	_right_player.reset()


func _lose() -> void:
	_screen_shaker.shake_horizontal(self, "position", 8, 5, 0.25)
	_reset()

func _on_LeftPlayer_died(sender) -> void:
	_lose()


func _on_RightPlayer_died(sender) -> void:
	_lose()
