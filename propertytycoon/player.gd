extends Sprite2D

class_name Player

@export var balance : int = 1500 #inital funds for every player is £1500
@export var injail : bool
@export var isAI : bool
var token : Token
@onready var labelmessage: Label = $"../CanvasLayer2/Labelmessage"
@onready var jail_choice: ConfirmationDialog = $"../Jail Choice"
@onready var house_choice: ConfirmationDialog = $"../House Choice"
@export var playerName : String
@export var properties = []
var current_position: int = 0
var jail_turns: int
var has_completed_loop: bool 
var get_out_of_jail_free: int
var is_bankrupt: bool
var final_space 
var moving_done: bool = false
var num : int
var atEnd: bool = false
var passedGo: bool
#var propertynames : String

func _ready() -> void:
	has_completed_loop = false

##This method allows the player to pay money to either another player or the bank
##@Param amount, amount to pay
##@Param recipient, either a player or the bank
func pay(amount: int, recipient: Node) -> void:
	if recipient is Banker:
		print("Paid ", amount, " to the bank")
		self.balance -= amount
		recipient.balance += amount
		show_message(self.playerName + " paid " + str(amount) + " to the bank", 3.0)
	else:
		print("Paid ", amount, " to ", recipient.playerName)
		show_message(self.playerName + " paid " + str(amount) + " to " + recipient.playerName, 3.0)
		self.balance -= amount
		recipient.balance += amount
	
##This method allows the player to roll the dice, checks if it has rolled a double
## and moves the player to jail if it has rolled a triple
##@Param dice, the first dice
##@Param dice_2, the second dice
##@Param game_spaces, the array of tiles in the main game
##@Return int, the sum of the two die
func roll(dice: Dice, dice_2: Dice, game_spaces: Array):
	var isNotADouble : bool = false 
	var addedNum : int = 0

	while isNotADouble != true:
		var dice1 = dice.roll()
		var dice2 = dice_2.roll()
		var diceCount : int = 0
		
		if dice1 != dice2:
			addedNum = addedNum + dice1 + dice2
			print("You are moving " + str(addedNum) + " spaces!")
			show_message(self.playerName + " is moving " + str(addedNum) + " spaces!")
			isNotADouble = true
	
		elif dice1 == dice2:
			print("You rolled a double!!")
			show_message(self.playerName + " rolled a double!")
			addedNum = addedNum + dice1 + dice2
			print("You are moving " + str(addedNum) + " spaces!")
			diceCount+=1
			
			#if three doubles are rolled in a row the player goes to jail
			if diceCount==3:
				print('three doubles in a row , go to jail!')
				show_message(self.playerName + " rolled 3 doubles in a row! GO TO JAIL!")
				go_to_jail(game_spaces)
				return 0
	return addedNum

# Moves the player through the array based on the spaces parameter and creates a tween which animates the token moving
# @Param spaces is the number of spaces the player is moving, game_spaces is the array of tiles the player moves through
func move_position(game_spaces: Array, spaces_moved: int):
	var tween4 = create_tween()
	tween4.tween_property(self, "position", game_spaces[spaces_moved].position, 1)
	current_position = spaces_moved
		

# Moves the player through the array based on the spaces parameter and creates a tween which animates the token moving, whilst 
# the player isn't at the end of the array 
# If the player gets to the end of the array, it resets it's position to the start and carries on the dice roll through the array
# @Param spaces is the number of spaces the player is moving, 
#game_spaces is the array of tiles the player moves through, 
#and timer adds a timer to the tween animation making the player move slower
func move(spaces: int, game_spaces: Array, timer: Timer):
	#can test by changing int to a specific number
	#oppo knocks
	#var num = 8
	var num = spaces + 1
	var turn_done = false
	var count : int = 0
	var extra_roll : int 
	var atEnd : bool = false
	#here is just to test the tiles
	#num = 3
	print(str(num))
	while num != 0 and atEnd == false and game_spaces[current_position] != game_spaces[39]:
		var tween1 = create_tween()
		tween1.tween_property(self, "position", game_spaces[current_position].position, 1)
		timer.start()
		await timer.timeout
		current_position += 1
		num -= 1
		count += 1
		print(game_spaces[current_position-1])
		if (game_spaces[current_position] == game_spaces[39]):
			atEnd = true
			
	if (game_spaces[current_position] == game_spaces[39]):
		atEnd = true
	if game_spaces[current_position] == game_spaces[0] and self.has_completed_loop:
		passedGo = true
	
	if atEnd == true:
		self.has_completed_loop = true
		var tween2 = create_tween()
		tween2.tween_property(self, "position", game_spaces[0].position, 1)
		current_position = 0
		timer.start()
		await timer.timeout
		while num != 1:
			var tween3 = create_tween()
			tween3.tween_property(self, "position", game_spaces[current_position].position, 1)
			timer.start()
			await timer.timeout
			current_position += 1
			num -= 1
			print(num)
		atEnd == false
	
	final_space = current_position -1
	moving_done = true

