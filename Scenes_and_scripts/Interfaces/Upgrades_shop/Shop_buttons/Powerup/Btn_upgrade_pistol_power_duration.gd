extends "res://Scenes_and_scripts/Interfaces/Upgrades_shop/Shop_buttons/Btn_shop_buy.gd"


func get_upgrade_price():
	return 150 + qnt_buyed * 200

func make_upgrade():
	Game.Player.attributes[Game.Player.PISTOL].power.duration += 1

func update_status_box():
	var duration = Game.Player.attributes[Game.Player.PISTOL].power.duration
	status_boxes_container.get_node("Pistol_power_duration_status/Attribute_label").text = str(duration) + " s"
