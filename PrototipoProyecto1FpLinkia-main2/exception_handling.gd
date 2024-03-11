extends Node

func checkIfStringIsNull(value):
	if value.is_empty():
		print ("Not a valid input")
	if value == null:
		print ("Not a valid input")

func fix(value):
	value.rstrip(18)
	value.strip_edges()
	value.strip_escapes()
	return value;
