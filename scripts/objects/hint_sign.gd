extends Area2D

@onready var hint: Label = $Label

@export_multiline() var hint_text: String = "..."

func _ready() -> void:
	hint.text = hint_text
	hint.visible = false

func _on_hint_sign_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		hint.visible = true


func _on_hint_sign_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		hint.visible = false
	
