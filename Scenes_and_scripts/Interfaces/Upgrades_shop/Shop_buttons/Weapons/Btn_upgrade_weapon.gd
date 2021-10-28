extends "res://Scenes_and_scripts/Interfaces/Upgrades_shop/Shop_buttons/Btn_shop_buy.gd"


func _ready():
	pass # Replace with function body.

func update_status_box():
	var pages_container = get_parent().get_parent().get_parent().get_parent()
	update_all_weapons_status(pages_container.get_node("Shop_pistol_page").get_node("Rigth_container").get_node("Status_boxes_container"),\
							  pages_container.get_node("Shop_shotgun_page").get_node("Rigth_container").get_node("Status_boxes_container"),\
							  pages_container.get_node("Shop_sniper_page").get_node("Rigth_container").get_node("Status_boxes_container"))

func update_all_weapons_status(pistol_status_container, shotgun_status_container, sniper_status_container):
	pass
