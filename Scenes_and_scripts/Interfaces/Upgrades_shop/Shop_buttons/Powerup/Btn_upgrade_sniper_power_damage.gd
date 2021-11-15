extends "res://Scenes_and_scripts/Interfaces/Upgrades_shop/Shop_buttons/Btn_shop_buy.gd"


func get_upgrade_price():
	return 150 + qnt_buyed * 200

func make_upgrade():
	var mult = Game.Player.attributes[Game.Player.SNIPER].power.multiplicator
	Game.Player.attributes[Game.Player.SNIPER].power.multiplicator += mult * 0.1

func update_status_box():
	var teste = 5.5
	var mult = Game.Player.attributes[Game.Player.SNIPER].power.multiplicator
	status_boxes_container.get_node("Sniper_power_dmg_mult_status/Attribute_label").text = "%.2f" % mult
