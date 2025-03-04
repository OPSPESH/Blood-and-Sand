extends CharacterBody2D

@export var up: bool = false
#@export var terminal_open: bool = true
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var attack: bool
var attack_type: String
var dir: Vector2

var dead:bool = false
var taking_damage: bool = false

var health
var speed

func _ready() -> void:
	Player.connect("update", update)
	up = false
	attack = false
	Global.player = self
	Global.alive = true
	
	health = Player.health
	speed = Player.speed

func update():
	health = Player.health
	speed = Player.speed

func get_input():
	dir = Input.get_vector("left", "right", "up", "down")
	velocity = dir * speed

func _physics_process(_delta: float) -> void:
	#if Input.is_action_just_pressed("toggle_terminal_menu"):
	#	terminal_open = !terminal_open
	if !dead:# and !terminal_open:
		if !attack:
			if Input.is_action_just_pressed("attack_1") or Input.is_action_just_pressed("attack_2"):
				attack = true
				if Input.is_action_just_pressed("attack_1"):
					attack_type = "light"
				elif Input.is_action_just_pressed("attack_2"):
					attack_type = "heavy"
				handle_attack_anim()
			get_input()
			move_and_slide()
			animation()

func animation():
	if !attack:
		if !velocity:
			sprite.play("idle")
		if velocity:
			sprite.play("run")
			toggle_flip()

func toggle_flip():
	var flip = Input.get_axis("left", "right")
	if flip == 1:
		sprite.flip_h = false
	elif flip == -1:
		sprite.flip_h = true
	damage_flip()

func damage_flip():
	var x = int(dir.x)
	var y = int(dir.y)
	if x == 1:
		$"left-right_player".scale.x = 1
	elif x == -1:
		$"left-right_player".scale.x = -1
	if y == -1:
		$"up-down_player".scale.y = 1
	elif y == 1:
		$"up-down_player".scale.y = -1

func handle_attack_anim():
	var x = int(dir.x)
	var y = int(dir.y)
	var anim:String
	if attack_type:
		if !x and !y: 
			anim = str(attack_type)
			sprite.play(anim)
		elif x:
			anim = str(attack_type)
			sprite.play(anim)
		elif y == -1:
			anim = str(attack_type, "_up")
			sprite.play(anim)
		elif y == 1:
			anim = str(attack_type, "_down")
			sprite.play(anim)
		toggle_damage_collision()
		set_damage()

func toggle_damage_collision():
	var collision_x = $"left-right_player".get_node("CollisionShape2D")
	var collision_y = $"up-down_player".get_node("CollisionShape2D")
	var x = int(dir.x)
	var y = int(dir.y)
	var wait_time:float
	if attack_type == "light":
		wait_time = 0.27
	elif attack_type == "heavy":
		wait_time = 0.6
	if !x and !y:
		collision_x.disabled = false
		await get_tree().create_timer(wait_time).timeout
		collision_x.disabled = true
	elif x:
		collision_x.disabled = false
		await get_tree().create_timer(wait_time).timeout
		collision_x.disabled = true
	elif y:
		collision_y.disabled = false
		await get_tree().create_timer(wait_time).timeout
		collision_y.disabled = true

func set_damage():
	var damage:int
	if attack_type == "light":
		damage = 1
	elif attack_type == "heavy":
		damage = 2
	Global.player_damage = damage

func _on_animated_sprite_2d_animation_finished() -> void:
	attack = false
	taking_damage = false

func die():
	dir = Vector2(0,0)
	dead = true
	Global.alive = false
	$CollisionShape2D.set_deferred("disabled", true)
	sprite.play("die")
	$sounds/death.play()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if "goblin" in area.name:
		if !taking_damage:
			var damage = Global.goblin_damage
			take_damage(damage)

func take_damage(damage):
	health -= damage
	taking_damage = true
	if health <= 0:
		health = 0
		$hitbox/CollisionShape2D.set_deferred("disabled", true)
		die()
	if !dead:
		sprite.play("hurt")
