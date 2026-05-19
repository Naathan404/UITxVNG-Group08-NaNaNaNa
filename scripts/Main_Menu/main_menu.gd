extends Control
# Called when the node enters the scene tree for the first time.
var game_play = preload("res://dummy_level.tscn")

func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(game_play)

func _on_setting_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()
