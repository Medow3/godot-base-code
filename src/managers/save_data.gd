extends Node

const VERSION: String = "1.0.0.0"
const SAVE_PATH: String = "user://save.dat"
const MAX_PROFILES = 10


var global_variables: Dictionary = {}

var current_profile: int = -1
var profiles_data: Dictionary = {
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



func create_new_profile(profile_number: int) -> bool:
	assert(profile_number <= MAX_PROFILES and profile_number >= 1) #,"Invalid profile number")
	if not profiles_data[profile_number].is_empty():
		return false
	profiles_data[profile_number] = get_reset_save_data()
	save_data(-1)
	return true


func delete_profile(profile_number: int) -> void:
	assert(profile_number <= MAX_PROFILES and profile_number >= 1) #,"Invalid profile number")
	profiles_data[profile_number] = {}
	save_data(-1)


func swap_profile_data(profile_1: int, profile_2: int) -> void:
	assert(profile_1 <= MAX_PROFILES and profile_1 >= 1) #,"Invalid profile number")
	assert(profile_2 <= MAX_PROFILES and profile_2 >= 1) #,"Invalid profile number")
	var temp = profiles_data[profile_1]
	profiles_data[profile_1] = profiles_data[profile_2]
	profiles_data[profile_2] = temp
	save_data(-1)


func select_profile(profile_number: int) -> bool:
	assert(profile_number <= MAX_PROFILES and profile_number >= 1) #,"Invalid profile number")
	if profiles_data[profile_number].is_empty():
		return false
	current_profile = profile_number
	load_data(current_profile)
	return true



func add_global_variable(variable_name: String, variable_value) -> void:
	assert(not variable_name in global_variables) #,"Global variable already exists.")
	global_variables[variable_name] = variable_value


func update_global_variable(variable_name: String, variable_value) -> void:
	assert(variable_name in global_variables) #,"Global variable doesnt exist.")
	global_variables[variable_name] = variable_value


func get_global_variable(variable_name: String):
	if variable_name in global_variables:
		return global_variables[variable_name]
	return null


func get_and_remove_global_variable(variable_name: String):
	if variable_name in global_variables:
		var value = global_variables[variable_name]
		global_variables.erase(variable_name)
		return value
	return null



func get_reset_save_data() -> Dictionary:
	return {
		global_variables = {}
		# Set the default data here
		# Example: "profile_time": 0.0,
		
	}


func save_data(profile_number: int = -1) -> void:
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	
	var saved_group_nodes = get_tree().get_nodes_in_group("Saved")
	var room_saved_object_data = []
	for i in saved_group_nodes:
		if i.filename.is_empty():
			continue
		var node_stats = i.get_node_save_data()
		room_saved_object_data.append(node_stats)
	
	var data = {
		"version": VERSION,
		"settings_data": Settings.get_settings_save_data(),
		"profiles": profiles_data,
	}
	
	if profile_number >= 1 and profile_number <= MAX_PROFILES:
		data["profiles"][current_profile] = {
			"global_variables": global_variables,
			# Save data here
			# Example: "profile_time": profile_time,
			
		}
	
	if file != null:
		file.store_var(data)
		file.close()


func load_data(profile_number: int = -1) -> bool:
	if FileAccess.file_exists(SAVE_PATH):
		var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file != null:
			var player_data = file.get_var()
			if not typeof(player_data) == TYPE_DICTIONARY:
				print("Data corrupted")
				player_data = {
				"version": VERSION,
				"settings_data": Settings.get_settings_save_data(),
				"profiles": profiles_data,
			}
			
			var version = player_data["version"]
			profiles_data = player_data["profiles"]
			
			if profile_number != -1:
				var profile_data = player_data["profiles"][profile_number]
				
				global_variables = profile_data["global_variables"]
				# Load data here from profile_data
				# Example: profile_time = profile_data["profile_time"]
			
			# Settings must be loaded last because updatings settings will
			# cause saves to happen. This could save over the loading data. Bad!
			Settings.load_settings_data(player_data["settings_data"], version)
			
			file.close()
			return true
	return false
