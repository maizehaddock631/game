extends Control
@onready var new_game_menu: NewGameMenu = $NewGame_menu
@onready var h_box_container_2: HBoxContainer = $MarginContainer/VBoxContainer/HBoxContainer2
var player_names = []

func _ready() -> void:
	for i in range(new_game_menu.num_players):
		var line_edit = LineEdit.new()
		line_edit.placeholder_text = "Player " + str(i + 1) + "'s Name"
		h_box_container_2.add_child(line_edit)
		player_names.append(line_edit)
		
