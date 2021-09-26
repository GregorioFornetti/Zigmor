extends "res://Scenes_and_scripts/Interfaces/Upgrades_shop/Shop_buttons/Btn_shop_buy.gd"


func get_upgrade_price():
	return 300 + 175 * int(pow(qnt_buyed, 2))

func make_upgrade(): 
	Game.Player.attributes[Game.Player.SNIPER].fire_rate -= 0.05
	if is_equal_approx(Game.Player.attributes[Game.Player.SNIPER].fire_rate, 0.8):
		disable_btn()

func update_status_box():
	var sniper_firerate = Game.Player.attributes[Game.Player.SNIPER].fire_rate
	status_boxes_container.get_node("Firerate_status/Attribute_label").text = str(sniper_firerate) + " s"
