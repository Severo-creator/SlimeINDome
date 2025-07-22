extends AreaSkill

var corte = load("res://assets/Scripts/Classes/Guerreiro/Skills/Salto/Perfurar.tscn")
var cooldown = 10
var last_cooldown = 300
var velociade = Vector2.ZERO
var direcao
var forca = 2000


var areas = []


func _ready():
	range = 10


func fire(s, a, hardpoint = self):
	if last_cooldown < cooldown: return
	else: last_cooldown = 0
	
	var area = corte.instantiate()
	area.add_collision_exception_with(s)
	s.add_child(area)
	
	
	
	direcao = (a - s.position).normalized()
	
	var ponto_medio = s.position + direcao * range
	area.position = ponto_medio
	area.rotation = s.rotation
	print(direcao)
	
	if int(str(s.name)) == multiplayer.get_unique_id():
		s.aplicar_impulso(direcao, forca)
	
	
	
	
	areas.append({
		"area" = area,
		"tempo" = timesurge,
		"tick" = 0
	})


func _physics_process(delta):
	last_cooldown += 1
	for i in areas:
		var p = i["area"]
		
		if i["tick"] >= 20:
			p.queue_free()
			areas.erase(i)
			pass
		var collision = p.move_and_collide(Vector2.ZERO)
		
		if (collision):
			var collider = collision.get_collider()
			
			if (collider.get_class() == "CharacterBody2D"):
				print("Damage")
				collider.apply_damage(damage)  
				
			p.queue_free()
			areas.erase(i)
		i["tick"] += 1





