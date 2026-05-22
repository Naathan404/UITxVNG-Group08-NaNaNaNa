extends StaticBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var magic_dust: CPUParticles2D = $MagicDust
@onready var burst_dust: CPUParticles2D = $BurstDust
@export var burst_duration: float = 0.5
@export var ghost_alpha: float = 0.3
var is_ghost: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.dash_trigger.connect(_handle_state)
	_become_ghost()


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
	modulate.a = ghost_alpha
	burst_dust.emitting = true
	magic_dust.emitting = true

	var tween = create_tween()
	tween.tween_property(sprite, "scale", Vector2(0.8, 0.8), burst_duration / 3.0).set_trans(Tween.TRANS_SINE)
	tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), burst_duration / 3.0).set_trans(Tween.TRANS_SINE)

func _become_solid() -> void:
	if not is_ghost: return
	is_ghost = false
	modulate.a = 1.0
	collision.set_deferred("disabled", false)
	magic_dust.emitting = false
	burst_dust.emitting = true
	
	sprite.scale = Vector2(0.5, 0.5)
	var tween = create_tween()
	tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), burst_duration).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
