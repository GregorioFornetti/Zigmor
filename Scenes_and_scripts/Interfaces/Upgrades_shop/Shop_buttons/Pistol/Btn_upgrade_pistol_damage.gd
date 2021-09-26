extends "res://Scenes_and_scripts/Interfaces/Upgrades_shop/Shop_buttons/Btn_shop_buy.gd"


func get_upgrade_price():
	return 50 + qnt_buyed * 50 + 5 * int(pow(qnt_buyed, 2))

func make_upgrade():
	var pistol_damage = Game.Player.attributes[Game.Player.PISTOL].damage
	Game.Player.attributes[Game.Player.PISTOL].damage = pistol_damage + 1 + int(pistol_damage / 5)

func update_status_box():
	var pistol_damage = Game.Player.attributes[Game.Player.PISTOL].damage
	status_boxes_container.get_node("Damage_status/Attribute_label").text = str(pistol_damage)
