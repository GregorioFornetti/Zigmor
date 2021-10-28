extends Node2D

const MAX_CHUNKS = 30
const CHUNK_WIDTH = 2048
const CHUNK_HEIGHT = 2048

var Florest_chunk = preload("res://Scenes_and_scripts/Map_generation/Chunks/Florest_chunk.tscn")

onready var chunks_info_list = []

func _process(_delta):
	#update()
	create_chunks_if_necessary()

#func _draw():
#	var window_size = Vector2(ProjectSettings.get_setting("display/window/size/width"), ProjectSettings.get_setting("display/window/size/height"))
#	draw_rect(Rect2(Game.Player.global_position - window_size / 2, window_size), ColorN("red"), false, 10)
#	for i in range(1, -2, -1):
#		for j in range(1, -2, -1):
#			var x = Game.Player.global_position.x + ProjectSettings.get_setting("display/window/size/width") * 1.5 * i
#			var y = Game.Player.global_position.y + ProjectSettings.get_setting("display/window/size/height") * 1.5 * j
#			draw_circle(Vector2(x, y), 10, ColorN("red"))

func create_chunks_if_necessary():
	for i in range(1, -2, -1):
		for j in range(1, -2, -1):
			var x = Game.Player.global_position.x + ProjectSettings.get_setting("display/window/size/width") * 1.5 * i
			var y = Game.Player.global_position.y + ProjectSettings.get_setting("display/window/size/height") * 1.5 * j
			create_new_chunk_if_necessary(x,y)

func create_new_chunk_if_necessary(global_x, global_y):
	var grid_position = Vector2(get_x_grid_position(global_x), get_y_grid_position(global_y))
	for chunk_info in chunks_info_list:
		if chunk_info["grid_position"] == grid_position:
			return
	create_new_chunk(grid_position)
	
func create_new_chunk(grid_position):
	if len(chunks_info_list) == MAX_CHUNKS:
		var old_chunk = chunks_info_list[0]["chunk"]
		old_chunk.queue_free()
		chunks_info_list.pop_front()
	
	var chunk = Florest_chunk.instance()
	chunk.global_position = Vector2(CHUNK_WIDTH * grid_position.x, \
									CHUNK_HEIGHT * grid_position.y)
	get_parent().call_deferred("add_child", chunk)
	chunks_info_list.append({"chunk": chunk, "grid_position": grid_position})

func get_x_grid_position(x):
	# Retorna o x da grid de chunks. O x = 0 da grid representa a chunk que começa na posição global x = 0
	# e a grid x = 1 representa a chunk que começa na posição global x = chunk_width 
	if x < 0:
		return int(x / CHUNK_WIDTH) - 1
	else:
		return int(x / CHUNK_WIDTH)

func get_y_grid_position(y):
	# Retorna o x da grid de chunks. O y = 0 da grid representa a chunk que começa na posição global y = 0
	# e a grid y = 1 representa a chunk que começa na posição global y = chunk_height
	if y < 0:
		return int(y / CHUNK_HEIGHT) - 1
	else:
		return int(y / CHUNK_HEIGHT)
