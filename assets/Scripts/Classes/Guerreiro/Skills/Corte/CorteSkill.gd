extends AreaSkill

var corte = load("res://assets/Scripts/Classes/Guerreiro/Skills/Corte/Corte.tscn")
var cooldown = 40
var last_cooldown = 30

var areas = []


func _ready():
	range = 30


func fire(s, a, hardpoint = self):
	if last_cooldown < cooldown: return
	else: last_cooldown = 0
	
	var area = corte.instantiate()
	area.add_collision_exception_with(s)
	s.add_child(area)
	
	
	
	
	var direcao = (a - s.position).normalized()
	print(direcao)
	var ponto_medio = s.position + direcao * range
	area.global_position = ponto_medio
	area.look_at(a)
	
	
	
	
	
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
			
			if collider.get_class() == "CharacterBody2D" and collider.is_in_group("slime"):
				print("Damage")
				collider.apply_damage(damage) 
				
			p.queue_free()
			areas.erase(i)
		i["tick"] += 1
