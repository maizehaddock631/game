class_name Token

extends Node2D

enum tokens {CAT, IRON, HATSTAND, SMARTPHONE, BOOT, SHIP}

var token_type : tokens
var sprite: Sprite2D

var textures = {
	"Cat" : preload("res://gameAssets/token assets/IMG_5684.PNG"),
	"Iron" : preload("res://gameAssets/token assets/IMG_5682.PNG"),
	"HatStand" : preload("res://gameAssets/token assets/IMG_5683.PNG"),
	"SmartPhone" : preload("res://gameAssets/token assets/IMG_5678.PNG"),
	"Boot" : preload("res://gameAssets/token assets/IMG_5677.PNG"),
	"Ship" : preload("res://gameAssets/token assets/IMG_5681.PNG")
}

func _ready() -> void:
	pass
