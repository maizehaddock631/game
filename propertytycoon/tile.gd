extends Node2D
class_name Tile 

@export var type = Tile.WhichType.NONE
@export var tilename: String
@export var buyable : bool 

enum WhichType {
	GO,
	PROPERTY,
	OPPORTUNITYKNOCKS,
	POTLUCK,
	TAX, 
	VISITINGJAIL,
	FREEPARKING,
	GOTOJAIL,
	NONE
}
