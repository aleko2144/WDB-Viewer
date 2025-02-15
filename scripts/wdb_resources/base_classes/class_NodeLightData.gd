class_name WDB_NodeLightData extends WDB_SimpleNodeData

#( DWORD		priority )
#( Color		ColorDiffuse )
#( Color		ColorAmbient )
#( Color		ColorSpecular )

var priority      : int
var ColorDiffuse  : Color
var ColorAmbient  : Color
var ColorSpecular : Color

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)
	priority      = file.get_u32()
	ColorDiffuse  = WDB_Color.LoadFromBuffer(file)
	ColorAmbient  = WDB_Color.LoadFromBuffer(file)
	ColorSpecular = WDB_Color.LoadFromBuffer(file)
