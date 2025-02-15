class_name WDB_ContainerRefTable1 extends WDB_DataContainer

#wdb.dsr:
#( DWORD numOfRecords )
#( DWORD sizeOfRecord )                                                               
#( RefTableEntry1 entry ( ( ITERATED numOfRecords ) ) )
#( RefTableNamesEntry names ( ( ITERATED numOfRecords ) ) )

var numOfRecords : int
var sizeOfRecord : int
var entry        : Array
var names        : Array

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	tag = 407
	
	super(file, loader)
	self.name = "RefTable1_%s" % self.offset_hex
	
	numOfRecords = file.get_32()
	sizeOfRecord = file.get_32()
	
	for i in range(numOfRecords):
		entry.append(RefTableEntry1.LoadFromBuffer(file))
	for i in range(numOfRecords):
		names.append(WDB_ASCIIZ.LoadFromBuffer(file))

func initialize(scene_root : Node) -> void:
	for obj in scene_root.nodes_list:
		for record in entry:
			if obj.offset == record.entityOffset:
				record.ref_object = obj
				
	#debug:
	var empty_references_cnt : int = 0
	for i in range(len(entry)):
		if not entry[i].ref_object:
			empty_references_cnt += 1
	#		print('! "%s" -> Ref record %d has no object!' % [get_parent().name, i])
	#		var _error_entry = entry[i]
	#		var _error_name  = names[i]
			#breakpoint
	if (empty_references_cnt):
		print('! "%s" -> %d ref records has no object!' % [get_parent().name, empty_references_cnt])

func getObjectByID(id : int) -> Object:
	var result : Object
	result = entry[id].ref_object
	return result
	
func getObjectByName(ref_name : String) -> Object:
	var result : Object
	
	for i in range(len(names)):
		if names[i] == ref_name:
			return getObjectByID(i)
	
	#если не помогло
	var scn_root : Node = get_parent().get_parent()
	for scn in scn_root.get_children():
		for i in range(len(scn.ref_table.names)):
			if scn.ref_table.names[i] == ref_name:
				return scn.ref_table.getObjectByID(i)
		#result = scn.ref_table.getObjectByName(ref_name)
		
	if (!result):
		if (not scn_root.not_found_references.has(ref_name)):
			scn_root.not_found_references.append(ref_name)
		#LogSystem.writeToErrorLog("%s reference not found in ANY imported table" % [ref_name])
		#print("%s reference not found in table" % [ref_name])
	
	return result
