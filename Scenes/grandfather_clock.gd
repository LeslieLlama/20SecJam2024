extends Node3D
var currentTime : float = 0
var is_gnomed : bool = false
var at_rest_position : Vector3 
var baseSecondsHandSpeed : float = 6
var secondsHandSpeed : float
var secondsHandRunning : bool = false
var base_Y_Rotation : float
var starting_position : Vector3 = Vector3(0,0,0)
var altered_position : Vector3 = Vector3(-5,0,0)
var has_moved : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	at_rest_position = $Moveables.position
	$GnomeModel.visible = false
	Signals.GameStart.connect(_GameStart)
	Signals.GameEnd.connect(_GameEnd)
	pass

func _GameStart():
	#reset to the normal value in the case where the previous game inverted the speed
	secondsHandSpeed = baseSecondsHandSpeed
	secondsHandRunning = true
	$Moveables.position = starting_position
	$GnomeModel.visible = false
	
func _GameEnd(GameWon:bool):
	is_gnomed = false
	secondsHandRunning = false
	$Moveables/SecondsHand.rotation_degrees.z = 0
	$Moveables.rotation_degrees.y = base_Y_Rotation

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if secondsHandRunning == true:
		$Moveables/SecondsHand.rotation_degrees.z += secondsHandSpeed*delta
	
func _check_gnome():
	var tween = get_tree().create_tween()
	if(has_moved == false):
		tween.tween_property($Moveables, "position", altered_position, 1).set_trans(Tween.TRANS_SINE)
	else: 
		tween.tween_property($Moveables, "position", starting_position, 1).set_trans(Tween.TRANS_SINE)
	has_moved = !has_moved
	#tween.tween_property($Moveables, "position", at_rest_position, 1).set_trans(Tween.TRANS_SINE)
	#grandfather clock does not take a health point when moved/checked
	if is_gnomed == true:
		Signals.emit_signal("GameEnd", true)
	
func _set_clock():
	var hour = floor(Globals.clock_time)
	var minute : float = Globals.clock_time - hour
	$Moveables/DigitalReadout.text = str(hour,":",(minute*100))
	$Moveables/HoursHand.rotation_degrees.z = hour * 30
	$Moveables/MinutesHand.rotation_degrees.z = minute * 600
	
func _is_gnomed():
	is_gnomed = true
	$GnomeModel.visible = true
	var random = RandomNumberGenerator.new()
	random.randomize()
	var behavior = random.randi_range(0,2)
	match behavior:
		0: #Clock Time is Wrong Behavior
			var hour = random.randi_range(0, 12)
			var minute : float = random.randi_range(0, 60)
			$Moveables/DigitalReadout.text = str(hour * 30,":",minute * 6)
			$Moveables/HoursHand.rotation_degrees.z = hour * 30
			$Moveables/MinutesHand.rotation_degrees.z = minute * 6
		1: #Seconds hand is running backwards behavior
			secondsHandSpeed *= -1
		2: 
			$Moveables.rotation_degrees.y += 180
	
	

func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
			_check_gnome()
