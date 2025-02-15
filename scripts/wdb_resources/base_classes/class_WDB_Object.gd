class_name WDB_Object extends Node3D

var tag : int
var size : int
var offset : int
var offset_hex : String
var data_end_offset : int

func clone() -> Node3D:
	var result : Node3D = Node3D.new()
	#result.set_script(self.get_script())
	
	#for property in self.get_property_list():
		#if !property.name.is_empty():
			#var test = property.name
			#if property.name != 'global_transform':
				#var par = self.get(property.name)
				#if par is Node:
					#result.set(property.name, par.clone())
					##breakpoint
				#else:
					#result.set(property.name, par)
				
	result.name = self.name + '_copy'
	
	for child in self.get_children():
		if child.get_script():
			result.add_child(child.clone())
		else:
			result.add_child(child.duplicate())

	#for child in self.get_children():
	#	if child.tag == 143:
	#		if (!child.initialized):
	#			child.initialize()
	
	return result
	
	#https://godotforums.org/d/37167-duplicating-nodes-with-at-onready-variables
	#var l=OBJ.get_property_list()
	#for property in l:
	#	if property.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
	#		if is_instance_valid(OBJ.get(property.name)):
	#			var prop=OBJ.get(property.name)
	#			if prop is Node or prop is Resource:
	#				OBJ2.set(property.name, prop.duplicate())
	#			else :
	#				OBJ2.set(property.name, prop)
