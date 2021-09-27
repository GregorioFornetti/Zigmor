extends TextureButton

const hover_sound = preload("res://Sound/Effects/Interface/btn-hover.wav")
const click_sound = preload("res://Sound/Effects/Interface/btn-click.wav")


func _on_Btn_mouse_entered():
	SoundSystem.play_sound_effect(hover_sound)

func _on_Btn_pressed():
	SoundSystem.play_sound_effect(click_sound)
