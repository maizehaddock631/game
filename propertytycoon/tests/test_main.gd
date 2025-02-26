extends GutTest

func test_turnlogic():
	var player = Player.new("Milly")
	var player2 = Player.new("Jhardelle")
	var game_manager_scene = preload("res://main.tscn")
	var game_manager = game_manager_scene.instance()
	add_child(game_manager)
	game_manager.players.append(player)
	
	game_manager.end_turn()
	
	assert(game_manager.current_turn == 1, "It should be player 2 turn")
	
