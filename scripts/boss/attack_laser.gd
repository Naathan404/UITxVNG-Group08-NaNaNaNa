extends  State_Boss

@onready var pivot = $"../../pivot"
@onready var animation_player = $"../../AnimationPlayer"
@onready var laser_hitbox = $"../../pivot/Area2D"


func enter():
	super.enter()
	if owner:
		owner.velocity.x = 0
		
	var player = get_tree().get_first_node_in_group("player")
	if player and pivot:
		pivot.look_at(player.global_position)
		pivot.visible = true

	if laser_hitbox:
		laser_hitbox.monitoring = false
	animation_player.play("laser")
	
	await get_tree().create_timer(1.0).timeout
	
	if laser_hitbox and pivot.visible == true:
		laser_hitbox.set_deferred("monitoring", true)
		
	await animation_player.animation_finished
	transitioned.emit(self, "idle")

func exit():
	super.exit()
	pivot.visible = false
	if laser_hitbox:
		laser_hitbox.monitoring = false
		laser_hitbox.set_deferred("monitoring", false)
