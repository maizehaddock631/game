class_name NewGameMenu
extends Control

#@onready var player_count_spinbox = $MarginContainer/VBoxContainer/HBoxContainer3/SpinBox as SpinBox
@onready var player_count_spinbox: SpinBox = $ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer3/SpinBox
#@onready var game_version_optionButton = $MarginContainer/VBoxContainer/OptionButton as OptionButton
@onready var game_version_optionButton: OptionButton = $ScrollContainer/MarginContainer/VBoxContainer/OptionButton
#@onready var autoplayer_checkBox = $MarginContainer/VBoxContainer/HBoxContainer/CheckBox
#@onready var startButton = $MarginContainer/VBoxContainer/startGame as Button
@onready var startButton: Button = $ScrollContainer/MarginContainer/VBoxContainer/startGame
#@onready var player_names_container = $MarginContainer/VBoxContainer as VBoxContainer
@onready var player_names_container: VBoxContainer = $ScrollContainer/MarginContainer/VBoxContainer
@onready var game = preload("res://main.tscn").instantiate()




var player_data = []
var num_players = 2
var game_version = 'Full'
var player_name_inputs =[]
var stored_player_names = []
var stored_tokens = []

func _ready() -> void:
	#Setting up spinBox linits
	set_process(false)
	player_count_spinbox.min_value = 2
	player_count_spinbox.max_value = 6
	num_players = player_count_spinbox.value

	create_player_name_inputs()
	
	
	#print("Starting game with settings:")
	#print("Players : ", num_players)
	#print("Game Version : ", game_version)
		#
	#get_tree().change_scene_to_file("res://main.tscn")
	#
	#Connect signals
		
	game_version_optionButton.connect("item_selected", func on_game_version_changed(index: int):
		game_version = "Full" if index == 0 else "Timed"
		print("Game Version : ", game_version))
	
	#Populate game version
	game_version_optionButton.clear()
	game_version_optionButton.add_item("Full Version")
	game_version_optionButton.add_item("Timed Version")
	
	
func create_player_name_inputs():
	# Clear any previous input fields
	for input_field in player_name_inputs:
		input_field.queue_free()
	
	player_name_inputs.clear()

	# Create a LineEdit for each player
	for i in range(num_players):
		var line_edit = LineEdit.new()
		var token = OptionButton.new()
		#token.add_item("Cat")
		#token.add_item("Iron")
		#token.add_item("HatStand")
		#token.add_item("SmartPhone")
		#token.add_item("Boot")
		#token.add_item("Ship")
		token.add_icon_item(preload("res://gameAssets/token assets/IMG_5684.PNG"), "Cat")
		token.add_icon_item(preload("res://gameAssets/token assets/IMG_5682.PNG"), "Iron")
		token.add_icon_item(preload("res://gameAssets/token assets/IMG_5683.PNG"), "HatStand")
		token.add_icon_item(preload("res://gameAssets/token assets/IMG_5678.PNG"), "SmartPhone")
		token.add_icon_item(preload("res://gameAssets/token assets/IMG_5677.PNG"), "Boot")
		token.add_icon_item(preload("res://gameAssets/token assets/IMG_5681.PNG"), "Ship")
		line_edit.placeholder_text = "Player " + str(i + 1) + "'s Name"
		player_names_container.add_child(line_edit)
		player_names_container.add_child(token)
		player_name_inputs.append(line_edit)
		stored_player_names.append("")
		print(stored_player_names[i])
		line_edit.connect("text_changed", self._on_line_edit_text_changed.bind(i))
	


func _on_start_game_pressed() -> void:
	print("Starting game with settings:")
	print("Players : ", num_players)
	print("Game Version : ", game_version)
	
	for i in range(num_players):
		var player_name = stored_player_names[i]
		var token = stored_tokens[i]
		if player_name == "":
			player_name = "Player " + str(i + 1)
		player_data.append({"name": player_name})
		player_data.append({"token" : token})  # Add player data for all players
	print("NewGameMenu - Player Data:", player_data)
	var game_scene = load("res://main.tscn").instantiate()
	game_scene.player_data = player_data
	if get_parent():
		get_parent().add_child(game_scene)
		queue_free()
	else:
		printerr("Error: NewGameMenu has no parent. Cannot add game scene.")
	


func _on_player_count_changed(value: float) -> void:
	num_players = int(value) #Making sure value passed is an integer
	print("Players : ", num_players)
	create_player_name_inputs()
	
#func _on_line_edit_text_changed(new_text, player_index):
	#stored_player_names
	#print("Player", player_index + 1, "typed:", new_text)
	## You could store the names in an array here as they are typed
	##player_name_inputs[player_index].text = new_text
	
func _on_line_edit_text_changed(new_text, player_index):
	print("SIGNAL: Player", player_index + 1, "typed:", new_text)
	if player_index >= 0 and player_index < stored_player_names.size():
		stored_player_names[player_index] = new_text
		print("UPDATE: stored_player_names[" + str(player_index) + "] =", stored_player_names[player_index])
		print("FULL stored_player_names:", stored_player_names)
	else:
		printerr("ERROR: Invalid player_index in _on_line_edit_text_changed:", player_index)
