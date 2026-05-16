class_name BaseCharacter
extends CharacterBody2D

## Base character class that provides common functionality for all characters
### Basic movement variables
@export var movement_speed: float = 200.0
@export var jump_force: float = 350.0

### Gravity and Direction
@export var gravity: float = 1000.0
@export var direction: int = 1

### Dash Setting
@export var dash_force: float = 600.0
@export var dash_duration: float = 0.2
var ignore_gravity: bool = false
var can_dash: bool = true

### Buffer jump & Coyote time
@export var coyote_time: float = 0.2      
@export var jump_buffer_time: float = 0.2
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0

### Ray cast
@onready var left_raycast: RayCast2D = $LeftRay
@onready var right_raycast: RayCast2D = $RightRay
@export var corner_correction_speed: float = 6.0	# tốc độ đẩy ra khi trúng góc

### Mask
enum MaskType { NONE, RED, BLUE }
@export var mask_type: MaskType = MaskType.NONE

var fsm: FSM = null
var current_animation = null
var animated_sprite: AnimatedSprite2D = null

var _next_animation = null
var _next_direction: int = 1
var _next_animated_sprite: AnimatedSprite2D = null

func _ready() -> void:
	set_animated_sprite($Direction2D/AnimatedSprite2D)

func _physics_process(delta: float) -> void:
	# Animation
	_check_changed_animation()
	
	# Check coyote time
	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta
	
	#Check buffer jump
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time
	else:
		jump_buffer_timer -= delta

	if fsm != null:
		fsm._update(delta)
	# Movement
	_update_movement(delta)
	# Direction
	_check_changed_direction()


func _update_movement(delta: float) -> void:
	### xử lý rơi
	if not is_on_floor() and not ignore_gravity:
		velocity.y += gravity * delta
	
	### nếu đang đứng trên đất thì có thể dash
	if is_on_floor():
		can_dash = true
		
	# thực hiện chỉnh góc khi người chơi ở trên không
	if velocity.y < 0:
		_apply_corner_correction()
	
	# di chuyển
	move_and_slide()
	pass

func turn_around() -> void:
	if _next_direction != direction:
		return
	_next_direction = -direction

func is_left() -> bool:
	return direction == -1

func is_right() -> bool:
	return direction == 1

func turn_left() -> void:
	_next_direction = -1

func turn_right() -> void:
	_next_direction = 1

func jump() -> void:
	velocity.y = -jump_force

func stop_move() -> void:
	velocity.x = 0
	velocity.y = 0

# Change the animation of the character on the next frame
func change_animation(new_animation: String) -> void:
	_next_animation = new_animation

# Change the direction of the character on the last frame
func change_direction(new_direction: int) -> void:
	_next_direction = new_direction

# Get the name of the current animation
func get_animation_name() -> String:
	return current_animation.name

func set_animated_sprite(new_animated_sprite: AnimatedSprite2D) -> void:
	_next_animated_sprite = new_animated_sprite

# Check if the animation or animated sprite has changed and play the new animation
func _check_changed_animation() -> void:
	var need_play: bool = false
	if _next_animation != current_animation:
		current_animation = _next_animation
		need_play = true
	if _next_animated_sprite != animated_sprite:
		if animated_sprite != null:
			animated_sprite.hide()
		animated_sprite = _next_animated_sprite
		animated_sprite.show()
		need_play = true
	if need_play:
		if animated_sprite != null and current_animation != null:
			animated_sprite.play(current_animation)

# Check if the direction has changed and set the new direction
func _check_changed_direction() -> void:
	if _next_direction != direction:
		direction = _next_direction
		_on_changed_direction()
		if direction == -1:
			$Direction2D.scale.x = -1
		if direction == 1:
			$Direction2D.scale.x = 1
			
# Hàm dùng để check góc và hiệu chỉnh góc va chạm phía trên
func _apply_corner_correction() -> void:
	if left_raycast.is_colliding() and not right_raycast.is_colliding():
		position.x += corner_correction_speed
	if right_raycast.is_colliding() and not left_raycast.is_colliding():
		position.x -= corner_correction_speed
	pass

# On changed direction
func _on_changed_direction() -> void:
	pass
