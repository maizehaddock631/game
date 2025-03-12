class_name propertyCard extends Property

@onready var property_card: propertyCard = $"."

@export var property_name : String = "property name"
@export var property_colour : Sprite2D
@export var property_cost : int = 1
@export var property_rent : int

@onready var property_lbl : Label = $PropertyDisplay/PropertyLabel
@onready var cost_lbl : Label = $PropertyDisplay/PropertyCost
#@onready var bought : bool 

#makes the card when the ready function is called
func _ready():
	visible = false
	make_card(property_cost, property_name)
	
#sets the card name and cost to the parameters past through the function
func make_card(_cost :int, _name :String):
	property_name = _name
	property_cost = _cost
	
	property_lbl.set_text(_name)
	cost_lbl.set_text(str(_cost))

#makes the card invisible 
func _on_buy_button_pressed() -> void:
	visible = false

#instead of button make input ui click the remove card
