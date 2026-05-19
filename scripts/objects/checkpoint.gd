extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var is_activated: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite.play("idle")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if is_activated: return
	if body.is_in_group("player"):
		is_activated = true
		animated_sprite.play("activated")
		GameManager._set_checkpoint(position)
		AudioManager.play_sound("checkpoint", global_position, 8.0)
		# chuyển sang anim cờ bay bay
		await animated_sprite.animation_finished
		animated_sprite.play("flag_ilde")
	pass # Replace with function body.
