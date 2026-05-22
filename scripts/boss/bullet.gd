extends Area2D

@export var speed: float = 250.0
@export var damage: float = 10.0
@export var bullet_mask_type: int = 1 # 1 là đỏ, 2 là xanh
@onready var sprite: Sprite2D = $Sprite2D

var direction: Vector2 = Vector2.ZERO
var player: Player
@export var texture_red: Texture2D
@export var texture_blue: Texture2D

func _ready() -> void:
	add_to_group("bullets")
	player = get_tree().get_first_node_in_group("player")
	
	if bullet_mask_type == 1:
		sprite.texture = texture_red
	elif bullet_mask_type == 2:
		sprite.texture = texture_blue 
	else:
		pass 

func _physics_process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
			queue_free()


#func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
#	queue_free()
