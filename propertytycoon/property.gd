extends Tile
class_name Property

@export var propertycost : int
@export var propertyowner : Player
@export var rent : int
@export var numofhouses: int
@export var colour = Property.WhichColour.NONE

enum WhichColour {
	BLUE,
	YELLOW,
	BROWN,
	RED,
	ORANGE,
	UTILITY,
	PURPLE,
	GREEN, 
	PINK,
	STATION,
	DEEPBLUE,
	NONE
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if propertyowner != null:
		buyable == false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
