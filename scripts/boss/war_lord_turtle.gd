extends CharacterBody2D

@export var distance_x: float = 200.0

@onready var debris_particles: CPUParticles2D = $DebrisParticles

var player: Node2D
var locked_y: float = 0.0
var is_enraged: bool = false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	var destroyer = $EntityDestroyer
	if GameManager.boss_saved_position != null:
		global_position = GameManager.boss_saved_position
	

func _physics_process(delta: float) -> void:
	if has_node("ScreenNotifier"):
		if $ScreenNotifier.is_on_screen() and abs(velocity.x) > 0:
			var camera = get_tree().get_first_node_in_group("camera")
			if camera and camera.has_method("add_shake"):
				camera.add_shake(2.5)
				
	if player:
		var direction_to_player = player.global_position.x - global_position.x
		var sprite = $AnimatedSprite2D
	
		if direction_to_player > 0:
				sprite.flip_h = true
		elif direction_to_player < 0:
				sprite.flip_h = false 

func activate_debris_effect(target_pos: Vector2) -> void:
	if debris_particles:
		debris_particles.global_position = target_pos
		
		if player:
			var direction = (player.global_position - target_pos).normalized()
			debris_particles.direction = direction

		debris_particles.restart()
		debris_particles.emitting = true

func _on_entity_destroyer_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_method("take_dame"):
			body.take_dame(100)
	if body == self or body.is_in_group("player"):
		return
		
	if body is TileMapLayer or body is TileMap:
		return

	if body.is_in_group("bullets"): 
		return
		
	if body.is_in_group("toxic_zones"):
		return
	if body.is_in_group("checkpoints"):
		return
	if body.is_in_group("rain_zones"):
		return
	activate_debris_effect(body.global_position)
	body.queue_free()


func _on_entity_destroyer_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		if area.has_method("take_dame"):
			area.take_dame(100)
	if area.get_parent() == self:
		return
		
	if area.is_in_group("bullets"):
		return
		
	if area.is_in_group("toxic_zones"):
		return
	
	if area.is_in_group("checkpoints"):
		return
	
	if area.is_in_group("rain_zones"):
		return
	activate_debris_effect(area.global_position)
	area.queue_free()


func _on_screen_notifier_screen_entered() -> void:
	var camera = get_tree().get_first_node_in_group("camera")
	if camera and camera.has_method("add_shake"):
		camera.add_shake(5.0)

func apply_rain_buff(active: bool) -> void:
	print("[BOSS] đã vào vùng mưa")
	is_enraged = active
	if is_enraged:
		distance_x = 10.0
	else:
		distance_x = 200.0
