@tool
extends Area2D

@export var jump_force: float = -800.0 
@export_enum("NONE", "Red", "Blue") var pad_color: String = "NONE":
	set(value):
		pad_color = value
		_update_visual()

enum MaskType {NONE, RED, BLUE}

@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	_update_visual()
	if not Engine.is_editor_hint():
		add_to_group("jump_pads")
		if animated_sprite:
			animated_sprite.play("idle")

func _update_visual():
	var sprite = get_node_or_null("AnimatedSprite2D")
	if sprite:
		if pad_color == "Red":
			sprite.modulate = Color(1, 0, 0, 1)
		elif pad_color == "Blue":
			sprite.modulate = Color(0, 0.5, 1, 1)
		else:
			sprite.modulate = Color(1, 1, 1, 1)

func _update_jump_pad_state(player_mask: int) -> void:
	var is_hide = false
	if pad_color == "Red" and player_mask == MaskType.BLUE:
		is_hide = true
	elif pad_color == "Blue" and player_mask == MaskType.RED:
		is_hide = true
		
	var collision = get_node_or_null("CollisionShape2D")
	var static_collision = get_node_or_null("StaticBody2D/CollisionShape2D")
	var sprite = get_node_or_null("AnimatedSprite2D")
	
	if is_hide:
		if sprite: sprite.modulate.a = 0.3
		if collision: collision.set_deferred("disabled", true)
		if static_collision: static_collision.set_deferred("disabled", true)
	else:
		if sprite: sprite.modulate.a = 1.0
		if collision: collision.set_deferred("disabled", false)
		if static_collision: static_collision.set_deferred("disabled", false)

func _on_body_entered(body):
	if Engine.is_editor_hint(): return
	
	if body.name == "Player" or body.is_in_group("player"):
		# Allow jumping only if falling or slightly moving down
		if body.velocity.y >= 0:
			# Ensure the player is above the jump pad to bounce (prevents side triggers)
			# Get the y position of the top of the jump pad Area2D
			var area_y = global_position.y
			var collision = get_node_or_null("CollisionShape2D")
			if collision:
				area_y = collision.global_position.y
				
			if body.global_position.y < area_y:
				body.velocity.y = jump_force
				
				if body.has_method("force_jump_state"):
					body.force_jump_state() 
					
				if animated_sprite:
					animated_sprite.play("bounce")

func _on_animated_sprite_2d_animation_finished():
	if Engine.is_editor_hint(): return
	if animated_sprite and animated_sprite.animation == "bounce":
		animated_sprite.play("idle")
