class_name KeybindManager extends Node

#export var keep_default_ui_bindings: bool = true
@export var default_keybinds: Dictionary = {}


var default_input_actions: Array = []

var input_actions: Array = [] # Initialized in _init()


func _init() -> void:
	input_actions = set_up_keybind_library()


func set_up_keybind_library() -> Array:
	var all_input_action_keybinds_objects = []
	var all_input_actions_names = InputMap.get_actions()
	for i in all_input_actions_names:
		var new_input_action_keybinds = InputActionKeybinds.new()
		new_input_action_keybinds.set_to_action(i)
		all_input_action_keybinds_objects.append(new_input_action_keybinds)
	default_input_actions = all_input_action_keybinds_objects.duplicate(true)
	return all_input_action_keybinds_objects


func reset_keybinds_to_default() -> void:
	input_actions = default_input_actions.duplicate(true)
	update_input_map()


func update_input_map() -> void:
	for i in input_actions:
		i.update_input_map_for_keybinds()


func update_keybind(action_name: String, new_keybind_input_action: InputEvent) -> void:
	assert(new_keybind_input_action == null or KeybindTypes.is_object_a_valid_keybind_type(new_keybind_input_action)) #,"Invalid keybind type.")
	for i in input_actions:
		if i.action_name == action_name:
			i.update_keybind(new_keybind_input_action)
			i.update_input_map_for_keybinds()


func get_button_string_for_action(action_name: String, for_controller: bool) -> String:
	for i in input_actions:
		if i.action_name == action_name:
			return i.get_button_string_for_action(for_controller)
	
	assert(false) #,"Invalid action_name.")
	return ""


func get_keybind_save_data() -> Dictionary:
	var save_data := {}
	for i in input_actions:
		save_data[i.action_name] = i.get_save_data()
	return save_data


func load_keybind_save_data(keybind_data: Dictionary, version: String) -> void:
	input_actions = []
	for i in keybind_data.keys():
		var new_input_action_keybinds = InputActionKeybinds.new()
		new_input_action_keybinds.load_save_data(keybind_data[i])
		input_actions.append(new_input_action_keybinds)
	update_input_map()
