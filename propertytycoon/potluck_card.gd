class_name potluckCard extends pot_luck

@onready var potluck: potluckCard = $"."
@export var pl_description : String = "Description"

@onready var des_lbl: Label = $potluck_display/des_lbl
@onready var close_button: Button = $close_button


func _ready():
	visible = false

func _make_card(_des :String):
	pl_description = _des
	des_lbl.set_text(_des)


func _on_close_button_pressed() -> void:
		visible = false
