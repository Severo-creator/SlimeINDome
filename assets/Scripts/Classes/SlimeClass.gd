extends Node

class_name SlimeClass

var vidaMaxima = 0
var vidaAtual = 0
var leveza = 0
var poder = 0




func damage(damage, idp):
	vidaAtual -= damage
	if vidaAtual <= 0 && idp == multiplayer.get_unique_id():
		print("Morte...")
		var controller = get_node("/root/MainMenu")
		controller.playerLose(multiplayer.get_unique_id())
