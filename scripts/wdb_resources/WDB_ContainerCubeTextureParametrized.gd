class_name WDB_ContainerCubeTextureParametrized extends WDB_DataContainer

#wdb.dsr description:
#( DWORD numOfParams )
#( TextureParamStruct params ( ( ITERATED numOfParams ) ) )
#( ContainerTextureLevels CF_Positive_X )
#( ContainerTextureLevels CF_Negative_X ) 
#( ContainerTextureLevels CF_Positive_Y )
#( ContainerTextureLevels CF_Negative_Y ) 
#( ContainerTextureLevels CF_Positive_Z )  
#( ContainerTextureLevels CF_Negative_Z )

var numOfParams   : int
var params        : Array
var CF_Positive_X : Node
var CF_Negative_X : Node
var CF_Positive_Y : Node
var CF_Negative_Y : Node
var CF_Positive_Z : Node
var CF_Negative_Z : Node

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	tag = 342

	super(file, loader)
	self.name = WDB_ASCIIZ.ApplyName(self.object_name, "CubeTextureParametrized_%s" % self.offset_hex)
	
	numOfParams = file.get_32()
	for i in range(numOfParams):
		var txr_struct : WDB_TextureParamStruct = WDB_TextureParamStruct.new()
		txr_struct.LoadFromBuffer(file)
		params.append(txr_struct)
	
	CF_Positive_X = loader.read_WDBNode(file, loader)
	CF_Negative_X = loader.read_WDBNode(file, loader)
	CF_Positive_Y = loader.read_WDBNode(file, loader)
	CF_Negative_Y = loader.read_WDBNode(file, loader)
	CF_Positive_Z = loader.read_WDBNode(file, loader)
	CF_Negative_Z = loader.read_WDBNode(file, loader)
