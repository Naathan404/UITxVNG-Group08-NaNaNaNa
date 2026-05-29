extends Control
# Called when the node enters the scene tree for the first time.
@export var scene_to_load_path: String

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
	SceneTransition._change_scene(scene_to_load_path)
	AudioManager.play_sound("click", global_position, 10.0)
	AudioManager.stop_music(0.5)

func _on_setting_pressed() -> void:
	AudioManager.play_sound("click", global_position, 10.0)
	var settings = preload("res://scripts/menu/settings_menu.gd").new()
	add_child(settings)


func _on_quit_pressed() -> void:
	AudioManager.play_sound("click", global_position, 10.0)
	
	get_tree().quit()


func _on_credit_pressed() -> void:
	AudioManager.play_sound("click", global_position, 10.0)
	SceneTransition._change_scene("res://scenes/menu/credit_scene.tscn")
