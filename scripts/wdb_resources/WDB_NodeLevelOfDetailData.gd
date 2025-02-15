class_name WDB_NodeLevelOfDetailData extends WDB_NodeSimpleGroupData

#wdb.dsr:
#( DWORD max_param )
#( float param ( (ITERATED max_param ) ) )
#( ContainerErrorMetrics error_metrics )

var max_param     : int
var param         : Array
var error_metrics : Node

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)
	max_param = file.get_32()
	
	for i in range(max_param):
		param.append(file.get_float())
		
	error_metrics = loader.read_WDBNode(file, loader)  
