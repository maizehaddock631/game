class_name MyMainMenu 
extends Control

@onready var start_Button = $MarginContainer/HBoxContainer/VBoxContainer/Start_Button as Button
@onready var new_game_menu = $NewGame_menu as NewGameMenu
@onready var exit_Button = $MarginContainer/HBoxContainer/VBoxContainer/Exit_Game as Button
@onready var settings_Button = $MarginContainer/HBoxContainer/VBoxContainer/Settings as Button
@onready var settings_menu = $Settings_Menu as SettingsMenu
@onready var margin_container = $MarginContainer as MarginContainer
@onready var margin_container2 = $MarginContainer as MarginContainer


#add game file to brackets in preload and then remove comment mark from function on_start_pressed
#@onready var start_level = preload("res://main_menu.tscn") as PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)
	handle_connecting_signals()

func on_start_pressed() -> void:
	print("LOAD NEW GAME MENU")
	margin_container2.visible = false
	new_game_menu.set_process(true)
	new_game_menu.visible = true

func on_settings_pressed() -> void:
	print("LOAD SETTINGS MENU")
	margin_container.visible = false
	settings_menu.set_process(true)
	settings_menu.visible = true

func on_exit_pressed() -> void:
	print("Exit button pressed")
	get_tree().quit()
	
func on_exit_settings_menu() -> void:
	margin_container.visible = true
	settings_menu.visible = false
	
	
func handle_connecting_signals() -> void:
	start_Button.button_down.connect(on_start_pressed)
	settings_Button.button_down.connect(on_settings_pressed)
	exit_Button.button_down.connect(on_exit_pressed)
	settings_menu.exit_settings_menu.connect(on_exit_settings_menu)
	
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta: float) -> void:
	#pass
