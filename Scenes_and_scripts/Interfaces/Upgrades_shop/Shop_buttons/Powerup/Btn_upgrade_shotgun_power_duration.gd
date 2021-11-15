extends "res://Scenes_and_scripts/Interfaces/Upgrades_shop/Shop_buttons/Btn_shop_buy.gd"


func get_upgrade_price():
	return 150 + qnt_buyed * 200

func make_upgrade():
	Game.Player.attributes[Game.Player.SHOTGUN].power.duration += 0.5

func update_status_box():
	var duration = Game.Player.attributes[Game.Player.SHOTGUN].power.duration
	status_boxes_container.get_node("Shotgun_power_duration_status/Attribute_label").text = str(duration) + " s"
