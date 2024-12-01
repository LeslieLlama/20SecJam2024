extends Node3D

enum GameState {IDLE, PLAY_GAME}
var CurrentGameState = GameState.IDLE
@export var Clocks: Array[Node] = []
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
	_setClockTime()
	_PickClock()
	
	
func _PickClock():
	var random = RandomNumberGenerator.new()
	random.randomize()
	var val = (random.randi_range(0, Clocks.size()))
	print(val-1)
	var gnome_clock = Clocks[val-1]
	gnome_clock._is_gnomed()
	
func _setClockTime():
	var random = RandomNumberGenerator.new()
	random.randomize()
	var hour = random.randi_range(0, 12)
	var minute : float = random.randi_range(0, 60)
	minute /= 100
	Globals.clock_time = hour+minute
	for x in Clocks:
		x._set_clock()
	
func _TakeDamage():
	if Globals.health > 0:
		Globals.health -= 1
	if Globals.health == 0:
		Signals.emit_signal("GameEnd")


func _on_game_timer_timeout() -> void:
	Signals.emit_signal("GameEnd")
