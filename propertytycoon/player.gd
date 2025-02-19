extends Sprite2D

class_name Player

var balance : int = 1500
var injail : bool
var isAI : bool
var token : Token
var properties = []
var current_position : Vector2
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
	if self.balance >= property.propertycost and self.has_completed_loop and property.propertyowner is not Player:
		self.properties.append(property)
		property.propertyowner = self
		bank.properties.erase(property)
		self.balance -= property.propertycost
		bank.balance += property.propertycost
	elif self.balance < property.propertycost:
		print("Sorry! You're broke!!")
	elif not self.has_completed_loop:
		print("You have to have completed a loop first!")
	elif property.propertyowner is Player:
		print("Sorry! Someone already owns this property")
		

func in_jail() -> bool:
	if current_position == Vector2(-12, 30):
		injail = true
	return injail
