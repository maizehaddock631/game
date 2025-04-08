extends Tile
class_name Property

@export var propertycost : int
@export var propertyowner : Node2D
@export var rent : int
@export var numofhouses: int
@export var colour = Property.WhichColour.NONE
var propertyname : String
var house_label: Label

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

var colour_groups = {
	Property.WhichColour.BROWN : [$".",$"../Gangster's Paradise" ],
	Property.WhichColour.BLUE : [$"../The Angel's Delight", $"../Potter Avenue", $"../Granger Drive"],
	Property.WhichColour.PURPLE : [$"../Sky walker drive", $"../Wookie hole",$"../Rey lane" ],
	Property.WhichColour.ORANGE : [$"../Bishop drive", $"../Duhnam street",$"../Broyles lane"],
	Property.WhichColour.RED : [$"../Yue fei square",$"../Mulan rouge", $"../Han xin gardens" ],
	Property.WhichColour.YELLOW: [$"../Shatner close", $"../Picard avenue",$"../Crusher creek" ],
	Property.WhichColour.GREEN: [$"../Sirat Mews",$"../Ghengis Crescent", $"../Ibis Close" ],
	Property.WhichColour.DEEPBLUE: [$"../James Webb Way", $"../Turing heights"]
}

func get_colour_group(color: Property.WhichColour) -> Array:
	return colour_groups.get(color, [])

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if propertyowner != null:
		buyable == false
	house_label = Label.new()
	house_label.visible = false  # Hide label initially
	house_label.add_theme_font_size_override("font_size", 20)  # Adjust font siz
	add_child(house_label)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
#func _on_mouse_entered():
	#if numofhouses > 0: 
		#house_label.text = self.playerName + " has " + str(self.numofhouses) + " houses!"
		#house_label.visible = true

func _on_mouse_exited():
	house_label.visible = false 
func show_house_count():
	house_label.text = "Houses: " + str(numofhouses)
	house_label.position = Vector2(20, -20)  # Adjust position above the property
	house_label.visible = true

#func _on_house_label_mouse_entered() -> void:
	#_on_mouse_entered()


#func _on_house_label_mouse_exited() -> void:
	#_on_mouse_exited()
