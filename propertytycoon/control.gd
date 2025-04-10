extends Control

class_name game_manager

@onready var dice: Dice = $DiceStuff/Dice
@onready var dice_button: Button = $DiceStuff/DiceButton
@onready var dice_2: Dice = $DiceStuff/Dice2
@onready var reveal_dice: Button = $DiceStuff/RevealDice
@onready var current_turn: int = 0
@export var game_spaces : Array[Tile]
#@export var oppo_knocks_cards : Array[oppoKnocksCard]
@export var potluck_card_deck : Array[PackedScene]
var number_of_spaces : int 
@onready var build_mortgage: Control = $BuildMortgage


#@onready var player: Player = $Player
#@onready var player2: Player = $Player2
#PACKED scenes
@export var oppo_card_deck : Array[PackedScene]

@export var player_data = []
var all_players = []
var current_player = Player
@onready var jail_choice: ConfirmationDialog = $"Jail Choice"

@onready var property_card_scene: PackedScene = preload("res://property_card.tscn")
@onready var ok_card_scene: PackedScene = preload("res://opportunity_knocks.tscn")
@onready var ok_scene: PackedScene = preload("res://opportunity_knocks.tscn")
@onready var potluck_card_scene: PackedScene = preload("res://potluck.tscn")
@onready var pl_scene: PackedScene = preload("res://potluck.tscn")

@onready var card_spawn = $CanvasLayer/CardSpawn

@onready var bank_label: Label = $bank_label
@onready var player_money_lbl: Label = $player_money_lbl
@onready var player_turn_label: Label = $player_turn_label
#@onready var player_properties: Label = $PlayerProperties
@onready var bank = $Banker
@onready var property_lbl: Label = $property_lbl

var count : int = 0
@export var final_space : Marker2D
@export var final_property : Property


@onready var banker: Banker = $Banker
@onready var timer: Timer = $Timer
@onready var property_button: Button = $PropertyButton
@onready var turn_action: Button = $"Turn Action"
@onready var propertynames: String
@onready var AITurnDone: bool = false
@onready var AIRollDone: bool = false


signal turn_end
signal finished_moving

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	turn_action.hide()
	dice.hide();
	dice_2.hide();
	dice_button.hide();
	property_button.hide()
	var player_scene = preload("res://player.tscn")
	var ai_scene = preload("res://ai.tscn")
	for i in range(player_data.size()):
		var new_player
		if player_data[i].get("name") == "AI":
			new_player = ai_scene.instantiate()
		else:
			new_player = player_scene.instantiate()
		new_player.playerName = player_data[i].get("name")
		new_player.texture = player_data[i].get("token")
		if new_player.texture == preload("res://gameAssets/token assets/Boot.PNG"):
			new_player.scale.x = 0.025
			new_player.scale.y = 0.025
		else:
			new_player.scale.x = 0.5
			new_player.scale.y = 0.5
		new_player.position.x = 390
		new_player.position.y = 620
		add_child(new_player)
		all_players.append(new_player)
	
	bank_label.text = "Bank: " + str(bank.balance)
	
	number_of_spaces = game_spaces.size()
	
	#player_turn_label.text = "it's " + all_players[current_turn].playerName + "'s turn"
	
	print(oppo_card_deck)
	#randomizes the order of the array
	oppo_card_deck.shuffle()
	print(oppo_card_deck)
	potluck_card_deck.shuffle()
	print(oppo_card_deck)
	
	start_turn()
	print(number_of_spaces)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
#	This method calls the current players roll and move functions when pressed and shows the turn action button 
#	@param none
#	@return awaits the turn end signal to then call the end turn function
func _on_dice_button_pressed():
	var num = all_players[current_turn].roll(dice, dice_2, game_spaces)
	all_players[current_turn].move(num, game_spaces, timer)
	turn_action.show()
	#timer.start()
	#if (AIRollDone == true):
		#_on_turn_action_pressed()
	#player_turn(game_spaces[all_players[current_turn].current_position-1], current_player)
	await turn_end
	end_turn()

