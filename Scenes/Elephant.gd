extends Node2D

var target_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	target_position = get_viewport_rect().size / 2 + Vector2.DOWN * 70 + Vector2.RIGHT * 70

func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		target_position = event.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var vector = target_position - global_position
	position += vector * delta
