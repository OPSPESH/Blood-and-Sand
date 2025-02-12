extends CharacterBody2D

@export var speed = 100
@export var up: bool = true
@export var health:int = 2
@export var chase: bool = true
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

var dir: Vector2
var player: CharacterBody2D
var player_dir: Vector2
var dead:bool
var taking_damage:bool = false

func _ready() -> void:
	player = Global.player

func _physics_process(_delta: float) -> void:
	dir.x = abs(velocity.x) / velocity.x
	dir.y = abs(velocity.y) / velocity.y
	print(position.distance_to(player.position))
	if chase:
		if !taking_damage:
			move()
			animation(dir.x)
			damage_flip()
		elif taking_damage:
			knockback()

func move():
	player = Global.player
	if position.distance_to(player.position) > 75:
		velocity = to_local(nav_agent.get_next_path_position()).normalized() * speed
	else:
		velocity = Vector2(0,0)
	move_and_slide()

func damage_flip():
	var x = int(dir.x)
	var y = int(dir.y)
	if x == 1:
		$"left_right goblin".scale.x = 1
	elif x == -1:
		$"left_right goblin".scale.x = -1
	if y == -1:
		$"up_down goblin".scale.y = 1
	elif y == 1:
		$"up_down goblin".scale.y = -1

func makepath():
	player = Global.player
	nav_agent.target_position = player.global_position

func _on_makepath_timeout() -> void:
	makepath()

func animation(direction):
	if !velocity:
		sprite.play("idle")
	if velocity:
		sprite.play("run")
		toggle_flip(direction)

func toggle_flip(direction):
	if direction == 1:
		sprite.flip_h = false
	if direction == -1:
		sprite.flip_h = true

func take_damage(damage):
	health -= damage
	taking_damage = true
	if health <= 0:
		health = 0
		get_tree().queue_delete(self)
	sprite.play("hurt")
	player_dir = position.direction_to(player.position)
	$timers/knockback.start(0.3)
	knockback()

func knockback():
	velocity = -position.direction_to(player.position) * 200
	move_and_slide()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if "player" in area.name:
		if !taking_damage:
			var damage = Global.player_damage
			take_damage(damage)

func _on_animated_sprite_2d_animation_finished() -> void:
	taking_damage = false


func _on_knockback_timeout() -> void:
	taking_damage = false
