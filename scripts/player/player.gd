extends BaseCharacter

### MASK SETTING
@export var max_oxygen: float = 100.0
@export var decrease_oxygen_rate: float = 5.0
var current_oxygen: float = 100.0
var multiplier: float = 1.0
var current_toxic_zone: String = ""
var is_oxygen_decreased: bool = false
var is_oxygen_regen: bool = false
var flash_oxygen: float
var is_dead: bool = false
var is_oxygen_decreased_by_other_source: bool = false

### Mask
enum MaskType { NONE, RED, BLUE }
@export var mask_type: MaskType = MaskType.NONE

@onready var game_ui: GameUI = $CanvasLayer

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
			multiplier = 3.0
		elif (current_toxic_zone == "Red" and mask_type == MaskType.RED) or (current_toxic_zone == "Blue" and mask_type == MaskType.BLUE):
			multiplier = 1.0
		else:
			multiplier = 2.0
	else:
		if mask_type == MaskType.NONE:
			multiplier = 0.0
		else:
			multiplier = 1.0
			
	if multiplier == 0 and not is_oxygen_decreased_by_other_source:
		is_oxygen_decreased = false
	else:
		is_oxygen_decreased = true
		
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
	if position.y > 500 and not is_dead:
		print("Té chết")
		_on_death()

### Hàm xử lý input
func _input(event: InputEvent) -> void:
	if fsm.current_state == fsm.states.die:
		return
	# đổi sang mặt nạ đỏ
	if event.is_action_pressed("mask_scroll_up"):
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
	mask_type = mask
	
	# gọi game_ui đổi texture cho avatar
	if game_ui:
		game_ui.update_avatar_texture(mask_type)
		
	print("[Player] Đổi sang mặt nạ ", mask_type)
	
	if fsm and fsm.current_state:
		fsm.current_state._enter()
	
	get_tree().call_group("spikes", "update_spike_state", mask_type)
	
	get_tree().call_group("platforms", "update_platform_state", mask_type)
	return true

# Hàm hồi Oxy khi nhặt được bình
func _refill_oxygen(amount: float) -> void:
	print("[Player] Đã hồi ", amount, " oxy!")
	is_oxygen_regen = true
	flash_oxygen = current_oxygen;
	flash_oxygen += amount;
	#flash_oxygen = clamp(flash_oxygen, 0.0, max_oxygen)
	
	if game_ui:
		game_ui._update_oxygen_bar_regen(current_oxygen, flash_oxygen, max_oxygen, mask_type, is_oxygen_regen)
	
	var tween = create_tween()
	tween.tween_property(self, "current_oxygen", flash_oxygen, 0.5)
	await  tween.finished
	is_oxygen_regen = false


# Xử lý khi hết sạch oxy
func _on_oxygen_ran_out() -> void:
	print("Hết oxy! Game Over!")
	# Tạm thời reset lại màn 
	get_tree().reload_current_scene()
func force_jump_state():
# Ví dụ: Nếu bạn có một biến chứa State hiện tại hoặc hàm gọi State chuyển đổi
# $States.change_state("")
	fsm.change_state($States/Jump)
	if is_dead: return
	print("[Player] Hết oxy! Game Over!")
	# Tạm thời reset lại màn
	_on_death()

# hàm gọi xử lý chuỗi sự kiện chết
func _on_death() -> void:
	if is_dead: return
	# set flags
	is_dead = true
	multiplier = 0.0
	# cập nhật gioa diẹne
	if game_ui: game_ui.update_ui(current_oxygen, max_oxygen, mask_type, is_oxygen_decreased)
	print("[Player] Người chơi đã die -> Reset màn chơi")
	fsm.change_state(fsm.states.die)
