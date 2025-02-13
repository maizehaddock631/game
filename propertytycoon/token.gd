class_name Token

extends Node2D

enum tokens {CAT, IRON, HATSTAND, SMARTPHONE, BOOT, SHIP}

var token_type : tokens
var sprite: Sprite2D

var textures = {
	tokens.IRON: preload("res://Screenshot_2025-02-10_101418-removebg-preview.png")
}

func _ready() -> void:
	allocate_sprite()

func allocate_sprite() -> void:
	pass
