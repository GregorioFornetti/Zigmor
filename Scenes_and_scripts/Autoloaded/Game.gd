extends Node

onready var rng = RandomNumberGenerator.new()
onready var timer = $Timer

enum difficulties {EASY, MEDIUM, HARD}
enum status {MENU, PLAYING, SHOPPING, PAUSED}

var enemies_points_function
var spawn_points_function
var spawn_delay_function
var enemy_money_drop_function

var qnt_enemies_killed = 0
var qnt_obstacles_destroyed = 0 
var current_status = status.MENU
var current_difficulty
var current_time = 100  # Game time in seconds
var Player


func _ready():
	rng.randomize()

func start_game(game_difficulty):
	current_difficulty = game_difficulty
	qnt_enemies_killed = 0
	qnt_obstacles_destroyed = 0 
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
	spawn_delay_function = funcref(self, difficult_name + "_spawn_delay_function")
	enemy_money_drop_function = funcref(self, difficult_name + "_enemy_money_drop_function")
	
	get_tree().change_scene("res://Scenes_and_scripts/Testing_map.tscn")
	$Timer.start()
	SoundSystem.start_game_bg_music(current_difficulty)


func _on_Timer_timeout():
	current_time += 1
	$Timer.start()

func _on_enemy_death(_enemy):
	qnt_enemies_killed += 1

func _on_obstacle_destruction():
	qnt_obstacles_destroyed += 1



# Funções modificadoras das dificuldades do jogo:

func get_enemies_points():
	return enemies_points_function.call_func(current_time)

func get_spawn_points():
	return spawn_points_function.call_func(current_time)

func get_spawn_delay():
	return spawn_delay_function.call_func(current_time)

func get_enemy_monmey_drop(enemy_points):
	return enemy_money_drop_function.call_func(enemy_points, current_time)


func easy_enemies_points_function(current_time):
	return int(current_time / 40)

func medium_enemies_points_function(current_time):
	return int(current_time / 35)

func hard_enemies_points_function(current_time):
	return int(current_time / 30)


func easy_spawn_points_function(current_time):
	return int(current_time / 50 + 2)

func medium_spawn_points_function(current_time):
	return int(current_time / 45 + 2)

func hard_spawn_points_function(current_time):
	return int(current_time / 40 + 2)


func easy_spawn_delay_function(current_time):
	return 20

func medium_spawn_delay_function(current_time):
	return 20

func hard_spawn_delay_function(current_time):
	return 20


func easy_enemy_money_drop_function(enemy_points, current_time):
	return 10 + int(enemy_points * 10 * current_time / 70)

func medium_enemy_money_drop_function(enemy_points, current_time):
	return 10 + int(enemy_points * 10 * current_time / 70)

func hard_enemy_money_drop_function(enemy_points, current_time):
	return 10 + int(enemy_points * 10 * current_time / 70)
