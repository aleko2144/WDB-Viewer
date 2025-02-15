class_name WDB_ContainerErrorMetricsByConvexHull extends WDB_ContainerErrorMetrics

#( DWORD num )
#( Vector	vertex ( ( ITERATED num ) ) )

var num    : int
var vertex : Array

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)
	
	self.name = "ErrorMetricsByConvexHull_%s" % self.offset_hex
	tag = 304
	
	num = file.get_32()
	for i in range(num):
		vertex.append(VectorUtils.LoadDVec3FromBuffer(file))
