extends Node

@export var test_localization: bool = false
@export var switch_language_seconds: float = 1.0

const LOCALIZATION_FILES_DIRECTORY: String = "res://src/resources/localization/translation_files/"

# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.is_debug_build() and test_localization:
		_loop_localization()


func _loop_localization() -> void:
	var all_implemented_languages: PackedStringArray = []
	var dir = DirAccess.open(LOCALIZATION_FILES_DIRECTORY)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".translation"):
				all_implemented_languages.append(file_name.rsplit(".")[1])
			file_name = dir.get_next()
	else:
		push_error("An error occurred when trying to access the path: ", LOCALIZATION_FILES_DIRECTORY)
	print(all_implemented_languages)
	
	var current_index: int = 0
	while true:
		TranslationServer.set_locale(all_implemented_languages[current_index])
		print(TranslationServer.get_locale_name(all_implemented_languages[current_index]))
		current_index += 1
		current_index %= len(all_implemented_languages)
		await get_tree().create_timer(switch_language_seconds).timeout
		
