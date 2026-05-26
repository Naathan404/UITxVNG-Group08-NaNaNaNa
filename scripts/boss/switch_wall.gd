extends Node2D

@export var drop_distance: float = 150.0 
@export var drop_duration: float = 1.0  

@onready var wall = $wall 
@onready var detector = $Button

var is_triggered: bool = false

func _ready() -> void:
	detector.body_entered.connect(_on_detector_entered)
	

func _on_detector_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not is_triggered:
		is_triggered = true
		start_mechanism()

func start_mechanism() -> void:
	# nút sau khi ấn
	await get_tree().create_timer(0.2).timeout
	
	shake_screen(2.0)
	
	var wall_tween = create_tween()
	var target_y = wall.position.y + drop_distance
	
	wall_tween.tween_property(wall, "position:y", target_y, drop_duration)\
		.set_trans(Tween.TRANS_EXPO)\
		.set_ease(Tween.EASE_IN)
	
	wall_tween.tween_callback(on_wall_finished)

func on_wall_finished() -> void:
	shake_screen(8.0)
	
func shake_screen(amount: float) -> void:
	var camera = get_tree().get_first_node_in_group("camera")
	if camera and camera.has_method("add_shake"):
		camera.add_shake(amount)
