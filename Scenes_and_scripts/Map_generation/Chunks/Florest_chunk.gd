extends Node2D

const WIDTH = 64 * 32
const HEIGTH = 64 * 32
onready var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	create_random_obstacles()

func create_random_obstacles():
	generate_trees()
	generate_stones()

func spawn_obstacle(Obstacle):
	var obstacle = Obstacle.instance()
	var random_pos = get_random_position(obstacle.get_node("CollisionShape2D").shape)
	if random_pos:
		obstacle.position = random_pos
		add_child(obstacle)


func generate_trees():
	var Small_tree = load("res://Scenes_and_scripts/Obstacles/Trees/Tree_sm.tscn")
	var Medium_tree = load("res://Scenes_and_scripts/Obstacles/Trees/Tree_md.tscn")
	var Large_tree = load("res://Scenes_and_scripts/Obstacles/Trees/Tree_lg.tscn")
	
	var qnt_spawn = rng.randi_range(6, 15)
	for i in range(qnt_spawn):
		var random_value = rng.randf_range(1, 100)
		if random_value <= 60:
			spawn_obstacle(Small_tree)
		elif random_value <= 90:
			spawn_obstacle(Medium_tree)
		else:
			spawn_obstacle(Large_tree)

func generate_stones():
	var Small_stone = load("res://Scenes_and_scripts/Obstacles/Stones/Stone_sm.tscn")
	var Medium_stone = load("res://Scenes_and_scripts/Obstacles/Stones/Stone_md.tscn")
	var Large_stone = load("res://Scenes_and_scripts/Obstacles/Stones/Stone_lg.tscn")
	
	var qnt_spawn = rng.randi_range(5, 12)
	for i in range(qnt_spawn):
		var random_value = rng.randf_range(1, 100)
		if random_value <= 60:
			spawn_obstacle(Small_stone)
		elif random_value <= 95:
			spawn_obstacle(Medium_stone)
		else:
			spawn_obstacle(Large_stone)

func get_random_position(obstacle_colision_shape):
	var space_state = get_world_2d().direct_space_state
	
	var random_pos = Vector2(rng.randf_range(0,WIDTH), rng.randf_range(0, HEIGTH))
	var query = Physics2DShapeQueryParameters.new()
	query.collision_layer = 0b00000000001000000111
	query.collide_with_areas = false
	query.set_shape(obstacle_colision_shape)
	query.set_transform(Transform2D(0, random_pos))
	
	if not space_state.collide_shape(query,1):
		return random_pos
	else:
		return false
