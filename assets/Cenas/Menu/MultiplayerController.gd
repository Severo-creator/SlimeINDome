extends Control

@export var Address = "127.0.0.1"
@export var port = 8910

var peer

var ready_players: Array[int] = []


var rooms = {} # Ex: { "sala1": [1, 5], "sala2": [3] }
@export var max_players_per_room = 2
var room
@onready var line_edit = %LineEdit
@onready var input_line = %inputchat
@onready var chat_log = %TextEdit

#@onready var chat_log = $TextEdit
#@onready var input_line = $inputchat

func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	
	
func peer_connected(id):
	print("Player Connected " + str(id))
	print(multiplayer.get_peers().size())
	
func peer_disconnected(id):
	print("Player Disconnected " + str(id))
	
func connected_to_server():
	print("	Connected to Server!")
	SandPlayerInformation.rpc_id(1, line_edit.text, multiplayer.get_unique_id())
	send_chat_message.rpc("Conectado!", multiplayer.get_unique_id())
	
func connection_failed():
	print("	Connection Failed!")
	

func Host_Down():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 5)
	if error != OK:
		print("cannot host" + error)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting for Players")
	
	SandPlayerInformation(line_edit.text, multiplayer.get_unique_id())

func Join_Down():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(Address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	

func Start_Game(id):
	add_player_to_room.rpc(id)
	
	if Room_size(room) < max_players_per_room:
		print("Esperando jogador")
	else :
		start_game_in_room(room)


func  Room_size(sala: String):
	if rooms.has(sala):
		return rooms[sala].size()
	else :
		return 0

@rpc("any_peer")
func SandPlayerInformation(name, id):
	if !DataPlayers.Players.has(id):
		DataPlayers.Players[id] = {
			"name" = name,
			"id" = id,

		}
	if multiplayer.is_server():
		for i in DataPlayers.Players:
			SandPlayerInformation.rpc(DataPlayers.Players[i], i)


func _on_start_game_pressed():
	Start_Game(multiplayer.get_unique_id())
	pass # Replace with function body.


func _on_host_pressed():
	Host_Down()
	
	pass # Replace with function body.
	

@rpc("any_peer", "call_local")
func set_Class_rpc(name, idPlayer):
	set_Class(name, idPlayer)

func set_Class(name, idPlayer):
	print("Player set em " ,idPlayer)
	if RoundData.Players.has(idPlayer):
		RoundData.Players[idPlayer]["Class"] = name


func _on_join_pressed():
	Join_Down()
	pass # Replace with function body.

@rpc("any_peer", "call_local")
func player_ready(player_id: int):
	if RoundData.Players.has(player_id):
		var jogadores = rooms[room]
		for p_id in jogadores:
			ready_play.rpc_id(p_id, room, player_id)
	
	
	
	
@rpc("any_peer", "call_local")
func ready_play(sala: String, player_id: int):

	if player_id in ready_players:
		return
	ready_players.append(player_id)
	print("Player ", player_id, " está pronto ", ready_players.size())
	
	
	if ready_players.size() >= rooms[sala].size():
		Arena()
		ready_players.clear()
	

func Arena():
	print("Todos prontos, iniciando cena")
	change_scene_all("res://assets/Cenas/Arena.tscn")

@rpc("call_local", "authority")
func change_scene_all(path: String):
	var scene = load(path).instantiate()
	get_tree().root.add_child(scene)
	self.hide()

@rpc("any_peer","call_local")
func add_player_to_room(peer_id: int):
	for room_name in rooms.keys():
		if rooms[room_name].size() < max_players_per_room:
			rooms[room_name].append(peer_id)
			print("Adicionado à ", room_name)
			if peer_id == multiplayer.get_unique_id():
				room = room_name
			return room_name

	# Se não há sala com espaço, crie uma nova
	var new_room_name = "sala" + str(rooms.size() + 1)
	rooms[new_room_name] = [peer_id]
	print("Nova sala criada:", new_room_name)
	if peer_id == multiplayer.get_unique_id():
		room = new_room_name
	return new_room_name
	

func start_game_in_room(sala: String):
	print("Start Room")
	var jogadores = rooms[sala]
	for player_id in jogadores:
		SendRoundInformation.rpc( player_id, sala)
		print(player_id)
		Selecao.rpc_id(player_id)

@rpc("any_peer","call_local")
func Selecao():
	var scene = load("res://assets/Cenas/Menu/SelecionarUsuario.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()
	
@rpc("any_peer", "call_local")
func SendRoundInformation(id : int, sala : String):
	if sala == room:
		if !RoundData.Players.has(id):
			RoundData.Players[id] = {
				"id" = id,
				"HP" = 0, 
				"Class" = ""
			}
		
		if multiplayer.is_server():
			for i in RoundData.Players:
				SendRoundInformation.rpc(RoundData.Players[i], i)

func on_send_pressed():
	var msg = input_line.text.strip_edges()
	if msg != "":
		send_chat_message.rpc(msg, multiplayer.get_unique_id())
		input_line.text = ""


@rpc("any_peer", "call_local")
func send_chat_message(msg: String, from_id: int):
	var sender = str(from_id)
	if multiplayer.has_multiplayer_peer() and multiplayer.get_peers().has(from_id):
		sender = "Player %d" % from_id
	chat_log.text += "\n%s: %s" % [sender, msg]
	chat_log.scroll_vertical = chat_log.get_line_count()


func _on_inputchat_text_submitted(new_text):
	on_send_pressed()
	pass # Replace with function body.

func playerLose(idloser):
	for playerid in rooms[room]:
		if playerid != idloser:
			Winer.rpc_id(playerid)
		endgame.rpc_id(playerid)

@rpc("any_peer", "call_local")
func endgame():
	var arena = get_node("/root/Arena")
	arena.queue_free()
	RoundData.Players = {}
	ereaseRoom.rpc(room)
	room = ""
	ready_players.clear()
	self.show()

@rpc("any_peer", "call_local")
func ereaseRoom(room):
	rooms.erase(room)


@rpc("call_local")
func Winer():
	print(" Jogador ganhou!")
	PlayerData.adicionar_vitoria()
