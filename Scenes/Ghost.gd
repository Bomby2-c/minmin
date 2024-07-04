extends Sprite3D

func _ready():
	$AudioStreamPlayer.play()
	$Timer.start()
	get_tree().root.get_node("/root/Node3D/Ui").MinminInScene -= 1
func _process(delta):
	translate(Vector3(0, 10, 0) * delta)
func Delete():
	get_parent().remove_child(self)
