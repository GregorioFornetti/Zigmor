extends "res://Scenes_and_scripts/Interfaces/Upgrades_shop/Shop_buttons/Btn_shop_buy.gd"


func get_upgrade_price():
	return 200 + 10 * int(pow(qnt_buyed, 2)) + 100 * qnt_buyed

func make_upgrade(): 
	Game.Player.attributes[Game.Player.PISTOL].reload_time -= 0.1
	if is_equal_approx(Game.Player.attributes[Game.Player.PISTOL].reload_time, 0.5):
		disable_btn()

func update_status_box():
	var pistol_firerate = Game.Player.attributes[Game.Player.PISTOL].reload_time
	status_boxes_container.get_node("Reload_time_status/Attribute_label").text = str(pistol_firerate) + " s"
