extends Node2D

@export var PlayerScene : PackedScene


func _ready():
	var index = 1
	
	for i in RoundData.Players:
		var currentPlayer = PlayerScene.instantiate()
		currentPlayer.name = str(RoundData.Players[i].id)
		currentPlayer.add_NodeClass(RoundData.Players[i]["Class"])
		add_child(currentPlayer)
		for spawn in get_tree().get_nodes_in_group("SpawnPlayer"):
			if spawn.name == str(index):
				currentPlayer.global_position = spawn.global_position
		index += 1
