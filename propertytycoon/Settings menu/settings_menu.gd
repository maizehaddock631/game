class_name SettingsMenu
extends Control


@onready var exit_button = $MarginContainer/VBoxContainer/Exit_button as Button

signal exit_settings_menu


# Called when the node enters the scene tree for the first time.
func _ready():
	exit_button.button_down.connect(on_exit_pressed)
	set_process(false)
	

func on_exit_pressed() -> void:
	exit_settings_menu.emit()
	set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
