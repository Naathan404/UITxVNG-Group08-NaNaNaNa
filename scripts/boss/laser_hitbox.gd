extends Area2D

@export var damage: int = 5
@export var tick_rate: float = 0.1

var time_since_last_hit: float = 0.0

func _physics_process(delta: float) -> void:
	if not monitoring:
		return
	time_since_last_hit += delta
	if time_since_last_hit >= tick_rate:
		var bodies = get_overlapping_bodies()
		
		for body in bodies:
			if body.is_in_group("player") and body.has_method("take_dame"):
				body.take_dame(damage)
				time_since_last_hit = 0.0
