extends PlayerState

func _enter() -> void:
	obj.change_animation("run")

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
