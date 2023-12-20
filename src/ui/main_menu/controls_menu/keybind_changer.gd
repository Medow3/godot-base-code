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
	GameManager.connect("using_controller_updated", Callable(self, "update_key_display"))
	
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
		Settings.set_keybind(action_name, event)
		
		# To avoid instantly going back into awaiting input mode after setting 
		# an action to enter/face button downwait a moment before proceding.
		if Input.is_action_just_pressed("ui_accept"):
			await get_tree().create_timer(0.1).timeout
		change_state(KEYBINDER_STATES.DEFAULT)
		unset_other_actions_with_duplicate_keys()


func unset_other_actions_with_duplicate_keys() -> void:
	for i in get_tree().get_nodes_in_group("Keybind Changer"):
		if (not i == self and i.current_state != KEYBINDER_STATES.AWAITING_INPUT 
				and i.button.text == button.text):
			i.unset_action_keybind()


func unset_action_keybind() -> void:
	Settings.set_keybind(action_name, null)
	change_state(KEYBINDER_STATES.UNSET)


func _on_Button_pressed() -> void:
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


#var mouse_left_click_held: bool = false
#var enter_held: bool = false
#var awaiting_input: bool = false
#var play_focus_sound: bool = false



#func _ready() -> void:
#	key_label.text = key
#	if value != null:
#		button.set("custom_colors/font_color", regular_font_color)
#		if not is_controller_keybind:
#			if not is_mouse_button:
#				button.text = OS.get_scancode_string(value)
#			else:
#				button.text = Settings.get_mouse_button_string(value)
#		else:
#			button.text = Input.get_joy_button_string(value)
#	else:
#		button.set("custom_colors/font_color", none_font_color)
#		button.text = "None"
#
#	if grab_focus_on_ready:
#		grab_focus()
#	play_focus_sound = true
#
#
#func update_values(new_key: String, new_value, new_is_mouse_button: bool) -> void:
#	key = new_key
#	value = new_value
#	is_mouse_button = new_is_mouse_button
#	key_label.text = key
#	if value != null:
#		button.set("custom_colors/font_color", regular_font_color)
#		if not is_controller_keybind:
#			if not is_mouse_button:
#				button.text = OS.get_scancode_string(value)
#			else:
#				button.text = Settings.get_mouse_button_string(value)
#		else:
#			button.text = Input.get_joy_button_string(value)
#	else:
#		button.set("custom_colors/font_color", none_font_color)
#		button.text = "None"
#
#
#func _on_main_menu_keybind_picker_focus_entered() -> void:
#	if not play_focus_sound:
#		play_focus_sound = true
#		animation_handler.travel_to("in")
#		emit_signal("on_element_focused", self)
#		return
#	SFX.play_sfx("on_main_menu_button_focused", 0.1, 1.0, 0.0, false, false)
#	animation_handler.travel_to("in")
#	emit_signal("on_element_focused", self)
#
#
#func _on_main_menu_keybind_picker_focus_exited() -> void:
#	animation_handler.travel_to("not_focused")
#	button.pressed = false
#	awaiting_input = false
#	emit_signal("update_override_escape", awaiting_input)
#	if value != null:
#		button.set("custom_colors/font_color", regular_font_color)
#		if not is_controller_keybind:
#			if not is_mouse_button:
#				button.text = OS.get_scancode_string(value)
#			else:
#				button.text = Settings.get_mouse_button_string(value)
#		else:
#			button.text = Input.get_joy_button_string(value)
#	else:
#		button.set("custom_colors/font_color", none_font_color)
#		button.text = "None"
#
#
#func _on_main_menu_keybind_picker_gui_input(event: InputEvent) -> void:
#	if not awaiting_input and Input.is_action_just_pressed("enter") and has_focus():
#		SFX.play_sfx("on_main_menu_button_pressed", 0.1, 1.0, 0.0, false, false)
#		button.pressed = not button.pressed
#		if button.pressed:
#			awaiting_input = true
#			emit_signal("update_override_escape", awaiting_input)
#			button.text = "Press Key"
#			enter_held = true
#	elif not awaiting_input and Input.is_action_just_pressed("left_click"):
#		SFX.play_sfx("on_main_menu_button_pressed", 0.1, 1.0, 0.0, false, false)
#		button.pressed = not button.pressed
#		if button.pressed:
#			awaiting_input = true
#			emit_signal("update_override_escape", awaiting_input)
#			button.text = "Press Key"
#			mouse_left_click_held = true
#
#	elif awaiting_input and not mouse_left_click_held and not enter_held:
#		if is_controller_keybind:
#			if event is InputEventJoypadButton:
#				SFX.play_sfx("on_controls_new_keybind_set", 0.1, 1.0, 5.0, false, false)
#				value = event.button_index
#				button.set("custom_colors/font_color", regular_font_color)
#				button.text = Input.get_joy_button_string(value)
#				button.pressed = false
#				awaiting_input = false
#				emit_signal("update_override_escape", awaiting_input)
#				emit_signal("value_changed", key, value, false, true)
#			elif event is InputEventJoypadButton and not event.pressed:
#				if value != null:
#					button.set("custom_colors/font_color", regular_font_color)
#					button.text = Input.get_joy_button_string(value)
#				else:
#					button.set("custom_colors/font_color", none_font_color)
#					button.text = "None"
#				button.pressed = false
#				awaiting_input = false
#				emit_signal("update_override_escape", awaiting_input)
#		else:
#			if event is InputEventKey and not event.scancode == KEY_ENTER and not event.scancode == KEY_ESCAPE:
#				SFX.play_sfx("on_controls_new_keybind_set", 0.1, 1.0, 5.0, false, false)
#				value = event.scancode
#				is_mouse_button = false
#				button.set("custom_colors/font_color", regular_font_color)
#				button.text = OS.get_scancode_string(value)
#				button.pressed = false
#				awaiting_input = false
#				emit_signal("update_override_escape", awaiting_input)
#				emit_signal("value_changed", key, value, false, false)
#			elif event is InputEventMouseButton:
#				SFX.play_sfx("on_controls_new_keybind_set", 0.1, 1.0, 5.0, false, false)
#				value = event.button_index
#				is_mouse_button = true
#				button.set("custom_colors/font_color", regular_font_color)
#				button.text = Settings.get_mouse_button_string(value)
#				button.pressed = false
#				awaiting_input = false
#				emit_signal("update_override_escape", awaiting_input)
#				emit_signal("value_changed", key, value, true, false)
#			elif event is InputEventMouseButton and not event.pressed:
#				if value != null:
#					button.set("custom_colors/font_color", regular_font_color)
#					if not is_controller_keybind:
#						if not is_mouse_button:
#							button.text = OS.get_scancode_string(value)
#						else:
#							button.text = Settings.get_mouse_button_string(value)
#					else:
#						button.text = Input.get_joy_button_string(value)
#				else:
#					button.set("custom_colors/font_color", none_font_color)
#					button.text = "None"
#				button.pressed = false
#				awaiting_input = false
#				emit_signal("update_override_escape", awaiting_input)
#
#	if mouse_left_click_held and Input.is_action_just_released("left_click"):
#		mouse_left_click_held = false
#	if enter_held and Input.is_action_just_released("enter"):
#		enter_held = false
#
#
#func _on_main_menu_keybind_picker_mouse_entered() -> void:
#	grab_focus()
#
#
#func _on_main_menu_keybind_picker_mouse_exited() -> void:
#	pass # Replace with function body.


