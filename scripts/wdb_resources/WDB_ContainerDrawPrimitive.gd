class_name WDB_ContainerDrawPrimitive extends WDB_DataContainer

#wdb.dsr comments
var primitiveType  : int #( ( MNEMONICS "OPT_*" ) ) )
var startNumber    : int #index of the first index in the vertex buffer or in the index buffer
var primitiveCount : int #number of faces or other primitives

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)
	
	tag = 327
	self.name = "DrawPrimitive_%s" % self.offset_hex
	#self.name = WDB_ASCIIZ.ApplyName(self.name, "DrawPrimitive_%s" % self.offset_hex)

	primitiveType = file.get_32()  #( ( MNEMONICS "OPT_*" ) ) )
	startNumber = file.get_32()    #index of the first index in the vertex buffer or in the index buffer
	primitiveCount = file.get_32() #number of faces or other primitives
