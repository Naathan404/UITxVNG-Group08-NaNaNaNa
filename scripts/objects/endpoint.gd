extends Node

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var blue_firework: CPUParticles2D = $BlueFirework
@onready var blue_firework_1: CPUParticles2D = $BlueFirework_1
@onready var red_firework: CPUParticles2D = $RedFirework
@onready var red_firework_1: CPUParticles2D = $RedFirework_1

@export var game_play = preload("res://scenes/levels/level_1_tutorial.tscn")

var is_activated: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	blue_firework.emitting = false
	blue_firework_1.emitting = false
	red_firework.emitting = false
	red_firework_1.emitting = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if is_activated: return
	if body.has_method("_complete_level"): 
		is_activated = true
		
		Engine.time_scale = 0.05
		await get_tree().create_timer(0.01 * 0.05).timeout
		Engine.time_scale = 1.0
		
		AudioManager.stop_music()
		AudioManager.play_sound("endpoint", body.global_position, 5.0)
		animated_sprite.play("activated")
		
		body._complete_level()
		blue_firework.emitting = true
		blue_firework_1.emitting = true
		red_firework.emitting = true
		red_firework_1.emitting = true
		
		await get_tree().create_timer(3.0).timeout
		#get_tree().change_scene_to_packed(game_play)
	pass # Replace with function body.
