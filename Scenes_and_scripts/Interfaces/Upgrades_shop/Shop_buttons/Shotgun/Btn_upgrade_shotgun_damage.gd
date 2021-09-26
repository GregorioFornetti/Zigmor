extends "res://Scenes_and_scripts/Interfaces/Upgrades_shop/Shop_buttons/Btn_shop_buy.gd"


func get_upgrade_price():
	return 150 + qnt_buyed * 100 + 10 * int(pow(qnt_buyed, 2))

func make_upgrade():
	var shotgun_damage = Game.Player.attributes[Game.Player.SHOTGUN].damage
	Game.Player.attributes[Game.Player.SHOTGUN].damage = shotgun_damage + 1 + int(shotgun_damage / 10)

func update_status_box():
	var shotgun_damage = Game.Player.attributes[Game.Player.SHOTGUN].damage
	status_boxes_container.get_node("Damage_status/Attribute_label").text = str(shotgun_damage)
