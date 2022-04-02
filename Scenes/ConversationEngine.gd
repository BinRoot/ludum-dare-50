extends Node2D

signal on_topic_change
signal on_topic_repeated
onready var search_api = $SearchAPI
onready var timer = $Timer
var query = null
var previous_topics = []
const NUM_REPEATS = 3

func _ready():
	pass


func _on_Timer_timeout():
	if query != null:
		search_api.fetch_search_results(query)

func _on_SearchAPI_on_search_request_completed(results):
	if len(results) == 0:
		emit_signal("on_topic_repeated", query, 100)
		return
	var num_topics_repeated = 0
	for result in results:
		if previous_topics.has(result):
			num_topics_repeated += 1
		else:
			previous_topics.append(result)
	if num_topics_repeated >= NUM_REPEATS:
		emit_signal("on_topic_repeated", query, num_topics_repeated)
	else:
		var result = results[len(results) - 1]
		query = result
		emit_signal("on_topic_change", query)
		timer.start()
