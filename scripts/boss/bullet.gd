extends Area2D

@export var damage: int = 10
@export var texture_blue: Texture2D
@export var texture_red: Texture2D

@onready var sprite = $Sprite2D
@onready var player = get_parent().find_child("Player")
@onready var screen_notifier = $VisibleOnScreenNotifier2D

enum MaskType { NONE, RED, BLUE }

var accleration: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	print("[bullet] đang gọi") 
	if player:
		print("Đang gán ảnh cho đạn...") # Dòng này sẽ hiện ở bảng Output
		if player.mask_type == MaskType.BLUE and texture_blue:
			sprite.texture = texture_blue
		elif player.mask_type == MaskType.RED and texture_red:
			sprite.texture = texture_red
		else:
			sprite.texture = texture_red

func _physics_process(delta: float) -> void:
	if player: 
		accleration = (player.global_position - global_position).normalized() * 700
		velocity += accleration * delta
		rotation = velocity.angle()
		
		velocity = velocity.limit_length(150)
		
		global_position += velocity * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_method("take_dame"):
			body.take_dame(float(damage))
		queue_free()
	elif body.is_in_group("boss"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		queue_free()


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