# Moves the player through the array based on the spaces parameter and creates a tween which animates the token moving, whilst 
# the player isn't at the end of the array 
# @Param spaces is the number of spaces the player is moving, 
#game_spaces is the array of tiles the player moves through, 
#and timer adds a timer to the tween animation making the player move slower
func move_back(spaces: int, game_spaces: Array, timer: Timer):
	num = spaces
	while num != 0:
		var tween5 = create_tween()
		tween5.tween_property(self, "position", game_spaces[current_position].position, 1)
		timer.start()
		await timer.timeout
		current_position -= 1

func buy_property(property: Property, bank: Banker) -> void:
	if self.balance < property.propertycost:
		print("Sorry! You don't have enough funds to purchase ", property.tilename)
		show_message("Sorry! You don't have enough funds to purchase " + property.tilename)
	if not self.has_completed_loop:
		print("You have to have completed a loop first!")
		show_message("You have to have completed a loop first!")
	if property.propertyowner is Player:
		print("Sorry! Someone already owns ", property.tilename)
		show_message("Sorry! Someone already owns " + property.tilename)
	
	var colour_group = property.get_colour_group(property.colour)
	if owns_all_property_colours(colour_group):
		show_message(self.playerName + " owns all properties in this colour group. They can now start buying houses!")
		house_choice.popup()
		house_choice.get_ok_button().connect("pressed", Callable(self, "buy_house").bind(property, bank))
	elif self.balance >= property.propertycost and self.has_completed_loop and property.propertyowner is not Player:
		self.properties.append(property)
		property.propertyowner = self
		bank.properties.erase(property)
		self.balance -= property.propertycost
		bank.balance += property.propertycost
		print("You have bought ", property.tilename)
		show_message(self.playerName + " has bought " + property.tilename)
	print(properties)
##This function allows the player to sell their property (land only) to the 
##bank for half of it's original price
##@Param property, property the player is selling
##@Param bank, the bank the player is selling to 
func sell_property(property: Property, bank: Banker) -> void:
	if property not in self.properties:
		print("You don't even own ", property.tilename)
	else:
		var new_sell_price = property.propertycost / 2
		self.balance += new_sell_price
		bank.balance -= new_sell_price
		bank.properties.append(property)
		self.properties.erase(property)
		property.propertyowner = bank
		print("You have sold ", property.tilename)

func mortgage_property(property: Property, bank: Banker) -> void:
	pass
	
func unmortgage_property(property: Property, bank: Banker ) -> void:
	pass
##This function allows the player to use a get out of jail free card 
##if they're in jail and if they have a get out of jail free card
func use_getoutofjailfree() -> void:
	if self.injail == false:
		print("You're not even in jail!")
		show_message(self.playerName + ", you're not even in jail!")
	if self.get_out_of_jail_free == 0:
		print("Sorry! You don't have any get out of jail free cards.")
		show_message(self.playerName + ", you don't even have any get out of jail free cards.")
	else:
		self.get_out_of_jail_free -= 1
		self.injail = false
		print("You have used one of your get out of jail free cards. You're no longer in jail")
		show_message(self.playerName + " has used one of their get out of jail free cards. They're no longer in jail")

