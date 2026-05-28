extends AnimatableBody2D

@export_enum("NONE", "Red", "Blue") var platform_color: String = "NONE":
	set(value):
		platform_color = value
		_update_visual()
@export var fall_delay: float = 0.5
@export var respawn_delay: float = 3.0 
@export var fall_speed: float = 500.0 

var is_falling: bool = false
var original_position: Vector2
var shake_power: float = 6.0
enum MaskType {NONE, RED, BLUE}
var is_hide: bool = false;

@onready var sprite = $Sprite2D
@onready var solid_collision = $CollisionShape2D
@onready var detector_collision = $Area2D/CollisionShape2D
@onready var detector = $Area2D

func _ready() -> void:
	original_position = global_position
	detector.body_entered.connect(_on_player_stepped)
	add_to_group("platforms")
	_update_visual()
	
func _update_visual():
	var spr = get_node_or_null("Sprite2D")
	if spr:
		if platform_color == "Red":
			spr.modulate = Color(1, 0, 0, 1)
		elif platform_color == "Blue":
			spr.modulate = Color(0, 0.5, 1, 1)
		else:
			spr.modulate = Color(1, 1, 1, 1)

func _physics_process(delta: float) -> void:
	if is_falling:
		global_position.y += fall_speed * delta
		
func _on_player_stepped(body: Node2D) -> void:
	if is_falling or not body.is_in_group("player") or is_hide:
		return
		
	var tween = create_tween().set_loops()
	
	tween.tween_property(sprite, "position:x", shake_power, 0.05).as_relative()
	tween.tween_property(sprite, "position:x", -shake_power * 2, 0.05).as_relative()
	tween.tween_property(sprite, "position:x", shake_power, 0.05).as_relative()
	
	await get_tree().create_timer(fall_delay).timeout
	
	tween.kill()
	
	sprite.position.x = 0
	fall()
	
func fall() -> void:
	is_falling = true
	solid_collision.set_deferred("disabled", true)
	detector_collision.set_deferred("disabled", true)
	
	await get_tree().create_timer(respawn_delay).timeout
	respawn()
	
func respawn() -> void:
	if not is_instance_valid(self) or not is_instance_valid(detector_collision):
		return
	is_falling = false
	global_position = original_position
	sprite.modulate.a = 0.0 
	
	solid_collision.set_deferred("disabled", false)
	detector_collision.set_deferred("disabled", false)
	
	var tween = create_tween()
	tween.tween_property(sprite, "modulate:a", 1.0, 0.3)

func update_platform_state(player_mask: int) -> void:
	is_hide = false
	if platform_color == "Red" and player_mask == MaskType.BLUE:
		is_hide = true
	elif platform_color == "Blue" and player_mask == MaskType.RED:
		is_hide = true

	if is_hide:
		if sprite:
			sprite.modulate.a = 0.3
		set_collision_layer_value(1, false)
		set_collision_mask_value(1, false)
		if detector_collision:
			detector_collision.set_deferred("disabled", true)
	else:
		if sprite:
			sprite.modulate.a = 1.0
			
		if not is_falling:
			set_collision_layer_value(1, true)
			set_collision_mask_value(1, true)
			if detector_collision:
				detector_collision.set_deferred("disabled", false)
