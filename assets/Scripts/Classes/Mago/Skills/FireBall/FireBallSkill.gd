extends Projetil

var fireball = load("res://assets/Scripts/Classes/Mago/Skills/FireBall/Fireball.tscn")
var cooldown = 40
var last_cooldown = 10

var projeteis = []

var time = 0

var playerpos

var forca = 500

func _ready():
	speed = 500



func fire(s,a, hardpoint = self):
	if last_cooldown < cooldown: return
	else: last_cooldown = 0

	var velocidade = Vector2()
	var projetil = fireball.instantiate()
	projetil.add_collision_exception_with(s)
	get_node("/root").add_child(projetil)

	var aim_pos = get_parent().position
	projetil.rotation = (a - s.position).normalized().angle()
	projetil.position = s.position
	
	velocidade = Vector2(speed, 0).rotated(projetil.rotation)
	
	playerpos = s
	
	projeteis.append({
		"projetil" = projetil,
		"velocidade" = velocidade,
		"tick" = 0
	})

func _physics_process(delta):
	last_cooldown += 1
	for i in projeteis:
		var p = i["projetil"]
		
		if i["tick"] >= 200:
			p.queue_free()
			projeteis.erase(i)
			pass
		var collision = p.move_and_collide(i["velocidade"] * delta)
		
		if (collision):
			var collider = collision.get_collider()
			
			if (collider.get_class() == "CharacterBody2D"):
				print("Damage")
				collider.apply_damage(damage)
				
				var direcao = (p.position - playerpos.position).normalized()
				collider.aplicar_impulso(direcao, forca)
			p.queue_free()
			projeteis.erase(i)
		i["tick"] += 1
		

