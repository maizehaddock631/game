extends Node2D
class_name Dice

@onready var timer: Timer = $Timer
@onready var dice_animation = $DiceAnimation
var random = RandomNumberGenerator.new()
#signal dice_has_rolled(roll)

#makes sure its a random seed everytime
func _ready() -> void:
	randomize()

# Creates a random number, calls a animation to play, prints command line/returns random number
func roll() -> int:
	var number = random.randi_range(1,6)
	dice_animation.play("rolling")
	print("you rolled a " + str(number));
	return number
	
	#dice_animation.play(str(number))
	#emit_signal("dice_has_rolled", number)
	
func _on_timer_timeout() -> void:
	pass
	
