extends CharacterBody2D

@export var speed = 400
@export var up: bool = false
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var attacking: bool
var attack: String
var input_direction: Vector2

func _ready() -> void:
	up = false
	attacking = false
	Global.player = self
	toggle_layer()

func get_input():
	input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(_delta: float) -> void:
	var move_faceing = Input.get_axis("left", "right")
	if !attacking:
		if Input.is_action_just_pressed("attack_1") or Input.is_action_just_pressed("attack_2"):
			attacking = true
			if Input.is_action_just_pressed("attack_1"):
				attack = "light"
			elif Input.is_action_just_pressed("attack_2"):
				attack = "heavy"
			handle_attack_anim(attack)
	if !attacking:
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
func handle_attack_anim(attack):
	var x = int(input_direction.x)
	var y = int(input_direction.y)
	if attack:
		if !x and !y: 
			var anim = str(attack)
			sprite.play(anim)
		elif x:
			var anim = str(attack)
			sprite.play(anim)
		elif y == -1:
			var anim = str(attack, "_up")
			sprite.play(anim)
		elif y == 1:
			var anim = str(attack, "_down")
			sprite.play(anim)



func _on_animated_sprite_2d_animation_finished() -> void:
	attacking = false
func toggle_layer():
	if up == false:
		self.collision_layer = 1
		self.collision_mask = 1
		self.z_index = 0
	elif up == true:
		self.collision_layer = 2
		self.collision_mask = 2
		self.z_index = 2
func _on_layer_2_body_exited(body: Node2D) -> void:
	if body == $".":
		up = true
		toggle_layer()
func _on_layer_1_body_exited(body: Node2D) -> void:
	if body == $".":
		up = false
		toggle_layer()
