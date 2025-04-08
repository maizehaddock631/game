extends Tile
class_name pot_luck

var pl_des : String
var num : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _inherit_200(player: Player, Banker) :
	pl_des = "you inherit £200"
	num = 200 
	Banker.pay(num, player)
	#Player.balance = Player.balance + 200
	#Banker.balance = Banker.balance - 200
	print(str(player.balance))
	print(str(Banker.balance))

func _beauty_con_50(Player):
	pl_des = "You have won 2nd prize in a beauty contest, collect £50"
	Player.balance = Player.balance + 50
	print(str(Player.balance))
	
func _loan_refund_20(Player):
	pl_des= "Student loan refund. Collect £20"
	Player.balance = Player.balance + 20
	print(str(Player.balance))
	
func _bank_error_200(Player):
	pl_des= "Bank error in your favour. Collect £200"
	Player.balance = Player.balance + 200
	print(str(Player.balance))

func _book_bill_200(Player):
	pl_des= "Pay bill for text books of £100"
	Player.balance = Player.balance - 100
	print(str(Player.balance))

func _taxi_bill_50(Player):
	pl_des= "Mega late night taxi bill pay £50"
	Player.balance = Player.balance - 50
	print(str(Player.balance))

func _bitcoin_sale_50(Player):
	pl_des ="From sale of Bitcoin you get £50"
	Player.balance = Player.balance + 50
	print(str(Player.balance))

func _bitcoin_fall_50(Player):
	pl_des= "Bitcoin assets fall - pay off Bitcoin short fall"
	Player.balance = Player.balance - 50
	print(str(Player.balance))
	
func _insurance_fee_50(Player):
	pl_des ="Pay insurance fee of £50"
	Player.balance = Player.balance - 50
	print(str(Player.balance))

func _bond_mature_100(Player):
	pl_des = "Savings bond matures, collect £100"
	Player.balance = Player.balance + 100
	print(str(Player.balance))
	
func _share_interestr_25(Player):
	pl_des = "Received interest on shares of £25"
	Player.balance = Player.balance + 100
	print(str(Player.balance))