##This method allows the player to declare bankruptcy if they no longer have the money they need to play the game
##@Param bank, gives the rest of their balance to the bank
func declare_bankruptcy(bank: Banker) -> void:
	bank.balance += self.balance
	self.balance = 0
	self.is_bankrupt = true
	print("You have now been declared bankrupt and you're eliminated from the game")
	show_message(self.playerName + " has now been declared bankrupt and is eliminated from the game")

##This method makes to player go to jail. It's called when they land on the go to jail tile
##@Param game_spaces, the array of tiles of the main game
func go_to_jail(game_spaces: Array):
	#updating the player's position to the jail position
	current_position = 10
	position = game_spaces[10].position
	self.injail= true
	jail_turns=3
	print(self.playerName,'has been sent to jail')
	show_message(self.playerName + " has been sent to jail!", 3.0)
	var tween = create_tween()
	tween.tween_property(self, "position", position, 1)

##This method allows the player to pay a fine if they want to be bailed out of jail
##@Param bank, the fine to be paid to
func pay_jail_fine(bank:Banker):
	pay(50, bank)
	self.injail = false
	self.jail_turns = 0
	print(self.playerName, " is no longer in jail")
	show_message(self.playerName + " is no longer in jail")

##This method allows the player to stay in jail if they decide to stay in jail. Each time they decide to stay in jail, 
##their turns to stay in jail decrease by one
func stay_in_jail():
	if self.jail_turns > 0:
		self.jail_turns -= 1
		print("You've decided to stay in jail")
		show_message(self.playerName + " has decided to stay in jail", 3.0)
	elif self.jail_turns == 0:
		print("You no longer have to stay in jail. You're free!")
		show_message(self.playerName + " no longer has to stay in jail. They're free!")
		self.injail = false
##This function allows the player to buy a house on the property they already own only 
##if they own all properties in the same colour group. It will spawn a house icon on that exact
##property tile
##@Param property, property the player is buying
##@Param bank, buying the house from the bank
func buy_house(property: Property, bank:Banker) :
	var house_cost : int
	if property.colour in [property.WhichColour.BROWN, property.WhichColour.BLUE]:
		house_cost = 50
	elif property.colour in [property.WhichColour.PURPLE, property.WhichColour.ORANGE]:
		house_cost = 100
	elif property.colour in [property.WhichColour.RED, property.WhichColour.YELLOW]:
		house_cost = 150
	elif property.colour in [property.WhichColour.GREEN, property.WhichColour.DEEPBLUE]:
		house_cost = 200
	if self.balance < house_cost:
		print("Not enough funds to buy a house!")
		show_message(self.playerName + " doesn't have enough money to buy a house!")
	else:
		var house_token = Sprite2D.new()
		house_token.texture = preload("res://gameAssets/house token.webp")
		house_token.scale.x = 0.1
		house_token.scale.y = 0.1
		property.add_child(house_token)
		house_token.name = "House"
		property.numofhouses += 1
		self.pay(house_cost, bank)
		print("House added to", property.propertyname, ". Total houses:", property.numofhouses)
		show_message("House added to " +  property.propertyname + ". Total houses: " + str(property.numofhouses) + "Paid: " + str(house_cost))
##This function is created to check to see if the player owns all of the properties in the colour group. 
##It is used in the buy_property method to see if they're eligible to buy a house
func owns_all_property_colours(colours:Array) -> bool:
	for property in colours:
		if property not in self.properties:
			return false
	return true

##This function allows the player to pay rent. It is used in the GameManager when the player lands on a property
##@Param property, property the player has to pay rent to
func pay_rent(property: Property) -> void:
	var propertyOwner = property.propertyowner
	var rent = property.get_rent()
	if propertyOwner != self and propertyOwner is Player:
		if rent> self.balance:
			is_bankrupt= true
			show_message(self.playerName + " has gone bankrupt!")
		else:
			self.pay(rent, propertyOwner)
	
##This function allows display of all actions of the player in the main game.
##@Param message_label, the label node in the main game that will be display the strings
##@Param duration, the duration of which the label will be showns
func show_message(message_label: String, duration: float = 3.0):
	labelmessage.set_text(message_label)
	labelmessage.show()
	await get_tree().create_timer(duration).timeout
	labelmessage.hide()
	
