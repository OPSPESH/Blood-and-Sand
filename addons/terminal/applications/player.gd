extends TerminalApplication

#health - get print health
#set_health
#speed - get the speed
#set_speed

func _init():
	name="player"
	description="Write arguments to the standard output"

func run(terminal : Terminal, params : Array):
	if len(params) == 0:
		terminal.add_to_log("Usage: player <health/ speed/ set_health/ set_speed>")
	else:
		var cmd = params[0]
		if cmd == "health":
			terminal.add_to_log(str(Player.health))
		elif cmd == "speed":
			terminal.add_to_log(str(Player.speed))
		elif cmd == "set_health":
			if params.size() < 2:
				terminal.add_to_log("Usage: player set_health <value>")
				return
			var good:bool
			for i in range(len(params[1])):
				if params[1].unicode_at(i) >= 48 and params[1].unicode_at(i) <= 57:
					good = true
				else:
					good = false
					break
			if !good:
				terminal.add_to_log("Please enter a number")
			else:
				var health = int(params[1])
				Player.set_health(health)
		elif cmd == "set_speed":
			if params.size() < 2:
				terminal.add_to_log("Usage: player set_speed <value>")
				return
			var good:bool
			for i in range(len(params[1])):
				if params[1].unicode_at(i) >= 48 and params[1].unicode_at(i) <= 57:
					good = true
				else:
					good = false
					break
			if !good:
				terminal.add_to_log("Please enter a number")
			else:
				var speed = int(params[1])
				Player.set_speed(speed)
