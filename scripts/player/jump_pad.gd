extends Area2D

@export var jump_force: float = -800.0 
@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	animated_sprite.play("idle")

func _on_body_entered(body):
	# IN DẤU VẾT 1: Xem Jump Pad có nhận diện được ai chạm vào không
	print("Jump Pad phat hien va cham voi: ", body.name)
	
	# Kiểm tra tên thay vì dùng group (để tránh lỗi chưa add group)
	if body.name == "Player" or body.is_in_group("player"):
		print("Dung la Player roi!") # IN DẤU VẾT 2
		
		# IN DẤU VẾT 3: In thử vận tốc Y của Player xem có đang > 0 không
		print("Van toc Y hien tai: ", body.velocity.y) 
		
		if body.velocity.y > 0:
			print("Kich hoat NAY!") # IN DẤU VẾT 4
			
			body.velocity.y = jump_force
			
			if body.has_method("force_jump_state"):
				body.force_jump_state() 
				
			animated_sprite.play("bounce")

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "bounce":
		animated_sprite.play("idle")
