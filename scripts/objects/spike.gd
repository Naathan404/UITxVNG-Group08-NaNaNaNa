@tool
extends Area2D
@export_enum("Red", "Blue") var spike_color: String = "Red":
	set(value):
		spike_color = value
		_update_visual()
enum MaskType {NONE, RED, BLUE}
func _ready() -> void:
	_update_visual()
	add_to_group("spikes")
func _update_visual():
	var sprite = get_node_or_null("Sprite2D")
	if sprite:
		if spike_color == "Red":
			sprite.modulate = Color(1, 0, 0, 1)
		else:
			sprite.modulate = Color(0, 0.5, 1, 1)
func update_spike_state(player_mask: int) -> void:
	var is_hide = false
	if spike_color == "Red" and player_mask == MaskType.BLUE:
		is_hide = true
	elif spike_color == "Blue" and player_mask == MaskType.RED:
		is_hide = true
	var collision = get_node_or_null("CollisionPolygon2D")
	var sprite = get_node_or_null("Sprite2D")
	if is_hide:
		sprite.modulate.a = 0.3
		collision.set_deferred("disabled", true)
	else:
		sprite.modulate.a = 1.0
		collision.set_deferred("disabled", false)
		
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().reload_current_scene()
