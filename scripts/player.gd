extends CharacterBody2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var move_speed: float = 200.0
@export var jump_force: float = -300.0
var isFacingRight = true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)

	move_and_slide()
	_render(direction)


##### ============= RENDER player on screen ==========
func _render(direction: float) -> void:
	if is_on_floor():
		if abs(velocity.x) > 1.0:
			animated_sprite.animation = "run"
		else:
			animated_sprite.animation = "idle"
	else:
		if velocity.y < -10.0:
			animated_sprite.animation = "jump"
		else:
			animated_sprite.animation = "fall"
			
	# check flip
	if direction == 1.0:
		animated_sprite.flip_h = false
	elif direction == -1.0:
		animated_sprite.flip_h = true
	
	pass
