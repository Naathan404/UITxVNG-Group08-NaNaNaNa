extends Node2D

@onready var raycast: RayCast2D = $RayCast2D
@onready var line: Line2D = $Line2D
@onready var particle: CPUParticles2D = $CPUParticles2D

@export_enum("Red", "Blue") var laser_color: String = "Red"

var is_activated: bool = true
var activated_alpha: float = 1.0;
var deactivated_alpha: float = 0.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	line.clear_points()
	line.add_point(Vector2.ZERO)
	line.add_point(Vector2.ZERO)
	
	if laser_color == "Red":
		line.default_color = Color(1.5, 0.2, 0.2, activated_alpha)
		particle.color = Color(1.5, 0.2, 0.2)
		raycast.set_collision_mask_value(3, true) 
		raycast.set_collision_mask_value(4, false) 
		
	elif laser_color == "Blue":
		line.default_color = Color(0.2, 0.5, 1.5, activated_alpha)
		particle.color = Color(0.2, 0.5, 1.5)

		raycast.set_collision_mask_value(4, true)
		raycast.set_collision_mask_value(3, false)
		
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	line.set_point_position(0, Vector2.ZERO)
	
	if raycast.is_colliding():
		var hit_point = to_local(raycast.get_collision_point())
		line.set_point_position(1, hit_point)
		particle.position = hit_point
		particle.emitting = true
		
		var collider = raycast.get_collider()
		if collider and collider.name == "Player":
			_handle_player_hit(collider)
	else:
		line.set_point_position(1, raycast.target_position)
		particle.emitting = false
	pass

func _handle_player_hit(player: Node2D) -> void:
	player._on_death()
	
func _toggle_laser() -> void:
	if is_activated:
		if laser_color == "Red":
			line.default_color = Color(1.5, 0.2, 0.2, deactivated_alpha)
			particle.color = Color(1.5, 0.2, 0.2)
		elif laser_color == "Blue":
			line.default_color = Color(0.2, 0.5, 1.5, deactivated_alpha)
			particle.color = Color(0.2, 0.5, 1.5)

		raycast.set_collision_mask_value(4, false)
		raycast.set_collision_mask_value(3, false)
		is_activated = false;
	
	else:
		if laser_color == "Red":
			line.default_color = Color(1.5, 0.2, 0.2, activated_alpha)
			particle.color = Color(1.5, 0.2, 0.2)
			raycast.set_collision_mask_value(3, true)
			raycast.set_collision_mask_value(4, false)
		elif laser_color == "Blue":
			line.default_color = Color(0.2, 0.5, 1.5, activated_alpha)
			particle.color = Color(0.2, 0.5, 1.5)
			raycast.set_collision_mask_value(4, true)
			raycast.set_collision_mask_value(3, false)

		is_activated = true;		
	pass
