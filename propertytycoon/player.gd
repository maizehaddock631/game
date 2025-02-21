extends Sprite2D

class_name Player

var balance : int = 1500
var Playername: String
var injail : bool
var isAI : bool
var token : Token
var properties = []
var current_position : Marker2D
var jail_turns: int
var has_completed_loop: bool
var get_out_of_jail_free: int
var is_bankrupt: bool

func pay(amount: int, who: Player) -> void:
	who.balance += amount
	self.balance -= amount
	
func roll() -> int:
	var number1 = $dice1.roll()
	var number2 = $dice2.roll()
	return number1 + number2

func buy_property(property: PropertyTile, bank: Banker) -> void:
	if self.balance < property.propertycost:
		print("Sorry! You don't have enough funds!")
	if not self.has_completed_loop:
		print("You have to have completed a loop first!")
	if property.propertyowner is Player:
		print("Sorry! Someone already owns this property")
	
	if self.balance >= property.propertycost and self.has_completed_loop and property.propertyowner is not Player:
		self.properties.append(property)
		property.propertyowner = self
		bank.properties.erase(property)
		self.balance -= property.propertycost
		bank.balance += property.propertycost
		print("You have bought", property.propertyname)

func sell_property(property: PropertyTile, bank: Banker) -> void:
	if property not in self.properties:
		print("You don't even own this property!")
	else:
		var new_sell_price = property.propertycost / 2
		self.balance += new_sell_price
		bank.balance -= new_sell_price
		bank.properties.append(property)
		self.properties.erase(property)
		property.propertyowner = bank
		print("You have sold", property.propertyname)
