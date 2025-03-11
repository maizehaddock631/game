extends Tile
class_name Property

@export var propertycost : int
@export var propertyowner : Node2D
@export var rent : int
@export var numofhouses: int = 0
@export var colour = Property.WhichColour.NONE
var propertyname : String
var numofhotels: int = 0

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
	pass
	#if propertyowner != null:
		#buyable == false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
