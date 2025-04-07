extends Control

class_name game_manager

@onready var dice: Dice = $DiceStuff/Dice
@onready var dice_button: Button = $DiceStuff/DiceButton
@onready var dice_2: Dice = $DiceStuff/Dice2
@onready var reveal_dice: Button = $DiceStuff/RevealDice
@onready var current_turn: int = 0
@export var game_spaces : Array[Tile]
var number_of_spaces : int 


#@onready var player: Player = $Player
#@onready var player2: Player = $Player2
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
		# You might want to set other initial properties of the player here,
		# like their starting position, initial balance, etc.
		new_player.scale.x = 0.25
		new_player.scale.y = 0.25
		new_player.position.x = 390
		new_player.position.y = 620
		add_child(new_player)
		all_players.append(new_player)
	
	bank_label.text = "Bank: " + str(bank.balance)
	
	number_of_spaces = game_spaces.size()
	
	player_turn_label.text = "it's " + all_players[current_turn].playerName + "'s turn"

	
	start_turn()
	print(number_of_spaces)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
# Called when the roll button is pressed
func _on_dice_button_pressed():
	var num = all_players[current_turn].roll(dice, dice_2, game_spaces)
	all_players[current_turn].move(num, game_spaces, timer)
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
		property_button.show()
		_landed_on_property(game_spaces[all_players[current_turn].current_position-1])

	if final_space.type == 2:
		print ("you landed on opportunity knocks")
		_landed_on_oppo_knocks(all_players[current_turn])

	if final_space.type == 3:
		print("you landed on potluck")
		_landed_on_potluck(all_players[current_turn])

	if final_space.type == 4:
		print("tax")
		_landed_on_tax(all_players[current_turn], final_space)

	if final_space.type == 5:
		print("visiting jail")
		

	if final_space.type == 6:
		print("free parking")
		_landed_on_freeparking(all_players[current_turn])
		
	if final_space.type == 7:
		print("go to jail")
		all_players[current_turn].go_to_jail(game_spaces)
		jail_choice.popup_centered()

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
	all_players[current_turn].pay_rent(property)

func _on_property_button_pressed() -> void:
	card_bought(final_property)
	
func card_bought(property : Property):
	all_players[current_turn].buy_property(property, bank)
	update_label()
	#update_property_label()
	
func _landed_on_oppo_knocks(Player):
	var ok_card : oppoKnocksCard = ok_card_scene.instantiate()
	var new_ok : OpportunityKnocks = ok_scene.instantiate()
	new_ok._dividend_50(Player, bank)
	card_spawn.add_child(ok_card)
	ok_card._make_card(new_ok.ok_des)
	ok_card.visible = true
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
		Player.show_message(self.playerName + " has to pay £100 in Super Tax!")
	if Tile.tilename == "Income Tax":
		Player.balance -= 200
		bank.freeParking += 200
		Player.show_message(self.playerName + " has to pay £200 in Income Tax!")
		
	print(bank.freeParking)
	update_label()
	
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
	propertynames = ""
	print("It's ", current_player.playerName, "'s turn!")
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
	
