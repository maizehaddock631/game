class_name oppoKnocksCard extends OpportunityKnocks

@onready var oppo_knocks_card: oppoKnocksCard= $"."
@export var ok_description: String = "description"

@onready var des_lbl: Label = $oppo_knocks_display/des_lbl
@onready var close_btn: Button = $oppo_knocks_display/close_btn


func _ready():
	visible = false

func _make_card(_des :String):
	ok_description = _des
	des_lbl.set_text(_des)
	
	
func _on_close_btn_pressed() -> void:
	visible = false
