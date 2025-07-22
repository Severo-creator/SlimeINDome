extends SlimeClass

class_name MagoSlime

var skill_1
var skill_2
var skill_3



func _init():
	vidaMaxima = 3
	vidaAtual = 3
	leveza = 3
	poder = 5
	

func get_vida():
	return vidaMaxima
	
func _ready():
	var skill_1_cena = load("res://assets/Scripts/Classes/Mago/Skills/FireBall/FireballSkill.tscn")
	skill_1 = skill_1_cena.instantiate()
	add_child(skill_1)
	
	var skill_2_cena = load("res://assets/Scripts/Classes/Mago/Skills/Explosao/ExplosaoSkill.tscn")
	skill_2 = skill_2_cena.instantiate()
	add_child(skill_2)
	
	
	
	
func usar_skill_1(s, a):
	if (skill_1 != null):
		skill_1.fire(s, a)
		
func usar_skill_2(s, a):
	if (skill_2 != null):
		skill_2.fire(s, a)

func usar_skill_3():
	if (skill_3 != null):
		skill_3.fire()

	
	

	
	
	

