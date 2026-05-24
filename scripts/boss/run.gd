extends State_Boss
class_name Boss_Run

@export var run_speed: float = 150.0
@export var run_duration: float = 2.0

@onready var player = get_tree().get_first_node_in_group("player")

var timer: float = 0.0

func enter():
	super.enter()
	timer = 0.0

	if animatedsprite2d:
		animatedsprite2d.play("run")
		
func exit():
	super.exit()
	
	if owner:
		owner.velocity.x = 0
		
func _physics_process(delta: float) -> void:
	timer += delta
	if not owner.is_on_floor():
		owner.velocity.y += 980 * delta
	if player:
		# Tính hướng: -1 (trái) hoặc 1 (phải)
		var direction = sign(player.global_position.x - owner.global_position.x)
		
		# Lật mặt Boss quay về phía người chơi
		if animatedsprite2d:
			if direction > 0:
				animatedsprite2d.flip_h = true  # Đổi thành false nếu Boss bị chạy lùi (moonwalk)
			elif direction < 0:
				animatedsprite2d.flip_h = false # Đổi thành true nếu Boss bị chạy lùi
				
		# Áp dụng vận tốc ngang
		owner.velocity.x = direction * run_speed
	
	# Kích hoạt di chuyển cho CharacterBody2D
	owner.move_and_slide()

	# 3. KIỂM TRA HẾT GIỜ
	if timer >= run_duration:
		transitioned.emit(self, "idle") # Chạy mệt rồi thì về trạng thái đứng chờ
