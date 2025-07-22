extends CharacterBody2D

var tempo_vida = 4
var tick 

func _ready():
	tick = 0


func _physics_process(delta):
	tick += 1
	if tick >= tempo_vida:
		self.queue_free()
