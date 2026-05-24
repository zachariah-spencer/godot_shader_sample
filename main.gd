extends Node2D

const DESIGN_SIZE := Vector2(1280, 720)
const MAC_WINDOW_SCALE := 2.0

const SPRITE_SIZE := 720.0
const SPEED := 60.0
const WATER_ALPHA := 0.5

func _ready():
	setup_window_size()

	setup_water_layer($WaterLayerRight)
	setup_water_layer($WaterLayerUp)

	$Label.text = "flow like water"

	update_water_positions(0.0)
	update_label_position(0.0)

func setup_window_size() -> void:
	var screen := DisplayServer.window_get_current_screen()
	var scale := DisplayServer.screen_get_scale(screen)

	var window_size := Vector2i(DESIGN_SIZE)

	if OS.get_name() == "macOS" and scale > 1.0:
		window_size = Vector2i(DESIGN_SIZE * scale)

	DisplayServer.window_set_size(window_size)
	center_window()

func center_window() -> void:
	var screen := DisplayServer.window_get_current_screen()
	var screen_pos := DisplayServer.screen_get_position(screen)
	var screen_size := DisplayServer.screen_get_size(screen)
	var window_size := DisplayServer.window_get_size()

	DisplayServer.window_set_position(
		screen_pos + ((screen_size - window_size) / 2)
	)

func setup_water_layer(layer: Node2D) -> void:
	for sprite in layer.get_children():
		sprite.texture = preload("res://art/water.png")
		sprite.scale = Vector2(
			SPRITE_SIZE / sprite.texture.get_width(),
			SPRITE_SIZE / sprite.texture.get_height()
		)
		sprite.modulate.a = WATER_ALPHA

func _process(delta):
	var t := Time.get_ticks_msec() / 1000.0

	update_water_positions(t)
	update_label_position(t)

	$BlueSquare.position = get_global_mouse_position()

func update_water_positions(t: float) -> void:
	var screen_size := DESIGN_SIZE
	var offset := fmod(t * SPEED, SPRITE_SIZE)

	for i in range($WaterLayerRight.get_child_count()):
		var sprite := $WaterLayerRight.get_child(i)

		sprite.position = Vector2(
			-SPRITE_SIZE / 2.0 + i * SPRITE_SIZE + offset,
			screen_size.y / 2.0
		)

	var columns := int(ceil(screen_size.x / SPRITE_SIZE) + 2)

	for i in range($WaterLayerUp.get_child_count()):
		var sprite := $WaterLayerUp.get_child(i)

		var column := i % columns
		var row := i / columns

		sprite.position = Vector2(
			-SPRITE_SIZE / 2.0 + column * SPRITE_SIZE,
			screen_size.y + SPRITE_SIZE / 2.0 - row * SPRITE_SIZE - offset
		)

func update_label_position(t: float) -> void:
	var screen_size := DESIGN_SIZE
	var label_size = $Label.size

	var y_progress := fmod(t * 0.12, 1.0)
	var x_progress := fmod(t * 0.06, 1.0)

	$Label.position = Vector2(
		lerp(screen_size.x * 0.2, screen_size.x, x_progress),
		lerp(screen_size.y, -label_size.y, y_progress)
	)
