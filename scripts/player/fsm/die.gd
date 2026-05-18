extends PlayerState

@export var die_duration: float = 1.0

func _enter() -> void:
	obj.change_animation("die")
	obj.velocity = Vector2.ZERO
	_play_death_sequence()
	
func _update(_delta: float) -> void:
	obj.velocity = Vector2.ZERO
	pass
	
func _exit() -> void:
	pass

func _play_death_sequence() -> void:
	var anim_sprite = obj.get_node("Direction2D/AnimatedSprite2D")
	
	await anim_sprite.animation_finished
	
	if obj.game_ui:
		await obj.game_ui.play_death_transition()
	
	obj.get_tree().reload_current_scene()
