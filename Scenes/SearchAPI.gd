extends Node2D

signal on_search_request_completed

onready var search_request: HTTPRequest = $HTTPRequest
const WIKIPEDIA_SEARCH_REQUEST_URL = "https://en.wikipedia.org/w/rest.php/v1/search/page"
const DEFAULT_SEARCH_LIMIT = 4

# Called when the node enters the scene tree for the first time.
#func _ready():
#	fetch_search_results("space")


func fetch_search_results(query):
	var url = _build_wikipedia_url(DEFAULT_SEARCH_LIMIT, query)
	search_request.request(url)

func _build_wikipedia_url(limit, query):
	return "{}?limit={}&q={}".format([
		WIKIPEDIA_SEARCH_REQUEST_URL, 
		limit,
		 query.percent_encode()
	], "{}")

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	if response_code != 200:
		print("Error: HTTP response code ", response_code)
	var search_results = []
	if json.result != null and json.result.pages != null:
		for page in json.result.pages:
			search_results.append(page.title)
	emit_signal("on_search_request_completed", search_results)
