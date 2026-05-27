extends StaticBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var magic_dust: CPUParticles2D = $MagicDust
@onready var burst_dust: CPUParticles2D = $BurstDust
@onready var check_zone: Area2D = $CheckZone

@export_group("Settings")
@export var hidden_start_state: bool = true
@export var burst_duration: float = 0.5
@export var ghost_alpha: float = 0.3

var is_ghost: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.dash_trigger.connect(_handle_state)
	magic_dust.emitting = true
	if hidden_start_state:
		_become_ghost()
	else:
		_become_solid()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _handle_state() -> void:
	print("[DashTriggerPlatform] Nhận được tín hiệu dash")
	if is_ghost: _become_solid()
	else: _become_ghost()
	
func _become_ghost() -> void:
	if is_ghost: return
	is_ghost = true
	collision.set_deferred("disabled", true)
	sprite.modulate.a = ghost_alpha
	burst_dust.emitting = true
	

	var tween = create_tween()
	tween.tween_property(sprite, "scale", Vector2(0.8, 0.8), burst_duration / 3.0).set_trans(Tween.TRANS_SINE)
	tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), burst_duration / 3.0).set_trans(Tween.TRANS_SINE)

#func _become_solid() -> void:
	#if not is_ghost: return
	#is_ghost = false
	#sprite.modulate.a = 1.0
	#collision.set_deferred("disabled", false)
	#burst_dust.emitting = true
	#
	#sprite.scale = Vector2(0.5, 0.5)
	#var tween = create_tween()
	#tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), burst_duration).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)

func _become_solid() -> void:
	if not is_ghost: return
	var overlapping_bodies = check_zone.get_overlapping_bodies()
	for body in overlapping_bodies:
		if body.name == "Player":
			print("[DashTriggerPlatform] Phát hiện người chơi kẹt, đang đẩy văng ra!")
			
			var platform_center = global_position
			var player_center = body.global_position
			var push_direction = (player_center - platform_center).normalized()
			
			if push_direction == Vector2.ZERO:
				push_direction = Vector2.UP
			
			body.global_position += push_direction * 50
	
	is_ghost = false
	sprite.modulate.a = 1.0
	collision.set_deferred("disabled", false)
	burst_dust.emitting = true
	
	sprite.scale = Vector2(0.5, 0.5)
	var tween = create_tween()
	tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), burst_duration).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
