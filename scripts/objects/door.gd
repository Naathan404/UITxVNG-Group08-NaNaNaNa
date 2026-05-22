extends Area2D

@export var opened_image: Texture2D
@onready var solid_collider: CollisionShape2D = $StaticBody2D/CollisionShape2D

var is_opened: bool = false

func _ready() -> void:
	add_to_group("doors")
	if solid_collider:
		solid_collider.set_deferred("disabled", false)
func open_door() -> void:
	is_opened = true
	$Sprite2D.texture = preload("res://assets/sprites/items/door_open.png")
	if solid_collider:
		solid_collider.set_deferred("disabled", true)

func _on_body_entered(body: Node2D) -> void:
	pass
