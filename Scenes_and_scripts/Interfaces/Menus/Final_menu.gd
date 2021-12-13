extends CanvasLayer

onready var timer = $Timer
onready var score_info_list = [
	{
		"points": Game.qnt_enemies_killed, 
		"function": funcref(self, "update_enemies_killed_score")
	},
	{
		"points": Game.current_time, 
		"function": funcref(self, "update_time_score")
	},
	{
		"points": Game.qnt_obstacles_destroyed,
		"function": funcref(self, "update_obstacle_score")
	},
	{
		"points": get_final_points(Game.qnt_enemies_killed, Game.current_time, Game.qnt_obstacles_destroyed), 
		"function": funcref(self, "update_final_score")
	}
]
var stop_updating = false
onready var current_index = 0
onready var update = score_info_list[0].function
onready var points = score_info_list[0].points
onready var Menu_music = preload("res://Sound/Musics/main-menu-music.wav")


func _ready():
	SoundSystem.play_pause_music()
	if Game.current_difficulty == Game.difficulties.EASY:
		$Bottom_container/GridContainer/Difficulty_box/Value.text = "Fácil"
	elif Game.current_difficulty == Game.difficulties.MEDIUM:
		$Bottom_container/GridContainer/Difficulty_box/Value.text = "Intermediário"
	else:
		$Bottom_container/GridContainer/Difficulty_box/Value.text = "Difícil"

func _process(_delta):
	if not stop_updating:
		update.call_func(get_current_points(points))

func get_current_points(points):
	if timer.time_left != 0:
		return int(points * (1 - (timer.time_left / timer.wait_time)))
	else:
		return points

func get_final_points(enemies_killed, time, obstacles_destroyed):
	return int(time * time / 100) + int(time * enemies_killed / 50) + \
		   int(time * obstacles_destroyed / 75)

func update_enemies_killed_score(points):
	$Bottom_container/GridContainer/Enemys_score_box/Value.text = str(points)

func update_time_score(points):
	$Bottom_container/GridContainer/Time_score_box/Value.text = GeneralCommands.seconds_to_time_string(points)

func update_obstacle_score(points):
	$Bottom_container/GridContainer/Obstacles_score_box/Value.text = str(points)

func update_final_score(points):
	$Bottom_container/GridContainer/Final_score_box/Value.text = str(points)

func _on_Timer_timeout():
	update.call_func(points)
	current_index += 1
	if current_index < len(score_info_list):
		update = score_info_list[current_index].function
		points = score_info_list[current_index].points
		timer.start()
	else:
		stop_updating = true
		$Bottom_container/Btn_return.visible = true

func _on_Btn_return_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://Scenes_and_scripts/Interfaces/Menus/Play_menu.tscn")
