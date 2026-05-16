@tool
extends Area2D

@export_enum("Red", "Blue") var toxic_zone_color: String = "Red":
	set(value):
		toxic_zone_color = value
		_update_visual()
func _ready() -> void:
	_update_visual()

func _update_visual() -> void:
	var rect = get_node_or_null("ColorRect")
	if rect:
		if toxic_zone_color == "Red":
			rect.color = Color(1,0,0,0.4)
		elif toxic_zone_color == "Blue":
			rect.color = Color(0,0.5,1,0.4)

func _process(delta: float) -> void:
	# công dụng khi chạy @tool thì máy sẽ dừng không chạy mấy code dưới
	if Engine.is_editor_hint(): return
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("player"):
			var check_mask = false
			if toxic_zone_color == "Red" and body.mask_type == body.MaskType.RED:
				check_mask = true
			elif toxic_zone_color == "Blue" and body.mask_type == body.MaskType.BLUE:
				check_mask = true
			if check_mask:
				body.multiplier = 1.0
			else:
				body.multiplier = 5.0


func _on_body_exited(body: Node2D) -> void:
	if (body.is_in_group("player")):
		body.multiplier = 1.0
