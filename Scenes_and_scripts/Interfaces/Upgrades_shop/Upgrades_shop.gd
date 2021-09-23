extends CanvasLayer

onready var close_btn = $Main_container/Bottom_container/Shop_fixed_container/Btn_close
onready var return_btn = $Main_container/Bottom_container/Shop_fixed_container/Btn_return
onready var main_page = $Main_container/Bottom_container/Shop_main_page
onready var current_page = main_page


func update_money_label():
	var label_money = $Main_container/Bottom_container/Shop_fixed_container/Money_status/Attribute_label
	label_money.text = Game.Player.get_money()

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
	get_tree().paused = false
	Game.current_status = Game.status.PLAYING
	$Main_container.visible = false


func _on_Btn_upgrade_pistol_pressed():
	change_page("Upgrades da pistola", $Main_container/Bottom_container/Shop_pistol_page)

func _on_Btn_upgrade_shotgun_pressed():
	change_page("Upgrades da shotgun", $Main_container/Bottom_container/Shop_shotgun_page)

func _on_Btn_upgrade_sniper_pressed():
	change_page("Upgrades da sniper", $Main_container/Bottom_container/Shop_sniper_page)

func _on_Btn_close_pressed():
	close_shop()

func _on_Btn_return_pressed():
	return_to_main_page()

func _input(event):
	if Game.current_status == Game.status.SHOPPING:
		if event.get_action_strength("0_shop_select"):
			if current_page == main_page:
				close_shop()
			else:
				return_to_main_page()


