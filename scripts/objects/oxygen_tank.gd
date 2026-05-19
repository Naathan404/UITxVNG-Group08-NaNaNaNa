extends Area2D

@onready var particle: CPUParticles2D = $Particle
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var y_offset: float = 10.0

var is_activated: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_start_floating_effect()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if is_activated: return
	if body.has_method("_refill_oxygen"):
		AudioManager.play_sound("oxygen", global_position, 5.0)
		is_activated = true
		body._refill_oxygen(25)
		animated_sprite.hide()
		particle.emitting = true
		await particle.finished
		queue_free()
	pass # Replace with function body.
	
func _start_floating_effect() -> void:
	var original_pos = animated_sprite.position
	
	var tween = create_tween().set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(animated_sprite, "position:y", original_pos.y - y_offset, 0.5)
	tween.tween_property(animated_sprite, "position:y", original_pos.y, 0.5)
	
	pass
