@tool
extends AnimatableBody2D

@export_enum("NONE", "Red", "Blue") var platform_color: String = "NONE":
	set(value):
		platform_color = value
		_update_visual()
@export var is_moving: bool = true
enum MaskType {NONE, RED, BLUE}
@export var move_offset: Vector2 = Vector2(150, 0)
@export var move_duration: float = 2.0
var start_position: Vector2

func _update_visual() -> void:
	var sprite = get_node_or_null("Sprite2D")
	if sprite:
		if platform_color == "Red":
			sprite.modulate = Color(1, 0, 0, 1)
		elif platform_color == "Blue":
			sprite.modulate = Color(0, 0.5, 1, 1)
		else:
			sprite.modulate = Color(1, 1, 1, 1)

func start_tween() -> void:
	# Tạo Tween lặp lại vô hạn
	var tween = create_tween().set_loops()
	var target_position = start_position + move_offset
	
	# Lượt đi
	tween.tween_property(self, "global_position", target_position, move_duration)
	# Lượt về
	tween.tween_property(self, "global_position", start_position, move_duration)

func _ready() -> void:
	_update_visual()

	if not Engine.is_editor_hint():
		add_to_group("platforms")
		if is_moving:
			start_position = global_position
			start_tween()
func update_platform_state(player_mask: int) -> void:
	var is_hide = false
	if platform_color == "Red" and player_mask == MaskType.BLUE:
		is_hide = true
	elif platform_color == "Blue" and player_mask == MaskType.RED:
		is_hide = true

	var sprite = get_node_or_null("Sprite2D")
	if is_hide:
		if sprite:
			sprite.modulate.a = 0.3
		set_collision_layer_value(1, false)
		set_collision_mask_value(1, false)
	else:
		if sprite: 
			sprite.modulate.a = 1.0
		set_collision_layer_value(1, true)
		set_collision_mask_value(1, true)
