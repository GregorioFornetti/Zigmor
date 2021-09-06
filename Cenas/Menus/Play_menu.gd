extends Control

onready var options_boxes = {
	"no_option" : $Right_container/Center_box/Box_no_option,
	"easy" : $Right_container/Center_box/Box_easy,
	"medium" : $Right_container/Center_box/Box_medium,
	"hard" : $Right_container/Center_box/Box_hard
}
onready var options_buttons = {
	"easy" : $Left_container/Center_box/VBoxContainer/Btn_easy,
	"medium" : $Left_container/Center_box/VBoxContainer/Btn_medium,
	"hard" : $Left_container/Center_box/VBoxContainer/Btn_hard
}
onready var btn_play = $Right_container/Bottom_box/Btn_play
onready var selected_option_label = $Right_container/Top_box/Option_label

var current_option = "no_option"


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
		current_option = "no_option"
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
	option_btn_toggle("easy", "Dificuldade: fácil")

func _on_Btn_medium_button_down():
	option_btn_toggle("medium", "Dificuldade: intermediária")

func _on_Btn_hard_pressed():
	option_btn_toggle("hard", "Dificuldade: difícil")

func _on_Btn_return_pressed():
	get_tree().change_scene("res://Cenas/Menus/Main_menu.tscn")
