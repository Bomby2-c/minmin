extends Control

@export var Whistle: Node3D
@export var PikminCount: Label
@export var sun: Node2D
@export var XstartXend: Vector2
@export var SunRotstartSunRotend: Vector2
@export var AudioPlayer: AudioStreamPlayer
@export var AudioSfx: AudioStreamPlayer
@export var BigSun: Node3D
@export var NightLight: Node3D
@onready var morningOst = preload("res://Audio/minminmorning.ogg")
@onready var middayOst = preload("res://Audio/minminmidday.ogg")
@onready var eveningOst = preload("res://Audio/minminevening.ogg")
var DayTime = 420
var time = 0
var MinminInScene = 0

func _process(delta):
	time += delta
	if(Input.is_action_pressed("KeyOne") && Input.is_action_pressed("KeyZero")):
		time += delta * 100
	PikminCount.text = str(Whistle.MinMen.size()) + "/" + str(MinminInScene)
	sun.rotation = time
	sun.global_transform.origin.x = lerp(XstartXend.x, XstartXend.y, time / DayTime)
	BigSun.rotation.x = lerp_angle(SunRotstartSunRotend.x, SunRotstartSunRotend.y, time / DayTime)
	
	if(time / DayTime >= 1):
		get_tree().change_scene_to_file("res://Scenes/Death.tscn")
	if(time / DayTime >= 0.33 && AudioPlayer.stream == morningOst):
		AudioPlayer.stream = middayOst
		AudioSfx.play()
	if(time / DayTime >= 0.66 && AudioPlayer.stream == middayOst):
		AudioPlayer.stream = eveningOst
		NightLight.visible = true
		AudioSfx.play()

func _on_soundeffect_finished():
	AudioPlayer.play()
	
func YouWin():
	get_tree().change_scene_to_file("res://Scenes/outtro.tscn")
