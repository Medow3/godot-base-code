extends Node

const SAVE_PATH: String = "user://save.dat"
const MAX_PROFILES = 10

# All global variables that need to be saved must be put in here as strings and values.
# Each variable must have a default value that will be used when a profile is started for the first time.
var _global_saved_variables: Dictionary = {
	# Example: "profile_time": 0.0,
	"test_variable": 1,
}
var _default_global_saved_variables_values: Dictionary # Set in _init() function

var _current_profile: int = -1
var _profiles_data: Dictionary = {
	1: {},
	2: {},
	3: {},
	4: {},
	5: {},
	6: {},
	7: {},
	8: {},
	9: {},
	10: {},
}


func _init() -> void:
	_default_global_saved_variables_values = _global_saved_variables.duplicate(true)
	# Load in any save data if it exists.
	load_data(-1)


func create_new_profile(profile_number: int) -> bool:
	assert(profile_number <= MAX_PROFILES and profile_number >= 1, "Invalid profile number.")
	if not _profiles_data[profile_number].is_empty():
		return false
	_profiles_data[profile_number] = _default_global_saved_variables_values.duplicate(true)
	save_data(-1)
	return true


func delete_profile(profile_number: int) -> void:
	assert(profile_number <= MAX_PROFILES and profile_number >= 1, "Invalid profile number.")
	_profiles_data[profile_number] = {}
	save_data(-1)


func swap_profile_data(profile_1: int, profile_2: int) -> void:
	assert(profile_1 <= MAX_PROFILES and profile_1 >= 1, "Invalid profile number.")
	assert(profile_2 <= MAX_PROFILES and profile_2 >= 1, "Invalid profile number.")
	var temp = _profiles_data[profile_1]
	_profiles_data[profile_1] = _profiles_data[profile_2]
	_profiles_data[profile_2] = temp
	save_data(-1)


func select_profile(profile_number: int) -> bool:
	assert(profile_number <= MAX_PROFILES and profile_number >= 1, "Invalid profile number.")
	if _profiles_data[profile_number].is_empty():
		return false
	_current_profile = profile_number
	load_data(_current_profile)
	return true



func set_global_saved_variable(variable_name: String, variable_value) -> void:
	assert(variable_name in _global_saved_variables, "Global variable doesnt exist.")
	_global_saved_variables[variable_name] = variable_value


func get_global_saved_variable(variable_name: String) -> Variant:
	if variable_name in _global_saved_variables:
		return _global_saved_variables[variable_name]
	return null


func get_current_profile_number() -> int:
	return _current_profile



func save_data(profile_number: int = -1) -> void:
	var saved_group_nodes = get_tree().get_nodes_in_group("Saved")
	var room_saved_object_data = []
	for i in saved_group_nodes:
		if i.filename.is_empty():
			continue
		var node_stats = i.get_node_save_data()
		room_saved_object_data.append(node_stats)
	
	var data = {
		"version": ProjectSettings.get_setting("application/config/version"),
		"settings_data": Settings.get_settings_save_data(),
		"profiles": _profiles_data,
	}
	
	if profile_number >= 1 and profile_number <= MAX_PROFILES:
		data["profiles"][_current_profile] = _global_saved_variables.duplicate(true)
	
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file != null:
		file.store_var(data)
		file.close()
	else:
		push_warning("Failed to save data.")


func load_data(profile_number: int = -1) -> bool:
	if FileAccess.file_exists(SAVE_PATH):
		var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file != null:
			var player_data = file.get_var()
			if not typeof(player_data) == TYPE_DICTIONARY:
				push_error("Data corrupted")
				player_data = {
					"version": ProjectSettings.get_setting("application/config/version"),
					"settings_data": Settings.get_settings_save_data(),
					"profiles": _profiles_data,
				}
			
			var data_version = player_data["version"]
			_profiles_data = player_data["profiles"]
			
			if profile_number != -1:
				_global_saved_variables = player_data["profiles"][profile_number].duplicate(true)
			
			# Settings must be loaded last because updatings settings will
			# cause saves to happen. This could save over the loading data. Bad!
			Settings.load_settings_data(player_data["settings_data"], data_version)
			
			file.close()
			return true
	return false
