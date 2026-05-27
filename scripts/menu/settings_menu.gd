extends CanvasLayer

var panel: Panel
var vbox: VBoxContainer
var title: Label
var mute_btn: Button
var font: Font
var close_btn: TextureButton

func _ready():
	layer = 100
	font = load("res://assets/font/Minecraft.ttf")
	
	var bg = ColorRect.new()
	bg.color = Color(0, 0, 0, 0.8) 
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	
	var center = CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(center)
	
	panel = Panel.new()
	# The game resolution is 480x270, so the panel must be smaller than that.
	panel.custom_minimum_size = Vector2(320, 220)
	center.add_child(panel)
	
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.15, 0.15, 0.15, 1.0)
	style.corner_radius_top_left = 6
	style.corner_radius_top_right = 6
	style.corner_radius_bottom_left = 6
	style.corner_radius_bottom_right = 6
	style.border_width_bottom = 3
	style.border_color = Color(0, 0, 0, 1.0)
	panel.add_theme_stylebox_override("panel", style)
	
	var margin = MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 15)
	margin.add_theme_constant_override("margin_right", 15)
	margin.add_theme_constant_override("margin_top", 15)
	margin.add_theme_constant_override("margin_bottom", 15)
	panel.add_child(margin)
	
	vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	margin.add_child(vbox)
	
	title = Label.new()
	title.text = "SETTINGS"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	if font: title.add_theme_font_override("font", font)
	title.add_theme_font_size_override("font_size", 24)
	vbox.add_child(title)
	
	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 5)
	vbox.add_child(spacer)
	
	mute_btn = Button.new()
	_update_mute_btn()
	if font: mute_btn.add_theme_font_override("font", font)
	mute_btn.add_theme_font_size_override("font_size", 12)
	mute_btn.pressed.connect(_on_mute_pressed)
	vbox.add_child(mute_btn)
	
	vbox.add_child(_create_volume_control("Âm lượng tổng (Master)", "Master"))
	
	# Create Close Button (TextureButton)
	close_btn = TextureButton.new()
	close_btn.texture_normal = load("res://assets/sprites/ui/buttons/Close.png")
	close_btn.texture_pressed = load("res://assets/sprites/ui/buttons/Close_pressed.png")
	close_btn.texture_hover = load("res://assets/sprites/ui/buttons/Close_pressed.png")
	# Make it smaller if needed, but pixel art buttons are usually already small
	close_btn.ignore_texture_size = true
	close_btn.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	close_btn.custom_minimum_size = Vector2(30, 30)
	
	# Position top-left inside the panel
	close_btn.set_anchors_preset(Control.PRESET_TOP_LEFT)
	close_btn.position = Vector2(-10, -10) # slightly offset outside or inside depending on preference. Let's do inside: (5, 5)
	close_btn.position = Vector2(5, 5)
	
	close_btn.pressed.connect(_on_close_pressed)
	panel.add_child(close_btn)

func _create_volume_control(label_text: String, bus_name: String) -> VBoxContainer:
	var container = VBoxContainer.new()
	container.add_theme_constant_override("separation", 2)
	
	var lbl = Label.new()
	lbl.text = label_text
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	if font: lbl.add_theme_font_override("font", font)
	lbl.add_theme_font_size_override("font_size", 12)
	container.add_child(lbl)
	
	var hbox = HBoxContainer.new()
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	hbox.add_theme_constant_override("separation", 10)
	
	var minus_btn = Button.new()
	minus_btn.text = " - "
	minus_btn.custom_minimum_size = Vector2(30, 0)
	if font: minus_btn.add_theme_font_override("font", font)
	minus_btn.add_theme_font_size_override("font_size", 12)
	
	var plus_btn = Button.new()
	plus_btn.text = " + "
	plus_btn.custom_minimum_size = Vector2(30, 0)
	if font: plus_btn.add_theme_font_override("font", font)
	plus_btn.add_theme_font_size_override("font_size", 12)
	
	var val_lbl = Label.new()
	val_lbl.custom_minimum_size = Vector2(50, 0)
	val_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	if font: val_lbl.add_theme_font_override("font", font)
	val_lbl.add_theme_font_size_override("font_size", 12)
	
	hbox.add_child(minus_btn)
	hbox.add_child(val_lbl)
	hbox.add_child(plus_btn)
	container.add_child(hbox)
	
	var bus_idx = AudioServer.get_bus_index(bus_name)
	
	var update_lbl = func():
		var vol_db = AudioServer.get_bus_volume_db(bus_idx)
		var percent = round(db_to_linear(vol_db) * 100)
		val_lbl.text = str(percent) + "%"
		
	update_lbl.call()
	
	minus_btn.pressed.connect(func():
		var vol_db = AudioServer.get_bus_volume_db(bus_idx)
		var linear = max(0.0, db_to_linear(vol_db) - 0.1)
		AudioServer.set_bus_volume_db(bus_idx, linear_to_db(linear))
		update_lbl.call()
		if AudioManager.has_method("play_sound"): AudioManager.play_sound("click", Vector2.ZERO, 10.0)
	)
	
	plus_btn.pressed.connect(func():
		var vol_db = AudioServer.get_bus_volume_db(bus_idx)
		var linear = min(1.0, db_to_linear(vol_db) + 0.1)
		AudioServer.set_bus_volume_db(bus_idx, linear_to_db(linear))
		update_lbl.call()
		if AudioManager.has_method("play_sound"): AudioManager.play_sound("click", Vector2.ZERO, 10.0)
	)
	
	return container

func _update_mute_btn():
	var is_muted = AudioServer.is_bus_mute(AudioServer.get_bus_index("Master"))
	mute_btn.text = "Tắt tiếng: " + ("Bật" if is_muted else "Tắt")

func _on_mute_pressed():
	var bus_idx = AudioServer.get_bus_index("Master")
	var is_muted = not AudioServer.is_bus_mute(bus_idx)
	AudioServer.set_bus_mute(bus_idx, is_muted)
	_update_mute_btn()
	if AudioManager.has_method("play_sound"):
		AudioManager.play_sound("click", Vector2.ZERO, 10.0)

func _on_close_pressed():
	if AudioManager.has_method("play_sound"):
		AudioManager.play_sound("click", Vector2.ZERO, 10.0)
	queue_free()
