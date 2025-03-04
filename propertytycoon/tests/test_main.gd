extends GutTest

func test_turnlogic():
	var player = Player.new()
	var player2 = Player.new()
	var game_manager_scene = load("res://main.tscn")
	var game_manager = game_manager_scene.instantiate()
	add_child(game_manager)
	game_manager.players.append(player)
	
	game_manager.end_turn()
	
	assert_eq(game_manager.current_turn, 1, "It should be player 2 turn")
	
