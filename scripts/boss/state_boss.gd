extends Node2D
class_name State_Boss

# tín hiệu chuyển state
signal transitioned(state, new_state_name)

@onready var animatedsprite2d = owner.find_child("AnimatedSprite2D")

func _ready() -> void:
	set_physics_process(false)

func enter():
	set_physics_process(true)

func exit():
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	pass
