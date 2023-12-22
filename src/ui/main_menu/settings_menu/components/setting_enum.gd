class_name SettingEnum extends Control

@export var setting_name: String
## The actual settings values.
@export var values: Array = []
## What is displayed for each value.
@export var display_values: Array[String] = []
## The tooltip for each value.
@export_multiline var value_tooltips: Array[String] = []

@onready var left_arrow: TextureButton = $HBoxContainer/left_arrow
@onready var value_label: Label = $HBoxContainer/Label
@onready var right_arrow: TextureButton = $HBoxContainer/right_arrow

var current_value_index: int


func _ready() -> void:
	Settings.setting_changed.connect(_on_settings_changed_signal_recieved)
	for i in range(len(values) - len(value_tooltips)):
		value_tooltips.append("")
	_reset_setting_value()


func _reset_setting_value() -> void:
	current_value_index = values.find(Settings.get_setting_value(setting_name))
	assert(current_value_index != -1, "Settings value, " + str(Settings.get_setting_value(setting_name)) + " not found in values array.")
	_update_value_label_text()


func _update_value_label_text() -> void:
	value_label.text = display_values[current_value_index]
	tooltip_text = value_tooltips[current_value_index]
	Settings.change_setting(setting_name, values[current_value_index])


func _on_left_arrow_pressed():
	current_value_index -= 1
	if current_value_index < 0:
		current_value_index = len(values) - 1
	_update_value_label_text()


func _on_right_arrow_pressed():
	current_value_index += 1
	if current_value_index >= len(values):
		current_value_index = 0
	_update_value_label_text()


func _on_settings_changed_signal_recieved(changed_setting_name: String) -> void:
	if changed_setting_name == setting_name:
		_reset_setting_value()
