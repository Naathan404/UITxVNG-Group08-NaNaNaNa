extends State_Boss
class_name Boss_idle

var timer: float = 0.0
var wait_time: float = 0.0
var locked_x: float = 0.0

func enter():
	super.enter()
	if owner.has_node("pivot"):
		owner.get_node("pivot").visible = false
	timer = 0.0
	wait_time = randf_range(1.0, 3.0)
	
	if owner:
		owner.velocity.x = 0
		locked_x = owner.global_position.x
	if animatedsprite2d:
		animatedsprite2d.play("idle")

func exit():
	super.exit()

func _physics_process(delta: float) -> void:
	if not owner.is_on_floor():
		owner.velocity.y += 980 * delta
	owner.move_and_slide()
	
	owner.global_position.x = locked_x
	
	timer += delta
	if timer >= wait_time:
		var random_attack = randi_range(1, 4)
		#transitioned.emit(self, "attack_laser")
		if random_attack == 1:
			transitioned.emit(self, "attack")
		elif random_attack == 2:
			transitioned.emit(self, "attack2")
		elif random_attack == 3:
			transitioned.emit(self, "run")
		elif random_attack == 4:
			transitioned.emit(self, "attack_laser")
