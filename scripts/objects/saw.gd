extends Area2D

enum MaskType {NONE, RED, BLUE }

@export_group("Buzzsaw Settings")
@export_enum("Red", "Blue", "None") var saw_color: String = "Red"
@export var move_speed: float = 100.0

var chain = preload("res://assets/sprites/envir/Chain.png")

@onready var path_follow: PathFollow2D = get_parent()
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_active: bool = true
var speed: float

func _ready() -> void:
	add_to_group("saw") 
	sprite.play("activated")
	
	speed = move_speed
	if saw_color == "Red":
		sprite.modulate = Color(1.5, 0.2, 0.2)
	elif saw_color == "Blue":
		sprite.modulate = Color(0.2, 0.5, 1.5)
	else:
		sprite.modulate = Color.WHITE
		
	body_entered.connect(_on_body_entered)
	_draw_chain_path()

func _process(delta: float) -> void:
	if path_follow and path_follow is PathFollow2D:
		path_follow.progress += speed * delta
	
	if is_active:
		sprite.rotation += 15.0 * delta

func update_mask_state(player_mask: int) -> void:
	if (saw_color == "Red" and player_mask == MaskType.BLUE) or \
	   (saw_color == "Blue" and player_mask == MaskType.RED):
		is_active = false
		sprite.modulate.a = 0.2
		speed = move_speed * 0.5
	else:
		is_active = true
		sprite.modulate.a = 1.0
		speed = move_speed
		
	set_deferred("monitoring", is_active)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and is_active:
		if body.has_method("_on_death"):
			body._on_death()


func _draw_chain_path() -> void:
	var path_node = path_follow.get_parent()
	
	if path_node is Path2D and not path_node.has_node("SawChain"):
		var chain_line = Line2D.new()
		chain_line.name = "SawChain"
		
		chain_line.texture = chain
		chain_line.texture_mode = Line2D.LINE_TEXTURE_TILE
		chain_line.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
		
		chain_line.width = 6.0 
		chain_line.z_index = -3 
		chain_line.default_color = Color(0.6, 0.6, 0.6) 
		
		chain_line.points = path_node.curve.get_baked_points()
		path_node.call_deferred("add_child", chain_line)
