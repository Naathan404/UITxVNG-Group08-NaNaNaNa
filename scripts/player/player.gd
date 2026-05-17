extends BaseCharacter

### MASK SETTING
@export var max_oxygen: float = 100.0
@export var decrease_oxygen_rate: float = 5.0
var current_oxygen: float = 100.0
var multiplier: float = 1.0
var current_toxic_zone: String = ""

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
	
	super._ready()
	
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
		
	current_oxygen -= decrease_oxygen_rate * multiplier * delta
	current_oxygen = clamp(current_oxygen, 0.0, max_oxygen)
	if current_oxygen <= 0.0: 
		_on_oxygen_ran_out()
	# gọi game_ui cập nhật giao diện liên tục
	if game_ui:
		game_ui.update_ui(current_oxygen, max_oxygen, mask_type)

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
	
	# gọi game_ui đổi texture cho avatar
	if game_ui:
		game_ui.update_avatar_texture(mask_type)
		
	print("Đổi sang mặt nạ ", mask_type)
	
	if fsm and fsm.current_state:
		fsm.current_state._enter()
	return true

# Hàm hồi Oxy khi nhặt được bình
func refill_oxygen(amount: float) -> void:
	current_oxygen += amount
	current_oxygen = clamp(current_oxygen, 0.0, max_oxygen)
	print("Đã hồi ", amount, " oxy!")

# Xử lý khi hết sạch oxy
func _on_oxygen_ran_out() -> void:
	print("Hết oxy! Game Over!")
	# Tạm thời reset lại màn 
	get_tree().reload_current_scene()
