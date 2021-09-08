extends Node

onready var timer = $Timer

enum difficulties {EASY, MEDIUM, HARD}
enum status {MENU, PLAYING, PAUSED}

var current_status = status.MENU
var current_difficulty
var enemies_points_function
var spawn_points_function
var current_time = 0  # Game time in seconds


func _ready():
	pass

func start_game(game_difficulty):
	current_difficulty = game_difficulty
	current_time = 0
	current_status = status.PLAYING
	
	var difficult_name
	match(current_difficulty):
		difficulties.EASY:
			difficult_name = "easy"
		difficulties.MEDIUM:
			difficult_name = "medium"
		difficulties.HARD:
			difficult_name = "hard"
	enemies_points_function = funcref(self, difficult_name + "_enemies_points_function")
	spawn_points_function = funcref(self, difficult_name + "_spawn_points_function")
	
	get_tree().change_scene("res://Cenas/Testing_map.tscn")
	$Timer.start()


func get_enemies_points():
	return enemies_points_function.call_func(current_time)

func get_spawn_points():
	return spawn_points_function.call_func(current_time)


func easy_enemies_points_function(t):
	return t

func medium_enemies_points_function(t):
	return 2 * t

func hard_enemies_points_function(t):
	return 3 * t


func easy_spawn_points_function(t):
	return t

func medium_spawn_points_function(t):
	return 2 * t

func hard_spawn_points_function(t):
	return 3 * t


func _on_Timer_timeout():
	current_time += 1
	$Timer.start()
