extends Node2D

@export var initial_state: State_Boss
var current_state: State_Boss
signal transitioned(state, new_state_name)

func _ready() -> void:
	await owner.ready
	for child in get_children():
		if child is State_Boss:
			child.transitioned.connect(on_child_transitioned)
	if initial_state:
		initial_state.enter()
		current_state = initial_state
		
func on_child_transitioned(state_calling: State_Boss, new_state_name: String) -> void:
	if state_calling != current_state:
		return
		
	var new_state = get_node_or_null(new_state_name)
	if not new_state:
		return
		
	if current_state:
		current_state.exit()
		
	new_state.enter()
	current_state = new_state
