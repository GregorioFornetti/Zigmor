extends Node


func apply_resolution(resolution_option):
	if resolution_option.full_screen:
		OS.window_fullscreen = true
	else:
		OS.window_fullscreen = false
		OS.window_size = Vector2(resolution_option.window_size_x, resolution_option.window_size_y)

func seconds_to_time_string(seconds):
	var minutes = int(seconds / 60)
	seconds %= 60
	var hours = int(minutes / 60)
	minutes %= 60
	return "%02d:%02d:%02d" % [hours, minutes, seconds]

