class_name WDB_ContainerDrawPrimitiveIndexed extends WDB_ContainerDrawPrimitive

#wdb.dsr comments
var minIndex    : int #is minimal index in the index buffer
var numVertices : int #range of vertices covered in the vertex buffer
var baseIndex   : int #value added to all the indices. Can be always 0, except for VIPM

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)
	
	tag = 328
	self.name = "DrawPrimitiveIndexed_%s" % self.offset_hex
	#self.name = WDB_ASCIIZ.ApplyName(self.name, "DrawPrimitiveIndexed_%s" % self.offset_hex)

	minIndex = file.get_32()    #is minimal index in the index buffer
	numVertices = file.get_32() #range of vertices covered in the vertex buffer
	baseIndex = file.get_32()   #value added to all the indices. Can be always 0, except for VIPM

#func ConstructMesh() -> void:
#	var MeshConstructor : WDB_MeshConstructor = WDB_MeshConstructor.new()
#	MeshConstructor.CreateMesh(self)
