extends "res://Scenes_and_scripts/Interfaces/Upgrades_shop/Shop_buttons/Btn_shop_buy.gd"


func get_upgrade_price():
	return int(pow(10, qnt_buyed + 3))

func make_upgrade():
	Game.Player.attributes.dash.qnt_total_dashes += 1
	Game.Player.attributes.status.qnt_available_dashes += 1
	Game.Player.update_dash_interface()
	

func update_status_box():
	var qnt_total_dashes = Game.Player.attributes.dash.qnt_total_dashes
	status_boxes_container.get_node("Dash_max_qnt_status/Attribute_label").text = str(qnt_total_dashes)
