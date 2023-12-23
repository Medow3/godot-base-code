class_name SettingValueLabel extends Label

## Override values with custom text.
## Types are (String: String)
@export var custom_value_labels: Dictionary
## Multiply values by this before displaying. Set to show percentages.
@export var multiply_values_by: float = 1.0
## Add this text after the value. E.g. "%"
@export var ending_text: String = ""


func set_value(new_value: String) -> void:
	if multiply_values_by != 1.0:
		new_value = str(float(new_value) * multiply_values_by)
	
	var new_text: String = GameManager.text_server.format_number(new_value) + ending_text
	if new_value in custom_value_labels:
		new_text = custom_value_labels[new_value]
	text = new_text
