extends Sprite2D

func _process(delta):
	if Input.is_action_pressed("Click"): Input.set_custom_mouse_cursor(texture.get_frame_texture(1), Input.CURSOR_ARROW, Vector2(texture.get_width(), texture.get_height()) / 2)
	else: Input.set_custom_mouse_cursor(texture.get_frame_texture(0), Input.CURSOR_ARROW, Vector2(texture.get_width(), texture.get_height()) / 2)
