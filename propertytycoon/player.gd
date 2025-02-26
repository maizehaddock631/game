extends Sprite2D

class_name Player

var balance : int = 1500 #inital funds for every player is £1500
var injail : bool
var isAI : bool
var token : Token
var Name : String
var properties = []
var current_position : Marker2D
var jail_turns: int
var has_completed_loop: bool
var get_out_of_jail_free: int
var is_bankrupt: bool

func _init(playerName: String) -> void:
	self.Name = playerName

func pay(amount: int, recipient: Node) -> void:
	if recipient is Banker:
		print("Paid ", amount, " to the bank")
		self.balance -= amount
		recipient.balance += amount
	else:
		print("Paid ", amount, " to ", recipient.Name)
		self.balance -= amount
		recipient.balance += amount
	
func roll() -> int:
	var number1 = $dice1.roll()
	var number2 = $dice2.roll()
	return number1 + number2

func buy_property(property: PropertyTile, bank: Banker) -> void:
	if self.balance < property.propertycost:
		print("Sorry! You don't have enough funds to purchase ", property.propertyname)
	if not self.has_completed_loop:
		print("You have to have completed a loop first!")
	if property.propertyowner is Player:
		print("Sorry! Someone already owns ", property.propertyname)
	
	if self.balance >= property.propertycost and self.has_completed_loop and property.propertyowner is not Player:
		self.properties.append(property)
		property.propertyowner = self
		bank.properties.erase(property)
		self.balance -= property.propertycost
		bank.balance += property.propertycost
		print("You have bought ", property.propertyname)

func sell_property(property: PropertyTile, bank: Banker) -> void:
	if property not in self.properties:
		print("You don't even own ", property.propertyname)
	else:
		var new_sell_price = property.propertycost / 2
		self.balance += new_sell_price
		bank.balance -= new_sell_price
		bank.properties.append(property)
		self.properties.erase(property)
		property.propertyowner = bank
		print("You have sold ", property.propertyname)

func mortgage_property(property: PropertyTile, bank: Banker) -> void:
	pass
	
func unmortgage_property(property: PropertyTile, bank: Banker ) -> void:
	pass

func use_getoutofjailfree() -> void:
	if self.injail == false:
		print("You're not even in jail!")
	if self.get_out_of_jail_free == 0:
		print("Sorry! You don't have any get out of jail free cards.")
	else:
		self.get_out_of_jail_free -= 1
		self.injail = false
		print("You have used one of your get out of jail free cards. You're no longer in jail")

func declare_bankruptcy(bank: Banker) -> void:
	bank.balance += self.balance
	self.balance = 0
	self.is_bankrupt = true
	print("You have now been declared bankrupt and you're eliminated from the game")
	
func go_to_jail():
	pass
	
func pay_jail_fine(bank:Banker):
	pay(50, bank)
	self.injail = false
	self.jail_turns = 0
	print(self.Name, " is no longer in jail")

func stay_in_jail():
	if self.jail_turns > 0:
		self.jail_turns -= 1
		print("You've decided to stay in jail")
	elif self.jail_turns == 0:
		print("You no longer have to stay in jail. You're free!")
		self.injail = false
	
	
	
