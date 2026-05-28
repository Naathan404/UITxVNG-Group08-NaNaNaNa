extends TextureButton

@export var level_number: int = 1
@export_file("*.tscn") var level_scene_path: String 

@onready var lock: TextureRect = $TextureRect
@onready var label: Label = $Label

func _ready() -> void:
	lock.visible = false
	self.disabled = false;
	if level_number <= 9:
		label.text = "0" + str(level_number)
	else:
		label.text = str(level_number)
	pressed.connect(_on_pressed)


func setup_lock_state(max_unlocked_level: int) -> void:
	if level_number > max_unlocked_level:
		self.disabled = true;
		lock.visible = true;

func _on_pressed() -> void:
	print("Đang tải màn chơi số: ", level_number)
	AudioManager.play_sound("click", global_position, 10.0)
	GameManager._reset_checkpoint()	
	
	if level_scene_path != "":
		SceneTransition._change_scene(level_scene_path)
