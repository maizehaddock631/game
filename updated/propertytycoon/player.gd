class_name Player

extends Node2D

var balance : int = 1500
var injail : bool
var isAI : bool
var token : Token
var properties = []
var current_position : Vector2

func pay(amount: int, who: Player) -> void:
	who.balance += amount
	balance -= amount
	
func roll() -> int:
	var number1 = $dice1.roll()
	var number2 = $dice2.roll()
	return number1 + number2

func buy_property() -> void:
	properties.add()
