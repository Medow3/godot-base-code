extends Node

signal setting_changed(changed_setting_name: String)

const FPS_CAP_MAX: int = 300

var _debug_setting_overrides: Dictionary = {
	"screen_mode": DisplayServer.WINDOW_MODE_WINDOWED,
}

# All settings must be put in this dictionary as strings and values.
# Each variable must have a default value that will be used the settins are reset.
var _settings_variables: Dictionary = {
	"keybinds_data": {},
	"screen_mode": DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN,
	"fps_cap": 60,
	"vsync": DisplayServer.VSYNC_ENABLED,
	"screen_shake_percentage": 1.0,
	"master_volume_percentage": 1.0,
	"sound_effects_volume_percentage": 1.0,
	"music_volume_percentage": 1.0,
}
var _default_settings_variables: Dictionary = _settings_variables.duplicate(true)

var keybinds: KeybindManager = KeybindManager.new()

# Whenever a setting is updated, the code for it in this dictionary is run.
var _settings_variable_change_code: Dictionary = {
	"keybinds_data": func (_value: Variant): 
		pass,
	"screen_mode": func (value: DisplayServer.WindowMode): 
		DisplayServer.window_set_mode(value),
	"fps_cap": func (value: int): 
		if value > FPS_CAP_MAX:
			Engine.max_fps = 0
		else:
			Engine.max_fps = value,
	"vsync": func (value: DisplayServer.VSyncMode): 
		DisplayServer.window_set_vsync_mode(value),
	"screen_shake_percentage": func (_value: float): 
		pass,
	"master_volume_percentage": func (value: float):
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value)),
	"sound_effects_volume_percentage": func (value: float): 
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound Effects"), linear_to_db(value)),
	"music_volume_percentage": func (value: float): 
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value)),
}


func change_setting(setting_name: String, value: Variant) -> void:
	assert(setting_name in _settings_variables, "Setting \"" + setting_name + "\" does not exsist.")
	if value != _settings_variables[setting_name]:
		_settings_variables[setting_name] = value
		_settings_variable_change_code[setting_name].call(value)
		SaveData.save_data(-1)
		emit_signal("setting_changed", setting_name)


func change_keybind(input_action_name: String, new_input_event_object) -> void:
	keybinds.update_keybind(input_action_name, new_input_event_object)
	SaveData.save_data(-1)
	emit_signal("setting_changed", "keybinds_data")


func get_setting_value(setting_name: String) -> Variant:
	assert(setting_name in _settings_variables, "Setting \"" + setting_name + "\" does not exsist.")
	return _settings_variables[setting_name]


func reset_settings_to_default() -> void:
	for setting_name in _settings_variables.keys():
		change_setting(setting_name, _default_settings_variables[setting_name])



func get_settings_save_data() -> Dictionary:
	_settings_variables["keybinds_data"] = keybinds.get_keybind_save_data()
	return _settings_variables.duplicate(true)


func load_settings_data(settings_data: Dictionary, version: String) -> void:
	keybinds = KeybindManager.new()
	keybinds.load_keybind_save_data(settings_data["keybinds_data"], version)
	for setting_name in settings_data.keys():
		if setting_name in _settings_variables and setting_name != "keybinds_data":
			change_setting(setting_name, settings_data[setting_name])
	
	if OS.is_debug_build():
		for setting_name in _debug_setting_overrides.keys():
			change_setting(setting_name, _debug_setting_overrides[setting_name])
