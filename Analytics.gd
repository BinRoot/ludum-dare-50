extends Node2D

onready var http_request: HTTPRequest = $HTTPRequest
const ENDPOINT = "https://shuklaniskmfo.dataplane.rudderstack.com/v1/webhook"
const ENDPOINT_KEY = "?writeKey=27IE1MHNbkQdtA1kdKSRh1QEkXb"

func capture(data_to_send):
	if data_to_send == null:
		return
	data_to_send["timestamp"] = OS.get_unix_time()
	var query = JSON.print(data_to_send)
	var headers = ["Content-Type: application/json"]
	var url = "{0}{1}".format([ENDPOINT, ENDPOINT_KEY])
	http_request.request(url, headers, true, HTTPClient.METHOD_POST, query)


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	if response_code != 200:
		print("Error: HTTP response code ", response_code)
		print(result, headers, body)

