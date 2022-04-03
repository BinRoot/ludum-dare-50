extends Node2D

signal on_topic_change
signal on_conversation_finished
signal on_conversation_dying

onready var conversation_engine = $ConversationEngine
onready var near_end_timer: Timer = $NearEndTimer

const STARTING_TOPIC = null

# Called when the node enters the scene tree for the first time.
#func _ready():
#	set_topic(STARTING_TOPIC)

func kill():
	conversation_engine.timer.stop()

func set_topic(topic):
	randomize()
	var prefixes = [
		"let's talk about",
		"we should talk about",
		"what do you think about",
		"thoughts on",
		"ever heard of",
		"know anything about"
	]
	var utterance = "{0} {1}".format([
		prefixes[randi() % len(prefixes)],
		topic.to_lower()
	])
	conversation_engine.timer.stop()
	conversation_engine.query = topic
	conversation_engine.timer.start()
	_some_person_say(utterance)	

func _on_ConversationEngine_on_topic_change(topic):
	randomize()
	var prefixes = [
		"oh, that reminds me of",
		"sounds a lot like",
		"isn't that just like",
		"you probably also know about",
		"speaking of, let's talk about",
		"reminds me of",
		"great, but what about",
		"but what about",
		"that's just",
		"that's nothing like",
		"there's nothing like",
		"not to be confused with",
		"not the same as",
		"thought you were talking about",
		"that reminds me:",
		"but what are your thoughts on",
		"curious what you think of",
		"ever think about",
		"that's pretty much",
		"almost like",
		"can we talk about",
		"this might interest you:",
		"oh,",
		"um,",
		"no,",
		"yes,",
		"nope,",
		"of course, like",
		"are we talking about",
		"just another way of saying",
		"it's the same as",
		"better than",
		"worse than",
		"how does it compare to",
		"what's better is",
		"what's worse is",
		"can you believe the",
		"basically"
	]
	var utterance = "{0} {1}".format([
		prefixes[randi() % len(prefixes)],
		topic.to_lower()
	])
	_some_person_say(utterance)
	emit_signal("on_topic_change")

func _some_person_say(utterance, reset_others=true):
	var people = get_tree().get_nodes_in_group("person")
	if reset_others:
		for person in people:
			person.idle()
	var active_people = []
	for person in people:
		if not person.is_out_of_topics:
			active_people.append(person)
	if len(active_people) > 0:
		var person = active_people[randi() % len(active_people)]
		person.say(utterance)
		return person
	else:
		return null

func _on_ConversationEngine_on_topic_repeated(topic, num_repeats):
	_someone_out_of_topics(true)

func _on_NearEndTimer_timeout():
	var people = get_tree().get_nodes_in_group("person")
	var num_idle_people = 0
	var non_idle_person = null
	for person in people:
		if person.is_out_of_topics:
			num_idle_people += 1
		else:
			non_idle_person = person
	if num_idle_people == len(people) - 1:
		non_idle_person.say("let's talk about the elephant in the room")
		conversation_engine.timer.stop()
		emit_signal("on_conversation_finished")
	elif num_idle_people != 0:
		_someone_out_of_topics(false)
		
func _someone_out_of_topics(reset_others):
	var utterances = [
		"... well hold on",
		"... ok wait",
		"... wait up",
		"... anyone seeing this",
		"... well ok",
		"... so yea",
		"... umm",
		"... ah",
		"... ehh",
		"... hmm",
		"... so umm",
		"... right umm",
		"... umm so yea",
		"... is this real",
		"... look at that",
		"... what in the world",
		"... oh my",
		"... what the heck",
		"... did you see that",
	]
	var utterance = utterances[randi() % len(utterances)]
	var person = _some_person_say(utterance, reset_others)
	if person != null:
		person.out_of_topics()
	near_end_timer.start()
	emit_signal("on_conversation_dying")
