extends Node

## AudioManager manages all audio in the game
## Supports SFX (sound effects) and Music with separate buses
const SFX_DATABASE = {
	"jump": "res://assets/audio/sfx/jump.mp3",
	"startpoint": "res://assets/audio/sfx/checkpoint.mp3",
	"checkpoint": "res://assets/audio/sfx/checkpoint_2.mp3",
	"mask_shift_1": "res://assets/audio/sfx/mask_shift_01.mp3",
	"mask_shift_2": "res://assets/audio/sfx/mask_shift_02.mp3",
	"dash": "res://assets/audio/sfx/dash.mp3",
	"oxygen": "res://assets/audio/sfx/oxygen_tank.mp3",
	"death": "res://assets/audio/sfx/death.mp3",
	"alarm": "res://assets/audio/sfx/alarm.wav",
	"endpoint": "res://assets/audio/sfx/end_level.wav",
	
	### ui sfx
	"click": "res://assets/audio/sfx/click.ogg",
}

const BGM_DATABASE = {
	"bgm_01": "res://assets/audio/bgm/bgm_01.mp3",
	"bgm_02": "res://assets/audio/bgm/bgm_02.mp3",
	"bgm_03": "res://assets/audio/bgm/bgm_03.mp3",
	
	### ui
	"bgm_menu": "res://assets/audio/bgm/bgm_menu.mp3"
	
}

@export var sfx_players: Array[AudioStreamPlayer2D] = []
var max_sfx_players: int = 16

# Audio player for Music (only plays one song at a time)
var music_player: AudioStreamPlayer = null

# Bus names
const SFX_BUS: String = "SFX"
const BGM_BUS: String = "BGM"

var current_sfx_bus_name: String = SFX_BUS
var current_music_id: String = ""

func _ready() -> void:
	# Initialize music player
	music_player = AudioStreamPlayer.new()
	music_player.name = "MusicPlayer"
	music_player.bus = BGM_BUS
	add_child(music_player)
	
	# Initialize pool of SFX players
	for i in range(max_sfx_players):
		var player = AudioStreamPlayer2D.new()
		player.name = "SFXPlayer_" + str(i)
		player.bus = SFX_BUS
		add_child(player)
		sfx_players.append(player)
	
	print("AudioManager initialized with ", max_sfx_players, " SFX players")


## Play sound by ID from database
func play_sound(sound_id: String, position: Vector2 = Vector2.ZERO, volume_db: float = 0.0) -> void:
	if not SFX_DATABASE.has(sound_id):
		push_error("Sound ID không tồn tại trong Database: " + sound_id)
		return
	
	play_sound_path(SFX_DATABASE[sound_id], position, volume_db)


## Play sound by path directly
func play_sound_path(sound_path: String, position: Vector2 = Vector2.ZERO, volume_db: float = 0.0) -> void:
	var free_player: AudioStreamPlayer2D = null
	for player in sfx_players:
		if not player.playing:
			free_player = player
			break
			
	if free_player == null:
		free_player = sfx_players[0]
		
	var stream = load(sound_path)
	if stream:
		free_player.stream = stream
		free_player.volume_db = volume_db
		
		if position != Vector2.ZERO:
			free_player.global_position = position
			
		free_player.play()


## Play music, fade in
func play_music(bgm_id: String, volume_db: float = 0.0, fade_in: float = 0.0) -> void:
	if not BGM_DATABASE.has(bgm_id):
		push_error("Music ID không tồn tại trong Database: " + bgm_id)
		return
		
	if current_music_id == bgm_id and music_player.playing:
		return
		
	var path = BGM_DATABASE[bgm_id]
	var stream = load(path)
	if not stream:
		push_error("Không thể load file nhạc từ đường dẫn: " + path)
		return
		
	# Lưu lại ID nhạc hiện tại đang chạy
	current_music_id = bgm_id
	music_player.stream = stream
	music_player.bus = BGM_BUS
	
	if fade_in > 0.0:
		music_player.volume_db = -80.0 
		music_player.play()
		var tween = create_tween()
		tween.tween_property(music_player, "volume_db", volume_db, fade_in).set_trans(Tween.TRANS_SINE)
	else:
		music_player.volume_db = volume_db
		music_player.play()


## Stop music, fade out
func stop_music(fade_out: float = 0.0) -> void:
	if not music_player.playing:
		return
	
	current_music_id = ""
	
	if fade_out > 0.0:
		var tween = create_tween()
		tween.tween_property(music_player, "volume_db", -80.0, fade_out)
		await tween.finished
		music_player.stop()
		music_player.volume_db = 0.0
	else:
		music_player.stop()

## get current music id
func get_current_music_id() -> String:
	return current_music_id


## Set volume for bus
func set_bus_volume(bus_name: String, volume_db: float) -> void:
	var bus_index = AudioServer.get_bus_index(bus_name)
	if bus_index == -1:
		push_error("Bus not exists: " + bus_name)
		return
	
	AudioServer.set_bus_volume_db(bus_index, volume_db)


## Get volume of bus
func get_bus_volume(bus_name: String) -> float:
	var bus_index = AudioServer.get_bus_index(bus_name)
	if bus_index == -1:
		return 0.0
	return AudioServer.get_bus_volume_db(bus_index)

func switch_sfx_bus(bus_name: String) -> void:
	var bus_index = AudioServer.get_bus_index(bus_name)
	if bus_index == -1:
		push_error("Bus not exists: " + bus_name)
		return
	current_sfx_bus_name = bus_name
	#switch all sfx players to new bus
	for sfx_player in sfx_players:
		sfx_player.bus = bus_name

## get current sfx bus name	
func get_current_sfx_bus_name() -> String:
	return current_sfx_bus_name
