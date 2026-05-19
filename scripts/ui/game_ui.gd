extends CanvasLayer
class_name GameUI

# get nodes
# main progress ui
@onready var oxygen_bar: TextureProgressBar = $OxygenBar
@onready var flash_bar: TextureProgressBar = $OxygenBar/FlashBar
@onready var avatar_react: TextureRect = $AvatarReact
@onready var oxygen_particle: CPUParticles2D = $OxygenBar/OxygenRanOutParticles
# hints
@onready var hint_up: TextureRect = $HintUp
@onready var hint_down: TextureRect = $HintDown
# over render on screen
@onready var death_screen: ColorRect = $DeathScreen

var is_oxygen_bar_blocked: bool = false
var is_regen: bool = false
var flash_timer: float = 0.0
const FLASH_DELAY: float = 0.5

var alarm_sfx_played: bool = false

const AVATAR_NONE = preload("res://assets/sprites/ui/avatar_react/none_mask.png")
const AVATAR_RED = preload("res://assets/sprites/ui/avatar_react/mask_red.png")
const AVATAR_BLUE = preload("res://assets/sprites/ui/avatar_react/mask_blue.png")

# particle settings
@export var oxygen_bar_radius: float = 24.0

# avatar shake setting
@export var shake_strenght: float = 2.0
var avatar_original_position: Vector2

func _ready() -> void:
	oxygen_particle.emitting = false
	call_deferred("_save_original_position")
	
func _process(delta: float) -> void:
	if is_regen: return 
	if flash_bar.value > oxygen_bar.value:
		flash_timer -= delta
		
		if flash_timer <= 0.0:
			flash_bar.value = lerpf(flash_bar.value, oxygen_bar.value, delta * 10.0)
			if (flash_bar.value - oxygen_bar.value) < 0.5:
				flash_bar.value = oxygen_bar.value
	else:
		flash_bar.value = oxygen_bar.value
		flash_timer = FLASH_DELAY

func _save_original_position() -> void:
	avatar_original_position = avatar_react.position

#  Player gọi hàm này liên tục mỗi khung hình
func update_ui(current_oxygen: float, max_oxygen: float, mask_type: int, is_oxygen_decreased: bool) -> void:
	is_regen = false
	oxygen_bar.max_value = max_oxygen
	flash_bar.max_value = max_oxygen
	oxygen_bar.value = current_oxygen
	oxygen_bar.tint_progress = Color(0.181, 0.956, 1.0)
	oxygen_particle.color = Color(0.181, 0.956, 1.0)
	
	if mask_type != 0 or is_oxygen_decreased: # != MaskType.NONE
		_handle_oxygen_particle(current_oxygen, max_oxygen)
	else:
		oxygen_particle.emitting = false	
	
	_handle_hint_buttons(mask_type)
	
	### Xử lý thanh oxygen và avatar
	# nếu oxy tuột dưới 25% thì báo đỏ
	if current_oxygen < max_oxygen * 0.25:
		if not alarm_sfx_played:
			AudioManager.play_sound("alarm", Vector2.ZERO, 10.0)
			alarm_sfx_played = true
			alarm_sfx_played = true
		oxygen_bar.tint_progress = Color(1.0, 0.6, 0.6)
		oxygen_particle.color = Color(1.0, 0.6, 0.6)
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
	await get_tree().create_timer(0.15).timeout
	flash_bar.value = current_oxygen
	
	if not alarm_sfx_played and current_oxygen >= max_oxygen * 0.25:
		alarm_sfx_played = false
	
