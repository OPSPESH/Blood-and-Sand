extends CharacterBody2D

@export var speed = 100
@export var chase: bool = true
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var dir: Vector2
var player: CharacterBody2D

#func _process(delta: float) -> void:
	#move()
	#animation(dir.x)

func move():
	if chase:
		player = Global.player
		velocity = position.direction_to(player.position) * speed
		dir.x = abs(velocity.x) / velocity.x
	if !chase:
		velocity = dir * speed
	move_and_slide()

func _on_timer_timeout() -> void:
	$Timer.wait_time = choose([1.0, 1.5, 2.0])
	if !chase:
		dir = choose([Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2. RIGHT])
		
func choose(array):
	array.shuffle()
	return array.front()

func animation(dir):
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
