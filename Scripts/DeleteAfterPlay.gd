extends AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	self.play()

func _process(_delta):
	if(!self.playing):
		queue_free()
