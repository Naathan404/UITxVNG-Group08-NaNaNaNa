extends Area2D

@export var damage: int = 10
@export var texture_blue: Texture2D
@export var texture_red: Texture2D

@onready var sprite = $Sprite2D
@onready var player = get_parent().find_child("Player")
@onready var screen_notifier = $VisibleOnScreenEnabler2D

enum MaskType { NONE, RED, BLUE }
var bullet_mask_type: MaskType = MaskType.NONE

var acceleration: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	if player:
		if player.mask_type == MaskType.BLUE and texture_blue:
			sprite.texture = texture_blue
			bullet_mask_type = MaskType.BLUE
		elif player.mask_type == MaskType.RED and texture_red:
			sprite.texture = texture_red
			bullet_mask_type = MaskType.RED
		else:
			sprite.texture = texture_red
			bullet_mask_type = MaskType.RED

func _physics_process(delta: float) -> void:
	if player:
		if  player.mask_type == bullet_mask_type or player.mask_type == MaskType.NONE:
			acceleration = (player.global_position - global_position).normalized() * 700
			velocity += acceleration * delta
			rotation = velocity.angle()
			velocity = velocity.limit_length(100)
		else:
			acceleration = Vector2.ZERO
			if velocity == Vector2.ZERO:
				velocity = Vector2.RIGHT.rotated(rotation) * 200
			velocity = velocity.limit_length(100)
		global_position += velocity * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_method("take_dame"):
			if player.mask_type == bullet_mask_type or player.mask_type == MaskType.NONE:
				body.take_dame(float(damage))
		queue_free()
	elif body.is_in_group("boss"):
		if body.has_method("take_damage"):
			if player.mask_type == bullet_mask_type or player.mask_type == MaskType.NONE:
				body.take_damage(damage)
		queue_free()


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
