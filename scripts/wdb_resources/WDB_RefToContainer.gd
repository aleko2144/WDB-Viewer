class_name WDB_RefToContainer extends WDB_RefContainer

#wdb.dsr description:
#( ASCIIZ reference )
#( RLOCATOR locator )
#( DWORD Id )

var reference : String
var locator : String
var Id : int #индекс объекта из RefTableEntry1

var ref_obj : Object #объект, присоединённый данным контейнером

func LoadFromBuffer(file : StreamPeerBuffer, _loader : WDB_FileLoader) -> void:
	self.name = "RefToContainer_%s" % self.offset_hex
	tag = 201
	
	reference = WDB_ASCIIZ.LoadFromBuffer(file)
	locator   = WDB_RLOCATOR.LoadFromBuffer(file)
	Id        = file.get_32()

func initialize(scene_root : Node) -> void:
	if Id != -1:
		ref_obj = scene_root.getRefObjectById(Id)
	else:
		if (reference):
			ref_obj = scene_root.getRefObjectByName(reference)
	#иногда таки есть Id=0, например, ссылка на tex_repair_stella
	#в материале mat_repair_stella_stolb_110 (common/RepairPoster_res.wdb)
	
	#if (reference == "tex_repair_stella"):
	#	breakpoint
	
	#if (reference):
	#	ref_obj = scene_root.getRefObjectByName(reference)
	#else:
	#	if (Id != -1):
	#		ref_obj = scene_root.getRefObjectById(Id)