#	Shows the dice sprites and roll button when pressed
func _on_reveal_dice_pressed():
	reveal_dice.hide()
	dice.show()
	dice_2.show()
	dice_button.show()

#	Checks what type of tile the tile and calls the appropriate function
#	@Param Tile, what tile the player has landed on, place being an int of what tile the player is in, in the array
#   @Return calls update label function to update the GUI
func player_turn(Tile, place):
	player_money_lbl.text =  all_players[current_turn].name + "'s balance: " + str(all_players[current_turn].balance) 
	final_space = Tile
	print(final_space)
	print(Tile.WhichType)
	print(final_space.type)
	print("player turn runs")
	if all_players[current_turn].passedGo:
		bank.pay(200, all_players[current_turn])
	
	if final_space.type == 1:
		print ("you landed on a property")
		all_players[current_turn].show_message("you landed on a property")
		property_button.show()
		_landed_on_property(game_spaces[all_players[current_turn].current_position-1])

	if final_space.type == 2:
		print ("you landed on opportunity knocks")
		all_players[current_turn].show_message("you landed on opportunity knocks")
		_landed_on_oppo_knocks(all_players[current_turn])

	if final_space.type == 3:
		print("you landed on potluck")
		all_players[current_turn].show_message("you landed on potluck")
		_landed_on_potluck(all_players[current_turn])

	if final_space.type == 4:
		print("tax")
		all_players[current_turn].show_message("you landed on tax")
		_landed_on_tax(all_players[current_turn], final_space)

	if final_space.type == 5:
		print("visiting jail")
		all_players[current_turn].show_message("you are visting jail")
		

	if final_space.type == 6:
		print("free parking")
		all_players[current_turn].show_message("collect money from free parking")
		_landed_on_freeparking(all_players[current_turn])
		
	if final_space.type == 7:
		print("go to jail")
		all_players[current_turn].go_to_jail(game_spaces)
		jail_choice.popup_centered()
	
	update_label()
	
	var current_player = all_players[current_turn]
	if current_player.playerName == "AI":
		AITurnDone == true
	#if (game_spaces[place-1]) == game_spaces[1] and firstround !=true
		#add £200

# Keeps the player in jail
func _on_ok_pressed():
	all_players[current_turn].stay_in_jail()
	
# Pays £15 fine to bank and removes player from the jail
func _on_no_pressed():
	all_players[current_turn].pay_jail_fine(bank)

# Called when a player lands on a property, instantiates a property card, players pay rent if property owned
# @Param Property, the property tile the player has landed on
# @Return Calls the on property button pressed for the AI player (we would change this if we want to make it random!!!***)
func _landed_on_property(property: Property):
	final_property = property
	print("you landed on a property!")
	print(property)
	var property_card : propertyCard = property_card_scene.instantiate()
	print(property.propertycost)
	card_spawn.add_child(property_card)
	property_card.make_card(property.propertycost, property.tilename)
	property_card.visible = true
	if all_players[current_turn].playerName == "AI":
		var random_chance = all_players[current_turn].get_ai_property_build_chance()
		var flip = randf()
		if flip < random_chance:
			_on_property_button_pressed()
	all_players[current_turn].pay_rent(property)

# Button that when pressed calls the card bought function taking the final property parameter
func _on_property_button_pressed() -> void:
	card_bought(final_property)

# 	Player buys the property off the bank using the buy_property function, labels are updated
#	@Param Property, the property tile the player has landed on
#	@Returns calls the update label funtionm
func card_bought(property : Property):
	all_players[current_turn].buy_property(property, bank)
	update_label()
	
