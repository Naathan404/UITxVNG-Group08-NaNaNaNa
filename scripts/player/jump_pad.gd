extends Area2D

# Lực nảy. Số âm vì trong Godot, trục Y hướng xuống dưới. -800 nghĩa là bắn lên trên.
@export var jump_force: float = -800.0 

# Lấy node AnimatedSprite2D để điều khiển hình ảnh
@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	# Khi mới chạy game, tấm nệm luôn ở trạng thái đứng im
	animated_sprite.play("idle")

# Hàm này sẽ được gọi khi có một vật thể (body) chạm vào vùng va chạm của tấm nệm
func _on_body_entered(body):
	# Kiểm tra xem vật chạm vào có thuộc nhóm "Player" không (tránh quái vật dẫm lên cũng bay)
	if body.is_in_group("player"):
		
		# 1. Đẩy Player lên trên bằng cách gán trực tiếp vận tốc Y
		body.velocity.y = jump_force
		
		# 2. Xử lý State Machine của Player (Phần này liên quan đến cấu trúc của bạn)
		# Vì bạn dùng node States riêng, bạn cần báo cho Player biết nó đang bị hất lên
		# Gọi hàm chuyển state trong script Player của bạn (Tên hàm có thể khác tuỳ bạn đặt)
		if body.has_method("force_jump_state"):
			body.force_jump_state() 
			
		# 3. Phát animation nệm lún xuống và nảy lên
		animated_sprite.play("bounce")

# Hàm này được gọi khi animation "bounce" đã chạy xong khung hình cuối cùng
func _on_animated_sprite_2d_animation_finished():
	# Chạy xong "bounce" thì quay lại trạng thái "idle" (đứng im)
	if animated_sprite.animation == "bounce":
		animated_sprite.play("idle")
