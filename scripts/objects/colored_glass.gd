@tool
extends StaticBody2D

@export_group("Colored Glass Settings")
@export_enum("Red", "Blue") var color: String = "Red":
	set(value):
		color = value
		_update_visual()

@export var deactivated_alpha: float = 0.1
@export var activated_alpha: float = 0.7
@export var is_activated: bool = false:
	set(value):
		is_activated = value
		_update_visual()

@onready var sprite: Sprite2D = $Sprite2D
enum MaskType { NONE, RED, BLUE }

func _ready() -> void:
	for i in range(1, 6):
		set_collision_layer_value(i, false)
	
	add_to_group("colored_glass")
	_update_visual()

func _update_visual() -> void:
	if not is_node_ready(): 
		return
		
	var current_alpha = activated_alpha if is_activated else deactivated_alpha
	
	if color == "Red":
		sprite.modulate = Color(1.5, 0.2, 0.2, current_alpha) 
		set_collision_layer_value(3, is_activated)
	else:
		sprite.modulate = Color(0.2, 0.5, 1.5, current_alpha)
		set_collision_layer_value(4, is_activated)
		
func _update_colored_glass_state(player_mask: int) -> void:
	if player_mask == MaskType.NONE:
		self.is_activated = false
		return
		
	if color == "Red":
		self.is_activated = (player_mask == MaskType.RED)
	else:
		self.is_activated = (player_mask == MaskType.BLUE)
