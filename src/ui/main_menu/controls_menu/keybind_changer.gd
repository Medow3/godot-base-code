class_name KeybindChanger extends HBoxContainer

@export var action_name: String = ""
@export var display_action_name: String = "" # Optional

@onready var action_label = $action_label
@onready var button = $Button

enum KEYBINDER_STATES {
	DEFAULT,
	AWAITING_INPUT,
	UNSET,
}

const AWAITING_INPUT_DISPLAY_TEXT = "Press Button"
const UNSET_DISPLAY_TEXT = "None"

const DEFAULT_FONT_COLOR = Color("ffffff")
const AWAITING_INPUT_FONT_COLOR = Color("ffffff")
const UNSET_FONT_COLOR = Color("8f2c2c")

var current_state: int = KEYBINDER_STATES.DEFAULT


func _ready() -> void:
	GameManager.using_controller_updated.connect(update_key_display)
	
	if display_action_name != "":
		action_label.text = display_action_name
	else:
		action_label.text = action_name
	update_key_display()


func update_key_display() -> void:
	match current_state:
		KEYBINDER_STATES.DEFAULT:
			button.text = Settings.keybinds.get_button_string_for_action(action_name, GameManager.using_controller)
			button.set("theme_override_colors/font_color", DEFAULT_FONT_COLOR)
		KEYBINDER_STATES.AWAITING_INPUT:
			button.text = AWAITING_INPUT_DISPLAY_TEXT
			button.set("theme_override_colors/font_color", AWAITING_INPUT_FONT_COLOR)
		KEYBINDER_STATES.UNSET:
			button.text = UNSET_DISPLAY_TEXT
			button.set("theme_override_colors/font_color", UNSET_FONT_COLOR)


func _input(event: InputEvent) -> void:
	if current_state == KEYBINDER_STATES.AWAITING_INPUT and KeybindTypes.is_object_a_valid_keybind_type(event):
		# Joystick motion was always being set. Just getting rid of it.
		if event is InputEventJoypadMotion:
			return
		get_viewport().set_input_as_handled()
		Settings.change_keybind(action_name, event)
		
		change_state(KEYBINDER_STATES.DEFAULT)
		unset_other_actions_with_duplicate_keys()


func unset_other_actions_with_duplicate_keys() -> void:
	for i in get_tree().get_nodes_in_group("Keybind Changer"):
		if (not i == self and i.current_state != KEYBINDER_STATES.AWAITING_INPUT 
				and i.button.text == button.text):
			i.unset_action_keybind()


func unset_action_keybind() -> void:
	Settings.change_keybind(action_name, null)
	change_state(KEYBINDER_STATES.UNSET)


func _on_Button_pressed() -> void:
	get_viewport().set_input_as_handled()
	match current_state:
		KEYBINDER_STATES.DEFAULT:
			change_state(KEYBINDER_STATES.AWAITING_INPUT)
		KEYBINDER_STATES.AWAITING_INPUT:
			pass
		KEYBINDER_STATES.UNSET:
			change_state(KEYBINDER_STATES.AWAITING_INPUT)


func _on_Button_focus_entered() -> void:
	for i in get_tree().get_nodes_in_group("Keybind Changer"):
		i.change_state(KEYBINDER_STATES.DEFAULT)


func _on_Button_focus_exited() -> void:
	if current_state == KEYBINDER_STATES.AWAITING_INPUT:
		change_state(KEYBINDER_STATES.DEFAULT)


func change_state(new_state: int) -> void:
	if new_state == KEYBINDER_STATES.DEFAULT and check_if_action_unset():
		new_state = KEYBINDER_STATES.UNSET
	elif new_state == KEYBINDER_STATES.UNSET and not check_if_action_unset():
		new_state = KEYBINDER_STATES.DEFAULT
	current_state = new_state
	update_key_display()


func check_if_action_unset() -> bool:
	var key_display_text = Settings.keybinds.get_button_string_for_action(action_name, GameManager.using_controller)
	if key_display_text == InputActionKeybinds.NO_BUTTON_ASSIGNED_TO_ACTION_DISPLAY_TEXT:
		return true
	return false
