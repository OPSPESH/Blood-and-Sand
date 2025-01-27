extends CharacterBody2D

@export var speed = 400
@export var layer: String
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var attacking: bool
var attack: String

func _ready() -> void:
	layer = "ground"
	attacking = false
	Global.player = self

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(_delta: float) -> void:
	var move_faceing = Input.get_axis("left", "right")
	var attack_faceing = Input.get_axis("up", "down")
	
	if !attacking:
		if Input.is_action_just_pressed("attack_1") or Input.is_action_just_pressed("attack_2"):
			attacking = true
			if Input.is_action_just_pressed("attack_1"):
				attack = "light"
			elif Input.is_action_just_pressed("attack_2"):
				attack = "heavy"
			handle_attack_anim(attack, attack_faceing)
	get_input()
	move_and_slide()
	animation(move_faceing)


func animation(dir):
	if !attacking:
		if !velocity:
			sprite.play("idle")
		if velocity:
			sprite.play("run")
			toggle_flip(dir)

func toggle_flip(dir):
	if dir == 1:
		sprite.flip_h = false
	if dir == -1:
		sprite.flip_h = true

@warning_ignore("shadowed_variable")
func handle_attack_anim(attack, dir):
	if attack:
		if !dir:
			var anim = str(attack)
			sprite.play(anim)
		if dir == -1:
			var anim = str(attack, "_up")
			sprite.play(anim)
		if dir == 1:
			var anim = str(attack, "_down")
			sprite.play(anim)

func _on_animated_sprite_2d_animation_finished() -> void:
	attacking = false
