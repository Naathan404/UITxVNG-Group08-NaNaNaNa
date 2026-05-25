extends CharacterBody2D

@export var distance_x: float = 200.0

var player: Node2D
var locked_y: float = 0.0

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	var destroyer = $EntityDestroyer
	

func _physics_process(delta: float) -> void:
	if player:
		if global_position.x < player.global_position.x - distance_x:
			global_position.x = player.global_position.x - distance_x
		var direction_to_player = player.global_position.x - global_position.x
		var sprite = $AnimatedSprite2D
	
		if direction_to_player > 0:
				sprite.flip_h = true
		elif direction_to_player < 0:
				sprite.flip_h = false 


func _on_entity_destroyer_body_entered(body: Node2D) -> void:
	if body == self or body.is_in_group("player"):
		return
		
	if body is TileMapLayer or body is TileMap:
		return

	if body.is_in_group("bullets"): 
		return

	body.queue_free()


func _on_entity_destroyer_area_entered(area: Area2D) -> void:
	if area.get_parent() == self or area.is_in_group("player"):
		return
	if area.is_in_group("bullets"):
		return
	area.queue_free()
