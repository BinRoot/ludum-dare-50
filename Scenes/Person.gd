extends Node2D

onready var label: Label = $Label
onready var color_rect: ColorRect = $ColorRect
onready var hand_sprite: AnimatedSprite = $HandSprite
onready var mouse_sprite: AnimatedSprite = $MouseSprite
onready var ding_sfx_player: AudioStreamPlayer2D = $DingSfxPlayer

enum State {
	IDLE,
	SAY
}

var current_state = State.IDLE

var is_highlighted = false
var is_out_of_topics = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func out_of_topics():
	is_out_of_topics = true

func say(utterance):
	is_out_of_topics = false
	current_state = State.SAY
	label.text = utterance
	mouse_sprite.play()
	ding_sfx_player.play()
	
func get_text():
	return label.text
	
func idle():
	is_out_of_topics = false
	current_state = State.IDLE
	mouse_sprite.stop()

func _process(delta):
	if current_state == State.IDLE:
		label.text = ""
		color_rect.color = Color.mediumpurple
	elif current_state == State.SAY:
		color_rect.color = Color.white
	elif current_state == State.HIGHLIGHTED:
		color_rect.color = Color.bisque
	if is_out_of_topics:
		hand_sprite.show()
		var elephants = get_tree().get_nodes_in_group("elephant")
		if len(elephants) > 0:
			var elephant_position: Vector2 = elephants[0].global_position
			var hand_offset = (elephant_position - global_position).normalized() * 50
			var angle = elephant_position.angle_to_point(global_position)
			hand_sprite.rotation_degrees = angle * (180/PI)
			hand_sprite.position = hand_offset
	else:
		hand_sprite.hide()

func _on_Area2D_area_entered(area):
	if current_state == State.IDLE and is_out_of_topics == false:
		is_highlighted = true

func _on_Area2D_area_exited(area):
	is_highlighted = false
