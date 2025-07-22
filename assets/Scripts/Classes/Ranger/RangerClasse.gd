extends SlimeClass

class_name RangerSlime


var skill_1
var skill_2

func _init():
	vidaMaxima = 3
	vidaAtual = 3
	leveza = 5
	poder = 4
	

func get_vida():
	return vidaMaxima
	
func _ready():
	var skill_1_cena = load("res://assets/Scripts/Classes/Ranger/Skills/Flecha/FlechaSkill.tscn")
	skill_1 = skill_1_cena.instantiate()
	add_child(skill_1)
	
	var skill_2_cena = load("res://assets/Scripts/Classes/Ranger/Skills/Salto/SaltoSkill.tscn")
	skill_2 = skill_2_cena.instantiate()
	add_child(skill_2)
	
	
	
	
func usar_skill_1(s, a):
	if (skill_1 != null):
		skill_1.fire(s, a)
		
func usar_skill_2(s, a):
	if (skill_2 != null):
		skill_2.fire(s, a)
