extends Node



func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_Q:
		print("A tecla Q foi pressionada")
		
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			print("Usuário clicou com o botão esquerdo do mouse")
		elif event.button_index == MOUSE_BUTTON_LEFT:
			print("Usuário clicou com o botão direito do mouse")






