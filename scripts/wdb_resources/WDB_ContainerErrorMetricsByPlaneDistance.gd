class_name WDB_ContainerErrorMetricsByPlaneDistance extends WDB_ContainerErrorMetrics

var plane : Vector4

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)
	
	self.name = "ErrorMetricsByPlaneDistance_%s" % self.offset_hex
	tag = 303
	
	#импорт Sphere
	plane = VectorUtils.LoadDVec4FromBuffer(file)
