extends "res://Scenes_and_scripts/Interfaces/Upgrades_shop/Shop_buttons/Btn_shop_buy.gd"


func get_upgrade_price():
	return 100 + qnt_buyed * 100 + 10 * int(pow(qnt_buyed, 2))

func make_upgrade():
	Game.Player.attributes[Game.Player.SHOTGUN].magazine_capacity += 1

func update_status_box():
	var magazine_size = Game.Player.attributes[Game.Player.SHOTGUN].magazine_capacity
	status_boxes_container.get_node("Magazine_size_status/Attribute_label").text = str(magazine_size)