# Loads an instance of the opportunity knocks cards from the deck and instantiates it, spawning it into the game, it is then pushed onto the back on the deck array
# Checks the card number and does the appropriate action as labelled on the card
# @Param Player, the player that has landed on the tile
# @Return updates_label, updates the labels on the GUI
func _landed_on_oppo_knocks(Player):
	var player = Player
	var num : int
	
	#load oppoknocks instance from deck array
	var oppo_knocks_scene = oppo_card_deck.pop_front()
	var oppo_knocks = oppo_knocks_scene.instantiate()
	card_spawn.add_child(oppo_knocks)

	if oppo_knocks._return_card_num() == 1:
		num = 50
		banker.pay(num, player)
		print(str(player.balance))
		print(str(banker.balance))
	if oppo_knocks._return_card_num() == 2:
		num = 100
		banker.pay(num, player)
		print(str(player.balance))
	if oppo_knocks._return_card_num() == 3:
		player.move_position(game_spaces, 39)
	if oppo_knocks._return_card_num() == 4:
		player.move_position(game_spaces, 24)
	if oppo_knocks._return_card_num() == 5:
		num = 15
		player.balance -= num
		banker.freeParking += num
		print(str(player.balance))
	if oppo_knocks._return_card_num() == 6:
		num = 150
		player.balance -= num
		banker.balance += num
	if oppo_knocks._return_card_num() == 7:
		player.move_position(game_spaces, 15)
	if oppo_knocks._return_card_num() == 8:
		num = 150
		banker.pay(num, player)
	if oppo_knocks._return_card_num() == 9:
		print("assessed for repairs")
	if oppo_knocks._return_card_num() == 10:
		player.move_position(game_spaces, 0)
	if oppo_knocks._return_card_num() == 11:
		print("assessed for repairs")
	if oppo_knocks._return_card_num() == 12:
		player.move_back(3, game_spaces)
	if oppo_knocks._return_card_num() == 13:
		player.move_position(game_spaces, 11)
	if oppo_knocks._return_card_num() == 14:
		player.go_to_jail(game_spaces)
	if oppo_knocks._return_card_num() == 15:
		num = 15
		player.balance -= num
		banker.freeParking += num
	if oppo_knocks._return_card_num() == 16:
		print("get out of jail free card")
	
	oppo_card_deck.push_back(oppo_knocks_scene)
	print(oppo_card_deck)
	update_label()

# Loads an instance of the potluck cards from the deck and instantiates it, spawning it into the game, it is then pushed onto the back on the deck array
# Checks the card number and does the appropriate action as labelled on the card
# @Param Player, the player that has landed on the tile
# @Return updates_label, updates the labels on the GUI
func _landed_on_potluck(Player):
	var player = Player
	var num : int
	
	var potluck_scene = potluck_card_deck.pop_front()
	var potluck = potluck_scene.instantiate()
	card_spawn.add_child(potluck)
	
	if potluck._return_card_num() == 1:
		num = 200
		banker.pay(num, player)
	if potluck._return_card_num() == 2:
		num = 50
		banker.pay(num, player)
	if potluck._return_card_num() == 3:
		player.move_position(game_spaces, 1)
	if potluck._return_card_num() == 4:
		num = 20
		banker.pay(num, player)
	if potluck._return_card_num() == 5:
		num = 200
		banker.pay(num, player)
	if potluck._return_card_num() == 6:
		num = 100
		player.balance -= num
		banker.balance += num
	if potluck._return_card_num() == 7:
		num = 50
		player.balance -= num
		banker.balance += num
	if potluck._return_card_num() == 8:
		player.move_position(game_spaces, 0)
	if potluck._return_card_num() == 9:
		num = 50
		banker.pay(num, player)
	if potluck._return_card_num() == 10:
		num = 50
		player.balance -= num
		banker.balance += num
	if potluck._return_card_num() == 11:
		num = 10
		player.balance -= num
		banker.freeParking += num
	if potluck._return_card_num() == 12:
		num = 50
		player.balance -= num
		banker.freeParking += num
	if potluck._return_card_num() == 13:
		num = 100
		banker.pay(num, player)
	if potluck._return_card_num() == 14:
		player.go_to_jail()
	if potluck._return_card_num() == 15:
		num = 25
		banker.pay(num, player)
	if potluck._return_card_num() == 16:
		for players in all_players:
			var curr_player = all_players[players]
			curr_player.balance -= 10
			num =+ 10		
		player.balance += num
	
	potluck_card_deck.push_back(potluck_scene)
	print(potluck_card_deck)
	update_label()

