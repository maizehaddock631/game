class_name NewGameMenu
extends Control

#@onready var player_count_spinbox = $MarginContainer/VBoxContainer/HBoxContainer3/SpinBox as SpinBox
#@onready var game_version_optionButton = $MarginContainer/VBoxContainer/OptionButton as OptionButton
#@onready var autoplayer_checkBox = $MarginContainer/VBoxContainer/HBoxContainer/CheckBox
#@onready var startButton = $MarginContainer/VBoxContainer/startGame as Button
#@onready var player_names_container = $MarginContainer/VBoxContainer as VBoxContainer
@onready var game = preload("res://main.tscn").instantiate()
@onready var player_count_spinbox: SpinBox = $MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer3/SpinBox
@onready var game_version_optionButton: OptionButton = $MarginContainer/ScrollContainer/VBoxContainer/OptionButton
@onready var startButton: Button = $MarginContainer/ScrollContainer/VBoxContainer/startGame
@onready var player_names_container: VBoxContainer = $MarginContainer/ScrollContainer/VBoxContainer




var player_data = []
var num_players = 2
var game_version = 'Full'
var player_name_inputs =[]
var stored_player_names = []
var stored_tokens = []
var tokens = []


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
	for token_option in stored_tokens:
		token_option.queue_free()
	stored_tokens.clear()

	# Create a LineEdit for each player
	for i in range(num_players):
		var line_edit = LineEdit.new()
		var token_options = OptionButton.new()
		token_options.add_icon_item(preload("res://gameAssets/token assets/Boot - token.png"), "Token - Boot")
		token_options.add_icon_item(preload("res://gameAssets/token assets/Cat - token.png"), "Token - Cat")
		token_options.add_icon_item(preload("res://gameAssets/token assets/Hat - Token.png"), "Token - Hat")
		token_options.add_icon_item(preload("res://gameAssets/token assets/Iron - token.png"), "Token - Iron")
		token_options.add_icon_item(preload("res://gameAssets/token assets/Ship - token.png"), "Token - Ship")
		token_options.add_icon_item(preload("res://gameAssets/token assets/Phone - token.png"), "Token - Phone")
		line_edit.placeholder_text = "Player " + str(i + 1) + "'s Name"
		player_names_container.add_child(line_edit)
		player_names_container.add_child(token_options)
		player_name_inputs.append(line_edit)
		stored_tokens.append(token_options)
		stored_player_names.append("")
		tokens.append(preload("res://gameAssets/token assets/Boot.PNG"))
		print(stored_player_names[i])
		line_edit.connect("text_changed", self._on_line_edit_text_changed.bind(i))
		token_options.connect("item_selected", func(selected_index):
			_on_token_chosen(i, selected_index)
			)
		
func _on_start_game_pressed() -> void:
	print("Starting game with settings:")
	print("Players : ", num_players)
	print("Game Version : ", game_version)
	
	for i in range(num_players):
		var player_name = stored_player_names[i]
		var token = tokens[i]
		if player_name == "":
			player_name = "Player " + str(i + 1)
		var info = {"name": player_name, "token" : token}
		player_data.append(info)
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

func _on_token_chosen(player_index: int, selected_index: int) -> void:
	if player_index < 0 or player_index >= tokens.size():
		printerr("ERROR: Invalid player_index in _on_token_chosen:", player_index)
		return  # Exit if player_index is out of bounds

	var texture_path: String
	match selected_index:
		0:
			texture_path = "res://gameAssets/token assets/Boot - token.png"
		1:
			texture_path = "res://gameAssets/token assets/Cat - token.png"
		2:
			texture_path = "res://gameAssets/token assets/Hat - Token.png"
		3:
			texture_path = "res://gameAssets/token assets/Iron - token.png"
		4:
			texture_path = "res://gameAssets/token assets/Ship - token.png"
		5:
			texture_path = "res://gameAssets/token assets/Phone - token.png"
		_:
			printerr("ERROR: Invalid selected_index:", selected_index)
			return
	if ResourceLoader.exists(texture_path):
		tokens[player_index] = load(texture_path)
		print("DEBUG: Token for player", player_index + 1, "set to:", texture_path)
	else:
		printerr("ERROR: Texture path does not exist:", texture_path)
	
func _on_line_edit_text_changed(new_text, player_index):
	print("SIGNAL: Player", player_index + 1, "typed:", new_text)
	if player_index >= 0 and player_index < stored_player_names.size():
		stored_player_names[player_index] = new_text
		print("UPDATE: stored_player_names[" + str(player_index) + "] =", stored_player_names[player_index])
		print("FULL stored_player_names:", stored_player_names)
	else:
		printerr("ERROR: Invalid player_index in _on_line_edit_text_changed:", player_index)


func _on_check_box_toggled(toggled_on: bool) -> void:
	var player_name = "AI"
	var token = preload("res://icon.svg")
	if toggled_on:
		num_players += 1
		stored_player_names.append(player_name)
		tokens.append(token)
		
