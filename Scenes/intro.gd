extends Node3D

func _on_timer_timeout():
	get_tree().change_scene_to_file("res://Scenes/Tutorial.tscn")
func _on_timer_2_timeout():
	$crash.play()
