extends Control

@onready var dice = $Dice
@onready var dice_2 = $Dice2
@onready var dice_button = $DiceButton
@onready var player: Player = $Player


# Called when the node enters the scene tree for the first time.
func _ready():
	dice.hide();
	dice_2.hide();
	dice_button.hide();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_dice_button_pressed():
	var dice1 = dice.roll()
	var dice2 = dice_2.roll()
	if dice1 == dice2:
		print("You rolled a double!!")
		_on_dice_button_pressed()
	
	
func diceroller():
	pass
	
func _on_reveal_dice_pressed():
	dice.show();
	dice_2.show();
	dice_button.show();
	
