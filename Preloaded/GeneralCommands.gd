extends Node

func apply_resolution(resolution_option):
	if resolution_option.full_screen:
		OS.window_fullscreen = true
	else:
		OS.window_fullscreen = false
		OS.window_size = Vector2(resolution_option.window_size_x, resolution_option.window_size_y)
