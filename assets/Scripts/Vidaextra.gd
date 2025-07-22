extends Area2D

@export var valor_cura: int = 1

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.is_in_group("slime"):
		if body.has_method("curar"):
			body.curar(valor_cura)
		queue_free()  # Remove o item da cena
