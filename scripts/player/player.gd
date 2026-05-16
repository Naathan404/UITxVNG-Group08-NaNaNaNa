extends BaseCharacter

### MASK SETTING
@export var max_oxygen: float = 100.0
@export var decrease_oxygen_rate: float = 5.0
var current_oxygen: float = 100.0
@onready var oxygen_bar: ProgressBar = $CanvasLayer/OxygenBar

### Mask
enum MaskType { NONE, RED, BLUE }
@export var mask_type: MaskType = MaskType.NONE

func _ready() -> void:
	fsm = FSM.new(self, $States, $States/Idle)
	
	current_oxygen = max_oxygen
	oxygen_bar.max_value = max_oxygen
	oxygen_bar.value = current_oxygen
	super._ready()
	
func _process(delta: float) -> void:
	if mask_type != MaskType.NONE:
		var multiplier: float = 1.0
		current_oxygen -= decrease_oxygen_rate * multiplier * delta
		current_oxygen = clamp(current_oxygen, 0.0, max_oxygen)
		oxygen_bar.value = current_oxygen
		
		if current_oxygen <= 0.0: 
			_on_oxygen_ran_out()
	#pass

# Hàm đổi mặt nạ
func _on_mask_change(mask: MaskType) -> bool:
	if mask_type != mask: return false
	mask_type = mask
	print("Đổi sang mặt nạ ", mask_type)
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
