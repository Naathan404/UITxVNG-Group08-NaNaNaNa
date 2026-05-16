extends PlayerState

## Idle state for player character

func _enter() -> void:
	if obj.mask_type == obj.MaskType.NONE:
		obj.change_animation("idle")
	elif obj.mask_type == obj.MaskType.RED:
		obj.change_animation("idle_red")
	else:
		obj.change_animation("idle_blue")

func _update(_delta: float) -> void:
	#Control dash
	if control_dash(): return
	#Control jump
	control_jump()
	#Control moving
	control_moving()
	#If not on floor change to fall
	if not obj.is_on_floor():
		change_state(fsm.states.fall)
