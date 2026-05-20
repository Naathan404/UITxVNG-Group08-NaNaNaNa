extends CanvasLayer

@onready var player_run_sprites: AnimatedSprite2D = $AnimatedSprite2D
@onready var black_rect: ColorRect = $ColorRect

func _ready() -> void:
	black_rect.hide()
	player_run_sprites.hide()
	pass

# Hàm gọi để chuyển cảnh
func _change_scene(scene_path: String) -> void:
	var screen_size = get_viewport().get_visible_rect().size
	
	black_rect.size = screen_size
	
	black_rect.position = Vector2(-screen_size.x, 0)
	
	player_run_sprites.position = Vector2(0, screen_size.y / 2) 
	player_run_sprites.play("run")
	
	black_rect.show()
	player_run_sprites.show()
	
	var tween = create_tween()
	
	var frames = player_run_sprites.sprite_frames
	var anim = player_run_sprites.animation
	var text = frames.get_frame_texture(anim, player_run_sprites.frame)
	
	AudioManager.play_sound("dash")
	tween.tween_property(black_rect, "position:x", 0, 0.5).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(player_run_sprites, "position:x", screen_size.x - text.get_size().x * 3.5, 0.5).set_trans(Tween.TRANS_SINE)
	
	await tween.finished
	
	player_run_sprites.play("idle") 
	get_tree().change_scene_to_file(scene_path) 
	await get_tree().create_timer(0.4).timeout 
	
	player_run_sprites.play("run") 
	var tween_out = create_tween()
	
	AudioManager.play_sound("dash")
	tween_out.tween_property(black_rect, "position:x", screen_size.x, 0.5).set_trans(Tween.TRANS_SINE)
	tween_out.parallel().tween_property(player_run_sprites, "position:x", screen_size.x * 2, 0.5).set_trans(Tween.TRANS_SINE)
	
	await tween_out.finished
	
	black_rect.hide()
	player_run_sprites.hide()
