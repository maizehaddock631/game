extends Tile
class_name pot_luck

@export var which_card = OpportunityKnocks.WhichCard.NONE #card number identifier

enum WhichCard {
	NONE,
	ONE,
	TWO,
	THREE,
	FOUR,
	FIVE, 
	SIX,
	SEVEN,
	EIGHT,
	NINE,
	TEN,
	ELEVEN,
	TWELVE,
	THIRTEEN,
	FOURTEEN,
	FIFTEEN,
	SIXTEEN,
	SEVENTEEN
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
# Returns the which_card ENUM var
func _return_card_num():
	return which_card
