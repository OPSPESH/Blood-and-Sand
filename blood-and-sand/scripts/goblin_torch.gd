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
var alive: bool

var attacking: bool = false

func _ready() -> void:
	player = Global.player
	alive = Global.alive

func _physics_process(_delta: float) -> void:
	alive = Global.alive
	if !dead and !attacking and alive:
		dir.x = abs(velocity.x) / velocity.x
		dir.y = abs(velocity.y) / velocity.y
		if chase:
			if !taking_damage:
				move()
				animation(dir.x)
			elif taking_damage:
				knockback()
		if position.distance_to(player.position) < 75:
			attack()

func attack():
	if !attacking:
		var rand = randi() % 10
		if rand == 9:
			attacking = true
		set_damage()

func set_damage():
	var damage: int
	if attacking:
		damage = 5
		Global.goblin_damage = damage
		attack_anim()
		await get_tree().create_timer(0.5).timeout
		attacking = false

func attack_anim():
	var x = int(dir.x)
	var y = int(dir.y)
	var anim:String
	if !x and !y: 
		anim = str("light")
		sprite.play(anim)
	elif x:
		anim = str("light")
		sprite.play(anim)
	elif y == -1:
		anim = str("light", "_up")
		sprite.play(anim)
	elif y == 1:
		anim = str("light", "_down")
		sprite.play(anim)
	toggle_damage_collision()

func toggle_damage_collision():
	var collision = $goblin_attack.get_node("CollisionShape2D")
	var wait_time:float = 0.27
	collision.disabled = false
	await get_tree().create_timer(wait_time).timeout
	collision.disabled = true

func move():
	if alive:
		player = Global.player
		if position.distance_to(player.position) > 50:
			velocity = to_local(nav_agent.get_next_path_position()).normalized() * speed
		else:
			velocity = Vector2(0,0)
		move_and_slide()

func makepath():
	nav_agent.target_position = player.global_position

func _on_makepath_timeout() -> void:
	if alive:
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
		die()
	if !dead:
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

func die():
	dead = true
	$CollisionShape2D.set_deferred("disabled", true)
	sprite.play("dead")
	await get_tree().create_timer(1.7).timeout
	sprite.play("bury")
	await get_tree().create_timer(0.7).timeout
	get_tree().queue_delete(self)
