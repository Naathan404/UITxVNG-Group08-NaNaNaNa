extends State_Boss
class_name Boss_idle

@export var move_speed: float = 150.0
@export var move_speed_current: float = 150.0
@export var buff_move_speed: float = 250.0
@export var attack_range: float = 150.0

var locked_x: float = 0.0
var player: Player
var speed: float = 150.0


func enter():
	super.enter()
	if owner.has_node("pivot"):
		owner.get_node("pivot").visible = false
	
	player = get_tree().get_first_node_in_group("player")
	
	if owner:
		owner.velocity.x = 0
		locked_x = owner.global_position.x
	#if animatedsprite2d:
	#	animatedsprite2d.play("run")

func exit():
	super.exit()

func _physics_process(delta: float) -> void:
	var boss = owner
	if not boss.is_on_floor():
		boss.velocity.y += boss.get_gravity().y * delta
	if player:
		var distance = boss.global_position.distance_to(player.global_position)
		if boss.get("is_enraged") == true:
			move_speed = buff_move_speed
		else:
			move_speed = move_speed_current
		if distance > attack_range:
			var direction = sign(player.global_position.x - boss.global_position.x)
			boss.velocity.x = direction * move_speed
			
		else:
			boss.velocity.x = move_toward(boss.velocity.x, 0, move_speed)
			
			var attack_skills = ["attack", "attack2", "attack_laser"]
			var random_skill = attack_skills.pick_random()
			
			transitioned.emit(self, random_skill)
			
	if animatedsprite2d:
		if boss.velocity.x == 0:
			animatedsprite2d.play("idle")
		else:
			animatedsprite2d.play("run")
			
			
	boss.move_and_slide()
