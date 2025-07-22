extends Projetil

var flecha = load("res://assets/Scripts/Classes/Ranger/Skills/Flecha/Flecha.tscn")
var arco = load("res://assets/Scripts/Classes/Ranger/ArcoAni.tscn")
var arcoani
var cooldown = 40
var last_cooldown = 10
var casting_time = 10

var projeteis = []

var time = 0
var casting = 0

var playerpos

var forca = 500



func _ready():
	speed = 500



func fire(s,a, hardpoint = self):
	if last_cooldown < cooldown: return
	else: last_cooldown = 0
	arcoani = arco.instantiate()
	s.add_child(arcoani)
	
	var direcao = (a - s.position).normalized()
	var ponto_medio = s.position + direcao
	arcoani.global_position = ponto_medio
	arcoani.look_at(a)
	
	arcoani.play("default")
	casting = 0
	Flecha(s, a)


func Flecha(s, a):
	await arcoani.animation_finished

	arcoani.queue_free()
	var velocidade = Vector2()
	var projetil = flecha.instantiate()
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
	casting += 1
	
	for i in projeteis:
		var p = i["projetil"]
		
		if i["tick"] >= 200:
			p.queue_free()
			projeteis.erase(i)
			pass
		var collision = p.move_and_collide(i["velocidade"] * delta)
		
		if (collision):
			var collider = collision.get_collider()
			
			if collider.get_class() == "CharacterBody2D" and collider.is_in_group("slime"):
				print("Damage")
				collider.apply_damage(damage)
				
				var direcao = (p.position - playerpos.position).normalized()
				collider.aplicar_impulso(direcao, forca)
			p.queue_free()
			projeteis.erase(i)
		i["tick"] += 1


