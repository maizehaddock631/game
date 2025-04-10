extends OpportunityKnocks
class_name oppoKnocksCard


@export var ok_description: String = "description" #card description
@onready var des_lbl: Label = $oppo_knocks_display/des_lbl #card label
@onready var close_btn: Button = $oppo_knocks_display/close_btn #card close button

# Checks the card based on the number from which type, puts the description in the make card function
func _ready():
	visible = true
	if _return_card_num() == 1:
		_make_card("Bank pays you divided of £50")
	if _return_card_num() == 2:
		_make_card("You have won a lip sync battle. Collect £100")
	if _return_card_num() == 3:
		_make_card("Advance to Turing Heights")
	if _return_card_num() == 4:
		_make_card("Advance to Han Xin Gardens. If you pass GO, collect £200")
	if _return_card_num() == 5:
		_make_card("Fined £15 for speeding")
	if _return_card_num() == 6:
		_make_card("Pay university fees of £150")
	if _return_card_num() == 7:
		_make_card("Take a trip to Hove station. If you pass GO collect £200")
	if _return_card_num() == 8:
		_make_card("Loan matures, collect £150")
	if _return_card_num() == 9:
		_make_card("You are assessed for repairs, £40/house, £115/hotel")
	if _return_card_num() == 10:
		_make_card("Advance to GO")
	if _return_card_num() == 11:
		_make_card("You are assessed for repairs, £25/house, £100/hotel" )
	if _return_card_num() == 12:
		_make_card("Go back 3 spaces" )
	if _return_card_num() == 13:
		_make_card("Advance to Skywalker Drive. If you pass GO collect £200")
	if _return_card_num() == 14:
		_make_card("Go to jail. Do not pass GO, do not collect £200" )
	if _return_card_num() == 15:
		_make_card("Drunk in charge of a hoverboard. Fine £30")
	if _return_card_num() == 16:
		_make_card("Get out of jail free")

# Sets the descrption of the card to the parsed string parameter
# @Param string description of the card
func _make_card(_des :String):
	ok_description = _des
	des_lbl.set_text(_des)

# Makes the card not visible
func _on_close_btn_pressed() -> void:
	visible = false
