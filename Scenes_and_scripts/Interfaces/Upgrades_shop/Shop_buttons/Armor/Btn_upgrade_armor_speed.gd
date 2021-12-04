extends "res://Scenes_and_scripts/Interfaces/Upgrades_shop/Shop_buttons/Btn_shop_buy.gd"


func get_upgrade_price():
	return 50 + 100 * qnt_buyed + 5 * int(pow(qnt_buyed, 2))

func make_upgrade():
	Game.Player.attributes.speed += 10
	if Game.Player.attributes.speed == 400:
		disable_btn()

func update_status_box():
	var speed = Game.Player.attributes.speed
	status_boxes_container.get_node("Speed_status/Attribute_label").text = str(speed)
