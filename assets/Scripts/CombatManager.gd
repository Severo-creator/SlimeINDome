extends Node2D

func _ready():
	spawn_player()

func spawn_player():
	var playerscene = load("res://assets/Player/Player.tscn")
	var playernode = playerscene.instantiate()
	add_child(playernode)
	playernode.add_class("Guerreiro")
	
	
