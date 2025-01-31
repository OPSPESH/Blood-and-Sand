extends CharacterBody2D

@export var speed = 100
@export var chase: bool
@export var up: bool = true
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

var dir: Vector2
var player: CharacterBody2D

func _ready() -> void:
	toggle_layer()

func _process(_delta: float) -> void:
	dir.x = abs(velocity.x) / velocity.x
	move()
	animation(dir.x)

func move():
	player = Global.player
	if chase == true:
		if position.distance_to(player.position) > 50:
			var dir = to_local(nav_agent.get_next_path_position()).normalized()
			velocity = dir * speed
		else:
			velocity = Vector2(0,0)
		move_and_slide()
	elif chase == false:
		velocity = Vector2(0,0)

func makepath():
	if chase == true:
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
