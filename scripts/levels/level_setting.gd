extends Node

@export_group("Camera Bound")
@export var left: int = -100
@export var right: int = 10000
@export var top: int = -10000
@export var bottom: int = 140

@export_group("Music")
@export var bgm_name: String

@export_group("Player Setting")

@onready var cam: Camera2D = $Player/LevelCamera
@onready var player: Player = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_music(bgm_name, -3.0, 1.0)
	AudioManager.set_bus_volume(AudioManager.BGM_BUS, 0.1)
	
	# giới hạn lại camera
	cam.limit_left = left
	cam.limit_right = right
	cam.limit_top = top
	cam.limit_bottom = bottom
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
