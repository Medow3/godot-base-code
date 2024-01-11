extends Node

signal music_state_changed(new_state: MUSIC_STATES)

enum MUSIC_STATES {
	STOPPED,
	PLAYING,
	TRANSITIONING,
}

const SONG_DATA_PATH: String = "res://src/resources/dynamic_soundtrack/song_data/"
const SONG_TRANSITION_DATA_PATH: String = "res://src/resources/dynamic_soundtrack/song_transition_data/"
const MUSIC_BUS_NAME: StringName = "Music"

var _songs: Array[SongData]
var _transitions: Array[SongTransitionData]
var _transition_map: Array[Array]

var _current_playing_song_data: SongData = null
var _current_state: MUSIC_STATES = MUSIC_STATES.STOPPED : 
	set(value):
		if _current_state != value:
			_current_state = value
			emit_signal("music_state_changed", _current_state)


func _ready() -> void:
	_set_up_song_data_recursive(SONG_DATA_PATH)
	_set_up_transition_data_recursive(SONG_TRANSITION_DATA_PATH)


func _set_up_song_data_recursive(directory_path: String) -> void:
	var dir = DirAccess.open(directory_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir() and file_name.left(1) != ".":
				_set_up_song_data_recursive(directory_path + file_name + "/")
			elif not dir.current_is_dir() and file_name.ends_with(".tres"):
				_songs.append(load(directory_path + file_name))
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path: ", directory_path)


func _set_up_transition_data_recursive(directory_path: String) -> void:
	var dir = DirAccess.open(directory_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir() and file_name.left(1) != ".":
				_set_up_transition_data_recursive(directory_path + file_name + "/")
			elif not dir.current_is_dir() and file_name.ends_with(".tres"):
				_transitions.append(load(directory_path + file_name))
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path: ", directory_path)


func _create_music_player() -> AudioStreamPlayer:
	var new_player: AudioStreamPlayer = AudioStreamPlayer.new()
	new_player.volume_db = -80.0
	new_player.bus = MUSIC_BUS_NAME
	return new_player


func _create_song_music_players(song: SongData) -> void:
	var parent_node: Node = Node.new()
	parent_node.name = song.song_name
	add_child(parent_node)
	
	var main_music_player: AudioStreamPlayer = _create_music_player()
	main_music_player.name = song.song_name + "_full"
	main_music_player.stream = song.full_song_file
	parent_node.add_child(main_music_player)
	
	var layers_dictionary: Dictionary
	for layer_name in song.layer_names_and_files:
		var layer_music_player: AudioStreamPlayer = _create_music_player()
		layer_music_player.name = song.song_name + layer_name
		layer_music_player.stream = song.layer_names_and_files[layer_name]
		parent_node.add_child(layer_music_player)
		layers_dictionary[layer_name] = layer_music_player
	
	song.current_main_music_player = main_music_player
	song.current_layer_names_and_music_players = layers_dictionary


func _destroy_song_music_players(song: SongData) -> void:
	var music_players_parent: Node = song.current_main_music_player.get_parent()
	if is_instance_valid(music_players_parent):
		music_players_parent.queue_free()
	song.current_main_music_player = null
	song.current_layer_names_and_music_players = {}


func transition_to(song_name: StringName) -> void:
	while _current_state == MUSIC_STATES.TRANSITIONING:
		await music_state_changed
	#TODO: handle many transition calls in quick succession. Only queue the most recent one I think.
	
	_current_state = MUSIC_STATES.TRANSITIONING
	if _current_playing_song_data == null:
		pass # Starting up a new song while no other songs are playing.
			 # Just play the song with no transitions.
	
	var index_of_song_to_transition_to: int = -1
	for i in range(len(_songs)):
		if _songs[i].song_name == song_name:
			index_of_song_to_transition_to = i
			break
	assert(index_of_song_to_transition_to != -1, song_name + " song not found.")
	var song_to_transition_to_data: SongData = _songs[index_of_song_to_transition_to]
		
	var applicable_transition_data: SongTransitionData = null
	for t: SongTransitionData in _transitions:
		if t.from_song == _current_playing_song_data and t.to_song == song_to_transition_to_data:
			if t.auto_transition_type != t.AUTO_TRANSITION.ONLY_AT_END:
				applicable_transition_data = t
				break
	if applicable_transition_data == null:
		pass
		# No custom transition found. Just use a default crossfade.
	
	_create_song_music_players(song_to_transition_to_data)
	var transition_music_player: AudioStreamPlayer = _create_music_player()
	add_child(transition_music_player)
	await applicable_transition_data.do_transition(transition_music_player)
	transition_music_player.queue_free()
	_destroy_song_music_players(_current_playing_song_data)
	_current_playing_song_data = song_to_transition_to_data
	
	_current_state = MUSIC_STATES.PLAYING
	
	
	














