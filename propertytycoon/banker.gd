class_name Banker

extends Node2D

@export var balance : int = 50000
@export var properties = []
@export var freeParking : int = 0

##This function allows the bank to give money to the player
##@Param amount, amount to pay
##@Param who, the player to pay it to
func pay(amount : int, who : Player) -> void:
	who.balance += amount
	balance -= amount
	
##This function allows the bank to sell to a player
##@Param player, player it is selling to
##Param tile, the property tile it is selling
func sell_property(player: Player, tile: Property) -> void:
	if tile.propertycost > player.balance:
		print("Sorry. Not enough funds")
	else:
		tile.propertyowner = player
		balance += tile.propertycost
		player.balance -= tile.propertycost
		player.properties.append(tile)
		properties.erase(tile)
