extends Area2D

@export var next_level_path: String = ""
@export var opened_image: Texture2D

@onready var blue_firework: CPUParticles2D = $BlueFirework
@onready var blue_firework_1: CPUParticles2D = $BlueFirework_1
@onready var red_firework: CPUParticles2D = $RedFirework
@onready var red_firework_1: CPUParticles2D = $RedFirework_1

var is_opened: bool = false
var is_activated: bool = false

func _ready() -> void:
	add_to_group("doors")
	
	if blue_firework: blue_firework.emitting = false
	if blue_firework_1: blue_firework_1.emitting = false
	if red_firework: red_firework.emitting = false
	if red_firework_1: red_firework_1.emitting = false

func open_door() -> void:
	is_opened = true
	$Sprite2D.texture = preload("res://assets/sprites/items/door_open.png")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not is_activated:
		if is_opened:
			is_activated = true
			Engine.time_scale = 0.05
			await get_tree().create_timer(0.01 * 0.05).timeout
			Engine.time_scale = 1.0
			
			AudioManager.stop_music()
			AudioManager.play_sound("endpoint", body.global_position, 5.0)
			
			GameManager._reset_checkpoint()
			body._complete_level()
			blue_firework.emitting = true
			blue_firework_1.emitting = true
			red_firework.emitting = true
			red_firework_1.emitting = true
			await get_tree().create_timer(2.0).timeout
			SceneTransition._change_scene(next_level_path)
