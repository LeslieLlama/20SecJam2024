extends MeshInstance3D

# link to the 3D model used for this scene: https://www.fab.com/listings/7f25d2ac-338e-4778-8b4f-c7f283b66e87

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _instant_death():
	Signals.emit_signal("RedDeath")
	Signals.emit_signal("GameEnd", false);

func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
			_instant_death()
