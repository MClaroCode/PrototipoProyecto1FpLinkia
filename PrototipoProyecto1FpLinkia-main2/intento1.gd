extends Control


@export var texto_monstruo_scene : PackedScene

@onready var v_box_container = $Popup/VBoxContainer2/ScrollContainer/VBoxContainer


var item_Data = {}
var data_file_path = "res://cosas/archivomonstruos.json"
var monstruo_array = []
var textos_array = []



# Called when the node enters the scene tree for the first time.
func _ready():
	item_Data = load_file(data_file_path)

	if "monstruos" in item_Data:
		var monstruos = item_Data["monstruos"]
		
		for monstruo in monstruos:
			monstruo_array.append((monstruo))
			var nombre = monstruo["nombre"]
			var derrota = str(monstruo["derrotado"])
			print("Nombre del monstruo:", nombre," ¿Le has partido la cara? ", derrota)
			
	else:
		print("Key 'nombre' not found in the JSON data.")
	print("---------------------------------------------")
	print(monstruo_array[0])
	

	var primer_m = monstruo_array[0]
	print(primer_m is Dictionary)

	crear_textos(monstruo_array)
	
	
func load_file(filePath : String):
	if FileAccess.file_exists(filePath):
		var dataFile = FileAccess.open(filePath,FileAccess.READ)
		var parseResult = JSON.parse_string(dataFile.get_as_text())
		print(parseResult)
		print( parseResult is Dictionary)
		return parseResult
	else :
		print("no esta")

func crear_textos(monstruos):
	var size = monstruos.size()
	var posicion = Vector2(50,50)
	for j in monstruos.size():
		var text_monstruo = texto_monstruo_scene.instantiate()
		v_box_container.add_child(text_monstruo)
		text_monstruo.size_flags_vertical = Control.SIZE_EXPAND_FILL
		text_monstruo.global_position = posicion
		#posicion += Vector2(300,0)
		textos_array.append(text_monstruo)
		text_monstruo.nameLineEdit.text = monstruos[j]["nombre"]
		text_monstruo.descriptionTextEdit.text = monstruos[j]["aspecto"]
		text_monstruo.dateLabel.text = monstruos[j]["fecha_descubrimiento"]
		if( posicion.x >800):
			posicion.x = 50
			posicion.y += 250
	
		


func _on_button_pressed():
	for j in monstruo_array.size():
		var lineas = textos_array[j].text.split("\n")
		monstruo_array[j]["nombre"] = lineas[0]
		monstruo_array[j]["aspecto"] = lineas[1]
		monstruo_array[j]["fecha_descubrimiento"] = lineas[2]
	if FileAccess.file_exists(data_file_path):
		var dataFile = FileAccess.open(data_file_path,FileAccess.WRITE)
		var json_text
		var json_data = {
			"monstruos": []
			}
		for monstruo in monstruo_array:
			var nuevo_monstruo = {
					"nombre": monstruo["nombre"],
					"aspecto": monstruo["aspecto"],
					"fecha_descubrimiento": monstruo["fecha_descubrimiento"],
					"derrotado": monstruo["derrotado"]
					
				}
			print("nuevomonstruoprint")
			
			print(nuevo_monstruo)
			json_data["monstruos"].append(nuevo_monstruo)
			print(json_data)
			json_text = JSON.stringify(json_data)
			print("-----------------------------------------------------------------------------")
			print(json_text)
			
			#dataFile.store_string("\n")
		dataFile.store_string(json_text)
		dataFile.close()
		
		
		#for j in monstruo_array.size():
			#var lineas = textos_array[j].text.split("\n")
			#print(lineas[0])
			#print(lineas[1])
			#print(lineas[2])
			#monstruo_array[j]["nombre"] = lineas[0]
			#monstruo_array[j]["aspecto"] = lineas[1]
			#monstruo_array[j]["fecha_descubrimiento"] = lineas[2]
			#print(monstruo_array[j])
			#
		#var json_text = JSON.stringify(monstruo_array,"\n")
		#dataFile.store_string(json_text)
		#dataFile.close()

#Devuelve una string con los datos necesarios de la fecha y hora formateados
func getDateString():
	var date = Time.get_datetime_dict_from_system()
	var stringDate = date["year"] + "-" + date["year"] + "-" + date["day"] + " " + date["hour"] + ":" + date["minute"]
	return stringDate
