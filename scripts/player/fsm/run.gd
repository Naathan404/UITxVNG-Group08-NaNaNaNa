extends PlayerState

func _enter() -> void:
	if obj.mask_type == obj.MaskType.NONE:
		obj.change_animation("run")
	elif obj.mask_type == obj.MaskType.RED:
		obj.change_animation("run_red")
	else:
		obj.change_animation("run_blue")
		
	# run particles
	obj.get_node("RunParticles").emitting = true

func _update(delta: float):
	if control_dash(): return
	if control_jump(): return
	
	# Nếu không bấm nút di chuyển nữa -> Quay về Idle
	var moving = control_moving()
	if not moving:
		change_state(fsm.states.idle)
	
	# Nếu không ở trên sàn -> Chuyển sang Fall
	if not obj.is_on_floor():
		change_state(fsm.states.fall)
func _exit() -> void:
	obj.get_node("RunParticles").emitting = false
