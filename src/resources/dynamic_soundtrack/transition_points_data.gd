class_name TransitionPointsData extends Resource

@export var custom_transition_points: Array[float]

@export_group("Recurring Points")
@export var beats_in_song: int = 0
@export var bpm: int = 60
@export var beats_per_bar: int = 4

@export_subgroup("Bars")
@export var use_bar_recurring_points: bool = false
@export var bars_per_recurring_point: int = 4

@export_subgroup("Beats")
@export var use_beat_recurring_points: bool = false
@export var beats_per_recurring_point: int = 1



func get_all_transition_points() -> Array[float]:
	var all_points: Array[float] = []
	all_points.append_array(custom_transition_points)
	all_points.append_array(get_all_recurring_transition_points())
	all_points.sort()
	return all_points


func get_all_recurring_transition_points() -> Array[float]:
	var all_recurring_points: Array[float] = []
	var bars_in_song: int = beats_in_song / beats_per_bar
	for i in range(bars_per_recurring_point, bars_in_song, bars_per_recurring_point):
		all_recurring_points.append(i)
	for i in range(beats_per_recurring_point, beats_in_song, beats_per_recurring_point):
		all_recurring_points.append(i)
	return all_recurring_points


func _get_all_beats() -> Array[float]:
	return range(beats_per_recurring_point, beats_in_song, beats_per_recurring_point)


func get_time_until_next_beat(current_song_time: float) -> float:
	var all_beats: Array[float] = _get_all_beats()
	for i in all_beats:
		if i > current_song_time:
			return i - current_song_time
	return 0.0




