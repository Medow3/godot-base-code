class_name SongData extends Resource

@export var full_song_file: AudioStreamOggVorbis = null
@export var layers: Array[AudioStreamOggVorbis]

@export var transition_points_data: TransitionPointsData


func call_func_on_next_beat(to_call: Callable, timer: SceneTreeTimer, my_player: AudioStreamPlayer) -> void:
	var current_playtime: float = my_player.get_playback_position()
	timer.start(transition_points_data.get_time_until_next_beat())
	await timer.timeout
	to_call.call()
