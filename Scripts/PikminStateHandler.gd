extends Node3D

@export var NavMeshCode: Node3D
@export var CurState: States
@onready var Corpse = preload("res://Scenes/min_min_ghost.tscn")
var whistle
var curattack

enum States{
	Idle,
	Follow,
	Sent,
	Carry,
	Attack,
	Dead
}

func _process(delta):
	if(CurState == States.Idle):
		NavMeshCode.Enabled = false
	if(CurState == States.Carry):
		NavMeshCode.Enabled = false
	if(CurState == States.Follow):
		NavMeshCode.Enabled = true
	if(CurState == States.Sent):
		NavMeshCode.Enabled = true
	if(CurState == States.Dead):
		var deadchild = Corpse.instantiate()
		get_tree().get_root().add_child(deadchild)
		deadchild.global_transform.origin = global_transform.origin
		get_parent().queue_free()
	if(CurState == States.Attack):
		NavMeshCode.Enabled = true
		if(is_instance_valid(curattack)):
			curattack.Health.hurt(delta)
	if(global_transform.origin.y < -100):
		die()

func Called(whis):
	if(CurState == States.Idle || CurState == States.Sent || CurState == States.Carry):
		whistle = whis
		CurState = States.Follow
func die():
	if(CurState == States.Follow):
		whistle.remove_minmin(get_parent())
	CurState = States.Dead
func Attack(enemy: Node3D):
	curattack = enemy

