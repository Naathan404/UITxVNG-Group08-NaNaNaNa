extends BaseCharacter
class_name Player

### MASK SETTING
@export_group("Oxygen Settings")
@export var max_oxygen: float = 100.0
@export var decrease_oxygen_rate: float
@export var dash_oxygen_cost: float = 10.0

@export_group("Player Abilities")
@export var has_red_mask: bool = false
@export var has_blue_mask: bool = false
@export var dash_unlocked: bool = false
var can_dash: bool = false


### Mask
enum MaskType { NONE, RED, BLUE }
@export_group("Mask Settings")
@export var mask_type: MaskType = MaskType.NONE

var current_oxygen: float = 100.0
var multiplier: float = 1.0
var current_toxic_zone: String = ""
var is_oxygen_decreased: bool = false
var is_oxygen_regen: bool = false
var flash_oxygen: float
var is_dead: bool = false
var is_oxygen_decreased_by_other_source: bool = false

## flag check thắng level
var is_level_completed: bool = false

# signals
signal ability_unlocked(ability_name: String)

# load nodes
@onready var game_ui: GameUI = $CanvasLayer
@onready var camera: Camera2D =  $LevelCamera

func _ready() -> void:
	fsm = FSM.new(self, $States, $States/Idle)
	
	# thiết lập ban đầu cho mặt nạ
	current_oxygen = max_oxygen
	mask_type = MaskType.NONE
	
	# gọi game_ui thiết lập ảnh ban đầu
	if game_ui:
		game_ui.update_avatar_texture(mask_type)
	
	position = GameManager.last_checkpoint_position
	
	super._ready()
	
	if GameManager.last_checkpoint_position != Vector2.ZERO:
		global_position = GameManager.last_checkpoint_position
		print("[Player] Player hồi sinh tại Checkpoint!")
	
func _process(delta: float) -> void:
	if current_toxic_zone != "":
		if mask_type == MaskType.NONE:
			multiplier = 5.0
		elif (current_toxic_zone == "Red" and mask_type == MaskType.RED) or (current_toxic_zone == "Blue" and mask_type == MaskType.BLUE):
			multiplier = 1.0
		else:
			multiplier = 5.0
	else:
		if mask_type == MaskType.NONE:
			multiplier = 0.0
		else:
			multiplier = 1.0
			
	if multiplier == 0 and not is_oxygen_decreased_by_other_source:
		is_oxygen_decreased = false
	else:
		is_oxygen_decreased = true
		
	### nếu đang đứng trên đất thì có thể dash
	if is_on_floor():
		if dash_unlocked:
			can_dash = true
	
	if not is_level_completed:
		current_oxygen -= decrease_oxygen_rate * multiplier * delta
		current_oxygen = clamp(current_oxygen, 0.0, max_oxygen)
		if current_oxygen <= 0.0: 
			_on_oxygen_ran_out()
			
	# gọi game_ui cập nhật giao diện liên tục
	if game_ui:
		if not is_oxygen_regen:
			game_ui.update_ui(current_oxygen, max_oxygen, mask_type, is_oxygen_decreased)
		elif is_oxygen_regen:
			game_ui._update_oxygen_bar_regen(current_oxygen, flash_oxygen, max_oxygen, mask_type, is_oxygen_regen)
		
		
	# rơi xuống thì chết
	if position.y > 130 and not is_dead:
		print("Té chết")
		_on_death()

### Hàm xử lý input
func _input(event: InputEvent) -> void:
	if is_level_completed: return
	
	if fsm.current_state == fsm.states.die:
		return
	# đổi sang mặt nạ đỏ
	if event.is_action_pressed("mask_scroll_up"):
		AudioManager.play_sound("mask_shift_1", global_position, 15.0)
		if game_ui: game_ui._play_hint_bounce(true)
		if(mask_type == MaskType.NONE):
			_on_mask_change(MaskType.RED)
		elif(mask_type == MaskType.RED):
			_on_mask_change(MaskType.BLUE)
		elif(mask_type == MaskType.BLUE):
			_on_mask_change(MaskType.NONE)
		return
		
	if event.is_action_pressed("mask_scroll_down"):
		if game_ui: game_ui._play_hint_bounce(false)
		AudioManager.play_sound("mask_shift_2", global_position, 15.0)
		if(mask_type == MaskType.NONE):
			_on_mask_change(MaskType.BLUE)
		elif(mask_type == MaskType.BLUE):
			_on_mask_change(MaskType.RED)
		elif(mask_type == MaskType.RED):
			_on_mask_change(MaskType.NONE)
		return
		
	#if event.is_action_pressed("quit"):
		#get_tree().quit

		
