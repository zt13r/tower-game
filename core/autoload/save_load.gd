extends Node


const PATH : String = "user://save.json"

var access : FileAccess = null
var data : Dictionary[String, Variant] = {}
var encryption : Encryption = null


func _ready() -> void:
	encryption = ResourceLoader.load("uid://bbp6vvr586r7t")


func save_game() -> void:
	access = FileAccess.open_encrypted_with_pass(
		PATH, FileAccess.WRITE, encryption.key)
	access.store_string(JSON.stringify(data))
	access.close()


func load_game() -> void:
	if FileAccess.file_exists(PATH):
		access = FileAccess.open_encrypted_with_pass(
			PATH, FileAccess.READ, encryption.key)
		data = JSON.parse_string(access.get_as_text())
		access.close()
