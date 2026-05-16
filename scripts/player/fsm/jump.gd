extends PlayerState

func _enter() -> void:
	if obj.mask_type == obj.MaskType.NONE:
		obj.change_animation("jump")
	elif obj.mask_type == obj.MaskType.RED:
		obj.change_animation("jump_red")
	else:
		obj.change_animation("jump_blue")

func _update(_delta: float):
	if control_dash(): return
	# Trên không trung thì xử lý cho người chơi đi trái phải
	var dir: float = Input.get_action_strength("right") - Input.get_action_strength("left")
	obj.velocity.x = obj.movement_speed * dir
	if abs(dir) > 0.1:
		obj.change_direction(sign(dir))
	
	# Khi vận tốc đi lên giảm dần và bắt đầu rơi xuống (velocity.y >= 0)
	if obj.velocity.y >= 0:
		change_state(fsm.states.fall)
