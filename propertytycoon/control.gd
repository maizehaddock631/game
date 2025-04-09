extends Control

class_name game_manager

@onready var dice: Dice = $DiceStuff/Dice
@onready var dice_button: Button = $DiceStuff/DiceButton
@onready var dice_2: Dice = $DiceStuff/Dice2
@onready var reveal_dice: Button = $DiceStuff/RevealDice
@onready var current_turn: int = 0
@export var game_spaces : Array[Tile]
#@export var oppo_knocks_cards : Array[oppoKnocksCard]
@export var potluck_cards : Array[potluckCard]
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


signal turn_end
signal finished_moving

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	turn_action.hide()
	dice.hide();
	dice_2.hide();
	dice_button.hide();
	property_button.hide()
	
	for i in range(player_data.size()):
		var new_player = preload("res://player.tscn").instantiate() # Assuming your Player scene is "player.tscn"
		new_player.playerName = player_data[i].get("name")
		new_player.texture = player_data[i].get("token")
		# You might want to set other initial properties of the player here,
		# like their starting position, initial balance, etc.
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
	
	start_turn()
	print(number_of_spaces)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
# Called when the roll button is pressed
func _on_dice_button_pressed():
	var num = all_players[current_turn].roll(dice, dice_2, game_spaces)
	all_players[current_turn].move(6, game_spaces, timer)
	turn_action.show()
	timer.start()
	#player_turn(game_spaces[all_players[current_turn].current_position-1], current_player)
	await turn_end
	end_turn()

# Shows the dice sprites and roll button when pressed
func _on_reveal_dice_pressed():
	reveal_dice.hide()
	dice.show()
	dice_2.show()
	dice_button.show()

# checks what type of tile the tile and calls the appropriate func
func player_turn(Tile, place):
	player_money_lbl.text =  all_players[current_turn].name + "'s balance: " + str(all_players[current_turn].balance) 
	final_space = Tile
	print(final_space)
	print(Tile.WhichType)
	print(final_space.type)
	print("player turn runs")
	
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

	#if (game_spaces[place-1]) == game_spaces[1] and firstround !=true
		#add £200
func _on_ok_pressed():
	all_players[current_turn].stay_in_jail()
func _on_no_pressed():
	all_players[current_turn].pay_jail_fine(bank)

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
		_on_property_button_pressed()
	all_players[current_turn].pay_rent(property)

func _on_property_button_pressed() -> void:
	card_bought(final_property)
	
func card_bought(property : Property):
	all_players[current_turn].buy_property(property, bank)
	update_label()
	#update_property_label()
	
func _landed_on_oppo_knocks(Player):
	var player = Player
	var num : int
	
	#load oppoknocks instance
	var oppo_knocks_scene = oppo_card_deck.pop_front()
	var oppo_knocks = oppo_knocks_scene.instantiate()
	card_spawn.add_child(oppo_knocks)
	#pop card off oppo_card_deck
	#set to new var
	#makes card visible
	#oppo_knocks.visible()
	#loops through to check number and do that thing to it
	#if card.whichcard == 1 then func _dividend_50(player : Player, Banker) :
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
		print("player moves to turing heights")
	if oppo_knocks._return_card_num() == 4:
		print("player moves to Han Xin garderns")
	if oppo_knocks._return_card_num() == 5:
		num = 15
		player.balance -= num
		banker.freeParking =+ num
		print(str(player.balance))
	if oppo_knocks._return_card_num() == 6:
		num = 150
		player.balance -= num
		banker.balance += num
	if oppo_knocks._return_card_num() == 7:
		print("take a trip to hove station")
	if oppo_knocks._return_card_num() == 8:
		num = 150
		banker.pay(num, player)
	if oppo_knocks._return_card_num() == 9:
		print("assessed for repairs")
	if oppo_knocks._return_card_num() == 10:
		print("advance to go")
	if oppo_knocks._return_card_num() == 11:
		print("assessed for repairs")
	if oppo_knocks._return_card_num() == 12:
		print("go back three spaces")
	if oppo_knocks._return_card_num() == 13:
		print("advance to skywalker drive")
	if oppo_knocks._return_card_num() == 14:
		print("go to jail")
	if oppo_knocks._return_card_num() == 15:
		num = 15
		player.balance -= num
		banker.freeParking += num
	if oppo_knocks._return_card_num() == 16:
		print("get out of jail free card")

	
	#var ok_card : oppoKnocksCard = ok_card_scene.instantiate()
	#var new_ok : OpportunityKnocks = ok_scene.instantiate()
	#new_ok._dividend_50(Player, bank)
	#card_spawn.add_child(ok_card)
	#ok_card._make_card(new_ok.ok_des)
	#ok_card.visible = true
	
	oppo_card_deck.push_back(oppo_knocks_scene)
	print(oppo_card_deck)
	update_label()
	
func _landed_on_potluck(Player):
	var pl_card : potluckCard = potluck_card_scene.instantiate()
	var new_pl : pot_luck = pl_scene.instantiate()
	new_pl._inherit_200(Player, bank)
	card_spawn.add_child(pl_card)
	pl_card._make_card(new_pl.pl_des)
	pl_card.visible = true
	update_label()
	
func _landed_on_freeparking(Player):
	Player.balance += bank.freeParking
	bank.freeParking = 0 
	update_label()
	
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
	
func update_label():
	player_money_lbl.text = all_players[current_turn].playerName + "'s balance: " + str(all_players[current_turn].balance) 
	bank_label.text = "Bank: " + str(bank.balance)
	player_turn_label.text = "it's " + all_players[current_turn].playerName + "'s turn"
	property_lbl.text = all_players[current_turn].playerName + "'s properties: " +str(all_players[current_turn].properties)


#func update_property_label():
	##all_players[current_turn].update_property()	
	#property_lbl.text = all_players[current_turn].name + "properties: " + str(all_players[current_turn].properties)
	
func start_turn():
	var current_player = all_players[current_turn]
	var new = Timer.new()
	propertynames = ""
	print("It's ", current_player.playerName, "'s turn!")
	if current_player.playerName == "AI":
		_on_dice_button_pressed()
		new.start(10)
		_on_turn_action_pressed()
		new.start(5)
		_on_end_turn_pressed()
	#update_property_label()
	if current_player.injail == true:
		jail_choice.popup_centered()
	reveal_dice.show()
	update_label()
	
	
func end_turn():
	property_button.hide()
	turn_action.hide()
	current_turn = (current_turn + 1) % all_players.size() #the next turn will always loop back to the beginning when all the players have had a turn
	print("Turn ended. Next up: ", all_players[current_turn].playerName)
	current_player = all_players[current_turn]
	update_label()
	start_turn()

func _on_end_turn_pressed() -> void:
	turn_end.emit()

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
	
