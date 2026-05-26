extends Area2D

@export var opened_image: Texture2D
@onready var solid_collider: CollisionShape2D = $StaticBody2D/CollisionShape2D
@onready var wall: Sprite2D = $Wall
@onready var door: Sprite2D = $Door
@onready var particle: CPUParticles2D = $DoorParticle

var is_opened: bool = false

func _ready() -> void:
	add_to_group("doors")
	particle.emitting = false
	body_entered.connect(_on_body_entered)
	if solid_collider:
		solid_collider.set_deferred("disabled", false)

func open_door() -> void:
	is_opened = true
	wall.visible = false
	door.visible = false
	particle.emitting = true
	AudioManager.play_sound("door", global_position, 10.0)
	if solid_collider:
		solid_collider.set_deferred("disabled", true)

func _on_body_entered(body: Node2D) -> void:
	if is_opened: return
	
	if body.is_in_group("player"):
		var keys = get_tree().get_nodes_in_group("keys")
		
		for key in keys:
			if key.current_state == key.State.FOLLOWING and key.target_player == body:
				key.fly_to_door_and_unlock(self)
				break
