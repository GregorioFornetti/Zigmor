extends Node2D

const SPAWN_WIDTH = 6000  # Largura a partir do player para spawn de inimigos (player centralizado)
const SPAWN_HEIGHT = 3500  # Altura a partir do player para spawn de inimigos (player centralizado)
const EXTRA_SPACE = 100  # Inimigos não podem spawnar no campo de visão do player + EXTRA_SPACE

onready var enemies = [  # Definir os enemy points (dificuldade) de cada no export var de cada inimigo
	{   # Pistol enemy (policial com pistola)
		"enemy": preload("res://Scenes_and_scripts/Enemies/Pistol_enemy.tscn")
	},
	{   # Shotgun enemy (policial com shotgun)
		"enemy": preload("res://Scenes_and_scripts/Enemies/Shotgun_enemy.tscn")
	}
]
onready var player = get_parent().get_node("Player")
onready var spawn_blocker = get_node("Spawn_blocker")
onready var rng = RandomNumberGenerator.new()

var possible_ranges_array = []
var qnt_enemies_alive = 0

class EnemiesSorter:
	static func sort_ascending(enemy1, enemy2):
		if enemy1['spawn_points_cost'] < enemy2['spawn_points_cost']:
			return true
		return false


func _ready():
	$Timer.start(Game.get_spawn_delay())
	rng.randomize()
	
	# Definindo o tamanho do spawn blocker para que inimigos não spawnem no campo de visão do player + EXTRA_SPACE
	spawn_blocker.shape.extents.x = ProjectSettings.get_setting("display/window/size/width") / 2 + EXTRA_SPACE
	spawn_blocker.shape.extents.y = ProjectSettings.get_setting("display/window/size/height") / 2 + EXTRA_SPACE
	
	for enemy_dict in enemies:
		var enemy_instance = enemy_dict['enemy'].instance()
		enemy_dict['spawn_points_cost'] = enemy_instance.points
	# Criação do vetor que ajudará na coleta do max range possível com certa quantidade de pontos de spawn.
	# possible_ranges_array[ponto_de_spawn_atual] deve representar o maximo range 
	# possivel de se conseguir com tal quantidade de pontos
	enemies.sort_custom(EnemiesSorter, "sort_ascending")
	var current_max_range = 0
	var max_points = enemies[-1]['spawn_points_cost']
	for current_points in range(1, max_points):
		while current_points >= enemies[current_max_range]['spawn_points_cost']:
			current_max_range += 1
		# OBS: Current max range sempre ficará 1 indice a frente do inimigo mais 
		# caro de spawnar atualmente (mais caro que da para "gastar" com os "current points".
		possible_ranges_array.append(current_max_range - 1)
	possible_ranges_array.append(len(enemies) - 1)
	
	spawn_enemies()

func _on_Timer_timeout():
	spawn_enemies()
	$Timer.start(Game.get_spawn_delay())

func spawn_enemies():
	var current_spawn_points = Game.get_spawn_points()
	while current_spawn_points != 0:
		var selected = enemies[rng.randi_range(0, get_possible_enemies_max_range(current_spawn_points))]
		current_spawn_points -= selected["spawn_points_cost"]
		spawn_enemy(selected['enemy'])
		qnt_enemies_alive += 1

func get_possible_enemies_max_range(current_points):
	# O max range possível representa até qual inimigo podemos pegar aleatoriamente com uma certa quantidade de pontos
	# Por exemplo, se eu tenho uma lista com inimigos com custo de spawn igual a [1, 1, 3, 5],
	# se eu possuir 1 ponto, o meu max range deve ser 1 (para poder acessar os indices 0 e 1),
	# e se eu tiver 5 pontos, meu max range dever ser 4 (para poder spawnar qualquer inimigo),
	# e caso eu tenha um número maior do que 5 de pontos, o max range deve continuar sendo 4 (pois posso spawnar qualquer inimigo).
	var index = min(current_points - 1, len(possible_ranges_array) - 1)
	return possible_ranges_array[index]

func spawn_enemy(Enemy):
	var enemy = Enemy.instance()
	get_parent().call_deferred("add_child", enemy)
	enemy.position = get_random_position(enemy.get_node("CollisionShape2D").shape)

func get_random_position(enemy_colision_shape):
	# Retorna uma posição aleatória dentro do range do retangulo de largura 
	# e altura definidos pelas constantes no começo do código.
	# A posição retornada precisa estar livre (sem nenhum objeto com colisão nela)
	
	position = player.position  # atualizar a posição do spawn blocker
	var space_state = get_world_2d().direct_space_state
	
	while true: # Enquanto a posição aleatória não for livre, irá ficar sorteando uma nova.
		var random_pos = player.position + Vector2(rng.randf_range(-SPAWN_WIDTH/2,SPAWN_WIDTH/2), rng.randf_range(-SPAWN_HEIGHT/2,SPAWN_HEIGHT/2))
		
		var query = Physics2DShapeQueryParameters.new()
		query.collision_layer = 0b00000000000010000111
		query.collide_with_areas = true
		query.set_shape(enemy_colision_shape)
		query.set_transform(Transform2D(0, random_pos))
		
		if not space_state.collide_shape(query,1):
			return random_pos

func _on_enemy_death(_enemy):
	qnt_enemies_alive -= 1
	if qnt_enemies_alive == 0:
		$Timer.start(min($Timer.time_left, 3))


# Para realizar testes de tamanhos da nova área de spawn, descomentar as linhas abaixo (Dica: use CTRL + K para descomentar, aumente o zoom no player)

#func _process(_delta):
#	update()
#
#func _draw():
#	draw_rect(Rect2(-SPAWN_WIDTH/2,-SPAWN_HEIGHT/2,SPAWN_WIDTH,SPAWN_HEIGHT), ColorN('red'), false, 20)

