extends "res://Scenes_and_scripts/Interfaces/Upgrades_shop/Shop_buttons/Btn_shop_buy.gd"


func get_upgrade_price():
	return 150 + qnt_buyed * 200

func make_upgrade():
	var reload_time = Game.Player.attributes[Game.Player.SNIPER].power.reload_time
	Game.Player.attributes[Game.Player.SNIPER].power.reload_time = int(reload_time * 0.9)
	if Game.Player.attributes[Game.Player.SNIPER].power.reload_time <= 20:
		disable_btn()

func update_status_box():
	var reload_time = Game.Player.attributes[Game.Player.SNIPER].power.reload_time
	status_boxes_container.get_node("Sniper_power_reload_time_status/Attribute_label").text = str(reload_time) + " s"
