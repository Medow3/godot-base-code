class_name KeybindTypes extends Node

# The input methods you can use as inputs for the game.
# This is used by the keybind management system.

# Explination:
# KEY = Keyboard (InputEventKey)
# MOUSE_BUTTON = Mouse clicks (InputEventMouseButton)
# JOYPAD_BUTTON = Controller buttons (InputEventJoypadButton)
# JOYPAD_AXIS = Controller joysticks (InputEventJoypadMotion)
enum KEYBIND_TYPES {
	KEY,
	MOUSE_BUTTON,
	JOYPAD_BUTTON,
	JOYPAD_AXIS,
}

static func is_object_a_valid_keybind_type(object) -> bool:
	return get_keybind_type_of_object(object) != -1


static func get_keybind_type_of_object(object) -> int:
	if object is InputEventKey:
		return KEYBIND_TYPES.KEY
	elif object is InputEventMouseButton:
		return KEYBIND_TYPES.MOUSE_BUTTON
	elif object is InputEventJoypadButton:
		return KEYBIND_TYPES.JOYPAD_BUTTON
	elif object is InputEventJoypadMotion:
		return KEYBIND_TYPES.JOYPAD_AXIS
	return -1
	
