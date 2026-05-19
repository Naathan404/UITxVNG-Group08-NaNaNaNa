extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_music("bgm_03", -5.0, 1.0)
	AudioManager.set_bus_volume(AudioManager.BGM_BUS, 0.1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
