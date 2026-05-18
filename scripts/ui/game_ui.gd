extends CanvasLayer
class_name GameUI

@onready var oxygen_bar: ProgressBar = $OxygenBar
@onready var avatar_react: TextureRect = $AvatarReact
@onready var oxygen_particle: CPUParticles2D = $OxygenBar/OxygenRanOutParticles
@onready var death_screen: ColorRect = $DeathScreen


const AVATAR_NONE = preload("res://assets/sprites/ui/avatar_react/none_mask.png")
const AVATAR_RED = preload("res://assets/sprites/ui/avatar_react/mask_red.png")
const AVATAR_BLUE = preload("res://assets/sprites/ui/avatar_react/mask_blue.png")

# avatar shake setting
@export var shake_strenght: float = 2.0
var avatar_original_position: Vector2

func _ready() -> void:
	oxygen_particle.emitting = false
	call_deferred("_save_original_position")

func _save_original_position() -> void:
	avatar_original_position = avatar_react.position

#  Player gọi hàm này liên tục mỗi khung hình
func update_ui(current_oxygen: float, max_oxygen: float, mask_type: int, is_oxygen_decreased: bool) -> void:
	oxygen_bar.max_value = max_oxygen
	oxygen_bar.value = current_oxygen
	
	if mask_type != 0 or is_oxygen_decreased: # != MaskType.NONE
		
		# particle cho oxygen
		oxygen_particle.emitting = true
		var ratio = current_oxygen / max_oxygen
		var bar_height = oxygen_bar.size.y

		oxygen_particle.position.y = bar_height - bar_height * ratio
		oxygen_particle.position.x = oxygen_bar.size.x / 2
	else:
		oxygen_particle.emitting = false	
	
	
	### Xử lý thanh oxygen và avatar
	# nếu oxy tuột dưới 25% thì báo đỏ
	if current_oxygen < max_oxygen * 0.25:
		if(mask_type == 1): # MaskType.RED
			avatar_react.modulate = Color(2.0, 0.5, 0.5)
		elif(mask_type == 2): # MaskType.BLUE
			avatar_react.modulate = Color(0.5, 0.5, 2.0)
		elif(mask_type == 0):
			avatar_react.modulate = Color(1.0, 1.0, 1.0)
		_shake_avatar()
	else:
		avatar_react.modulate = Color(1.0, 1.0, 1.0)
		avatar_react.position = avatar_original_position
	
		


# Hàm đổi avatar rect
func update_avatar_texture(mask_type: int) -> void:
	if mask_type == 0: avatar_react.texture = AVATAR_NONE
	elif mask_type == 1: avatar_react.texture = AVATAR_RED
	elif mask_type == 2: avatar_react.texture = AVATAR_BLUE

# rung cái avatar
func _shake_avatar() -> void:
	var random_x = randf_range(-shake_strenght, shake_strenght)
	var random_y = randf_range(-shake_strenght, shake_strenght)
	# Cộng dồn độ lệch ngẫu nhiên vào vị trí gốc
	avatar_react.position = avatar_original_position + Vector2(random_x, random_y)
	
func play_death_transition() -> Signal:
	death_screen.color = Color(0, 0, 0, 0.0) 
	
	var tween = create_tween()
	tween.tween_property(death_screen, "color:a", 1.0, 0.5)
	
	return tween.finished
	
	
