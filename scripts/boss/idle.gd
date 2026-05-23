extends State_Boss
class_name Boss_idle

var timer: float = 0.0
var wait_time: float = 0.0

func enter():
	super.enter() 
	timer = 0.0
	wait_time = randf_range(1.0, 3.0)
	
	if animatedsprite2d:
		animatedsprite2d.play("idle")

func exit():
	super.exit()

func _physics_process(delta: float) -> void:
	timer += delta
	if timer >= wait_time:
		var random_attack = randi_range(1, 2)
		
		if random_attack == 1:
			transitioned.emit(self, "attack")
		else:
			transitioned.emit(self, "attack2")
