extends pot_luck
class_name potluckCard 


@export var pl_description : String = "Description" #card description
@onready var des_lbl: Label = $potluck_display/des_lbl #card label
@onready var close_button: Button = $close_button #card close button


# Checks the card based on the number from which type, puts the description in the make card function
func _ready():
	visible = true
	if _return_card_num() == 1:
		_make_card("You inherit £200")
	if _return_card_num() == 2:
		_make_card("You have won 2nd prize in a beauty contest, collect £50")
	if _return_card_num() == 3:
		_make_card("You are up the creek with no paddle - go back to the Old Creek")
	if _return_card_num() == 4:
		_make_card("Student loan refund. Collect £20")
	if _return_card_num() == 5:
		_make_card("Bank error in your favour. Collect £200")
	if _return_card_num() == 6:
		_make_card("Pay bill for text books of £100")
	if _return_card_num() == 7:
		_make_card("Mega late night taxi bill pay £50")
	if _return_card_num() == 8:
		_make_card("Advance to go" )
	if _return_card_num() == 9:
		_make_card("From sale of Bitcoin you get £50" )
	if _return_card_num() == 10:
		_make_card("Bitcoin assets fall - pay off Bitcoin short fall")
	if _return_card_num() == 11:
		_make_card("Pay a £10 fine or take opportunity knocks")
	if _return_card_num() == 12:
		_make_card("Pay insurance fee of £50")
	if _return_card_num() == 13:
		_make_card("Savings bond matures, collect £100")
	if _return_card_num() == 14:
		_make_card("Go to jail. Do not pass GO, do not collect £200")
	if _return_card_num() == 15:
		_make_card("Received interest on shares of £25")
	if _return_card_num() == 16:
		_make_card("It's your birthday. Collect £10 from each player")
	if _return_card_num() == 16:
		_make_card("Get out of jail free")

# Sets the descrption of the card to the parsed string parameter
# @Param string description of the card
func _make_card(_des :String):
	pl_description = _des
	des_lbl.set_text(_des)

# Makes the card not visible
func _on_close_button_pressed() -> void:
		visible = false
