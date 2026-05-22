extends Area2D

@export var speed: float = 250.0
@export var damage: float = 10.0
@export var bullet_mask_type: int = 1 # 1 là đỏ, 2 là xanh
@onready var sprite: Sprite2D = $Sprite2D

var direction: Vector2 = Vector2.ZERO
var player: Node2D

func _ready() -> void:
	add_to_group("bullets")
	player = get_tree().get_first_node_in_group("player")
	if player:
		direction = global_position.direction_to(player.global_position)
		rotation = direction.angle()
	if bullet_mask_type == 1:
		sprite.modulate = Color(1, 0, 0)
	elif bullet_mask_type == 2:
		sprite.modulate = Color(0, 0.5, 1, 1)
	else:
		sprite.modulate = Color(1, 1, 1)

func _physics_process(delta: float) -> void:
	if player:
		if player.mask_type == bullet_mask_type or player.mask_type == 0:
			var target_angle = global_position.direction_to(player.global_position).angle()
			rotation = lerp_angle(rotation, target_angle, 3.0 * delta)
			direction = Vector2.RIGHT.rotated(rotation)
		else:
			rotation = direction.angle()
	global_position += direction * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
			queue_free()


#func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
#	queue_free()
