extends Node3D

@onready var minmin = preload("res://Scenes/min_min.tscn")
@onready var audio = preload("res://Scenes/prefabs/audio_pluck.tscn")

func _ready():
	get_tree().root.get_node("/root/Node3D/Ui").MinminInScene += 1

func _process(delta):
	$Seedmodel.transform.origin = lerp($Seedmodel.transform.origin, Vector3.ZERO, delta * 2)
	$Seedmodel/AnimationPlayer.play("wiggle")

func _on_area_3d_body_entered(body):
	if(body.is_in_group("Player")):
		var minny = minmin.instantiate()
		get_tree().root.get_child(0).add_child(minny)
		var aud = audio.instantiate()
		get_tree().get_root().add_child(aud)
		minny.global_transform.origin = global_transform.origin + Vector3.UP
		var nodeinquestion = get_node("/root/Node3D/whistle")
		nodeinquestion.add_minmin(minny)
		queue_free()
