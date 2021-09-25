extends Node

onready var rng = RandomNumberGenerator.new()
onready var timer = $Timer

enum difficulties {EASY, MEDIUM, HARD}
enum status {MENU, PLAYING, SHOPPING, PAUSED}

var enemies_points_function
var spawn_points_function
var spawn_delay_function
var enemy_money_drop_function

var current_status = status.MENU
var current_difficulty
var current_time = 0  # Game time in seconds
var Player


func _ready():
	rng.randomize()

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
	spawn_delay_function = funcref(self, difficult_name + "_spawn_delay_function")
	enemies_points_function = funcref(self, difficult_name + "_enemy_money_drop_function")
	
	get_tree().change_scene("res://Scenes_and_scripts/Testing_map.tscn")
	$Timer.start()


func _on_Timer_timeout():
	current_time += 1
	$Timer.start()



# Funções modificadoras das dificuldades do jogo:

func get_enemies_points():
	return enemies_points_function.call_func(current_time)

func get_spawn_points():
	return spawn_points_function.call_func(current_time)

func get_spawn_delay():
	return spawn_delay_function.call_func(current_time)

func get_enemy_monmey_drop(enemy_points):
	return enemies_points_function.call_func(enemy_points, current_time)


func easy_enemies_points_function(t):
	return t

func medium_enemies_points_function(t):
	return 2 * t

func hard_enemies_points_function(t):
	return 3 * t


func easy_spawn_points_function(t):
	return int(t / 60 + 2)

func medium_spawn_points_function(t):
	return int(t / 45 + 3)

func hard_spawn_points_function(t):
	return int(t / 30 + 3)


func easy_spawn_delay_function(t):
	return 30

func medium_spawn_delay_function(t):
	return 25

func hard_spawn_delay_function(t):
	return 20


func easy_enemy_money_drop_function(enemy_points, current_time):
	var min_money = 5 + int(enemy_points * 10 * current_time / 60)
	var max_money = 10 + int(enemy_points * 15 * current_time / 60)
	return rng.randi_range(min_money, max_money)

func medium_enemy_money_drop_function(enemy_points, current_time):
	var min_money = 3 + int(enemy_points * 7 * current_time / 60)
	var max_money = 7 + int(enemy_points * 13 * current_time / 60)
	return rng.randi_range(min_money, max_money)

func hard_enemy_money_drop_function(enemy_points, current_time):
	var min_money = 2 + int(enemy_points * 5 * current_time / 60)
	var max_money = 5 + int(enemy_points * 10 * current_time / 60)
	return rng.randi_range(min_money, max_money)