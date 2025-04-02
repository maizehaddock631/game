extends Control

class_name game_manager

@onready var dice: Dice = $DiceStuff/Dice
@onready var dice_button: Button = $DiceStuff/DiceButton
@onready var dice_2: Dice = $DiceStuff/Dice2
@onready var current_turn: int = 0
@export var game_spaces : Array[Tile]
var number_of_spaces : int 

@onready var player: Player = $Player
@onready var player2: Player = $Player2
var all_players = []
var current_player = Player
@onready var jail_choice: ConfirmationDialog = $"Jail choice"

@onready var property_card_scene: PackedScene = preload("res://property_card.tscn")
@onready var ok_card_scene: PackedScene = preload("res://opportunity_knocks.tscn")
@onready var ok_scene: PackedScene = preload("res://opportunity_knocks.tscn")
@onready var potluck_card_scene: PackedScene = preload("res://potluck.tscn")
@onready var pl_scene: PackedScene = preload("res://potluck.tscn")

@onready var card_spawn = $CanvasLayer/CardSpawn

@onready var bank_label: Label = $bank_label
@onready var player_money_lbl: Label = $player_money_lbl
@onready var player_turn_label: Label = $player_turn_label
@onready var player_properties: Label = $PlayerProperties
@onready var bank = $Banker
@onready var property_lbl: Label = $ScrollContainer/VBoxContainer/TextureRect/property_lbl

var count : int = 0
@export var final_space : Marker2D
@export var final_property : Property

@onready var banker: Banker = $Banker
@onready var timer: Timer = $Timer
@onready var property_button: Button = $PropertyButton
@onready var turn_action: Button = $"Turn Action"


signal turn_end
signal finished_moving

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	dice.hide();
	dice_2.hide();
	dice_button.hide();
	property_button.hide()
	
	player_money_lbl.text = "Player 1 " + str(player.balance) + "\nPlayer 2 " + str(player2.balance)
	bank_label.text = "Bank: " + str(bank.balance)
	
	number_of_spaces = game_spaces.size()
	all_players = [player, player2]
	
	player_turn_label.text = "it's " + all_players[current_turn].name + " turn"
	
	property_lbl.text = "Player 1 properties: " +str(player.properties) + "\nPlayer 2 properties: " +str(player2.properties)
	jail_choice.get_ok_button().connect("ok", _on_ok_pressed)
	jail_choice.get_cancel_button().connect("no", _on_no_pressed)
	start_turn()
	print(number_of_spaces)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
# Called when the roll button is pressed
func _on_dice_button_pressed():
	var num = all_players[current_turn].roll(dice, dice_2, game_spaces)
	all_players[current_turn].move(13, game_spaces, timer)
	timer.start()
	#player_turn(game_spaces[all_players[current_turn].current_position-1], current_player)
	await turn_end
	end_turn()

# Shows the dice sprites and roll button when pressed
func _on_reveal_dice_pressed():
	dice.show();
	dice_2.show();
	dice_button.show();

# checks what type of tile the tile and calls the appropriate func
func player_turn(Tile, place):
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
		## make player pay tax

	if final_space.type == 5:
		print("visiting jail")

	if final_space.type == 6:
		print("free parking")

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

func _on_property_button_pressed() -> void:
	card_bought(final_property)
	
func card_bought(property : Property):
	all_players[current_turn].buy_property(property, bank)
	
func _landed_on_oppo_knocks(Player):
	var ok_card : oppoKnocksCard = ok_card_scene.instantiate()
	var new_ok : OpportunityKnocks = ok_scene.instantiate()
	new_ok._dividend_50(Player, bank)
	card_spawn.add_child(ok_card)
	ok_card._make_card(new_ok.ok_des)
	ok_card.visible = true
	
func _landed_on_potluck(Player):
	var pl_card : potluckCard = potluck_card_scene.instantiate()
	var new_pl : pot_luck = pl_scene.instantiate()
	new_pl._inherit_200(Player, bank)
	card_spawn.add_child(pl_card)
	pl_card._make_card(new_pl.pl_des)
	pl_card.visible = true
	
func update_label():
	player_money_lbl.text = "Player 1 " + str(player.balance) + "\nPlayer 2 " + str(player2.balance)
	bank_label.text = "Bank: " + str(bank.balance)
	player_turn_label.text = "it's " + all_players[current_turn].name + " turn"
	property_lbl.text = "Player 1 properties: " +str(player.properties) + "\nPlayer 2 properties: " +str(player2.properties)
	
func start_turn():
	var current_player = all_players[current_turn]
	print("It's ", current_player.playerName, "'s turn!")
	if current_player.injail == true:
		jail_choice.popup_centered()
		
	
func end_turn():
	property_button.hide()
	current_turn = (current_turn + 1) % all_players.size() #the next turn will always loop back to the beginning when all the players have had a turn
	print("Turn ended. Next up: ", all_players[current_turn].playerName)
	current_player = all_players[current_turn]
	update_label()
	start_turn()

#not using rn
func _on_timer_timeout() -> void:
	pass # Replace with function body.

#not using
func _on_end_turn_pressed() -> void:
	turn_end.emit()

func _on_turn_action_pressed() -> void:
	player_turn(game_spaces[all_players[current_turn].current_position-1], current_player)


func _on_mouse_entered() -> void:
	pass # Replace with function body.
