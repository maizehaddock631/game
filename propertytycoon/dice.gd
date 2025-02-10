extends Node2D
class_name Dice

@onready var dice_animation = $DiceAnimation
var random = RandomNumberGenerator.new()


func roll() -> int:
	var number = random.randi_range(1,6)
	print("you rolled a " + str(number));
	dice_animation.play("rolling")
	return number
