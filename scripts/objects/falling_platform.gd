extends AnimatableBody2D

@export var fall_delay: float = 0.5 
@export var respawn_delay: float = 3.0 
@export var fall_speed: float = 500.0 

var is_falling: bool = false
var original_position: Vector2

@onready var sprite = $Sprite2D
@onready var solid_collision = $CollisionShape2D
@onready var detector_collision = $Area2D/CollisionShape2D
@onready var detector = $Area2D

func _ready() -> void:
	original_position = global_position
	detector.body_entered.connect(_on_player_stepped)
	
func _physics_process(delta: float) -> void:
	if is_falling:
		global_position.y += fall_speed * delta
		
func _on_player_stepped(body: Node2D) -> void:
	if is_falling or not body.is_in_group("player"):
		return
		
	# Rung lắc viên gạch
	var tween = create_tween()
	tween.tween_property(sprite, "position:x", 3.0, 0.05).as_relative()
	tween.tween_property(sprite, "position:x", -6.0, 0.05).as_relative()
	tween.tween_property(sprite, "position:x", 3.0, 0.05).as_relative()
	
	await get_tree().create_timer(fall_delay).timeout
	fall()
	
func fall() -> void:
	is_falling = true
	solid_collision.set_deferred("disabled", true)
	detector_collision.set_deferred("disabled", true)
	
	await get_tree().create_timer(respawn_delay).timeout
	respawn()
	
func respawn() -> void:
	is_falling = false
	global_position = original_position
	sprite.modulate.a = 0.0 
	
	solid_collision.set_deferred("disabled", false)
	detector_collision.set_deferred("disabled", false)
	
	var tween = create_tween()
	tween.tween_property(sprite, "modulate:a", 1.0, 0.3)
