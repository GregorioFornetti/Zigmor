extends Node

const MASTER_MAX_VOLUME = 0
const MUSICS_MAX_VOLUME = 0
const EFFECTS_MAX_VOLUME = 0
const MASTER_MIN_VOLUME = -60
const MUSICS_MIN_VOLUME = -60
const EFFECTS_MIN_VOLUME = -60

onready var music_player = get_node("Music_player")
onready var effects_players_list = get_node("Effects_players_list")

func _ready():
	for effect_player in $Effects_players_list.get_children():
		effect_player.connect("finished", self, "_on_Effect_player_finish", [effect_player])

func play_music(music_audio):
	$Music_player.stream = music_audio
	music_player.play()

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
	print("oi")
	effect_player.pitch_scale = 1
