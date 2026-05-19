extends PlayerState

## ghost effect setting
const GHOST_SCENE = preload("res://scenes/player/ghost_effect.tscn")
@export var ghost_effect_interval: float = 0.05
@export var oxygen_cost: float = 10.0
var ghost_timer: float = 0.0

## dash direction, mặc định là hướng sang phải
var dash_direction: int = 1


func _enter() -> void:
	if obj.mask_type == obj.MaskType.NONE:
		obj.change_animation("dash")
	elif obj.mask_type == obj.MaskType.RED:
		obj.change_animation("dash_red")
	else:
		obj.change_animation("dash_blue")
	
	obj.get_node("DashParticles").emitting = true
	
	_use_oxygen(oxygen_cost)
		
	obj.can_dash = false;
	obj.ignore_gravity = true;
	dash_direction = obj.direction
	timer = obj.dash_duration
	
	# tạo timer cho ghost effect
	ghost_timer = 0.0
	_spawn_ghost()
	pass
	
func _update(delta: float) -> void:
	obj.velocity.x = dash_direction * obj.dash_force
	obj.velocity.y = 0;
	
	ghost_timer += delta
	if ghost_timer > ghost_effect_interval:
		ghost_timer = 0.0
		_spawn_ghost()
	
	if update_timer(delta):
		# Hết thời gian lướt
		if obj.is_on_floor():
			if abs(Input.get_axis("left", "right")) > 0.1:
				change_state(fsm.states.run)
			else:
				change_state(fsm.states.idle)
		else:
			change_state(fsm.states.fall)
	pass
	
# Called when the node enters the scene tree for the first time.
func _exit() -> void:
	obj.get_node("DashParticles").emitting = false
	obj.ignore_gravity = false
	obj.velocity.x *= 0.5



#### sinh ra ghost object cho ghost effect
func _spawn_ghost() -> void:
	if obj.animated_sprite == null: return
	# tạo vật thể ghost
	var ghost = GHOST_SCENE.instantiate() as Sprite2D
	# set ghost là node con của node States
	obj.get_parent().add_child(ghost)
	# lấy ảnh frame hiện tại của người chơi để gán vào ghost 
	var current_anim = obj.animated_sprite.animation
	var current_frame = obj.animated_sprite.frame
	
	# cái texture_at_frame này Nguyên chưa hiểu lắm 
	var texture_at_frame = obj.animated_sprite.sprite_frames.get_frame_texture(current_anim, current_frame)
	ghost.texture = texture_at_frame
	
	# gán vị trí cho ghost
	ghost.position = obj.position
	
	# lật hướng ghost
	ghost.scale.x = obj.get_node("Direction2D").scale.x
	

func _use_oxygen(new_value: float) -> void:
	var tween = create_tween()
	tween.tween_property(obj, "current_oxygen", obj.current_oxygen - new_value, 0.3)
	obj.is_oxygen_decreased = true
	obj.is_oxygen_decreased_by_other_source = true
	await tween.finished
	obj.is_oxygen_decreased = false
	obj.is_oxygen_decreased_by_other_source = false
	pass
