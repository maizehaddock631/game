class_name Dice

extends Node2D

var random = RandomNumberGenerator.new()

func roll() -> int:
	var number = random.randi_range(1,6)
	return number
