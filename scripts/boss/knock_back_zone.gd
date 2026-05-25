extends Node2D

@export var knockback_force_x: float = 600.0 
@export var knockback_force_y: float = -400.0 
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		
		var push_direction = sign(body.global_position.x - global_position.x)
		
		if push_direction == 0: 
			push_direction = 1 
		
		body.velocity.x = push_direction * knockback_force_x
		body.velocity.y = knockback_force_y
