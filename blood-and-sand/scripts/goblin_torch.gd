extends CharacterBody2D

@export var speed = 100
@export var up: bool = true
@export var health:int = 2
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

var dir: Vector2
var player: CharacterBody2D

var dead:bool
var taking_damage:bool = false
var knockback:bool = false

func _ready() -> void:
	toggle_layer()

func _process(_delta: float) -> void:
	dir.x = abs(velocity.x) / velocity.x
	move()
	if !taking_damage:
		animation(dir.x)

func move():
	player = Global.player
	if knockback:
		velocity = position.direction_to(player.position) * -250
		move_and_slide()
		await get_tree().create_timer(0.3).timeout
		knockback = false
	elif !taking_damage:
		if position.distance_to(player.position) > 50:
			velocity = to_local(nav_agent.get_next_path_position()).normalized() * speed
		else:
			velocity = Vector2(0,0)
	move_and_slide()
	

func makepath():
	player = Global.player
	nav_agent.target_position = player.global_position

func _on_timer_timeout() -> void:
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
	knockback = true
	if health <= 0:
		health = 0
		get_tree().queue_delete(self)
	sprite.play("hurt")

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

func _on_hitbox_area_entered(area: Area2D) -> void:
	if !taking_damage:
		if area == Global.player_attack_zone_x or Global.player_attack_zone_y:
			var damage = Global.player_damage
			take_damage(damage)


func _on_animated_sprite_2d_animation_finished() -> void:
	taking_damage = false
