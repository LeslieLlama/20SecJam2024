extends Camera3D
var idleRotationSpeed = 3
@export var rotation_pos : Vector3

enum GameState {IDLE, PLAY_GAME}
var CurrentGameState = GameState.IDLE
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.GameStart.connect(_StartGame)
	Signals.GameEnd.connect(_EndGame)

func _StartGame():
	rotation_pos.y = 0
	CurrentGameState = GameState.PLAY_GAME
func _EndGame():
	CurrentGameState = GameState.IDLE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#mode : idle
	if CurrentGameState == GameState.IDLE:
		rotation_pos.y += delta*idleRotationSpeed
	#mode : active control
	if CurrentGameState == GameState.PLAY_GAME:
		if Input.is_action_just_released("move_right"):
			rotation_pos.y -= 90
		if Input.is_action_just_released("move_left"):
			rotation_pos.y += 90

func _physics_process(delta: float) -> void:
	
	#rotation_degrees.y = rotation_pos
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(self, "rotation_degrees", rotation_pos, 0.2)
	
