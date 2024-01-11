class_name SongTransitionData extends Resource

enum TRANSITION_TYPE {
	CUT,
	CROSS_FADE,
	CUT_TO_CUSTOM_TRACK,
	CROSS_FADE_TO_CUSTOM_TRACK,
}

enum AUTO_TRANSITION {
	NONE,
	ONLY_AT_END,
	ANY_TIME_OR_AT_END,
}

@export var from_song: SongData
@export var to_song: SongData

@export var transition_type: TRANSITION_TYPE = TRANSITION_TYPE.CUT_TO_CUSTOM_TRACK
@export var auto_transition_type: AUTO_TRANSITION = AUTO_TRANSITION.NONE

@export_group("Volume")
## Check this if you want the custom_volume to be used instead of the default volume.
@export var use_custom_sfx_volume: bool = false
@export_range(-80, 24, 0.001, "or_greater", "or_lesser") var custom_volume: float

@export_group("Cross Fade")
@export var cross_fade_length: float = 1.0
@export var cross_fade_ease: Tween.EaseType = Tween.EaseType.EASE_IN
@export var cross_fade_trans: Tween.TransitionType = Tween.TransitionType.TRANS_LINEAR

@export_group("Custom Music Transition")
@export var can_transition_at_any_time: bool = false
@export var custom_transition_points: Array[float]

@export_subgroup("Bars")
@export var use_bar_recurring_points: bool = false
@export var bars_per_recurring_point: int = 4

@export_subgroup("Beats")
@export var use_beat_recurring_points: bool = false
@export var beats_per_recurring_point: int = 1


var all_transition_points: Array[float]
var current_music_player: AudioStreamPlayer = null


func _init():
	# Use call_deferred because export vars are set after _init is called.
	call_deferred("_initialize_data")


func _initialize_data() -> void:
	#all_transition_points = _get_all_transition_points()
	pass


func _get_all_transition_points() -> Array[float]:
	var all_points: Array[float] = []
	all_points.append_array(custom_transition_points)
	all_points.append_array(_get_all_recurring_transition_points())
	all_points.sort()
	return all_points


func _get_all_recurring_transition_points() -> Array[float]:
	var all_recurring_points: Array[float] = []
	var bars_in_song: int = from_song.beats_in_song / from_song.beats_per_bar
	for i in range(bars_per_recurring_point, bars_in_song, bars_per_recurring_point):
		all_recurring_points.append(i)
	for i in range(beats_per_recurring_point, from_song.beats_in_song, beats_per_recurring_point):
		all_recurring_points.append(i)
	return all_recurring_points


func _get_time_until_next_transition_point(current_playback_time: float) -> float:
	if can_transition_at_any_time:
		return 0.0
	
	for i in all_transition_points:
		if i >= current_playback_time:
			return i - current_playback_time
	
	var from_song_length: float = from_song.bpm * from_song.total_beats_in_song / 60.0
	return from_song_length - current_playback_time


func do_transition(transition_music_player: AudioStreamPlayer) -> void:
	var time_until_next_transition_point = _get_time_until_next_transition_point(from_song.current_main_music_player.get_playback_position())
	# Need to use from_song.current_main_music_player.get_tree() to get the tree
	# because resources can't call get_tree() to make tweens and timers.
	var get_tree: SceneTree = from_song.current_main_music_player.get_tree()
	await get_tree.create_timer(time_until_next_transition_point).timeout
	match transition_type:
		TRANSITION_TYPE.CUT:
			pass
		TRANSITION_TYPE.CROSS_FADE:
			pass
		TRANSITION_TYPE.CUT_TO_CUSTOM_TRACK:
			pass
		TRANSITION_TYPE.CROSS_FADE_TO_CUSTOM_TRACK:
			pass
	var tween: Tween = get_tree.create_tween()

#
#
#func _get_time_until_next_beat(current_song_time: float) -> float:
	#var all_beats: Array[float] = range(beats_per_recurring_point, from_song.beats_in_song, beats_per_recurring_point)
	#for i in all_beats:
		#if i > current_song_time:
			#return i - current_song_time
	#return 0.0
#
#
#func call_func_on_next_beat(to_call: Callable, timer: SceneTreeTimer, my_player: AudioStreamPlayer) -> void:
	#var current_playtime: float = my_player.get_playback_position()
	#timer.start(_get_time_until_next_beat(current_playtime))
	#await timer.timeout
	#to_call.call()
