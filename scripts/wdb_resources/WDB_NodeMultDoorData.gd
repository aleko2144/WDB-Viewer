class_name WDB_NodeMultDoorData extends WDB_SimpleNodeData 

#wdb.dsr:
#( DWORD	modelNum )
#( Ref pump_units ( (ITERATED modelNum) ))
#( Ref models ( (ITERATED modelNum) ))
#( DWORD	num )
#( Vector  vertex ( (ITERATED num) ) )

var modelNum   : int
var pump_units : Array
var models     : Array
var num        : int
var vertex     : Array

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)
	
	modelNum  = file.get_32()
	
	for i in range(modelNum):
		var child_obj : Node = loader.read_WDBNode(file, loader)
		if (child_obj): #чтобы не было ошибок при импорте
			pump_units.append(child_obj)
			
	for i in range(modelNum):
		var child_obj : Node = loader.read_WDBNode(file, loader)
		if (child_obj): #чтобы не было ошибок при импорте
			models.append(child_obj)

	num       = file.get_32()

	for i in range(num):
		vertex.append(VectorUtils.LoadDVec3FromBuffer(file))