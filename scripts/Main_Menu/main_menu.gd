extends Control
# Called when the node enters the scene tree for the first time.
var game_play = preload("res://dummy_level.tscn")

@onready var title: TextureRect = $Node/Title

func _ready() -> void:
	AudioManager.play_music("bgm_menu")
	
	var title_origin_position = title.position
	var tween = create_tween().set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(title, "position:y", title_origin_position.y - 5.0, 0.5)
	tween.tween_property(title, "position:y", title_origin_position.y, 0.5)
	

func _on_start_pressed() -> void:
	SceneTransition._change_scene("res://dummy_level.tscn")
	AudioManager.play_sound("click", global_position, 5.0)

func _on_setting_pressed() -> void:
	AudioManager.play_sound("click", global_position, 5.0)

	
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	AudioManager.play_sound("click", global_position, 5.0)
	
	get_tree().quit()
