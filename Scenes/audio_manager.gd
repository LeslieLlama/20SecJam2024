extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.RedDeath.connect(_red_death)
	Signals.GameStart.connect(_game_start)
	Signals.GameEnd.connect(_game_end)
	
	$IdleMenuMusic.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _game_start():
	$IdleMenuMusic.stop()
	$ClockTicking.play()
	$GameActiveMusic.play()
func _game_end(game_won : bool):
	if game_won == true:
		$GameWonSound.play()
	else:
		$GameFailedSound.play()
		
	$GameActiveMusic.stop()
	$ClockTicking.stop()
	await get_tree().create_timer(1.0).timeout
	$IdleMenuMusic.play()

func _red_death():
	$RedDeathSound.play()
