extends Node3D

func _ready():
	var character_scene = preload("res://Cowboy_Test.tscn")
	var character_instance = character_scene.instantiate()
	add_child(character_instance)
