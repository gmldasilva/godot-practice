extends Area2D

const X = preload("res://Assets/x.png")
const O = preload("res://Assets/o.png")
var selected = false
export var pos = -1

func _ready():
	$Overlay.hide()

func _on_MousePosition_mouse_entered():
	if (!selected and !Game.win):
		$Overlay.show()


func _on_MousePosition_mouse_exited():
	$Overlay.hide()

func play_x():
	if (!selected and !Game.win):
		$Overlay.hide()
		selected = true
		$XO.set_texture(X)
		Game.data_store[pos] = "x"
		Game.check_win(pos, "x")

func play_o():
	if (!selected and !Game.win):
		$Overlay.hide()
		selected = true
		$XO.set_texture(O)
		Game.data_store[pos] = "o"
		Game.check_win(pos, "o")

func _on_MousePosition_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton and event.pressed):
		if (event.button_index == BUTTON_LEFT):
			play_x()
			Game.play_computer()
			#$Overlay.hide()
			#selected = true
		#else: # TEST PURPOSES ONLY
		#	play_o()
		#	$Overlay.hide()
		#	selected = true
