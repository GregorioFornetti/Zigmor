extends Node2D

const SPAWN_WIDTH = 6000  # Largura a partir do player para spawn de inimigos (player centralizado)
const SPAWN_HEIGHT = 3500  # Altura a partir do player para spawn de inimigos (player centralizado)
const EXTRA_SPACE = 100  # Inimigos não podem spawnar no campo de visão do player + EXTRA_SPACE

onready var Pistol_enemy = preload("res://Scenes_and_scripts/Enemies/Pistol_enemy.tscn")
onready var player = get_parent().get_node("Player")
onready var spawn_blocker = get_node("Spawn_blocker")
onready var rng = RandomNumberGenerator.new()

func _ready():
	spawn_blocker.shape.extents.x = ProjectSettings.get_setting("display/window/size/width") / 2 + EXTRA_SPACE
	spawn_blocker.shape.extents.y = ProjectSettings.get_setting("display/window/size/height") / 2 + EXTRA_SPACE
	rng.randomize()


func spawn_enemy(Enemy):
	var enemy = Enemy.instance()
	get_parent().add_child(enemy)
	enemy.position = get_random_position(enemy.collision_shape)

func get_random_position(enemy_colision_shape):
	# Retorna uma posição aleatória dentro do range do retangulo de largura 
	# e altura definidos pelas constantes no começo do código
	
	position = player.position  # atualizar a posição do spawner block
	var space_state = get_world_2d().direct_space_state
	
	while true:
		var random_pos = player.position + Vector2(rng.randf_range(-SPAWN_WIDTH/2,SPAWN_WIDTH/2), rng.randf_range(-SPAWN_HEIGHT/2,SPAWN_HEIGHT/2))
		
		var query = Physics2DShapeQueryParameters.new()
		#query.collision_layer = 0b00000000000010000111
		query.collide_with_areas = true
		query.set_shape(enemy_colision_shape)
		query.set_transform(Transform2D(0, random_pos))
		
		if not space_state.collide_shape(query,1):
			return random_pos




# Para realizar testes de tamanhos da nova área de spawn, descomentar as linhas abaixo (Dica: use CTRL + K para descomentar, aumente o zoom no player)

#func _process(_delta):
#	update()
#
#func _draw():
#	draw_rect(Rect2(-SPAWN_WIDTH/2,-SPAWN_HEIGHT/2,SPAWN_WIDTH,SPAWN_HEIGHT), ColorN('red'), false, 20)


func _on_Timer_timeout():
	spawn_enemy(Pistol_enemy)
