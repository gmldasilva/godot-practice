extends Node

const CAR = preload("res://Car/car.tscn")

func _ready():
	$YSort/player.position = $PlayerStartPos.position 
	$"CanvasLayer/Label".text = "Score: " + str(GLOBAL.score)

func car_spawn(start_position):
	var car = CAR.instance()
	var car_start_node_name = "StartPositions/CarStart" + str(start_position)
	car.position = get_node(car_start_node_name).position
	$"YSort".add_child(car)

	var timer_node_name = "CarTimers/Timer" + str(start_position)
	get_node(timer_node_name).wait_time = rand_range(1.5,2.3)
	
func _process(delta):
	if $"YSort/player".position.y <= -100:
		GLOBAL.score += 1
		$"YSort/player".position = $"PlayerStartPos".position
		$"CanvasLayer/Label".text = "Score: " + str(GLOBAL.score)

func _on_Timer1_timeout(): car_spawn(1)
func _on_Timer2_timeout(): car_spawn(2)
func _on_Timer3_timeout(): car_spawn(3)
func _on_Timer4_timeout(): car_spawn(4)
func _on_Timer5_timeout(): car_spawn(5)
