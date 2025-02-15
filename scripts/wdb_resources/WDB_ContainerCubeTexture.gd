class_name WDB_ContainerCubeTexture extends WDB_DataContainer

#wdb.dsr description:
#( ContainerTextureLevels CF_Positive_X )
#( ContainerTextureLevels CF_Negative_X ) 
#( ContainerTextureLevels CF_Positive_Y )
#( ContainerTextureLevels CF_Negative_Y ) 
#( ContainerTextureLevels CF_Positive_Z )  
#( ContainerTextureLevels CF_Negative_Z )

var CF_Positive_X : Node
var CF_Negative_X : Node
var CF_Positive_Y : Node
var CF_Negative_Y : Node
var CF_Positive_Z : Node
var CF_Negative_Z : Node

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	tag = 308

	super(file, loader)
	self.name = WDB_ASCIIZ.ApplyName(self.object_name, "CubeTexture_%s" % self.offset_hex)
	
	CF_Positive_X = loader.read_WDBNode(file, loader)
	CF_Negative_X = loader.read_WDBNode(file, loader)
	CF_Positive_Y = loader.read_WDBNode(file, loader)
	CF_Negative_Y = loader.read_WDBNode(file, loader)
	CF_Positive_Z = loader.read_WDBNode(file, loader)
	CF_Negative_Z = loader.read_WDBNode(file, loader)
