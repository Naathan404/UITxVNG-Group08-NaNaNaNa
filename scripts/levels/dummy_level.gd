extends Node

@export var left: float = -100
@export var right: float = 10000
@export var top: float = -10000
@export var bottom: float = 140

@onready var cam: Camera2D = $Player/LevelCamera

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_music("bgm_03", -5.0, 1.0)
	AudioManager.set_bus_volume(AudioManager.BGM_BUS, 0.1)
	
	cam.limit_left = left
	cam.limit_right = right
	cam.limit_top = top
	cam.limit_bottom = bottom
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
