class_name WDB_ContainerErrorMetricsBySphereProjection extends WDB_ContainerErrorMetrics

var select : WDB_Sphere

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)
	
	self.name = "ErrorMetricsBySphereProjection_%s" % self.offset_hex
	tag = 302
	
	#импорт Sphere
	select = WDB_Sphere.new()
	select.LoadFromBuffer(file)
