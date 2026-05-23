extends State_Boss
class_name Boss_attack_2

@export var bullet_scene: PackedScene

@onready var shoot_point_1 = owner.find_child("ShootPoint_3")
@onready var shoot_point_2 = owner.find_child("ShootPoint_4")

func enter():
	super.enter()
	if animatedsprite2d:
		animatedsprite2d.play("attack_2")
	await get_tree().create_timer(0.8).timeout
	shoot(shoot_point_1)
	await get_tree().create_timer(1.0).timeout
	shoot(shoot_point_2)
	
	await get_tree().create_timer(1.0).timeout
	transitioned.emit(self, "idle")

func shoot(point: Marker2D):
	if bullet_scene:
		var bullet = bullet_scene.instantiate()
		
		get_tree().current_scene.add_child(bullet)
		
		bullet.global_position = point.global_position
