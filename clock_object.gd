extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _check_gnome():
	self.get_active_material(0).albedo_color = Color("fa7997")
	await get_tree().create_timer(1.0).timeout
	self.get_active_material(0).albedo_color = Color("ffffff")
	Signals.emit_signal("TakeDamage")
	
	


func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
			_check_gnome()
