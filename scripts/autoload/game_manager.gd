extends Node

@export var max_lives: int = 999
var last_checkpoint_position: Vector2 = Vector2.ZERO
var current_lives: int

var max_unlocked_level: int = 1

signal dash_trigger

func _ready() -> void:
	current_lives = max_lives

func _set_checkpoint(new_checkpoint: Vector2) -> bool:
	# nếu là vị trí cp cũ
	if(new_checkpoint == last_checkpoint_position): return false
	last_checkpoint_position = new_checkpoint
	return true

func _reset_checkpoint() -> void:
	current_lives = max_lives
	last_checkpoint_position = Vector2.ZERO
	print("[GameManager] Reset màn chơi -> Còn " + str(current_lives) + " mạng")
	
