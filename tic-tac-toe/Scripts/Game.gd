extends Node

var game_won = preload("res://Scenes/GameWon.tscn")
const checker_dict = {
	"row_one": [0,1,2],
	"row_two": [3,4,5],
	"row_three": [6,7,8],
	"col_one": [0,3,6],
	"col_two": [1,4,7],
	"col_three": [2,5,8],
	"diag_one": [0,4,8],
	"diag_two": [2,4,6]
}

var possible_win_x = []
var possible_win_o = []

var data_store = []
var win = false

func get_main_node():
	var root = get_tree().get_root()
	return root.get_child(root.get_child_count() -1)

func _ready():
	reset_data_store()

func reset_data_store():
	win = false
	data_store = []
	for i in range(0,9):
		data_store.append("--")

func get_keys_for_value(value):
	var all_keys = checker_dict.keys()
	var keys = []
	for i in range(0, all_keys.size()):
		var values = checker_dict[String(all_keys[i])]
		for j in range(0, values.size()):
			if (values[j] == value):
				keys.append(String(all_keys[i]))
	return keys
	
func check_win(pos, letter):
	var tally = 0
	var key = []
	var keys_to_check = get_keys_for_value(pos)

	for i in range(0, keys_to_check.size()):
		key = keys_to_check[i]
		for j in range(0, checker_dict[key].size()):
			if (data_store[checker_dict[key][j]] == letter):
				tally += 1
				
		if (tally == 3):
			win = true
			break
		elif (tally == 2):
			if (letter == "x"):
				possible_win_x.append(key)
			else:
				possible_win_o.append(key)
			tally = 0
		else:
			tally = 0
			
	if (win):
		won_game(checker_dict[key])
		
func won_game(win_key):
	var inst = game_won.instance()
	var node = "MousePosition" + String(win_key[1])
	inst.position = get_main_node().get_node("Grid/" + node).global_position
	var diff = win_key[2] - win_key[0]
	
	match diff:
		4:
			inst.rotation = deg2rad(-45)
		8:
			inst.rotation = deg2rad(45)
		6:
			inst.rotation = deg2rad(90)
	
	get_main_node().add_child(inst)
		
func play_winning_move():
	var played_winning_move = false
	var played_pos = -1
	var key_to_remove = -1

	if(possible_win_o.size() > 0): 
		for i in range(0, possible_win_o.size()):
			for j in range(0, checker_dict[possible_win_o[i]].size()):
				if(data_store[checker_dict[possible_win_o[i]][j]] == "--"):
					played_pos = checker_dict[possible_win_o[i]][j]
					key_to_remove = i
					var node = "MousePosition" + String(played_pos)
					get_main_node().get_node("Grid/" + node).play_o()
					played_winning_move = true
				if(played_winning_move):
					return played_winning_move
		if(key_to_remove != -1):
			possible_win_o.remove(key_to_remove)
		else:
			possible_win_o = []
	return played_winning_move
	
func block_players_win():
	var blocked_player = false
	var played_pos = -1
	var key_to_remove = -1

	if(possible_win_x.size() > 0): 
		for i in range(0, possible_win_x.size()):
			for j in range(0, checker_dict[possible_win_x[i]].size()):
				if(data_store[checker_dict[possible_win_x[i]][j]] == "--"):
					played_pos = checker_dict[possible_win_x[i]][j]
					key_to_remove = i
					var node = "MousePosition" + String(played_pos)
					get_main_node().get_node("Grid/" + node).play_o()
					blocked_player = true
					
				if(blocked_player):
					return blocked_player
					
		if(key_to_remove != -1):
			possible_win_x.remove(key_to_remove)
		else:
			possible_win_x = []
	
	return blocked_player
		
func check_for_draw():
	var draw = true
	for i in range(0, data_store.size()):
		if(data_store[i] == "--"):
			draw = false
	return draw
		
func play_computer():
	var won_by_comp = play_winning_move()
	if (won_by_comp):
		return
		
	var blocked_players_win = block_players_win()
	if (blocked_players_win):
		return
		
	var draw = check_for_draw()
	if (draw):
		return
		
	var can_take_pos = false
	while(!can_take_pos):
		var pos = randi()%8
		if(data_store[pos] == "--"):
			can_take_pos = true
			var node = "MousePosition" + String(pos)
			get_main_node().get_node("Grid/"+node).play_o()
		
func _process(delta):
	if (Input.is_key_pressed(KEY_ENTER)):
		possible_win_o = []
		possible_win_x = []
		get_tree().reload_current_scene()
		reset_data_store()
