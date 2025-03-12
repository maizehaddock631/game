class_name NewGameMenu
extends Control

@onready var player_count_spinbox = $MarginContainer/VBoxContainer/HBoxContainer3/SpinBox as SpinBox
@onready var game_version_optionButton = $MarginContainer/VBoxContainer/OptionButton as OptionButton
#@onready var autoplayer_checkBox = $MarginContainer/VBoxContainer/HBoxContainer/CheckBox
@onready var startButton = $MarginContainer/VBoxContainer/startGame as Button
@onready var player_names_container = $MarginContainer/VBoxContainer as VBoxContainer





var num_players = 2
var game_version = 'Full'
var player_name_inputs =[]

func _ready() -> void:
	#Setting up spinBox linits
	set_process(false)
	player_count_spinbox.min_value = 2
	player_count_spinbox.max_value = 6
	player_count_spinbox.value = num_players
	create_player_name_inputs()
	var startGameButton = func on_start_game():
		print("Starting game with settings:")
		print("Players : ", num_players)
		print("Game Version : ", game_version)
		get_tree().change_scene_to_file("res://main.tscn")
	
	#Connect signals
	player_count_spinbox.connect("value_changed", func on_player_count_changed(value: float):
		num_players = int(value) #Making sure value passed is an integer
		print("Players : ", num_players))
	game_version_optionButton.connect("item_selected", func on_game_version_changed(index: int):
		game_version = "Full" if index == 0 else "Timed"
		print("Game Version : ", game_version))
	startButton.connect("pressed", startGameButton)
	
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
		line_edit.placeholder_text = "Player " + str(i + 1) + "'s Name"
		player_names_container.add_child(line_edit)
		player_name_inputs.append(line_edit)
	
	
	

	
