extends Control

var config_path = "user://Usuarios.cfg"
var config = ConfigFile.new()

@onready var username_input = %UsernameInput
@onready var password_input = %PasswordInput
@onready var feedback_label = %FeedbackLabel
@onready var login_button = %LoginButton
@onready var register_button = %RegisterButton


func _ready():
	login_button.pressed.connect(_on_login_pressed)
	register_button.pressed.connect(_on_register_pressed)
	
	if FileAccess.file_exists(config_path):
		config.load(config_path)

func _on_register_pressed():
	print("registrado")
	var username = username_input.text.strip_edges()
	var password = password_input.text.strip_edges()
	
	if username == "" or password == "":
		feedback_label.text = "Preencha os dois campos."
		return

	if config.has_section_key("usuarios", username):
		feedback_label.text = "Usuário já existe."
	else:
		var user_data = {
			"senha": password,
			"vitorias": 0
		}
		config.set_value("usuarios", username, user_data)
		config.save(config_path)
		feedback_label.text = "Cadastro feito com sucesso!"

func _on_login_pressed():
	var username = username_input.text.strip_edges()
	var password = password_input.text.strip_edges()

	if config.has_section_key("usuarios", username):
		var user_data = config.get_value("usuarios", username)
		if user_data["senha"] == password:
			feedback_label.text = "Login bem-sucedido! Vitórias: " + str(user_data["vitorias"])
			PlayerData.username = username
			PlayerData.senha = password
			PlayerData.vitorias = user_data["vitorias"]
			await get_tree().create_timer(1).timeout
			get_tree().change_scene_to_file("res://assets/Cenas/Menu/MainMenu.tscn")
		else:
			feedback_label.text = "Senha incorreta."
	else:
		feedback_label.text = "Usuário não encontrado."
	

func adicionar_vitoria(username):
	if config.has_section_key("usuarios", username):
		var user_data = config.get_value("usuarios", username)
		user_data["vitorias"] += 1
		config.set_value("usuarios", username, user_data)
		config.save(config_path)
