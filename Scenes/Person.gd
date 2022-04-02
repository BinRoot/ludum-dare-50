extends Node2D

onready var label: Label = $Label
onready var color_rect: ColorRect = $ColorRect
onready var highlight_color_rect: ColorRect = $HighlightColorRect

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
	
func get_text():
	return label.text
	
func idle():
	is_out_of_topics = false
	current_state = State.IDLE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_state == State.IDLE:
		label.text = ""
		color_rect.color = Color.mediumpurple
	elif current_state == State.SAY:
		color_rect.color = Color.white
	elif current_state == State.HIGHLIGHTED:
		color_rect.color = Color.bisque
	if is_highlighted:
		highlight_color_rect.show()
	else:
		highlight_color_rect.hide()

func _on_Area2D_area_entered(area):
	if current_state == State.IDLE and is_out_of_topics == false:
		is_highlighted = true

func _on_Area2D_area_exited(area):
	is_highlighted = false
