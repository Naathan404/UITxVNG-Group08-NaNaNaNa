extends Control

@onready var title: TextureRect = $Title
@onready var grid: GridContainer = $GridContainer

@export var scene_to_load_path: String

@export var floating_offset_y: float = 5.0
@export var floating_duration: float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_music("bgm_menu")
	
	# floating title
	var original_pos_y = title.position.y
	var tween = create_tween().set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(title, "position:y", original_pos_y - floating_offset_y, floating_duration)
	tween.tween_property(title, "position:y", original_pos_y, floating_duration);
	
	var current_unlocked = GameManager.max_unlocked_level
	for button in grid.get_children():
		if button is TextureButton\
			and button.has_method("setup_lock_state"):
			button.setup_lock_state(current_unlocked)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_close_pressed() -> void:
	AudioManager.play_sound("click", global_position, 10.0)
	SceneTransition._change_scene(scene_to_load_path)
	pass # Replace with function body.
