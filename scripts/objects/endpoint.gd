extends Node

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var blue_firework: CPUParticles2D = $BlueFirework
@onready var blue_firework_1: CPUParticles2D = $BlueFirework_1
@onready var red_firework: CPUParticles2D = $RedFirework
@onready var red_firework_1: CPUParticles2D = $RedFirework_1
@onready var limit: CollisionShape2D = $StaticBody2D/Limit

@export var next_scene_path: String
@export var current_level: int = 1

var is_activated: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	limit.set_deferred("disabled", true)
	blue_firework.emitting = false
	blue_firework_1.emitting = false
	red_firework.emitting = false
	red_firework_1.emitting = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if is_activated: return
	if body.has_method("_complete_level"): 
		is_activated = true
		limit.set_deferred("disabled", false)
		Engine.time_scale = 0.05
		await get_tree().create_timer(0.01 * 0.05).timeout
		Engine.time_scale = 1.0
		
		AudioManager.stop_music()
		AudioManager.play_sound("endpoint", body.global_position, 5.0)
		animated_sprite.play("activated")
		GameManager._reset_checkpoint()
		
		body._complete_level()
		blue_firework.emitting = true
		blue_firework_1.emitting = true
		red_firework.emitting = true
		red_firework_1.emitting = true
		
		if GameManager.max_unlocked_level <= current_level:
			GameManager.max_unlocked_level = current_level + 1
		
		await get_tree().create_timer(2.0).timeout
		SceneTransition._change_scene(next_scene_path)
	pass # Replace with function body.