func _update_oxygen_bar_regen(current_oxygen: float, flash_oxygen: float, max_oxygen: float, mask_type: int, is_oxygen_regen: bool) -> void:
	is_regen = true
	oxygen_bar.max_value = max_oxygen
	flash_bar.max_value = max_oxygen
	flash_bar.value = flash_oxygen
	
	
	if is_oxygen_regen: # != MaskType.NONE
		oxygen_bar.value = current_oxygen
		_handle_oxygen_particle(current_oxygen, max_oxygen)
	else:
		oxygen_particle.emitting = false	
	
	
	_handle_hint_buttons(mask_type)
	
	### Xử lý thanh oxygen và avatar
	# nếu oxy tuột dưới 25% thì báo đỏ
	if current_oxygen < max_oxygen * 0.25:
		oxygen_bar.tint_progress = Color(1.0, 0.6, 0.6)
		oxygen_particle.color = Color(1.0, 0.6, 0.6)
		if(mask_type == 1): # MaskType.RED
			avatar_react.modulate = Color(2.0, 0.5, 0.5)
		elif(mask_type == 2): # MaskType.BLUE
			avatar_react.modulate = Color(0.5, 0.5, 2.0)
		elif(mask_type == 0):
			avatar_react.modulate = Color(1.0, 1.0, 1.0)
		_shake_avatar()
	else:
		avatar_react.modulate = Color(1.0, 1.0, 1.0)
		oxygen_bar.tint_progress = Color(0.181, 0.956, 1.0)
		oxygen_particle.color = Color(0.181, 0.956, 1.0)
		avatar_react.position = avatar_original_position

	if not alarm_sfx_played and flash_oxygen >= max_oxygen * 0.25:
		alarm_sfx_played = false
	pass
		
func _handle_oxygen_particle(current_oxygen: float, max_oxygen: float) -> void:
	# particle cho oxygen
	oxygen_particle.emitting = true
	
	var ratio = current_oxygen / max_oxygen
	var bar_center = oxygen_bar.size / 2.0
	var angle = PI / 2.0 - ratio * PI
	
	oxygen_particle.position.x = round(bar_center.x + cos(angle) * oxygen_bar_radius)
	oxygen_particle.position.y = round(bar_center.y + sin(angle) * oxygen_bar_radius)

	pass
	
func _handle_hint_buttons(mask_type: int) -> void:
	if mask_type == 0:
		hint_up.self_modulate = Color.CRIMSON
		hint_down.self_modulate = Color.ROYAL_BLUE
	elif mask_type == 1:
		hint_up.self_modulate = Color.ROYAL_BLUE
		hint_down.self_modulate = Color.WHITE
	elif mask_type == 2:
		hint_up.self_modulate = Color.WHITE
		hint_down.self_modulate = Color.CRIMSON
	pass

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
	
func _play_death_transition() -> Signal:
	death_screen.color = Color(0, 0, 0, 0.0) 
	
	var tween = create_tween()
	tween.tween_property(death_screen, "color:a", 1.0, 0.5)
	
	return tween.finished
	
func _play_hint_bounce(is_scroll_up: bool) -> void:
	var tween = create_tween()
	if(is_scroll_up):
		tween.tween_property(hint_up, "scale", Vector2(1.3, 1.3), 0.1).set_trans(Tween.TRANS_SINE)
		tween.tween_property(hint_up, "scale", Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_BOUNCE)
		hint_up.modulate = Color(1.5, 1.5, 1.5)
		tween.parallel().tween_property(hint_up, "modulate", Color(1.0, 1.0, 1.0), 0.2)
	else:
		tween.tween_property(hint_down, "scale", Vector2(1.3, 1.3), 0.1).set_trans(Tween.TRANS_SINE)
		tween.tween_property(hint_down, "scale", Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_BOUNCE)
		hint_down.modulate = Color(1.5, 1.5, 1.5)
		tween.parallel().tween_property(hint_down, "modulate", Color(1.0, 1.0, 1.0), 0.2)
	
	tween.parallel().tween_property(avatar_react, "scale", Vector2(1.1, 1.1), 0.1).set_trans(Tween.TRANS_SINE)
	tween.tween_property(avatar_react, "scale", Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_BOUNCE)
	pass
