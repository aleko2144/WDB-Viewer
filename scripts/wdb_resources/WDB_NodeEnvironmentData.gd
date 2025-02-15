class_name WDB_NodeEnvironmentData extends WDB_SimpleNodeData

#wdb.dsr:
#( Color ambientColor )
#( DWORD fogType ( ( MNEMONICS "fog_*" ) ) )
#( float fogNear )
#( float fogFar )
#( Color fogColor )

var ambientColor : Color
var fogType      : int
var fogNear      : float
var fogFar       : float
var fogColor     : Color

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)

	ambientColor = WDB_Color.LoadFromBuffer(file)
	fogType      = file.get_32()
	fogNear      = file.get_float()
	fogFar       = file.get_float()
	fogColor     = WDB_Color.LoadFromBuffer(file)
