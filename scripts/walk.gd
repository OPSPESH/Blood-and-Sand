extends AudioStreamPlayer2D

const WALK_1 = preload("res://assets/sounds/walk/walk_1.wav")
const WALK_2 = preload("res://assets/sounds/walk/walk_2.wav")
const WALK_3 = preload("res://assets/sounds/walk/walk_3.wav")

var walking: bool
var _playing:bool
var attacking

func _ready() -> void:
	random()

func _process(_delta: float) -> void:
	attacking = $"../..".attack
	if $"../..".dir:
		walking = true
		if !_playing:
			random()
		_playing = true
	else:
		walking = false
		_playing = false
	if _playing:
		if attacking:
			self.playing = false

func _on_finished() -> void:
	random()

func random():
	if walking:
		var rand = randi_range(1,3)
		var track = str("walk_", rand)
		var sound = load(str("res://assets/sounds/walk/", track, ".wav"))
		self.stream = sound
		self.play()
