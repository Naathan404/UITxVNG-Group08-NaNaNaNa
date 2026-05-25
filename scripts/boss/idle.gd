extends State_Boss
class_name Boss_idle

var timer: float = 0.0
var wait_time: float = 0.0
var locked_x: float = 0.0
var player: Player

func enter():
	super.enter()
	if owner.has_node("pivot"):
		owner.get_node("pivot").visible = false
	timer = 0.0
	wait_time = randf_range(5.0, 8.0)
	
	player = get_tree().get_first_node_in_group("player")
	
	if owner:
		owner.velocity.x = 0
		locked_x = owner.global_position.x
	if animatedsprite2d:
		animatedsprite2d.play("idle")

func exit():
	super.exit()

func _physics_process(delta: float) -> void:
	timer += delta
	if timer >= wait_time:
		var random_attack = randi_range(1, 3)
		#transitioned.emit(self, "attack_laser")
		if random_attack == 1:
			transitioned.emit(self, "attack")
		elif random_attack == 2:
			transitioned.emit(self, "attack2")
		elif random_attack == 3:
			transitioned.emit(self, "attack_laser")
