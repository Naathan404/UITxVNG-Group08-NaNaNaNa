extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("boss"):
		if body.has_method("apply_rain_buff"):
			body.apply_rain_buff(true)


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("boss"):
		if body.has_method("apply_rain_buff"):
			body.apply_rain_buff(false)
