extends Node

onready var music_player = get_node("Music_player")
onready var effects_players_list = get_node("Effects_players_list")


func play_music(music_audio):
	$Music_player.stream = music_audio
	music_player.play()


func play_sound_effect(effect_audio):
	for effect_player in $Effects_players_list.get_children():
		if not effect_player.playing:
			effect_player.stream = effect_audio
			effect_player.play()
			break 
