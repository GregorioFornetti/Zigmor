extends "res://Scenes_and_scripts/Interfaces/Upgrades_shop/Shop_buttons/Weapons/Btn_upgrade_weapon.gd"

func get_upgrade_price():
	return 100 + qnt_buyed * 100 + 10 * int(pow(qnt_buyed, 2))

func make_upgrade():
	Game.Player.attributes[Game.Player.PISTOL].magazine_capacity += 1
	Game.Player.attributes[Game.Player.SHOTGUN].magazine_capacity += 1
	Game.Player.attributes[Game.Player.SNIPER].magazine_capacity -= 1

func update_all_weapons_status(pistol_status_container, shotgun_status_container, sniper_status_container):
	var pistol_magazine_size = Game.Player.attributes[Game.Player.PISTOL].magazine_capacity
	var shotgun_magazine_size = Game.Player.attributes[Game.Player.SHOTGUN].magazine_capacity
	var sniper_magazine_size = Game.Player.attributes[Game.Player.SNIPER].magazine_capacity
	
	pistol_status_container.get_node("Magazine_size_status/Attribute_label").text = str(pistol_magazine_size)
	shotgun_status_container.get_node("Magazine_size_status/Attribute_label").text = str(shotgun_magazine_size)
	sniper_status_container.get_node("Magazine_size_status/Attribute_label").text = str(sniper_magazine_size)
