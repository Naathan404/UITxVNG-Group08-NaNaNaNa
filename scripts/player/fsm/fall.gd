extends PlayerState

func _enter() -> void:
	if obj.mask_type == obj.MaskType.NONE:
		obj.change_animation("fall")
	elif obj.mask_type == obj.MaskType.RED:
		obj.change_animation("fall_red")
	else:
		obj.change_animation("fall_blue")

func _update(_delta: float) -> void:
	if control_dash(): return
	if control_jump(): return
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
			
func _exit() -> void:
	obj.get_node("JumpParticles").emitting = true
