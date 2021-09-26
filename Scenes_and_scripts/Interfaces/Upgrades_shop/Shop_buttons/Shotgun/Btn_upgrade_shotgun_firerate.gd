extends "res://Scenes_and_scripts/Interfaces/Upgrades_shop/Shop_buttons/Btn_shop_buy.gd"


func get_upgrade_price():
	return 300 + 150 * int(pow(qnt_buyed, 2))

func make_upgrade(): 
	Game.Player.attributes[Game.Player.SHOTGUN].fire_rate -= 0.05
	if is_equal_approx(Game.Player.attributes[Game.Player.SHOTGUN].fire_rate, 0.5):
		disable_btn()

func update_status_box():
	var shotgun_firerate = Game.Player.attributes[Game.Player.SHOTGUN].fire_rate
	status_boxes_container.get_node("Firerate_status/Attribute_label").text = str(shotgun_firerate) + " s"
