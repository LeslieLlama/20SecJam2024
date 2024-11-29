extends Node3D

enum GameState {IDLE, PLAY_GAME}
var CurrentGameState = GameState.IDLE
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.GameStart.connect(_GameStart)
	Signals.TakeDamage.connect(_TakeDamage)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Globals.time_remaining = $GameTimer.time_left

func _GameStart():
	$GameTimer.start()
	print("game started")
	
func _TakeDamage():
	if Globals.health > 0:
		Globals.health -= 1
	if Globals.health == 0:
		Signals.emit_signal("GameEnd")


func _on_game_timer_timeout() -> void:
	Signals.emit_signal("GameEnd")
