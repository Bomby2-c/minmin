extends Control

@export var image: Sprite2D
@export var images: Array[Texture2D]
@export var noise: AudioStreamPlayer
@export var music: AudioStreamPlayer
@export var finaldaysfx: AudioStream
@export var finalday: AnimationPlayer
@export var timie: Timer
var current = 0
var rng = RandomNumberGenerator.new()

func _process(_delta):
	image.global_scale = lerp(image.global_scale, Vector2.ONE * 0.45, 0.1)

func Next():
	current += 1
	if current == images.size():
		current = images.size() - 1
	else:
		image.global_scale = Vector2.ONE * 0.5
		noise.pitch_scale = rng.randf_range(0.9, 1.1)
		noise.play()
	image.texture = images[current]
	
func Back():
	if current != 0:
		current -= 1
		image.global_scale = Vector2.ONE * 0.5
		noise.pitch_scale = rng.randf_range(0.9, 1.1)
		noise.play()
	image.texture = images[current]
	
func GotIt():
	music.stream = finaldaysfx
	music.play()
	timie.start()
	finalday.play("CrossFade")

func loadscene():
	get_tree().change_scene_to_file("res://Scenes/MainTest.tscn")
