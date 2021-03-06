extends Node2D

onready var analytics_api = $Analytics
onready var input_ui: Control = $Control/InputUI
onready var game_over_ui: Control = $Control/GameOverUI
onready var line_edit: LineEdit = $Control/InputUI/LineEdit
onready var score_label: Label = $Control/ScoreUI/Score
onready var score_ui: Control = $Control/ScoreUI
onready var conversation = $Conversation
onready var arrow_sprite_1 = $Control/InputUI/ArrowSprite1
onready var arrow_sprite_2 = $Control/InputUI/ArrowSprite2
onready var cross_sprite = $Control/ScoreUI/CrossSprite
onready var music_player: AudioStreamPlayer2D = $Music
onready var game_over_audio_player: AudioStreamPlayer2D = $GameOverAudio
onready var music_urgent_tween: Tween = $MusicUrgentTween
const COST_OF_NEW_TOPIC_INPUT = 1
var points = 1


func _ready():
	randomize()
	music_player.play()


func _process(delta):
	score_ui.rect_position = \
		get_viewport_rect().size / 2 + \
		Vector2.DOWN * get_viewport_rect().size.y * (0.33) + \
		Vector2.LEFT * get_viewport_rect().size.x * (0.2)
	input_ui.rect_position = \
		get_viewport_rect().size / 2 + \
		Vector2.DOWN * get_viewport_rect().size.y * (0.35)
	conversation.position = \
		get_viewport_rect().size / 2
	game_over_ui.rect_position = \
		get_viewport_rect().size / 2 + \
		Vector2.UP * get_viewport_rect().size.y * (0.05)
	score_label.text = str(points)


func _on_LineEdit_text_entered(new_text):
	if points >= COST_OF_NEW_TOPIC_INPUT:
		points -= COST_OF_NEW_TOPIC_INPUT
		conversation.set_topic(line_edit.text)
		analytics_api.capture({"topic": line_edit.text})
		line_edit.text = ""
		_hide_urgent_arrows()
		line_edit.placeholder_text = "enter new topic"
	else:
		cross_sprite.show()
		cross_sprite.frame = 0
		cross_sprite.play()
	

func _on_Conversation_on_topic_change():
	score_ui.show()
	points += 1
	_hide_urgent_arrows()

func _on_Conversation_on_conversation_finished():
	conversation.kill()
	input_ui.hide()
	game_over_ui.show()
	game_over_audio_player.play()
	music_urgent_tween.interpolate_property(music_player, "volume_db",
		music_player.volume_db, -20, 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_OUT)
	music_urgent_tween.start()


func _on_TryAgainButton_pressed():
	get_tree().reload_current_scene()

func _show_urgent_arrows():
	arrow_sprite_1.show()
	arrow_sprite_2.show()
	arrow_sprite_1.play()
	arrow_sprite_2.play()
	music_urgent_tween.interpolate_property(music_player, "pitch_scale",
		music_player.pitch_scale, 1.6, 3,
		Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	music_urgent_tween.start()
	
func _hide_urgent_arrows():
	arrow_sprite_1.hide()
	arrow_sprite_2.hide()
	music_urgent_tween.interpolate_property(music_player, "pitch_scale",
		music_player.pitch_scale, 1, 0.5,
		Tween.TRANS_EXPO, Tween.EASE_OUT)
	music_urgent_tween.start()

func _on_Conversation_on_conversation_dying():
	_show_urgent_arrows()
	line_edit.placeholder_text = "change the topic"


func _on_CrossSprite_animation_finished():
	cross_sprite.hide()
