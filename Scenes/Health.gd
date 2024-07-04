extends Sprite3D

@export var Health: float
var starthealth = 0
@export var Healthbar: TextureProgressBar

func _ready():
	starthealth = int(Health)
	Healthbar.value = 100

func hurt(ammount: float):
	Health -= ammount
	var normalizedHealth = Health / starthealth
	Healthbar.value = int(lerp(0, 100, normalizedHealth))
	if(Health <= 0):
		get_parent().die()
