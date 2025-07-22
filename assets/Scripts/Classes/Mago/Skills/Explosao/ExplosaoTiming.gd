extends CharacterBody2D



func _ready():

	await $AnimatedSprite2D.animation_finished
	self.queue_free()


func _physics_process(delta):
	
