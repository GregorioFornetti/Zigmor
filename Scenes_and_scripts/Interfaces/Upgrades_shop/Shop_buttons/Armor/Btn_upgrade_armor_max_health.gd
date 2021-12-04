extends "res://Scenes_and_scripts/Interfaces/Upgrades_shop/Shop_buttons/Btn_shop_buy.gd"


func get_upgrade_price():
	return 30 + qnt_buyed * 20 + 10 * int(pow(qnt_buyed, 2))

func make_upgrade():
	var max_health = Game.Player.attributes.max_health
	var incremented_health = int(max_health * 0.05) + 10
	Game.Player.attributes.max_health = max_health + incremented_health
	Game.Player.attributes.status.health += incremented_health
	Game.Player.update_health_interface()

func update_status_box():
	var max_health = Game.Player.attributes.max_health
	status_boxes_container.get_node("Max_health_status/Attribute_label").text = str(max_health)
