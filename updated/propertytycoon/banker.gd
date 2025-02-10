class_name Banker

extends Node2D

var balance : int = 50000
var properties = []

func pay(amount : int, who : Player) -> void:
	who.balance += amount
	balance -= amount
