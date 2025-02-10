extends Control

@onready var dice = $Dice
@onready var dice_2 = $Dice2
@onready var dice_button = $DiceButton


# Called when the node enters the scene tree for the first time.
func _ready():
	dice.hide();
	dice_2.hide();
	dice_button.hide();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_dice_button_pressed():
	dice.roll();
	dice_2.roll();
	
func diceroller():
	pass
	
func _on_reveal_dice_pressed():
	dice.show();
	dice_2.show();
	dice_button.show();
	
