class_name InputActionKeybinds

@export var action_name: String
@export var key_keybind: InputEventKey
@export var mouse_button_keybind: InputEventMouseButton
@export var joy_button_keybind: InputEventJoypadButton
@export var joy_axis_keybind: InputEventJoypadMotion

const NO_BUTTON_ASSIGNED_TO_ACTION_DISPLAY_TEXT: String = "Unassigned"

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

# For the JoyButton enum
const JOY_BUTTON_STRINGS: Array = [
	"Face Button Bottom",
	"Face Button Right",
	"Face Button Left",
	"Face Button Top",
	"Select",
	"Guide",
	"Start",
	"Left Stick",
	"Right Stick",
	"Left Shoulder",
	"Right Shoulder",
	"D-pad Up",
	"D-pad Down",
	"D-pad Left",
	"D-pad Right",
	"Button 15",
	"Button 16",
	"Button 17",
	"Button 18",
	"Button 19",
	"Button 20",
	"Button 21",
	"Button 22",
	"Button 23",
	"Button 24",
	"Button 25",
	"Button 26",
	"Button 27",
	"Button 28",
	"Button 29",
	"Button 30",
	"Button 31",
	"Button 32",
	"Button 33",
	"Button 34",
	"Button 35",
]

# For the JoyAxis enum
const JOY_AXIS_STRINGS: Array = [
	"Left Stick X",
	"Left Stick Y",
	"Right Stick X",
	"Right Stick Y",
	"Left Trigger",
	"Right Trigger",
	"Joystick 3 X",
	"Joystick 3 Y",
	"Joystick 4 X",
	"Joystick 4 Y",
]


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
	assert(keybind_type != -1, "Invalid keybind type.")
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
	
	if key_keybind != null:
		InputMap.action_add_event(action_name, key_keybind)
	if mouse_button_keybind != null:
		InputMap.action_add_event(action_name, mouse_button_keybind)
	if joy_button_keybind != null:
		InputMap.action_add_event(action_name, joy_button_keybind)
	if joy_axis_keybind != null:
		InputMap.action_add_event(action_name, joy_axis_keybind)


func get_button_string_for_action(for_controller: bool) -> String:
	var output_text = ""
	if not for_controller:
		if mouse_button_keybind != null and mouse_button_keybind.button_index != 0:
			output_text = get_mouse_button_string(mouse_button_keybind.button_index)
		if key_keybind != null:
			output_text = OS.get_keycode_string(key_keybind.get_physical_keycode_with_modifiers())
	else:
		if joy_button_keybind != null:
			output_text = JOY_BUTTON_STRINGS[joy_button_keybind.button_index]
		if joy_axis_keybind != null:
			output_text = JOY_AXIS_STRINGS[joy_axis_keybind.axis]
	
	if output_text != "":
		return output_text
	return NO_BUTTON_ASSIGNED_TO_ACTION_DISPLAY_TEXT


func get_mouse_button_string(mouse_button: int) -> String:
	return MOUSE_BUTTON_STRINGS[mouse_button]


func get_save_data() -> Dictionary:
	return {
		"action_name": action_name,
		"key_keybind": {
			"keycode": key_keybind.physical_keycode if key_keybind != null else null,
			#"alt": key_keybind.alt,
			#"shift": key_keybind.shift,
			#"control": key_keybind.control,
			#"meta": key_keybind.meta,
			#"command": key_keybind.command,
			#"device": key_keybind.device,
		},
		"mouse_button_keybind": {
			#"factor": mouse_button_keybind.factor,
			"button_index": mouse_button_keybind.button_index if mouse_button_keybind != null else null,
			#"button_mask": mouse_button_keybind.button_mask,
			#"alt": mouse_button_keybind.alt,
			#"shift": mouse_button_keybind.shift,
			#"control": mouse_button_keybind.control,
			#"meta": mouse_button_keybind.meta,
			#"command": mouse_button_keybind.command,
			#"device": mouse_button_keybind.device,
		},
		"joy_button_keybind": {
			"button_index": joy_button_keybind.button_index if joy_button_keybind != null else null,
			#"device": joy_button_keybind.device,
		},
		"joy_axis_keybind": {
			"axis": joy_axis_keybind.axis if joy_axis_keybind != null else null,
			#"device": joy_axis_keybind.device,
		},
	}


func load_save_data(data: Dictionary) -> void:
	action_name = data["action_name"]
	
	key_keybind = InputEventKey.new()
	if data["key_keybind"]["keycode"] != null:
		key_keybind.physical_keycode = data["key_keybind"]["keycode"]
	else:
		key_keybind = null
	#key_keybind.alt = data["key_keybind"]["alt"]
	#key_keybind.shift = data["key_keybind"]["shift"]
	#key_keybind.control = data["key_keybind"]["control"]
	#key_keybind.meta = data["key_keybind"]["meta"]
	#key_keybind.command = data["key_keybind"]["command"]
	#key_keybind.device = data["key_keybind"]["device"]
	
	mouse_button_keybind = InputEventMouseButton.new()
	#mouse_button_keybind.factor = data["mouse_button_keybind"]["factor"]
	if data["mouse_button_keybind"]["button_index"] != null:
		mouse_button_keybind.button_index = data["mouse_button_keybind"]["button_index"]
	else:
		mouse_button_keybind = null
	#mouse_button_keybind.button_mask = data["mouse_button_keybind"]["button_mask"]
	#mouse_button_keybind.alt = data["mouse_button_keybind"]["alt"]
	#mouse_button_keybind.shift = data["mouse_button_keybind"]["shift"]
	#mouse_button_keybind.control = data["mouse_button_keybind"]["control"]
	#mouse_button_keybind.meta = data["mouse_button_keybind"]["meta"]
	#mouse_button_keybind.command = data["mouse_button_keybind"]["command"]
	#mouse_button_keybind.device = data["mouse_button_keybind"]["device"]
	
	joy_button_keybind = InputEventJoypadButton.new()
	if data["joy_button_keybind"]["button_index"] != null:
		joy_button_keybind.button_index = data["joy_button_keybind"]["button_index"]
	else:
		joy_button_keybind = null
	#joy_button_keybind.device = data["joy_button_keybind"]["device"]
	
	joy_axis_keybind = InputEventJoypadMotion.new()
	if data["joy_axis_keybind"]["axis"] != null:
		joy_axis_keybind.axis = data["joy_axis_keybind"]["axis"]
	else:
		joy_axis_keybind = null
	#joy_axis_keybind.device = data["joy_axis_keybind"]["device"]
	update_input_map_for_keybinds()
