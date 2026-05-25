extends Area2D

@export var off_y: float = 5.0
@export var tween_duration: float = 1.0

@export_group("Follow Settings")
@export var follow_speed: float = 8.0
@export var follow_offset: Vector2 = Vector2(-20, -30) # Tọa độ bay lơ lửng (sau lưng, trên đầu)

enum State { IDLE, FOLLOWING, UNLOCKING }
var current_state: State = State.IDLE

var target_player: Node2D = null
var idle_tween: Tween

func _ready() -> void:
	add_to_group("keys")
	_start_idle_animation()

func _start_idle_animation() -> void:
	var original_pos_y = position.y
	idle_tween = create_tween().set_loops()
	idle_tween.set_trans(Tween.TRANS_SINE)
	idle_tween.set_ease(Tween.EASE_IN_OUT)
	idle_tween.tween_property(self, "position:y", original_pos_y + off_y, tween_duration)
	idle_tween.tween_property(self, "position:y", original_pos_y, tween_duration)

func _process(delta: float) -> void: 
	if Engine.is_editor_hint(): return 
	
	if current_state == State.FOLLOWING and is_instance_valid(target_player):
		var target_pos = target_player.global_position + follow_offset
		global_position = global_position.lerp(target_pos, follow_speed * delta)

func _on_body_entered(body: Node2D) -> void:
	if current_state == State.IDLE and body.is_in_group("player"):
		current_state = State.FOLLOWING
		target_player = body
		AudioManager.play_sound("pickup", global_position, 5.0)
		
		if idle_tween:
			idle_tween.kill()

func fly_to_door_and_unlock(door_node: Node2D) -> void:
	if current_state == State.UNLOCKING: return
	current_state = State.UNLOCKING
	
	var fly_tween = create_tween()
	fly_tween.set_trans(Tween.TRANS_BACK)
	fly_tween.set_ease(Tween.EASE_IN)
	fly_tween.tween_property(self, "global_position", door_node.global_position, 0.4)
	
	fly_tween.finished.connect(func():
		door_node.open_door() 
		queue_free())
