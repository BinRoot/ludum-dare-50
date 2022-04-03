extends Node2D

onready var animated_sprite: AnimatedSprite = $AnimatedSprite
var target_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	target_position = get_viewport_rect().size / 2 + Vector2.DOWN * 5 + Vector2.RIGHT * 5
	animated_sprite.play()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		target_position = event.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var vector = target_position - global_position
	vector.x = tanh(vector.x)
	vector.y = tanh(vector.y)
	animated_sprite.speed_scale = max(0, vector.length()/200 + tanh(vector.length()))
	animated_sprite.flip_h = vector.x > 0
	position += vector * delta * 20


func _on_WanderTimer_timeout():
	var x_range = 400
	var y_range = 130
	target_position = get_viewport_rect().size / 2 + \
		Vector2.UP * (randi() % y_range - y_range / 2) + \
		Vector2.RIGHT * (randi() % x_range - x_range / 2) 
