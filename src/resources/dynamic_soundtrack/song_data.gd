class_name SongData extends Resource

@export var song_name: StringName
@export var full_song_file: AudioStreamOggVorbis = null
## Dictonary types: {String: AudioStreamOggVorbis}
@export var layer_names_and_files: Dictionary

@export_group("Data")
@export var total_beats_in_song: int = 0
@export var bpm: int = 60
@export var beats_per_bar: int = 4

var current_main_music_player: AudioStreamPlayer = null
## Dictonary types: {String: AudioStreamOggVorbis}
var current_layer_names_and_music_players: Dictionary
