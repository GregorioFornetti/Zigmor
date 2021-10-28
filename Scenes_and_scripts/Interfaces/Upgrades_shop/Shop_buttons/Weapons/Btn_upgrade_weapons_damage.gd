extends "res://Scenes_and_scripts/Interfaces/Upgrades_shop/Shop_buttons/Weapons/Btn_upgrade_weapon.gd"


func get_upgrade_price():
	return 150 + qnt_buyed * 150 + 15 * int(pow(qnt_buyed, 2))

func make_upgrade():
	var pistol_damage = Game.Player.attributes[Game.Player.PISTOL].damage
	var shotgun_damage = Game.Player.attributes[Game.Player.SHOTGUN].damage
	var sniper_damage = Game.Player.attributes[Game.Player.SNIPER].damage
	
	Game.Player.attributes[Game.Player.PISTOL].damage = pistol_damage + 1 + int(pistol_damage / 5)
	Game.Player.attributes[Game.Player.SHOTGUN].damage = shotgun_damage + 1 + int(shotgun_damage / 10)
	Game.Player.attributes[Game.Player.SNIPER].damage = sniper_damage + 3 + int(sniper_damage / 5)


func update_all_weapons_status(pistol_status_container, shotgun_status_container, sniper_status_container):
	var pistol_damage = Game.Player.attributes[Game.Player.PISTOL].damage
	var shotgun_damage = Game.Player.attributes[Game.Player.SHOTGUN].damage
	var sniper_damage = Game.Player.attributes[Game.Player.SNIPER].damage
	
	pistol_status_container.get_node("Damage_status/Attribute_label").text = str(pistol_damage)
	shotgun_status_container.get_node("Damage_status/Attribute_label").text = str(shotgun_damage)
	sniper_status_container.get_node("Damage_status/Attribute_label").text = str(sniper_damage)
