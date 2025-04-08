extends Control
@onready var panel_container: PanelContainer = $PanelContainer
@onready var panel: Panel = $PanelContainer/Panel



func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("ui_click"):
		panel_container.hide()
		
