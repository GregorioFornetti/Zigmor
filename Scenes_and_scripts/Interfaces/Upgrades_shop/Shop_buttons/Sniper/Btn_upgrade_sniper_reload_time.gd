extends "res://Scenes_and_scripts/Interfaces/Upgrades_shop/Shop_buttons/Btn_shop_buy.gd"


func get_upgrade_price():
	return 300 + 15 * int(pow(qnt_buyed, 2)) + 150 * qnt_buyed

func make_upgrade(): 
	Game.Player.attributes[Game.Player.SNIPER].reload_time -= 0.1
	if is_equal_approx(Game.Player.attributes[Game.Player.SNIPER].reload_time, 1.0):
		disable_btn()

func update_status_box():
	var sniper_reload_time = Game.Player.attributes[Game.Player.SNIPER].reload_time
	status_boxes_container.get_node("Reload_time_status/Attribute_label").text = str(sniper_reload_time) + " s"
