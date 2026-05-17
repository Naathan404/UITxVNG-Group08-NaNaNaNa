@tool
extends Area2D

@export_enum("Red", "Blue") var toxic_zone_color: String = "Red":
	set(value):
		toxic_zone_color = value
		_update_visual()
@export var is_change_color: bool = false
@export var min_time: float = 1.0
@export var max_time: float = 10.0

var _timer: float = 0.0
var _current_target_time: float = 1.0

func _ready() -> void:
	_update_visual()
	_current_target_time = randf_range(min_time, max_time)

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
	
	if is_change_color:
		_timer += delta
		if _timer >= _current_target_time:
			_timer = 0
			_current_target_time = randf_range(min_time, max_time)
			if (toxic_zone_color == "Red"):
				toxic_zone_color = "Blue"
			else:
				toxic_zone_color = "Red"
			_update_visual()
	
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("player"):
			body.current_toxic_zone = toxic_zone_color
			


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.current_toxic_zone = ""
