extends "res://Scenes_and_scripts/Interfaces/Upgrades_shop/Shop_buttons/Weapons/Btn_upgrade_weapon.gd"


func get_upgrade_price():
	return 250 + 300 * int(pow(qnt_buyed, 2))

func make_upgrade():
	Game.Player.attributes[Game.Player.PISTOL].fire_rate -= 0.05
	Game.Player.attributes[Game.Player.SHOTGUN].fire_rate -= 0.05
	Game.Player.attributes[Game.Player.SNIPER].fire_rate -= 0.05
	
	if is_equal_approx(Game.Player.attributes[Game.Player.PISTOL].fire_rate, 0.05):
		disable_btn()


func update_all_weapons_status(pistol_status_container, shotgun_status_container, sniper_status_container):
	var pistol_firerate = Game.Player.attributes[Game.Player.PISTOL].fire_rate
	var shotgun_firerate = Game.Player.attributes[Game.Player.SHOTGUN].fire_rate
	var sniper_firerate = Game.Player.attributes[Game.Player.SNIPER].fire_rate
	
	pistol_status_container.get_node("Firerate_status/Attribute_label").text = str(pistol_firerate) + " s"
	shotgun_status_container.get_node("Firerate_status/Attribute_label").text = str(shotgun_firerate) + " s"
	sniper_status_container.get_node("Firerate_status/Attribute_label").text = str(sniper_firerate) + " s"
