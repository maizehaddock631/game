extends Tile 
class_name OpportunityKnocks

@export var ok_des : String
@export var num : int
@export var which_card = OpportunityKnocks.WhichCard.NONE

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
	SIXTEEN
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _return_card_num():
	return which_card

# Dividend 50
func _dividend_50(player : Player, Banker) :
	ok_des = "Bank pays you divided of £50"
	num = 50
	Banker.pay(num, player)
	print(str(player.balance))
	print(str(Banker.balance))

# 15 speeding fine
func _fine_15(Player):
	ok_des = "Fined £15 for speeding"
	Player.balance = Player.balance - 15
	print(str(Player.balance))
	
# 150 university fees
func _fees_150(Player):
	ok_des = "Pay university fees of £150"
	Player.balance = Player.balance - 150
	print(str(Player.balance))
	
# 150 loan matures 
func _loan_matures_150(Player):
	ok_des = "Loan matures, collect £150"
	Player.balance = Player.balance + 150
	print(str(Player.balance))

# 30 drunk fine 
func _fine_30(Player):
	ok_des = "Drunk in charge of a hoverboard. Fine £30"
	Player.balance = Player.balance - 30
	print(str(Player.balance))
	
