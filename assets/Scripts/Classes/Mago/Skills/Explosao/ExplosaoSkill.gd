extends AreaSkill

var Explosion = load("res://assets/Scripts/Classes/Mago/Skills/Explosao/Explosao.tscn")
var cooldown = 10
var last_cooldown = 10

var areas = []

func _ready():
	range = 300

func fire(s,a, hardpoint = self):
	if last_cooldown < cooldown: return
	else: last_cooldown = 0
	
	var area = Explosion.instantiate()
	area.add_collision_exception_with(s)
	get_node("/root").add_child(area)
	
	var distance = s.position.distance_to(a)
	
	if(distance > range):
		var direcao = (a - s.position).normalized()
		var ponto_medio = s.position + direcao * range
		area.position = ponto_medio
		area.rotation = s.rotation
	else:
		area.position = get_viewport().get_mouse_position()
		area.rotation = s.rotation
	
	
	
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
		var collision = p.move_and_collide(Vector2(0.1, 0))
		
		if (collision):
			var collider = collision.get_collider()
			
			if collider.get_class() == "CharacterBody2D" and collider.is_in_group("slime"):
				
				collider.apply_damage(damage) 
				
			p.get_node("CollisionShape2D").disabled = true
			areas.erase(i)
		i["tick"] += 1


