extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0

var NodeClass 
var palavraaux 

func _ready():
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_Q:
		if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
			print("A tecla Q foi pressionada")
			Skill_2.rpc(get_global_mouse_position())
		
		
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
				print("Usuário clicou com o botão esquerdo do mouse")
				Skill_1.rpc(get_global_mouse_position())
				

@rpc("any_peer", "call_local")
func Skill_1(pos):
	NodeClass.usar_skill_1(self, pos)
	
@rpc("any_peer","call_local")
func Skill_2(pos):
	NodeClass.usar_skill_2(self, pos)


func _physics_process(delta): 
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():

		# Handle Jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			
		# Get the input direction and handle the movement/deceleration.
		var directionx = Input.get_axis("ui_left", "ui_right")
		if directionx:
			velocity.x = directionx * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		var directiony = Input.get_axis("ui_up", "ui_down")
		if directiony:
			velocity.y = directiony * SPEED
		else:
			velocity.y = move_toward(velocity.y, 0, SPEED) # <-- Corrigido aqui

		# Só use esse se quiser desacelerar geral, talvez com condição
		# velocity = velocity.move_toward(Vector2.ZERO, 300 * delta)

		move_and_slide()




	
func add_NodeClass(name):
	var cena = load("res://assets/Scripts/Classes/" + name + "/" + name + "Classe.tscn")
	NodeClass = cena.instantiate()
	add_child(NodeClass)
	return NodeClass
	
func aplicar_impulso(direcao: Vector2, forca: float):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		velocity += direcao.normalized() * forca
	
func set_NodeClass(NodeClassestg):
	var NodeClass_cena = load(NodeClassestg)
	NodeClass = NodeClass_cena.instantiate()
	add_child(NodeClass)


func apply_damage(damage):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		print("Dano playerController")
		NodeClass.damage(damage, $MultiplayerSynchronizer.get_multiplayer_authority())
