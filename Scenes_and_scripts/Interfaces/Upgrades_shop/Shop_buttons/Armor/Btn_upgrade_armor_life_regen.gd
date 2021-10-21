extends "res://Scenes_and_scripts/Interfaces/Upgrades_shop/Shop_buttons/Btn_shop_buy.gd"


func get_upgrade_price():
	return 40 + qnt_buyed * 50

func make_upgrade():
	Game.Player.attributes.life_regen += 1

func update_status_box():
	var life_regen = Game.Player.attributes.life_regen
	status_boxes_container.get_node("Life_regen_status/Attribute_label").text = str(life_regen)
