@tool
extends Sprite2D

@export var texture_path: String = ""
@export var target_size: Vector2 = Vector2.ZERO
@export var fallback_node_path: NodePath
@export var keep_existing_if_missing := true
@export var preserve_initial_visibility := false

func _ready():
	var should_remain_hidden = preserve_initial_visibility and not visible
	refresh()
	if should_remain_hidden:
		visible = false
		_set_fallback_visible(false)

func refresh(path_override := "") -> bool:
	var path = path_override if path_override != "" else texture_path
	var loaded_texture: Texture2D = null
	if path != "" and ResourceLoader.exists(path):
		loaded_texture = load(path)

	if loaded_texture != null:
		texture = loaded_texture
		visible = true
		_fit_to_target()
		_set_fallback_visible(false)
		return true

	var has_existing_texture = texture != null and keep_existing_if_missing
	visible = has_existing_texture
	_fit_to_target()
	_set_fallback_visible(not has_existing_texture)
	return false

func _fit_to_target():
	if texture == null or target_size == Vector2.ZERO:
		return
	var texture_size = texture.get_size()
	if texture_size.x <= 0.0 or texture_size.y <= 0.0:
		return
	scale = Vector2(target_size.x / texture_size.x, target_size.y / texture_size.y)

func _set_fallback_visible(value: bool):
	if String(fallback_node_path) == "":
		return
	var fallback = get_node_or_null(fallback_node_path)
	if fallback != null:
		fallback.visible = value
