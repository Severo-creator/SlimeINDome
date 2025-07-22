extends Control


func _on_guerreiro_pressed():
	var controller = get_node("/root/MainMenu")  
	controller.set_Class_rpc.rpc("Guerreiro", multiplayer.get_unique_id())
	controller.player_ready.rpc(multiplayer.get_unique_id())
	self.queue_free()

func _on_mago_pressed():
	var controller = get_node("/root/MainMenu")  
	controller.set_Class_rpc.rpc("Mago", multiplayer.get_unique_id())
	controller.player_ready.rpc(multiplayer.get_unique_id())
	self.queue_free()
	




func _on_menu_pressed():
	pass # Replace with function body.


func _on_ranger_pressed():
	var controller = get_node("/root/MainMenu")  
	controller.set_Class_rpc.rpc("Ranger", multiplayer.get_unique_id())
	controller.player_ready.rpc(multiplayer.get_unique_id())
	self.queue_free()
	pass # Replace with function body.
