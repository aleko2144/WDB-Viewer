class_name WDB_ContainerTextureLevelsParametrized extends WDB_DataContainer

#wdb.dsr description:
#( DWORD numOfParams )
#( TextureParamStruct params ( ( ITERATED numOfParams ) ) )
#( DWORD num )
#( Container	text ( (ITERATED num ) ) )

var numOfParams : int
var params      : Array
var num         : int
var text        : Array

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	tag = 342

	super(file, loader)
	self.name = WDB_ASCIIZ.ApplyName(self.object_name, "TextureLevelsParametrized_%s" % self.offset_hex)
	
	numOfParams = file.get_32()
	for i in range(numOfParams):
		var txr_struct : WDB_TextureParamStruct = WDB_TextureParamStruct.new()
		txr_struct.LoadFromBuffer(file)
		params.append(txr_struct)
	
	num = file.get_32()
	for i in range(num):
		var child_obj : Node = loader.read_WDBNode(file, loader)
		if (child_obj): #чтобы не было ошибок при импорте
			text.append(child_obj)
			if (self.object_name):
				child_obj.texture.resource_name = "%s_%d" % [self.object_name, i]
				#print(object_name)
