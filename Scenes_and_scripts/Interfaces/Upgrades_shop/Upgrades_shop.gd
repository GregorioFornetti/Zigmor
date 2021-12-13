extends CanvasLayer

onready var close_btn = $Main_container/Bottom_container/Shop_fixed_container/Btn_close
onready var return_btn = $Main_container/Bottom_container/Shop_fixed_container/Btn_return
onready var main_page = $Main_container/Bottom_container/Shop_main_page
onready var current_page = main_page

func open_shop():
	$Main_container.visible = true
	update_money_label()

func update_money_label():
	var label_money = $Main_container/Bottom_container/Shop_fixed_container/Money_status/Attribute_label
	label_money.text = str(Game.Player.get_money())

func return_to_main_page():
	$Main_container/Top_container/Page_title.text = "Pagina principal"
	current_page.visible = false
	main_page.visible = true
	current_page = main_page
	
	close_btn.visible = true
	return_btn.visible = false

func change_page(page_name, page_node):
	$Main_container/Top_container/Page_title.text = page_name
	
	main_page.visible = false
	current_page = page_node
	current_page.visible = true
	
	close_btn.visible = false
	return_btn.visible = true

func close_shop():
	Game.current_status = Game.status.PLAYING
	$Main_container.visible = false
	get_tree().paused = false
	if Game.current_difficulty != Game.difficulties.HARD:
		SoundSystem.continue_game_bg_music()


func _on_Btn_upgrade_weapons_pressed():
	change_page("Upgrades gerais das armas", $Main_container/Bottom_container/Shop_weapons_page)

func _on_Btn_upgrade_pistol_pressed():
	change_page("Upgrades da pistola", $Main_container/Bottom_container/Shop_pistol_page)

func _on_Btn_upgrade_shotgun_pressed():
	change_page("Upgrades da shotgun", $Main_container/Bottom_container/Shop_shotgun_page)

func _on_Btn_upgrade_sniper_pressed():
	change_page("Upgrades da sniper", $Main_container/Bottom_container/Shop_sniper_page)

func _on_Btn_upgrade_armor_pressed():
	change_page("Upgrades da armadura", $Main_container/Bottom_container/Shop_armor_page)

func _on_Btn_upgrade_powerup_pressed():
	change_page("Upgrades de poderes", $Main_container/Bottom_container/Shop_powerup_page)


func _on_Btn_close_pressed():
	close_shop()

func _on_Btn_return_pressed():
	return_to_main_page()

func _on_Btn_quit_pressed():
	return_to_main_page()
	close_shop()


func _ready():
	# Adicionando um texto de ajuda em cada botão da loja com a tecla
	# que pode ser apertada para fazer o mesmo que clicar naquele botão
	# EX: Fechar [0] -> 0 é a tecla padrão para fechar/voltar na loja
	
	var b_container = $Main_container/Bottom_container
	var fixed_container = b_container.get_node("Shop_fixed_container")
	
	# Adicionando a ajuda nos botões de fechar e voltar da loja
	var btn_close = b_container.get_node("Shop_fixed_container/Btn_close")
	var btn_return = b_container.get_node("Shop_fixed_container/Btn_return")
	var close_and_return_key = OS.get_scancode_string(InputMap.get_action_list("0_shop_select")[0].scancode)
	btn_close.get_node("Label").text += to_helper_str(close_and_return_key)
	btn_return.get_node("Label").text += to_helper_str(close_and_return_key)
	
	# Adicionando a ajuda no restante dos botões da loja
	for page in b_container.get_children():
		if page != fixed_container:
			var btns_container = page.get_node("Left_container/Shop_btns_container")
			for i in range(btns_container.get_child_count()):
				var btn = btns_container.get_child(i)
				var help_text = to_helper_str(OS.get_scancode_string( \
					InputMap.get_action_list(str(i+1) + "_shop_select")[0].scancode))
				btn.get_node("Title").text += help_text

func to_helper_str(key):
	return " [" + key + "]" 


func _input(event):
	if Game.current_status == Game.status.SHOPPING and event is InputEventKey:
		if event.is_action_pressed("open_shop"):
			return_to_main_page()
			close_shop()
			get_tree().set_input_as_handled()
		elif event.is_action_pressed("0_shop_select"):
			if current_page == main_page:
				close_shop()
			else:
				return_to_main_page()
		else:
			var btns_container = current_page.get_node("Left_container/Shop_btns_container")
			var btn_num = null
			if event.is_action_pressed("1_shop_select"):
				btn_num = 0
			elif event.is_action_pressed("2_shop_select"):
				btn_num = 1
			elif event.is_action_pressed("3_shop_select"):
				btn_num = 2
			elif event.is_action_pressed("4_shop_select"):
				btn_num = 3
			elif event.is_action_pressed("5_shop_select"):
				btn_num = 4
			elif event.is_action_pressed("6_shop_select"):
				btn_num = 5
			elif event.is_action_pressed("7_shop_select"):
				btn_num = 6
			elif event.is_action_pressed("8_shop_select"):
				btn_num = 7
			elif event.is_action_pressed("9_shop_select"):
				btn_num = 8
			
			if btn_num != null and btn_num < btns_container.get_child_count():
				btns_container.get_child(btn_num).emit_signal("pressed")

