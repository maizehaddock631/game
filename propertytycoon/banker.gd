class_name Banker

extends Node2D

var balance : int = 50000
var properties = []

func pay(amount : int, who : Player) -> void:
	who.balance += amount
	balance -= amount

func sell_property(player: Player, tile: PropertyTile) -> void:
	if tile.propertycost > player.balance:
		print("Sorry. Not enough funds")
	else:
		tile.propertyowner = player
		balance += tile.propertycost
		player.balance -= tile.propertycost
		player.properties.append(tile)
		properties.erase(tile)
