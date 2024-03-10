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
	
	var antiguo_textos = v_box_container.get_children()
	for antiguo_texto in antiguo_textos:
		antiguo_texto.queue_free()
		
	for j in monstruos.size():
		var text_monstruo = texto_monstruo_scene.instantiate()
		v_box_container.add_child(text_monstruo)
		text_monstruo.size_flags_vertical = Control.SIZE_EXPAND_FILL
		
		
		textos_array.append(text_monstruo)
		text_monstruo.nameLineEdit.text = monstruos[j]["nombre"]
		text_monstruo.descriptionTextEdit.text = monstruos[j]["aspecto"]
		text_monstruo.dateLabel.text = monstruos[j]["fecha_descubrimiento"]
		


func _on_button_pressed():
	for j in monstruo_array.size():
		var nameLineEdit = textos_array[j].nameLineEdit
		var descriptionTextEdit = textos_array[j].descriptionTextEdit
		var dateLabel = textos_array[j].dateLabel
		monstruo_array[j]["nombre"] = nameLineEdit.text
		monstruo_array[j]["aspecto"] = descriptionTextEdit.text
		monstruo_array[j]["fecha_descubrimiento"] = dateLabel.text
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
	var stringDate2 = str(date)
	var stringDate = str(date["year"]) + "-" + str(date["year"]) + "-" + str(date["day"]) + " " + str(date["hour"]) + ":" + str(date["minute"])
	return stringDate


func _on_delete_button_pressed():
	# Crear una lista para almacenar los índices de los monstruos seleccionados para eliminar
	var indices_a_eliminar = []

	# Recorrer los textos y checkboxes para identificar los monstruos seleccionados
	
	for i in range(textos_array.size() - 1, -1, -1):
		
		var checkbox = textos_array[i].deleteCheck.is_pressed() # Obtener el primer hijo del HBoxContainer que es el CheckBox
		if checkbox:
			indices_a_eliminar.append(i)
			
			

	# Eliminar los monstruos seleccionados de la lista y del contenedor visual
	for indice in indices_a_eliminar:
		monstruo_array.remove_at(indice)  # Elimina el monstruo de la lista que irá en el JSON cuando se guarde
		textos_array[indice].queue_free()  # textos_array es la lista visual de monstruos
		 # Liberar el nodo del texto_monstruo

	# Limpiar la lista de textos después de eliminar los monstruos
	textos_array.clear() 

	# Recrear los textos con los monstruos restantes
	crear_textos(monstruo_array)


func _on_add_button_pressed():
	var text_monstruo = texto_monstruo_scene.instantiate()
	v_box_container.add_child(text_monstruo)
	
	text_monstruo.dateLabel.text = getDateString()
	textos_array.append(text_monstruo)
