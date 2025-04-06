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

func test_rolling():
	var game_manager_scene = load("res://main.tscn")
	var game_manager = game_manager_scene.instantiate()
	add_child(game_manager)

	assert_eq(game_manager.addedNum, 7, "Should've gotten 7")
	game_manager._rolling()

func test_move_player():
	var game_manager_scene = load("res://main.tscn")
	var game_manager = game_manager_scene.instantiate()
	add_child(game_manager)

	game_manager._move_player(3)

func test_player_turn():
	var game_manager_scene = load("res://main.tscn")
	var game_manager = game_manager_scene.instantiate()
	add_child(game_manager)
	var tile = Tile.new()
	game_manager.player_turn(tile, 2)
	
func test_landed_on_property():
	var game_manager_scene = load("res://main.tscn")
	var game_manager = game_manager_scene.instantiate()
	add_child(game_manager)
	game_manager._landed_on_property(Property.new())

func test_on_property_button_pressed():
	var game_manager_scene = load("res://main.tscn")
	var game_manager = game_manager_scene.instantiate()
	add_child(game_manager)
	game_manager._on_property_button_pressed()

func test_update_label():
	var game_manager_scene = load("res://main.tscn")
	var game_manager = game_manager_scene.instantiate()
	add_child(game_manager)
	game_manager.update_label()
	
	
