extends Control

onready var options_boxes = {
	null : $Right_container/Center_box/Box_no_option,
	Game.difficulties.EASY : $Right_container/Center_box/Box_easy,
	Game.difficulties.MEDIUM : $Right_container/Center_box/Box_medium,
	Game.difficulties.HARD : $Right_container/Center_box/Box_hard
}
onready var options_buttons = {
	Game.difficulties.EASY : $Left_container/Center_box/VBoxContainer/Btn_easy,
	Game.difficulties.MEDIUM: $Left_container/Center_box/VBoxContainer/Btn_medium,
	Game.difficulties.HARD : $Left_container/Center_box/VBoxContainer/Btn_hard
}
onready var btn_play = $Right_container/Bottom_box/Btn_play
onready var selected_option_label = $Right_container/Top_box/Option_label

var current_option


func update_boxes():
	for box_name in options_boxes:
		options_boxes[box_name].visible = false
	options_boxes[current_option].visible = true

func update_buttons():
	for btn_name in options_buttons:
		if btn_name != current_option:
			options_buttons[btn_name].pressed = false

func option_btn_toggle(option, option_message):
	if current_option == option: # Selecionou a mesma dificuldade (volta a ficar sem dificuldade selecionada)
		current_option = null
		update_boxes()
		btn_play.disabled = true
		selected_option_label.text = "Nenhuma dificuldade escolhida"
	else:  # Selecionou nova opção de dificuldade
		current_option = option
		update_boxes()
		update_buttons()
		btn_play.disabled = false
		selected_option_label.text = option_message


func _on_Btn_easy_button_down():
	option_btn_toggle(Game.difficulties.EASY, "Dificuldade: fácil")

func _on_Btn_medium_button_down():
	option_btn_toggle(Game.difficulties.MEDIUM, "Dificuldade: intermediária")

func _on_Btn_hard_pressed():
	option_btn_toggle(Game.difficulties.HARD, "Dificuldade: difícil")

func _on_Btn_return_pressed():
	get_tree().change_scene("res://Cenas/Menus/Main_menu.tscn")

func _on_Btn_play_pressed():
	Game.start_game(current_option)
