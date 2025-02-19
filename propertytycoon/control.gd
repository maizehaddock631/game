extends Control

@onready var dice: Dice = $DiceStuff/Dice
@onready var dice_button: Button = $DiceStuff/DiceButton
@onready var dice_2: Dice = $DiceStuff/Dice2

@export var game_spaces : Array[Node]
var place : int = 0
var number_of_spaces : int 

@onready var player: Player = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dice.hide();
	dice_2.hide();
	dice_button.hide();
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
				#JAIL, call/make a jail functio
	_move_player(addedNum)

# Shows the dice sprites and roll button when pressed
func _on_reveal_dice_pressed():
	dice.show();
	dice_2.show();
	dice_button.show();

# Moves the player through the array, changing its position
func _move_player(int):
	if place >= number_of_spaces:
		print("out of bounds")
	
	place = place + int
	var tween = create_tween()
	tween.tween_property(player, "position", game_spaces[place].position, 1)
	print(game_spaces[place])
	
	#need to send player position back to 0 in array, call func to add money
