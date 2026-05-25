extends Camera2D
class_name GameCamera

var zoom_tween: Tween

var shake_strength: float = 0.0
var shake_fade: float = 5.0 # Tốc độ dập tắt độ rung

func zoom_to(target_zoom: Vector2, duration: float) -> void:
	if zoom_tween and zoom_tween.is_valid():
		zoom_tween.kill()
		
	zoom_tween = create_tween()
	zoom_tween.tween_property(self, "zoom", target_zoom, duration)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)

func _process(delta: float) -> void:
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		
		offset = Vector2(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength))
	else:
		offset = Vector2.ZERO


func add_shake(strength: float) -> void:
	shake_strength = max(shake_strength, strength)
