class_name Banker

extends Node2D

@export var balance : int = 50000
@export var properties = []
@export var freeParking : int = 0

func pay(amount : int, who : Player) -> void:
	who.balance += amount
	balance -= amount

func sell_property(player: Player, tile: Property) -> void:
	if tile.propertycost > player.balance:
		print("Sorry. Not enough funds")
	else:
		tile.propertyowner = player
		balance += tile.propertycost
		player.balance -= tile.propertycost
		player.properties.append(tile)
		properties.erase(tile)
