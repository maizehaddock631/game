extends Node2D
class_name Dice

@onready var timer: Timer = $Timer
@onready var dice_animation = $DiceAnimation
var random = RandomNumberGenerator.new()
var rand_num : int 

func roll() -> int:
	var number = random.randi_range(1,6)
	timer.start()
	dice_animation.play("rolling")
	print("you rolled a " + str(number));
	#rand_num = number
	return number
	
func _on_timer_timeout() -> void:
	match rand_num:
		1: 
			dice_animation.play("1")
		2:
			dice_animation.play("2")
		3:
			dice_animation.play("3")
		4:
			dice_animation.play("4")
		5:
			dice_animation.play("5")
		6:
			dice_animation.play("6")
	
