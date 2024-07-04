extends Control

@export var logo: Node2D
@export var platform: Node3D
@export var minmin: Array[Node3D]
var time = 0

func OnPlayPressed():
	get_tree().change_scene_to_file("res://Scenes/intro.tscn")
func OnQuitPressed():
	get_tree().quit()
func _process(delta):
	time += delta * 5
	logo.rotation = sin(time) * 0.1
	logo.global_transform.origin.y = cos(time) * 10 + 125
	platform.rotate_y(delta / 2)
	platform.rotation.x = sin(time) * 0.05
	platform.global_transform.origin.y = cos(time) * 0.25
	minmin[0].get_node("AnimationPlayer").play("Idle")
	minmin[1].get_node("AnimationPlayer").play("Idle")
	minmin[2].get_node("AnimationPlayer").play("Idle")
	minmin[3].get_node("AnimationPlayer").play("Idle")
