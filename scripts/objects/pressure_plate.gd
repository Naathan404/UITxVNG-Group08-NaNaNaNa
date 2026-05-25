@tool
extends Area2D

# Tín hiệu báo cho Cửa hoặc Laze biết để đóng/mở
signal plate_pressed
signal plate_released

enum MaskType { NONE, RED, BLUE }

@export_group("Pressure Plate Settings")
@export_enum("Red", "Blue") var plate_color: String = "Red":
	set(value):
		plate_color = value
		_update_visual()

@export var deactivated_alpha: float = 0.2
@export var activated_alpha: float = 1.0


var is_interactive: bool = true:
	set(value):
		is_interactive = value
		_update_visual()

var _is_pressed: bool = false

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	# Kết nối signal va chạm của Area2D
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	add_to_group("pressure_plates")
	_update_visual()

func _update_visual() -> void:
	# Bảo vệ tool tránh crash ngoài Editor
	if sprite == null: 
		return
		
	var current_alpha = activated_alpha if is_interactive else deactivated_alpha
	
	if plate_color == "Red":
		sprite.modulate = Color(1.5, 0.2, 0.2, current_alpha) # Màu Đỏ rực
	else:
		sprite.modulate = Color(0.2, 0.5, 1.5, current_alpha) # Màu Xanh rực


func _update_plate_state(player_mask: int) -> void:
	if player_mask == MaskType.NONE:
		self.is_interactive = true
		return
		
	if plate_color == "Red":
		self.is_interactive = (player_mask == MaskType.RED)
	else:
		self.is_interactive = (player_mask == MaskType.BLUE)
		
	if not is_interactive and _is_pressed:
		_is_pressed = false
		plate_released.emit()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and is_interactive:
		if not _is_pressed:
			_is_pressed = true
			plate_pressed.emit()
			print("[PressurePlate] Tấm màu ", plate_color, " ĐÃ BỊ DẪM LÊN!")

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player" and _is_pressed:
		_is_pressed = false
		plate_released.emit()
		print("[PressurePlate] Tấm màu ", plate_color, " ĐÃ ĐƯỢC NHẢ RA!")
		# Thêm animation nút nảy lên lại ở đây
