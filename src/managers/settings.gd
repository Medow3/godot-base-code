extends Node

signal changed

enum FULLSCREEN_TYPES {
	FULLSCREEN,
	BORDERLESS_FULLSCREEN,
	OFF
}

var keybinds: KeybindManager = KeybindManager.new()
var fullscreen: int = FULLSCREEN_TYPES.FULLSCREEN
var cap_fps_at_60: bool = true
var vsync: DisplayServer.VSyncMode = DisplayServer.VSYNC_ENABLED
var screen_shake: bool = true

var master_volume: float = 0.4
var sound_effects_volume: float = 1.0
var music_volume: float = 1.0



func on_setting_changed() -> void:
	SaveData.save_data(-1)
	emit_signal("changed")



func set_master_volume(new_value: float) -> void:
	if new_value != master_volume:
		master_volume = new_value
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), master_volume)
		on_setting_changed()


func set_music_volume(new_value: float) -> void:
	if new_value != music_volume:
		music_volume = new_value
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), music_volume)
		on_setting_changed()


func set_sound_effects_volume(new_value: float) -> void:
	if new_value != sound_effects_volume:
		sound_effects_volume = new_value
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound Effects"), sound_effects_volume)
		on_setting_changed()



func set_keybind(input_action_name: String, new_input_event_object: InputEvent) -> void:
	keybinds.update_keybind(input_action_name, new_input_event_object)
	on_setting_changed()


func reset_keybinds_to_default() -> void:
	pass




func set_full_screen(new_value: int) -> void:
	assert(new_value >= 0 and new_value <= 2) #,"Invalid fullscreen enum value")
	if new_value != fullscreen:
		fullscreen = new_value
		match fullscreen:
			FULLSCREEN_TYPES.FULLSCREEN:
				get_window().borderless = (true)
				get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (true) else Window.MODE_WINDOWED
				get_window().always_on_top = (true)
				get_window().set_size(DisplayServer.screen_get_size())
				get_window().set_position(Vector2(0, 0))
			FULLSCREEN_TYPES.BORDERLESS_FULLSCREEN:
				get_window().borderless = (true)
				get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (false) else Window.MODE_WINDOWED
				get_window().set_size(DisplayServer.screen_get_size())
				get_window().set_position(Vector2(0, 0))
				get_window().always_on_top = (false)
			FULLSCREEN_TYPES.OFF:
				get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (false) else Window.MODE_WINDOWED
				get_window().borderless = (false)
				get_window().set_size(DisplayServer.screen_get_size())
				get_window().set_position(Vector2(0, 0))
				get_window().always_on_top = (false)
		on_setting_changed()


func set_fps_cap_at_60(new_value: bool) -> void:
	if new_value != cap_fps_at_60:
		cap_fps_at_60 = new_value
		if cap_fps_at_60:
			Engine.max_fps = 60
		else:
			Engine.max_fps = 0
		on_setting_changed()


func set_vsync(new_value: DisplayServer.VSyncMode) -> void:
	if new_value != vsync:
		vsync = new_value
		DisplayServer.window_set_vsync_mode(new_value)
		on_setting_changed()


func set_screen_shake(new_value: bool) -> void:
	if new_value != screen_shake:
		screen_shake = new_value
		on_setting_changed()


func reset_settings_to_default() -> void:
#	keybinds = {
#		"Jump": [KEY_UP, false],
#		"Interact": [KEY_DOWN, false],
#		"Left": [KEY_LEFT, false],
#		"Right": [KEY_RIGHT, false],
#		"Attack": [KEY_Z, false],
#		"Dash": [KEY_C, false],
#		"Grapple": [KEY_X, false],
#		"Map": [KEY_CONTROL, false],
#		"Inventory": [KEY_F, false],
#		"Carvings": [KEY_G, false],
#		"Use Patch": [KEY_SHIFT, false],
#	}
	fullscreen = FULLSCREEN_TYPES.FULLSCREEN
	cap_fps_at_60 = true
	vsync = DisplayServer.VSYNC_ENABLED
	screen_shake = true
	
	master_volume = true
	sound_effects_volume = true
	music_volume = true


func get_settings_save_data() -> Dictionary:
	return {
#		"keybinds": keybinds,
#		"controller_keybinds": controller_keybinds,
		"fullscreen": fullscreen,
		"cap_fps_at_60": cap_fps_at_60,
		"vsync": vsync,
		"screen_shake": screen_shake,
		"master_volume": master_volume,
		"sound_effects_volume": sound_effects_volume,
		"music_volume": music_volume,
	}


func load_settings_data(settings_data: Dictionary, version: String) -> void:
	set_full_screen(settings_data["fullscreen"])
	set_fps_cap_at_60(true)
	set_vsync(settings_data["vsync"])
	set_screen_shake(settings_data["screen_shake"])
#	set_keybinds(settings_data["keybinds"], settings_data["controller_keybinds"])
	set_master_volume(settings_data["master_volume"])
	set_sound_effects_volume(settings_data["sound_effects_volume"])
	set_music_volume(settings_data["music_volume"])
	
	
