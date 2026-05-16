extends BaseCharacter

### MASK SETTING
@export var max_oxygen: float = 100.0
@export var decrease_oxygen_rate: float = 5.0
var current_oxygen: float = 100.0

### Mask
enum MaskType { NONE, RED, BLUE }
@export var mask_type: MaskType = MaskType.NONE

### UI for Mask
@onready var oxygen_bar: ProgressBar = $CanvasLayer/OxygenBar
@onready var avatar_react: TextureRect = $CanvasLayer/AvatarReact
@onready var oxygen_particle: CPUParticles2D = $CanvasLayer/OxygenBar/OxygenRanOutParticles
const AVATAR_NONE = preload("res://assets/sprites/ui/avatar_react/none_mask.png")
const AVATAR_RED = preload("res://assets/sprites/ui/avatar_react/mask_red.png")
const AVATAR_BLUE = preload("res://assets/sprites/ui/avatar_react/mask_blue.png")

# avatar shake setting
@export var shake_strenght: float = 3.0
var avatar_original_position: Vector2

func _ready() -> void:
	fsm = FSM.new(self, $States, $States/Idle)
	
	# thiết lập ban đầu cho mặt nạ
	current_oxygen = max_oxygen
	mask_type = MaskType.NONE
	
	# ui mặt nạ và thanh oxygen bar
	oxygen_bar.max_value = max_oxygen
	oxygen_bar.value = current_oxygen
	avatar_react.texture = AVATAR_NONE
	
	# game juice
	oxygen_particle.emitting = false
	avatar_original_position = avatar_react.position
	
	super._ready()
	
func _process(delta: float) -> void:
	if mask_type != MaskType.NONE:
		var multiplier: float = 1.0
		current_oxygen -= decrease_oxygen_rate * multiplier * delta
		current_oxygen = clamp(current_oxygen, 0.0, max_oxygen)
		oxygen_bar.value = current_oxygen
		
		# particle cho oxygen
		oxygen_particle.emitting = true
		var ratio = current_oxygen / max_oxygen
		var bar_height = oxygen_bar.size.y
		
		oxygen_particle.position.y = bar_height - bar_height * ratio
		oxygen_particle.position.x = oxygen_bar.size.x / 2
		
	# nếu oxy tuột dưới 25% thì báo đỏ
	if current_oxygen < max_oxygen * 0.25:
		if(mask_type == MaskType.RED):
			avatar_react.modulate = Color(2.0, 0.5, 0.5)
		elif(mask_type == MaskType.BLUE):
			avatar_react.modulate = Color(0.5, 0.5, 2.0)
		elif(mask_type == MaskType.NONE):
			avatar_react.modulate = Color(1.0, 1.0, 1.0)
		_shake_avatar(delta)
	else:
		avatar_react.modulate = Color(1.0, 1.0, 1.0)
			
	if current_oxygen <= 0.0: 
		_on_oxygen_ran_out()

### Hàm xử lý input
func _input(event: InputEvent) -> void:
	# đổi sang mặt nạ đỏ
	if event.is_action_pressed("mask_red"):
		_on_mask_change(MaskType.RED)
		return
	# mặt nạ xanh	
	elif event.is_action_pressed("mask_blue"):
		_on_mask_change(MaskType.BLUE)
		return
	elif event.is_action_pressed("unmask"):
		_on_mask_change(MaskType.NONE)
		return
		
# Hàm đổi mặt nạ
func _on_mask_change(mask: MaskType) -> bool:
	if mask_type == mask: return false
	mask_type = mask
	if mask == MaskType.NONE: avatar_react.texture = AVATAR_NONE
	elif mask == MaskType.BLUE: avatar_react.texture = AVATAR_BLUE
	elif mask == MaskType.RED: avatar_react.texture = AVATAR_RED
	print("Đổi sang mặt nạ ", mask_type)
	fsm.current_state._enter()
	return true

# Hàm hồi Oxy khi nhặt được bình
func refill_oxygen(amount: float) -> void:
	current_oxygen += amount
	current_oxygen = clamp(current_oxygen, 0.0, max_oxygen)
	oxygen_bar.value = current_oxygen
	print("Đã hồi ", amount, " oxy!")

# Xử lý khi hết sạch oxy
func _on_oxygen_ran_out() -> void:
	print("Hết oxy! Game Over!")
	# Tạm thời reset lại màn 
	get_tree().reload_current_scene()

# rung cái avatar
func _shake_avatar(_delta: float) -> void:
	var random_x = randf_range(-shake_strenght, shake_strenght)
	var random_y = randf_range(-shake_strenght, shake_strenght)
	
	# Cộng dồn độ lệch ngẫu nhiên vào vị trí gốc
	avatar_react.position = avatar_original_position + Vector2(random_x, random_y)
