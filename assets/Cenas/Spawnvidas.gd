extends Node2D

# Arraste o recurso (PackedScene) no editor para este campo
@export var recurso_scene: PackedScene

# Número de instâncias que serão criadas
@export var quantidade = 10

# Área onde será feita a geração
@export var area_spawn := Rect2(Vector2.ZERO, Vector2(320, 180))

func _ready():
	for i in quantidade:
		await get_tree().create_timer(5.0).timeout
		instanciar_recurso()


func instanciar_recurso():
	if recurso_scene:
		
		var pos_random = Vector2(
			randf_range(area_spawn.position.x, area_spawn.position.x + area_spawn.size.x),
			randf_range(area_spawn.position.y, area_spawn.position.y + area_spawn.size.y)
		)
		for id_player in RoundData.Players:
			spawn.rpc_id(id_player, pos_random)

@rpc("call_local", "any_peer")
func spawn(pos_random):
	var recurso = recurso_scene.instantiate()
	
	recurso.global_position = pos_random
	add_child(recurso)
