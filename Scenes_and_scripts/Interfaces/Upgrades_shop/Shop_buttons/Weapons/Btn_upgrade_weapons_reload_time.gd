extends "res://Scenes_and_scripts/Interfaces/Upgrades_shop/Shop_buttons/Weapons/Btn_upgrade_weapon.gd"


func get_upgrade_price():
	return 250 + 15 * int(pow(qnt_buyed, 2)) + 125 * qnt_buyed

func make_upgrade():
	Game.Player.attributes[Game.Player.PISTOL].reload_time -= 0.1
	Game.Player.attributes[Game.Player.SHOTGUN].reload_time -= 0.1
	Game.Player.attributes[Game.Player.SNIPER].reload_time -= 0.1
	
	if is_equal_approx(Game.Player.attributes[Game.Player.PISTOL].reload_time, 0.5):
		disable_btn()


func update_all_weapons_status(pistol_status_container, shotgun_status_container, sniper_status_container):
	var pistol_reload_time = Game.Player.attributes[Game.Player.PISTOL].reload_time
	var shotgun_reload_time = Game.Player.attributes[Game.Player.SHOTGUN].reload_time
	var sniper_reload_time = Game.Player.attributes[Game.Player.SNIPER].reload_time
	
	pistol_status_container.get_node("Reload_time_status/Attribute_label").text = str(pistol_reload_time) + " s"
	shotgun_status_container.get_node("Reload_time_status/Attribute_label").text = str(shotgun_reload_time) + " s"
	sniper_status_container.get_node("Reload_time_status/Attribute_label").text = str(sniper_reload_time) + " s"
