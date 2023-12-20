class_name InputActionKeybinds extends Node

@export var action_name: String
@export var key_keybind: InputEventKey
@export var mouse_button_keybind: InputEventMouseButton
@export var joy_button_keybind: InputEventJoypadButton
@export var joy_axis_keybind: InputEventJoypadMotion

const NO_BUTTON_ASSIGNED_TO_ACTION_DISPLAY_TEXT: String = "[Button Unassigned]"

const MOUSE_BUTTON_STRINGS: Dictionary = {
	MOUSE_BUTTON_LEFT: "Left Click",
	MOUSE_BUTTON_RIGHT: "Right Click",
	MOUSE_BUTTON_MIDDLE: "Middle Click",
	MOUSE_BUTTON_XBUTTON1: "X1 Click",
	MOUSE_BUTTON_XBUTTON2: "X2 Click",
	MOUSE_BUTTON_WHEEL_UP: "Wheel Up",
	MOUSE_BUTTON_WHEEL_DOWN: "Wheel Down",
	MOUSE_BUTTON_WHEEL_LEFT: "Wheel Left",
	MOUSE_BUTTON_WHEEL_RIGHT: "Wheel Right",
}


func set_to_action(new_action_name: String) -> void:
	action_name = new_action_name
	var action_list = InputMap.action_get_events(new_action_name)
	for i in action_list:
		update_keybind(i)


func update_keybind(new_keybind_object: InputEvent) -> void:
	if new_keybind_object == null:
		if GameManager.using_controller:
			joy_button_keybind = null
			joy_axis_keybind = null
		else:
			key_keybind = null
			mouse_button_keybind = null
		return
	
	var keybind_type = KeybindTypes.get_keybind_type_of_object(new_keybind_object)
	assert(keybind_type != -1) #,"Invalid keybind type.")
	match keybind_type:
		KeybindTypes.KEYBIND_TYPES.KEY:
			key_keybind = new_keybind_object
			mouse_button_keybind = null
		KeybindTypes.KEYBIND_TYPES.MOUSE_BUTTON:
			key_keybind = null
			mouse_button_keybind = new_keybind_object
		KeybindTypes.KEYBIND_TYPES.JOYPAD_BUTTON:
			joy_button_keybind = new_keybind_object
			joy_axis_keybind = null
		KeybindTypes.KEYBIND_TYPES.JOYPAD_AXIS:
			joy_button_keybind = null
			joy_axis_keybind = new_keybind_object


func update_input_map_for_keybinds() -> void:
	InputMap.action_erase_events(action_name)
	
	InputMap.action_add_event(action_name, key_keybind)
	InputMap.action_add_event(action_name, mouse_button_keybind)
	InputMap.action_add_event(action_name, joy_button_keybind)
	InputMap.action_add_event(action_name, joy_axis_keybind)


func get_button_string_for_action(for_controller: bool) -> String:
	var output_text = ""
	if not for_controller:
		if is_instance_valid(mouse_button_keybind):
			output_text = get_mouse_button_string(mouse_button_keybind.button_index)
		if is_instance_valid(key_keybind):
			output_text = OS.get_keycode_string(key_keybind.get_keycode_with_modifiers())
	else:
		if is_instance_valid(joy_button_keybind):
			output_text = ""
			assert(false, "TODO")
#			output_text = Input.get_joy_button_string(joy_button_keybind.button_index)
		if is_instance_valid(joy_axis_keybind):
			output_text = ""
			assert(false, "TODO")
#			output_text = Input.get_joy_axis_string(joy_axis_keybind.axis)
	
	if output_text != "":
		return output_text
	return NO_BUTTON_ASSIGNED_TO_ACTION_DISPLAY_TEXT


func get_mouse_button_string(mouse_button: int) -> String:
	return MOUSE_BUTTON_STRINGS[mouse_button]


func get_save_data() -> Dictionary:
	return {
		"action_name": action_name,
		"key_keybind": {
			"keycode": key_keybind.keycode,
			"alt": key_keybind.alt,
			"shift": key_keybind.shift,
			"control": key_keybind.control,
			"meta": key_keybind.meta,
			"command": key_keybind.command,
			"device": key_keybind.device,
		},
		"mouse_button_keybind": {
			"factor": mouse_button_keybind.factor,
			"button_index": mouse_button_keybind.button_index,
			"button_mask": mouse_button_keybind.button_mask,
			"alt": mouse_button_keybind.alt,
			"shift": mouse_button_keybind.shift,
			"control": mouse_button_keybind.control,
			"meta": mouse_button_keybind.meta,
			"command": mouse_button_keybind.command,
			"device": mouse_button_keybind.device,
		},
		"joy_button_keybind": {
			"button_index": joy_button_keybind.button_index,
			"device": joy_button_keybind.device,
		},
		"joy_axis_keybind": {
			"axis": joy_axis_keybind.axis,
			"device": joy_axis_keybind.device,
		},
	}


func load_save_data(data: Dictionary) -> void:
	action_name = data["action_name"]
	
	key_keybind = InputEventKey.new()
	key_keybind.keycode = data["key_keybind"]["keycode"]
	key_keybind.alt = data["key_keybind"]["alt"]
	key_keybind.shift = data["key_keybind"]["shift"]
	key_keybind.control = data["key_keybind"]["control"]
	key_keybind.meta = data["key_keybind"]["meta"]
	key_keybind.command = data["key_keybind"]["command"]
	key_keybind.device = data["key_keybind"]["device"]
	
	mouse_button_keybind = InputEventMouseButton.new()
	mouse_button_keybind.factor = data["mouse_button_keybind"]["factor"]
	mouse_button_keybind.button_index = data["mouse_button_keybind"]["button_index"]
	mouse_button_keybind.button_mask = data["mouse_button_keybind"]["button_mask"]
	mouse_button_keybind.alt = data["mouse_button_keybind"]["alt"]
	mouse_button_keybind.shift = data["mouse_button_keybind"]["shift"]
	mouse_button_keybind.control = data["mouse_button_keybind"]["control"]
	mouse_button_keybind.meta = data["mouse_button_keybind"]["meta"]
	mouse_button_keybind.command = data["mouse_button_keybind"]["command"]
	mouse_button_keybind.device = data["mouse_button_keybind"]["device"]
	
	joy_button_keybind = InputEventJoypadButton.new()
	joy_button_keybind.button_index = data["joy_button_keybind"]["button_index"]
	joy_button_keybind.device = data["joy_button_keybind"]["device"]
	
	joy_axis_keybind = InputEventJoypadMotion.new()
	joy_axis_keybind.axis = data["joy_axis_keybind"]["axis"]
	joy_axis_keybind.device = data["joy_axis_keybind"]["device"]
