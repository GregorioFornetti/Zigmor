extends Node

const MASTER_MAX_VOLUME = 0
const MUSICS_MAX_VOLUME = 0
const EFFECTS_MAX_VOLUME = 0
const MASTER_MIN_VOLUME = -60
const MUSICS_MIN_VOLUME = -60
const EFFECTS_MIN_VOLUME = -60

onready var effects_players_list = get_node("Effects_players_list")
onready var pause_music = preload("res://Sound/Musics/main-menu-music.wav")
onready var bg_musics = [
	preload("res://Sound/Musics/bg-music1.wav"),
	preload("res://Sound/Musics/bg-music2.wav"),
	preload("res://Sound/Musics/bg-music3.wav")
]
var time_left_to_change_bg_music
var bg_music_time
var current_bg_music_index
var current_bg_music
var bg_music_loop_counter_list # deve conter uma lista de numero de repetições de cada parte da musica de bg
# Ex: [10] quer dizer que a primeira musica deve loopar 10 vezes.
# OBS: a ultima musica loopa indefinidas vezes

func _ready():
	for effect_player in $Effects_players_list.get_children():
		effect_player.connect("finished", self, "_on_Effect_player_finish", [effect_player])
	play_pause_music()

func start_game_bg_music(game_difficulty):
	current_bg_music = bg_musics[0]
	bg_music_time = 0
	current_bg_music_index = 0
	$Music_player.stream = current_bg_music
	$Music_player.play()
	
	
	if game_difficulty == Game.difficulties.EASY:
		bg_music_loop_counter_list = [10, 10]
	elif game_difficulty == Game.difficulties.MEDIUM:
		bg_music_loop_counter_list = [5, 3]
	elif game_difficulty == Game.difficulties.HARD:
		bg_music_loop_counter_list = [2, 2]
	
	$Timer.start(current_bg_music.get_length() * bg_music_loop_counter_list[0])

func play_pause_music():
	time_left_to_change_bg_music = $Timer.time_left
	$Timer.stop()
	bg_music_time = $Music_player.get_playback_position()
	$Music_player.stop()
	$Music_player.stream = pause_music
	$Music_player.play()

func continue_game_bg_music():
	$Timer.start(time_left_to_change_bg_music)
	$Music_player.stop()
	$Music_player.stream = current_bg_music
	$Music_player.play(bg_music_time)


func play_sound_effect(effect_audio):
	for effect_player in $Effects_players_list.get_children():
		if not effect_player.playing:
			effect_player.stream = effect_audio
			effect_player.play()
			break 

func play_sound_effect_with_config(effect_audio, speed):
	for effect_player in $Effects_players_list.get_children():
		if not effect_player.playing:
			effect_player.stream = effect_audio
			effect_player.pitch_scale = speed
			effect_player.play()
			return effect_player
	return false

func apply_new_volume(bus_index, value, min_value):
	AudioServer.set_bus_volume_db(bus_index, value)
	mute_in_min(bus_index, value, min_value)

func apply_sound_configurations(volume_options):
	apply_new_volume(AudioServer.get_bus_index("Master"), volume_options["master_volume"], MASTER_MIN_VOLUME)
	apply_new_volume(AudioServer.get_bus_index("Musics"), volume_options["musics_volume"], MUSICS_MIN_VOLUME)
	apply_new_volume(AudioServer.get_bus_index("Effects"), volume_options["effects_volume"], EFFECTS_MIN_VOLUME)

func mute_in_min(bus_index, current_value, min_value):
	# Muta o canal de som caso chegue no valor mínimo.
	if current_value == min_value:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)

func _on_Effect_player_finish(effect_player):
	effect_player.pitch_scale = 1


func _on_Timer_timeout():
	if current_bg_music_index < len(bg_music_loop_counter_list):
		current_bg_music_index += 1
		current_bg_music = bg_musics[current_bg_music_index]
		
		$Music_player.stop()
		$Music_player.stream = current_bg_music
		$Music_player.play()
		
		if current_bg_music_index < len(bg_music_loop_counter_list):
			$Timer.start(current_bg_music.get_length() * bg_music_loop_counter_list[current_bg_music_index])
