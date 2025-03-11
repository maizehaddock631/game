extends Sprite2D

class_name Player

@export var balance : int = 1500 #inital funds for every player is £1500
@export var injail : bool
@export var isAI : bool
var token : Token
@export var playerName : String
@export var properties = [Property]
var current_position: int = 0
var jail_turns: int
var has_completed_loop: bool
var get_out_of_jail_free: int
var is_bankrupt: bool

func get_properties():
	for property in properties:
		return property.propertyname
	
func pay(amount: int, recipient: Node) -> void:
	if recipient is Banker:
		print("Paid ", amount, " to the bank")
		self.balance -= amount
		recipient.balance += amount
	else:
		print("Paid ", amount, " to ", recipient.playerName)
		self.balance -= amount
		recipient.balance += amount
	
func roll(dice: Dice, dice_2: Dice):
	var isNotADouble : bool = false 
	var addedNum : int = 0

	while isNotADouble != true:
		var dice1 = dice.roll()
		var dice2 = dice_2.roll()
		var diceCount : int = 0
		
		if dice1 != dice2:
			addedNum = addedNum + dice1 + dice2
			print("You are moving " + str(addedNum) + " spaces!")
			isNotADouble = true
	
		elif dice1 == dice2:
			print("You rolled a double!!")
			addedNum = addedNum + dice1 + dice2
			print("You are moving " + str(addedNum) + " spaces!")
			diceCount+=1
	return addedNum
	##implement escape attempt here

func move(spaces: int, game_spaces: Array, timer: Timer):
	#can test by changing int to a specific number
	var num = spaces + 1
	var final_space 
	var turn_done = false
	var count : int = 0
	
	while num != 0 and game_spaces[current_position] != game_spaces[39]:
		var tween = create_tween()
		tween.tween_property(self, "position", game_spaces[current_position].position, 1)
		timer.start()
		await timer.timeout
		current_position += 1
		num -= 1
		count += 1
		#print(game_spaces[current_position-1])
	
	if game_spaces[current_position] == game_spaces[39]:
		var tween = create_tween()
		tween.tween_property(self, "position", game_spaces[0].position, 1)
		timer.start()
		await timer.timeout
		current_position -= count 
		count = 0
		self.has_completed_loop = true
		current_position = 0
	
	turn_done = true
	
	#if turn_done == true:
	final_space = current_position -1
	#print("this runs")
	#print(current_position-1)
	#print(game_spaces[current_position-1])
	
	

func buy_property(property: Property, bank: Banker) -> void:
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

func sell_property(property: Property, bank: Banker) -> void:
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

func mortgage_property(property: Property, bank: Banker) -> void:
	##give option whether to proceed
	self.properties.erase(property)
	bank.properties.append(property)
	var value = property.propertycost / 2
	bank.pay(value, self)
	property.propertyowner = bank
	print(self.playerName, " has mortgaged ", property.propertyname)
	
	
func unmortgage_property(property: Property, bank: Banker ) -> void:
	var value = (property.propertycost / 2) * 1.1
	##give option whether to proceed
	self.pay(value, bank)
	self.properties.append(property)
	bank.properties.erase(property)
	property.propertyowner = self
	print(self.playerName, " has unmortgaged ", property.propertyname)

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
	print(self.playerName, " is no longer in jail")

func stay_in_jail():
	if self.jail_turns > 0:
		self.jail_turns -= 1
		print("You've decided to stay in jail")
	elif self.jail_turns == 0:
		print("You no longer have to stay in jail. You're free!")
		self.injail = false

func buy_house(property: Property, bank: Banker):
	pass

func sell_house(property: Property, bank: Banker):
	pass

func buy_hotel(property: Property, bank:Banker):
	pass

func sell_hotel(property: Property, bank: Banker):
	pass

func trade_assets(player: Player):
	var properties = self.properties
	self.properties = player.properties
	player.properties = properties
	print(self.playerName, " has successfully traded with ", player.playerName)
	print(self.playerName, " now owns ", player.get_properties())

func place_bid():
	pass
