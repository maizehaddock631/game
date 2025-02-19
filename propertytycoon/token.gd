class_name Token

extends Node2D

enum tokens {CAT, IRON, HATSTAND, SMARTPHONE, BOOT, SHIP}

var token_type : tokens
var sprite: Sprite2D

##var textures = {}

func _ready() -> void:
	allocate_sprite()

func allocate_sprite() -> void:
	pass
