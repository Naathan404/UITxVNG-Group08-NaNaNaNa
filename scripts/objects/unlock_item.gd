extends Area2D

@export_enum("red_mask", "blue_mask", "dash") var unlock_type: String
@onready var sprite: Sprite2D = $Sprite2D
@onready var particle: CPUParticles2D = $PickUpParticle

func _ready() -> void:
	particle.emitting = false
	var original_pos = sprite.position
	
	var tween = create_tween().set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(sprite, "position:y", original_pos.y - 16.0, 0.5)
	tween.tween_property(sprite, "position:y", original_pos.y, 0.5)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		
		match unlock_type:
			"red_mask":
				body.has_red_mask = true
			"blue_mask":
				body.has_blue_mask = true
			"dash":
				body.can_dash = true
		sprite.hide()
		# bắn signal
		body.ability_unlocked.emit(unlock_type)
		AudioManager.play_sound("pickup")
		
		particle.emitting = true
		await  particle.finished
		queue_free()