# Hàm đổi mặt nạ
func _on_mask_change(mask: MaskType) -> bool:
	if mask_type == mask: return false
	if mask == MaskType.RED and not has_red_mask: return false
	if mask == MaskType.BLUE and not has_blue_mask: return false
	if not has_red_mask and not has_blue_mask: return false
	
	mask_type = mask
	
	# gọi game_ui đổi texture cho avatar
	if game_ui:
		game_ui.update_avatar_texture(mask_type)
		
	print("[Player] Đổi sang mặt nạ ", mask_type)
	
	if current_anim_name != "":
		if current_anim_name == "idle" or current_anim_name == "idle_red" or current_anim_name == "idle_blue":
			if mask_type == MaskType.NONE: change_animation("idle")
			elif mask_type == MaskType.RED: change_animation("idle_red")
			elif mask_type == MaskType.BLUE: change_animation("idle_blue")
		elif (current_anim_name == "run" or current_anim_name == "run_red" or current_anim_name == "run_blue"):
			if mask_type == MaskType.NONE: change_animation("run")
			elif mask_type == MaskType.RED: change_animation("run_red")
			elif mask_type == MaskType.BLUE: change_animation("run_blue")
		elif (current_anim_name == "jump" or current_anim_name == "jump_red" or current_anim_name == "jump_blue"):
			if mask_type == MaskType.NONE: change_animation("jump")
			elif mask_type == MaskType.RED: change_animation("jump_red")
			elif mask_type == MaskType.BLUE: change_animation("jump_blue")
		elif (current_anim_name == "fall" or current_anim_name == "fall_red" or current_anim_name == "fall_blue"):
			if mask_type == MaskType.NONE: change_animation("fall")
			elif mask_type == MaskType.RED: change_animation("fall_red")
			elif mask_type == MaskType.BLUE: change_animation("fall_blue")
		elif (current_anim_name == "dash" or current_anim_name == "dash_red" or current_anim_name == "dash_blue"):
			if mask_type == MaskType.NONE: change_animation("dash")
			elif mask_type == MaskType.RED: change_animation("dash_red")
			elif mask_type == MaskType.BLUE: change_animation("dash_blue")
	
	get_tree().call_group("spikes", "_update_spike_state", mask_type)
	get_tree().call_group("platforms", "update_platform_state", mask_type)
	get_tree().call_group("colored_glass", "_update_colored_glass_state", mask_type)
	get_tree().call_group("saw", "update_mask_state", mask_type)
	return true

# Hàm hồi Oxy khi nhặt được bình
func _refill_oxygen(amount: float) -> void:
	if is_level_completed: return
	
	print("[Player] Đã hồi ", amount, " oxy!")
	is_oxygen_regen = true
	flash_oxygen = current_oxygen;
	flash_oxygen += amount;
	flash_oxygen = clamp(flash_oxygen, 0.0, max_oxygen)
	
	if game_ui:
		if amount >= 25.0: game_ui.alarm_sfx_played = false
		game_ui._update_oxygen_bar_regen(current_oxygen, flash_oxygen, max_oxygen, mask_type, is_oxygen_regen)
	
	var tween = create_tween()
	tween.tween_property(self, "current_oxygen", flash_oxygen, 0.5)
	await  tween.finished
	is_oxygen_regen = false


# Xử lý khi hết sạch oxy
func _on_oxygen_ran_out() -> void:
	if is_dead: return
	print("[Player] Hết oxy! Game Over!")
	# Tạm thời reset lại màn
	_on_death()

# hàm gọi xử lý chuỗi sự kiện chết
func _on_death() -> void:
	if is_dead: return
	get_tree().paused = false
	# set flags
	is_dead = true
	multiplier = 0.0
	# cập nhật gioa diẹne
	if game_ui: game_ui.update_ui(current_oxygen, max_oxygen, mask_type, is_oxygen_decreased)
	print("[Player] Người chơi đã die -> Reset màn chơi")
	fsm.change_state(fsm.states.die)

# trừ máu khi đạn bắn trúng
func take_dame(damage_amount: float) -> void:
	if is_dead or is_level_completed: return
	current_oxygen -= damage_amount
	current_oxygen = clamp(current_oxygen, 0.0, max_oxygen)
	
	if game_ui:
		game_ui.update_ui(current_oxygen, max_oxygen, mask_type, true)
	if current_oxygen <= 0.0:
		_on_oxygen_ran_out()

func _complete_level() -> void:
	_on_mask_change(MaskType.NONE)
	change_animation("idle")
	if camera and camera.has_method("zoom_to"):
		camera.zoom_to(Vector2(1.5, 1.5), 1.0)
	is_level_completed = true
