extends CanvasLayer

onready var timer = $Timer

var pontos = 10000


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(_delta):
	print(timer.time_left)
	print(get_current_points(pontos))

func get_current_points(points):
	if timer.time_left != 0:
		return int(points * (1 - (timer.time_left / timer.wait_time)))
	else:
		return points

func update_enemy_score():
	var divisor = timer.wait_time - timer.time_left
