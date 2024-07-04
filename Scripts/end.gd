extends Control

@export var note: Node2D
var time = 0

func _process(delta):
	time += delta * 5
	note.rotation = sin(time * 1.1) * 0.05
	var q = cos(time) * 0.025 + 0.5
	var r = sin(time) * 0.025 + 0.5
	note.scale = Vector2(q, r)
	
func _on_got_it_button_up():
	get_tree().change_scene_to_file("res://Scenes/Menu.tscn")
