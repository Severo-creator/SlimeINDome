extends Node


var username

var senha

var vitorias

var config_path = "user://Usuarios.cfg"
var config = ConfigFile.new()

func _ready():
	if FileAccess.file_exists(config_path):
		config.load(config_path)


func adicionar_vitoria():
	print("Adicionando ponto")
	if config.has_section_key("usuarios", username):
		print(username)
		var user_data = config.get_value("usuarios", username)
		user_data["vitorias"] += 1
		config.set_value("usuarios", username, user_data)
		config.save(config_path)
