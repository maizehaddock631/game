extends Control

@onready var dice: Dice = $DiceStuff/Dice
@onready var dice_button: Button = $DiceStuff/DiceButton
@onready var dice_2: Dice = $DiceStuff/Dice2
@onready var property_card_scene: PackedScene = preload("res://property_card.tscn")
@onready var card_spawn = $CanvasLayer/CardSpawn
@onready var player_money: Label = $PlayerMoney
@onready var player_properties: Label = $PlayerProperties


@export var game_spaces : Array[Tile]
var place : int = 0
var number_of_spaces : int 
var count : int = 0
@export var final_space : Tile
@export var final_property : Property

@onready var banker: Banker = $Banker
@onready var player: Player = $Players/Player
@onready var timer: Timer = $Timer
@onready var property_panel: Panel = $PropertyPanel
@onready var property_button: Button = $PropertyButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dice.hide();
	dice_2.hide();
	dice_button.hide();
	property_panel.hide()
	number_of_spaces = game_spaces.size()
	print(number_of_spaces)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
# Called when the roll button is pressed
func _on_dice_button_pressed():
	_rolling()

#Calls the roll function from each dice instance, 
#checks if it is a double and adds the dice roll numbers to addedNum, 
#passes it through move player func 
func _rolling():
	var isNotADouble : bool = false
	var addedNum : int 

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
			#if diceCount = 3:
				#JAIL, call/make a jail function
	_move_player(addedNum)

# Shows the dice sprites and roll button when pressed
func _on_reveal_dice_pressed():
	dice.show();
	dice_2.show();
	dice_button.show();
	

# Moves the player through the array, changing its position
func _move_player(int):
	#can test by changing int to a specific number
	var num = int + 1
	var final_space 
	var turn_done = false
	
	while num != 0 and game_spaces[place] != game_spaces[39]:
		var tween = create_tween()
		tween.tween_property(player, "position", game_spaces[place].position, 1)
		timer.start()
		await timer.timeout
		place += 1
		num -= 1
		count += 1
		print(game_spaces[place-1])
	
	if game_spaces[place] == game_spaces[39]:
		var tween = create_tween()
		tween.tween_property(player, "position", game_spaces[0].position, 1)
		timer.start()
		await timer.timeout
		place = place - count 
		count = 0
		player.has_completed_loop == true
		print(player.has_completed_loop)
		_move_player(place)
	
	turn_done == true
	
	#if turn_done == true:
	final_space == place -1
	print("this runs")
	print(place-1)
	print(game_spaces[place-1])
	
	player_turn(game_spaces[place-1], place)
	
	
func player_turn(Tile, place):
	final_space = Tile
	print(final_space)
	print(Tile.WhichType)
	print(final_space.type)
	print("player turn runs")
	

	if final_space.type == 1:
		print("you landed on a property1")
		_landed_on_property(game_spaces[place-1])

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

func _landed_on_property(Property):
	final_property = Property
	print("you landed on a property2")
	print(final_property)
	var card : propertyCard = property_card_scene.instantiate()
	print(final_property.propertycost)
	card_spawn.add_child(card)
	card.make_card(final_property.propertycost, final_property.tilename)
	card.visible = true
	

func _on_property_button_pressed() -> void:
	print("property bought")
	card_bought(final_property)
	
func card_bought(property : Property):
	player.buy(property)
	
func move(place) -> void:
	pass
	
func update_label(int, array):
	player_money = int
	player_properties = array
