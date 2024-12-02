extends Node3D
var currentTime : float = 0
var is_gnomed : bool = false
var at_rest_position : Vector3 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	at_rest_position = $Moveables.position
	$GnomeModel.visible = false
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _check_gnome():
	var tween = get_tree().create_tween()
	tween.tween_property($Moveables, "position", Vector3(0,5,0), 1).set_trans(Tween.TRANS_SINE)
	tween.tween_property($Moveables, "position", at_rest_position, 1).set_trans(Tween.TRANS_SINE)
	if is_gnomed == false:
		Signals.emit_signal("TakeDamage")
	else:
		Signals.emit_signal("GameWon")
	
func _set_clock():
	var hour = floor(Globals.clock_time)
	var minute : float = Globals.clock_time - hour
	$Moveables/TestLabel.text = str(hour,":",(minute*100))
	$Moveables/HoursHand.rotation_degrees.z = hour * 30
	$Moveables/MinutesHand.rotation_degrees.z = minute * 600
	
func _is_gnomed():
	is_gnomed = true
	$GnomeModel.visible = true
	var random = RandomNumberGenerator.new()
	random.randomize()
	var hour = random.randi_range(0, 12)
	var minute : float = random.randi_range(0, 60)
	$Moveables/TestLabel.text = str(hour,":",minute)
	$Moveables/HoursHand.rotation_degrees.z = hour * 30
	$Moveables/MinutesHand.rotation_degrees.z = minute * 6

func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
			_check_gnome()
