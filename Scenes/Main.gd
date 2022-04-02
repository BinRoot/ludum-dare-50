extends Node2D

onready var input_ui: Control = $Control/InputUI
onready var game_over_ui: Control = $Control/GameOverUI
onready var line_edit: LineEdit = $Control/InputUI/LineEdit
onready var score_label: Label = $Control/ScoreUI/Score
onready var score_ui: Control = $Control/ScoreUI
onready var submit_button: Button = $Control/InputUI/SubmitButton
onready var conversation = $Conversation
var num_topic_changes = 0


func _ready():
	randomize()


func _process(delta):
	score_ui.rect_position = \
		get_viewport_rect().size / 2 + \
		Vector2.UP * get_viewport_rect().size.y * (0.4) + \
		Vector2.RIGHT * get_viewport_rect().size.x * (0.45)
	input_ui.rect_position = \
		get_viewport_rect().size / 2 + \
		Vector2.DOWN * get_viewport_rect().size.y * (0.35)
	conversation.position = \
		get_viewport_rect().size / 2
	if line_edit.text == "":
		submit_button.hide()
	else:
		submit_button.show()
	submit_button.disabled = line_edit.text == ""
	game_over_ui.rect_position = \
		get_viewport_rect().size / 2 + \
		Vector2.DOWN * get_viewport_rect().size.y * (0.35)
	var is_any_person_highlighted = false
	for person in get_tree().get_nodes_in_group("person"):
		if person.is_highlighted:
			is_any_person_highlighted = true
	if not game_over_ui.is_visible_in_tree():
		if is_any_person_highlighted:
			input_ui.show()
		else:
			input_ui.hide()

func _on_SubmitButton_button_down():
	conversation.set_topic(line_edit.text)
	line_edit.text = ""
	

func _on_LineEdit_text_entered(new_text):
	_on_SubmitButton_button_down()


func _on_Conversation_on_topic_change():
	score_ui.show()
	num_topic_changes += 1
	score_label.text = str(num_topic_changes)


func _on_Conversation_on_conversation_finished():
	input_ui.hide()
	game_over_ui.show()


func _on_TryAgainButton_pressed():
	get_tree().reload_current_scene()
