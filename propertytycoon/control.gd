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

@onready var property_card_scene: PackedScene = preload("res://property_card.tscn")
@onready var card_spawn = $CanvasLayer/CardSpawn
@onready var player_money: Label = $PlayerMoney
@onready var player_properties: Label = $PlayerProperties
@onready var bank = $Banker

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
	number_of_spaces = game_spaces.size()
	all_players = [player, player2]
	start_turn()
	print(number_of_spaces)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
# Called when the roll button is pressed
func _on_dice_button_pressed():
	var num = all_players[current_turn].roll(dice, dice_2, game_spaces)
	all_players[current_turn].move(num, game_spaces, timer)
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
		_landed_on_property(game_spaces[all_players[current_turn].current_position-1])

	if final_space.type == 2:
		print ("you landed on opportunity knocks")

	if final_space.type == 3:
		print("potluck")

	if final_space.type == 4:
		print("tax")

	if final_space.type == 5:
		print("visiting jail")

	if final_space.type == 6:
		print("free parking")

	if final_space.type == 7:
		print("go to jail")

	#if (game_spaces[place-1]) == game_spaces[1] and firstround !=true
		#add £200

	#need to send player position back to 0 in array, call func to add money

func _landed_on_property(property: Property):
	final_property = property
	print("you landed on a property!")
	print(property)
	var card : propertyCard = property_card_scene.instantiate()
	print(property.propertycost)
	card_spawn.add_child(card)
	card.make_card(property.propertycost, property.tilename)
	card.visible = true

func _on_property_button_pressed() -> void:
	card_bought(final_property)
	
func card_bought(property : Property):
	all_players[current_turn].buy_property(property, bank)
	
func update_label(int, array):
	player_money = int
	player_properties = array
	
func start_turn():
	var current_player = all_players[current_turn]
	print("It's ", current_player.playerName, "'s turn!")
	
func end_turn():
	current_turn = (current_turn + 1) % all_players.size() #the next turn will always loop back to the beginning when all the players have had a turn
	print("Turn ended. Next up: ", all_players[current_turn].playerName)
	current_player = all_players[current_turn]
	start_turn()

#not using rn
func _on_timer_timeout() -> void:
	pass # Replace with function body.

#not using
func _on_end_turn_pressed() -> void:
	turn_end.emit()

func _on_turn_action_pressed() -> void:
	player_turn(game_spaces[all_players[current_turn].current_position-1], current_player)
