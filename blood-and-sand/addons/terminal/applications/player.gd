extends TerminalApplication

#health - get print health
#set_health
#speed - get the speed
#set_speed

func _init():
	name="Echo"
	description="Write arguments to the standard output"

func run(terminal : Terminal, params : Array):
	var cmd = params[0]
	if cmd == "health":
		terminal.add_to_log(str(Player.health))
	elif cmd == "speed":
		terminal.add_to_log(str(Player.speed)) 
	elif cmd == "set_health":
		print(typeof(int(params[1])))
