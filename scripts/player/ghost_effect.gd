extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# tạo tween
	var tween = create_tween()
	
	# cho phép nhiều tween chạy song song
	tween.set_parallel(true)
	
	# tween modulate alpha của obj này về 0.0 trong 0.2s
	tween.tween_property(self, "modulate:a", 0.0, 0.2)
	
	# giải phóng tween khỏi bộ nhớ
	tween.chain().tween_callback(queue_free)
	pass
