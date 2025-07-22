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
	
	
	
	
	
	direcao = (a - s.position).normalized()
	
	if int(str(s.name)) == multiplayer.get_unique_id():
		s.aplicar_impulso(direcao, forca)
	
	
	
	



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





