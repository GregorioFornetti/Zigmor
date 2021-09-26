extends "res://Scenes_and_scripts/Interfaces/Upgrades_shop/Shop_buttons/Btn_shop_buy.gd"


func get_upgrade_price():
	return 300 + 10 * int(pow(qnt_buyed, 2)) + 150 * qnt_buyed

func make_upgrade(): 
	Game.Player.attributes[Game.Player.SHOTGUN].reload_time -= 0.1
	if is_equal_approx(Game.Player.attributes[Game.Player.SHOTGUN].reload_time, 0.8):
		disable_btn()

func update_status_box():
	var shotgun_reload_time = Game.Player.attributes[Game.Player.SHOTGUN].reload_time
	status_boxes_container.get_node("Reload_time_status/Attribute_label").text = str(shotgun_reload_time) + " s"
