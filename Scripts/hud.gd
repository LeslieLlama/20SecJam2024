extends Control

enum GameState {IDLE, PLAY_GAME}
var CurrentGameState = GameState.IDLE
var healthSprites: Array[Node] = []
var instruction_manual_active : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	healthSprites = [$Health1,$Health2,$Health3]
	Signals.GameStart.connect(_GameStart)
	Signals.GameEnd.connect(_GameEnd)
	Signals.TakeDamage.connect(_TakeDamage)
	Signals.RedDeath.connect(_RedDeath)
	$GameOverMessage.visible = false
	$GameWonMessage.visible = false
	$InstructionManual.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if CurrentGameState == GameState.IDLE:
		$TimeRemainingLabel.text = str("Fastest Time: 11.11 seconds")
	if CurrentGameState == GameState.PLAY_GAME:
		$TimeRemainingLabel.text = str(Globals.time_remaining," Seconds")

func _on_how_to_play_button_button_up() -> void:
	if instruction_manual_active == false:
		$InstructionManual.visible = true
		$HowToPlayButton.text = str("X")
	else: 
		$InstructionManual.visible = false
		$HowToPlayButton.text = str("?")
	instruction_manual_active = !instruction_manual_active
	

func _on_start_game_button_up() -> void:
	Signals.emit_signal("GameStart")
	$StartGame.visible = false
	CurrentGameState = GameState.PLAY_GAME
	
func _GameStart():
	$Title.visible = false
	$Health1.visible = true
	$Health2.visible = true
	$Health3.visible = true
	$Mouseblocker.visible = false
	Globals.health = 3
	
func _GameEnd(GameWon : bool):
	if(GameWon == false):
		$GameOverMessage.visible = true
		await get_tree().create_timer(2.0).timeout
		CurrentGameState = GameState.IDLE
		$GameOverMessage.visible = false
		$Mouseblocker.visible = true
		_ResetGame()
	else: 
		$GameWonMessage.visible = true
		await get_tree().create_timer(4.0).timeout
		CurrentGameState = GameState.IDLE
		$GameWonMessage.visible = false
	_ResetGame()

func _RedDeath():
	var tween = get_tree().create_tween()
	tween.tween_property($RedDeath, "modulate:a", 255, 1).set_trans(Tween.TRANS_SINE)
	tween.tween_property($RedDeath, "modulate:a", 1, 1).set_trans(Tween.TRANS_SINE)
	
func _ResetGame():
	
	$StartGame.visible = true
	await get_tree().create_timer(0.8).timeout
	$Title.visible = true
	
func _TakeDamage():
	healthSprites[Globals.health - 1].visible = false
	
	
