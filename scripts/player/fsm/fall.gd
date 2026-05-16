extends PlayerState

func _enter() -> void:
	obj.change_animation("fall")

func _update(_delta: float) -> void:
	var dir: float = Input.get_action_strength("right") - Input.get_action_strength("left")
	obj.velocity.x = obj.movement_speed * dir
	if abs(dir) > 0.1:
		obj.change_direction(sign(dir))
	
	# Nếu đã chạm đất 
	if obj.is_on_floor():
		if abs(obj.velocity.x) > 0.1:
			change_state(fsm.states.run)
		else:
			change_state(fsm.states.idle)
