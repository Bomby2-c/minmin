extends Panel

var paused: bool
@export var whistle: Node3D
@export var music: AudioStreamPlayer
@export var pausemusic: AudioStreamPlayer
var pausepos = 0

func _process(_delta):
	if(Input.is_action_just_pressed("Pause")):
		PauseSwap()

func PauseSwap():
	paused = !paused
	if(paused):
		Engine.time_scale = 0
		whistle.Enabled = false
		visible = true
		pausepos = music.get_playback_position()
		music.stop()
		pausemusic.play()
	else:
		Engine.time_scale = 1
		whistle.Enabled = true
		visible = false
		music.play(pausepos)
		pausemusic.stop()


func _on_resume_button_up():
	PauseSwap()

func _on_retry_button_up():
	get_tree().change_scene_to_file("res://Scenes/MainTest.tscn")
	Engine.time_scale = 1

func _on_menu_button_up():
	get_tree().change_scene_to_file("res://Scenes/Menu.tscn")
	Engine.time_scale = 1
