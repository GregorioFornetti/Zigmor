extends "res://Scenes_and_scripts/Interfaces/Upgrades_shop/Shop_buttons/Btn_shop_buy.gd"


func get_upgrade_price():
	return 50 + qnt_buyed * 200

func make_upgrade():
	Game.Player.attributes.dash.reload_time -= 0.1
	if is_equal_approx(Game.Player.attributes.dash.reload_time, 2.0):
		disable_btn()

func update_status_box():
	var reload_time = Game.Player.attributes.dash.reload_time
	status_boxes_container.get_node("Dash_reload_time_status/Attribute_label").text = str(reload_time) + " s"
