class_name SettingSlider extends HSlider

@export var setting_name: String
@export var value_label: SettingValueLabel


func _ready() -> void:
	Settings.setting_changed.connect(_on_settings_changed_signal_recieved)
	_reset_setting_value()


func _reset_setting_value() -> void:
	value = Settings.get_setting_value(setting_name)
	if is_instance_valid(value_label):
		value_label.set_value(str(value))


func _on_value_changed(value):
	if is_instance_valid(value_label):
		value_label.set_value(str(value))
	Settings.change_setting(setting_name, value)


func _on_settings_changed_signal_recieved(changed_setting_name: String) -> void:
	if changed_setting_name == setting_name:
		_reset_setting_value()
