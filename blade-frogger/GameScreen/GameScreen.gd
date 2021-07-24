extends Control


func _process(delta):
	$"Label".text = "Score: " + str(GLOBAL.score)

	if Input.is_action_pressed("ui_select"):
		get_tree().change_scene("res://Level/level.tscn")
		GLOBAL.score = 0
