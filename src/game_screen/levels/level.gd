class_name Level
extends Node2D

const REUNION_SCENE = preload("res://game_screen/reunion.tscn")
const CORPSE_SCENE = preload("res://game_screen/corpse.tscn")

signal finished(sender, retries)
signal lost(sender)

export(String) var level_title = ""
export(bool) var has_darkness = true
export(float) var spread_time = 2.0

onready var _spreading_timer: Timer = $"SpreadingTimer"
onready var _darkness_tile_map: TileMap = $"Right/DarknessTileMap"
onready var _darkness_spawn: Position2D = $"Right/DarknessSpawn"
onready var _right_player: Player = $"Right/RightPlayer"
onready var _left_player: Player = $"Left/LeftPlayer"
onready var _right_player_spawn: Position2D = $"Right/RightPlayerSpawn"
onready var _left_player_spawn: Position2D = $"Left/LeftPlayerSpawn"
onready var _tile_map: TileMap = $"TileMap"

var _dark_tile = TileMap.INVALID_CELL
var _united = false
var _retries = 0
var _left_corpse: Corpse
var _right_corpse: Corpse
var _audio_player: AudioStreamPlayer

func _ready() -> void:
	_spreading_timer.wait_time = spread_time
	_mirror_map()
	_reset()
	_left_corpse = CORPSE_SCENE.instance()
	_right_corpse = CORPSE_SCENE.instance()
	_right_corpse.is_mirror = true
	add_child(_left_corpse)
	add_child(_right_corpse)

	_audio_player = AudioStreamPlayer.new()
	add_child(_audio_player)


func _reset() -> void:
	_right_player_spawn.position = _left_player_spawn.position
	_left_player.position = _left_player_spawn.position
	_right_player.position = _right_player_spawn.position
	_left_player.reset()
	_right_player.reset()

	if has_darkness:
		_spreading_timer.start()
		_darkness_tile_map.clear()
		_dark_tile = _darkness_tile_map.tile_set.find_tile_by_name("darkness_a")
		var pos = _darkness_tile_map.world_to_map(_darkness_spawn.position)
		_darkness_tile_map.set_cellv(pos, _dark_tile)


func _mirror_map() -> void:
	var bounds = _tile_map.get_used_rect()
	var middle = bounds.size.x / 2

	for x in range(bounds.position.x, bounds.end.x / 2):
		for y in range(bounds.position.y, bounds.end.y):
			var target = Vector2(bounds.end.x - x - 2, y)
			_tile_map.set_cellv(target, _tile_map.get_cell(x, y))

	_tile_map.update_bitmask_region()


func _lose() -> void:
	emit_signal("lost", self)
	_retries += 1
	_reset()


func _on_LeftPlayer_died(sender) -> void:
	_left_corpse.global_position = sender.global_position
	_left_corpse.start()
	_lose()


func _on_RightPlayer_died(sender) -> void:
	_right_corpse.global_position = sender.global_position
	_right_corpse.start()
	_lose()


func _on_SpreadingTimer_timeout() -> void:
	if _united:
		_spreading_timer.stop()
		return

	_audio_player.stream = preload("res://assets/sound/spread.wav")
	_audio_player.play()
	_darkness_tile_map.spread_towards(_right_player.position)
	_darkness_tile_map.spread_randomly()
	_darkness_tile_map.spread_randomly()


func _on_LeftPlayer_joined() -> void:
	if _united:
		return

	_united = true
	_left_player.queue_free()
	_right_player.queue_free()
	var reunion = REUNION_SCENE.instance()
	var pos = (_left_player.position + _right_player.position) / 2
	pos.x += 8
	reunion.position = pos
	add_child(reunion)
	reunion.unite()

	emit_signal("finished", self, _retries)
