extends Node

#==============================================================
# This file handles global settings
# such as volume, screen res etc...
# so it is meant to be an autoload
# setters handle the actual change of settings
# (and emitting signals so that other nodes can be notified)
#==============================================================

signal volume_changed(type: String, value: float)
signal fullscreen_changed(value: bool)

var common_resolutions = [
	Vector2i(1280, 720),
	Vector2i(1366, 768),
	Vector2i(1600, 900),
	Vector2i(1920, 1080),
	Vector2i(2560, 1440),
	Vector2i(3840, 2160)
]

func get_compatible_resolutions()-> Array:
	var screen_index = DisplayServer.window_get_current_screen()
	var max_res = DisplayServer.screen_get_size(screen_index)
	var available = []
	
	for res in common_resolutions:
		if res.x <= max_res.x and res.y <= max_res.y:
			available.append(res)
	return available

var master_volume_level: float:
	set(value):
		master_volume_level = value
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value / 100.0))
		volume_changed.emit("Master", value)
		
var music_volume_level: float:
	set(value):
		music_volume_level = value
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value / 100.0))
		volume_changed.emit("Music", value)
		
var sound_effects_volume_level:float:
	set(value):
		sound_effects_volume_level = value
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sounds"), linear_to_db(value / 100.0))
		volume_changed.emit("Sounds", value)

var is_fullscreen: bool:
	set(value):
		is_fullscreen = value
		# Applica direttamente la modalità finestra
		if is_fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		fullscreen_changed.emit(value)

func save_settings_to_file():
	var config=ConfigFile.new()
	config.set_value("Display", "is_fullscreen", is_fullscreen)
	config.set_value("Audio", "master_volume_level", master_volume_level)
	config.set_value("Audio", "music_volume_level", music_volume_level)
	config.set_value("Audio", "sound_effects_volume_level", sound_effects_volume_level)
	config.save("user://settings.cfg")


func load_settings_from_file():
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	
	if err != OK:
		return
	
	is_fullscreen=config.get_value("Display", "is_fullscreen", false)
	master_volume_level=config.get_value("Audio", "master_volume_level", 50.0)
	music_volume_level=config.get_value("Audio", "music_volume_level", 75.0)
	sound_effects_volume_level=config.get_value("Audio", "sound_effects_volume_level", 75.0)
