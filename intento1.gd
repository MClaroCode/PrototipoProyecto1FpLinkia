extends Node2D


@export var texto_monstruo_scene : PackedScene

@onready var v_box_container = $ScrollContainer/VBoxContainer



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
	var posicion = Vector2(50, 50)
	var antiguo_textos = v_box_container.get_children()
	for antiguo_texto in antiguo_textos:
		antiguo_texto.queue_free()
	for j in monstruos.size():
		var text_monstruo = texto_monstruo_scene.instantiate()
		
		v_box_container.add_child(text_monstruo)
		text_monstruo.size_flags_vertical = Control.SIZE_EXPAND_FILL
		text_monstruo.global_position = posicion
# Crear un HBoxContainer para contener el texto del monstruo y la casilla de verificación
		var hbox = HBoxContainer.new()
		text_monstruo.add_child(hbox)
		# Agregar la casilla de verificación
		var checkbox = CheckBox.new()
		hbox.add_child(checkbox)

		textos_array.append(text_monstruo)
		
		text_monstruo.text = monstruos[j]["nombre"] + "\n" + monstruos[j]["aspecto"] + "\n" + monstruos[j]["fecha_descubrimiento"]

		if posicion.x > 899:
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
		




func _on_eliminar_pressed():
	# Crear una lista para almacenar los índices de los monstruos seleccionados para eliminar
	var indices_a_eliminar = []

	# Recorrer los textos y checkboxes para identificar los monstruos seleccionados
	# Iterating in reverse order to avoid issues when removing items
	for i in range(textos_array.size() - 1, -1, -1):
		var hbox = textos_array[i].get_child(0)  # Obtener el primer hijo que es el HBoxContainer
		var checkbox = hbox.get_child(0)  # Obtener el primer hijo del HBoxContainer que es el CheckBox
		if checkbox.is_pressed():
			indices_a_eliminar.append(i)

	# Eliminar los monstruos seleccionados de la lista y del contenedor visual
	for indice in indices_a_eliminar:
		monstruo_array.remove_at(indice)  # Elimina el monstruo de la lista que irá en el JSON cuando se guarde
		var texto_monstruo = textos_array[indice]  # textos_array es la lista visual de monstruos
		texto_monstruo.queue_free()  # Liberar el nodo del texto_monstruo

	# Limpiar la lista de textos después de eliminar los monstruos
	textos_array.clear() 

	# Recrear los textos con los monstruos restantes
	crear_textos(monstruo_array)
