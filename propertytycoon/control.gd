extends Control

@onready var dice = $Dice
@onready var dice_2 = $Dice2


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_dice_button_pressed():
	dice.roll();
	dice_2.roll();
	
func diceroller():
	pass
	
