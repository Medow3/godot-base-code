extends Node

signal using_controller_updated

const MOUSE_MOTION_THRESHOLD: float = 10.0

var using_controller: bool = false
var controller_being_used: String = ""

var global_rng: RandomNumberGenerator = RandomNumberGenerator.new()


func _ready() -> void:
	global_rng.randomize()
	using_controller = Input.get_connected_joypads().size() >= 1
	controller_being_used = Input.get_joy_name(0)
	Input.connect("joy_connection_changed", Callable(self, "_on_joystick_configuration_changed"))


func _input(event: InputEvent) -> void:
	if ((event is InputEventKey and event.pressed) or (event is InputEventMouseButton and event.pressed)
			and using_controller):
		using_controller = false
		controller_being_used = Input.get_joy_name(0)
		emit_signal("using_controller_updated")
	elif event is InputEventMouseMotion and event.relative.length() > MOUSE_MOTION_THRESHOLD and using_controller:
		using_controller = false
		controller_being_used = Input.get_joy_name(0)
		emit_signal("using_controller_updated")
	elif ((event is InputEventJoypadButton and event.pressed) or 
			(event is InputEventJoypadMotion and event.axis_value > 0.1)) and not using_controller:
		using_controller = true
		controller_being_used = Input.get_joy_name(0)
		emit_signal("using_controller_updated")


func _on_joystick_configuration_changed(device_id, connected) -> void:
	using_controller = connected
	controller_being_used = Input.get_joy_name(0)
	emit_signal("using_controller_updated")