# Gives the player the money at free parking and sets it to 0
# @Param Player, that has landed on free parking
# @Return updates_label, updates the labels on the GUI
func _landed_on_freeparking(Player):
	Player.balance += bank.freeParking
	bank.freeParking = 0 
	update_label()
	
# Checks the tile name for super or income tax and makes the player pay the specific amount to freeparking
# @Param Player, that has landed on the tax, what tile the player has landed on
func _landed_on_tax(Player, Tile):
	if Tile.tilename == "Super Tax":
		Player.balance -= 100
		bank.freeParking += 100
		Player.show_message(Player.playerName + " has to pay £100 in Super Tax!")
	if Tile.tilename == "Income Tax":
		Player.balance -= 200
		bank.freeParking += 200
		Player.show_message(Player.playerName + " has to pay £200 in Income Tax!")
		
	print(bank.freeParking)
	
# Updates the GUI for the current players turn, money and properties and the bank
func update_label():
	player_money_lbl.text = all_players[current_turn].playerName + "'s balance: " + str(all_players[current_turn].balance) 
	bank_label.text = "Bank: " + str(bank.balance)
	player_turn_label.text = "it's " + all_players[current_turn].playerName + "'s turn"
	property_lbl.text = all_players[current_turn].playerName + "'s properties: " +str(all_players[current_turn].properties)

# Sets the new current player based on the player array, checks to see if it is an AI player and carries out their turn, checks to see if player is in jail
# and makes the jail choice popup appear
func start_turn():
	var current_player = all_players[current_turn]
	var new = Timer.new()
	propertynames = ""
	print("It's ", current_player.playerName, "'s turn!")
	if current_player.injail == true:
		jail_choice.popup_centered()
	if current_player.playerName == "AI" and current_player.has_completed_loop:
		_on_dice_button_pressed()
		await get_tree().create_timer(15).timeout
		_on_turn_action_pressed()
		await get_tree().create_timer(15).timeout
		_on_end_turn_pressed()
	elif current_player.playerName == "AI":
		_on_dice_button_pressed()
		await get_tree().create_timer(5).timeout
		_on_end_turn_pressed()
	#update_property_label()
	reveal_dice.show()
	update_label()

# Hides property and turn action button 
# Moves the current turn to the next player in the array
# Sets the new current player
# Sets the AI bools to false // not using 
# Calls the update_label() and start_turn() functions
func end_turn():
	property_button.hide()
	turn_action.hide()
	current_turn = (current_turn + 1) % all_players.size() #the next turn will always loop back to the beginning when all the players have had a turn
	print("Turn ended. Next up: ", all_players[current_turn].playerName)
	current_player = all_players[current_turn]
	#AITurnDone = false
	#AIRollDone = false
	#current_player.moving_done = false
	update_label()
	start_turn()

# Emits the turn end signal
func _on_end_turn_pressed() -> void:
	turn_end.emit()

# Hides the dice GUI elements and calls the player turn function for the current player
func _on_turn_action_pressed() -> void:
	dice.hide();
	dice_2.hide();
	dice_button.hide();
	
	player_turn(game_spaces[all_players[current_turn].current_position-1], current_player)

func _on_property_houses_button_pressed() -> void:
	#load it
	var build_morgage_scene = preload("res://housingUI.tscn")
	#instance it
	var build_mortgage = build_morgage_scene.instantiate()
	#add it
	add_child(build_mortgage)
	#position it
	
