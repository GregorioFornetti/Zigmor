extends "res://Scenes_and_scripts/Interfaces/Upgrades_shop/Shop_buttons/Btn_shop_buy.gd"


func get_upgrade_price():
	return 200 + qnt_buyed * 120 + 15 * int(pow(qnt_buyed, 2))

func make_upgrade():
	var sniper_damage = Game.Player.attributes[Game.Player.SNIPER].damage
	Game.Player.attributes[Game.Player.SNIPER].damage = sniper_damage + 3 + int(sniper_damage / 5)

func update_status_box():
	var sniper_damage = Game.Player.attributes[Game.Player.SNIPER].damage
	status_boxes_container.get_node("Damage_status/Attribute_label").text = str(sniper_damage)
