extends Camera2D
class_name GameCamera

var zoom_tween: Tween

func zoom_to(target_zoom: Vector2, duration: float) -> void:
	if zoom_tween and zoom_tween.is_valid():
		zoom_tween.kill()
		
	zoom_tween = create_tween()
	zoom_tween.tween_property(self, "zoom", target_zoom, duration)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
