extends CanvasLayer

@export var main: bool = true
var render: bool
var time: int = 0

func _ready() -> void:
	$".".visible = main
	if OS.is_debug_build():
		render = true

func _process(_delta: float) -> void:
	if render and main:
		var fps = Engine.get_frames_per_second()
		var architecture = Engine.get_architecture_name()
		var frames = Engine.get_frames_drawn()
		
		$GridContainer/fps.text = str(fps)
		$GridContainer/architecture.text = str(architecture)
		$GridContainer/frames.text = str(frames)
		$GridContainer/time.text = str(time)


func _on_time_timeout() -> void:
	time += 1
