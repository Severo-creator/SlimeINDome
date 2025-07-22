extends Control

var multiplayerscene = load("res://assets/Cenas/Testmultiplayer.tscn")
var multiplayersct = multiplayerscene.instantiate()

func _ready():
	add_child(multiplayersct)

@rpc("any_peer","call_local")
func Start_Game():
	var start = load("res://assets/Cenas/Menu/SelecionarUsuario.tscn")
	get_tree().root.add_child(start)
	self.hide()

@rpc("any_peer","call_local")
func SandPlayerInformation(name, id):
	if RoundData.Players.has(id):
		RoundData.Players[id] = {
			"name" = name,
			"id" = id,
			"HP" = 0
		}


func _on_start_game_pressed():
	
	Start_Game().rpc()
	
	




func _on_quiti_game_pressed():
	pass # Replace with function body.


func _on_host_pressed():
	multiplayersct.Hot_Down()
	
	pass # Replace with function body.


func _on_join_pressed():
	multiplayersct.Join_Down()
	
	
	pass # Replace with function body.
