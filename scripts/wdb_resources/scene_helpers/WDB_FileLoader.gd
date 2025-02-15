class_name WDB_FileLoader

var active_scene : Node #сцена, в которую всё импортируется
var scene_name : String #имя импортируемой сцены
var test_iter : int = 1 #пробный итератор для экспорта текстур в png

func setActiveScene(scn : Node) -> void:
	active_scene = scn
	
func setActiveSceneName(scn_name : String) -> void:
	scene_name = scn_name

func read_WDBNode(file : StreamPeerBuffer, loader : WDB_FileLoader) -> Node:
	var tag : int = file.get_32()
	var size : int = file.get_32()
	var offset : int = file.get_position() - 8
	var node : Node
	
	match tag:
		2:
			node = WDB_LinkContainer.new()
		3:
			node = WDB_BackRefContainer.new()
		103: #not tested
			node = WDB_NodeCylinder.new()
		104:
			node = WDB_NodeScreen.new()
		105:
			node = WDB_NodeSphere.new()
		106:
			node = WDB_NodeCaseRefSwitch.new()
			active_scene.switch_nodes.append(node)
		107:
			node = WDB_NodeCaseRefMask.new()
			#active_scene.switch_nodes.append(node)
		108:
			node = WDB_NodeEnvironment.new()
		#109:
		#    node = WDB_NodeLocalSpotLight.new()
		#110:
		#    node = WDB_NodeLocalPointLight.new()
		#111:
		#    node = WDB_NodeLocalDirectionLight.new()
		#112:
		#    node = WDB_NodeGlobalSpotLight.new()
		#113:
		#    node = WDB_NodeGlobalPointLight.new()
		#114:
		#    node = WDB_NodeGlobalDirectionLight.new()
		115:
			node = WDB_NodeObject.new()
			active_scene.object_nodes.append(node)
		116:
			node = WDB_NodeSpace.new()
		117:
			node = WDB_NodeSimpleGroup.new()
			#active_scene.group_nodes.append(node)
		118:
			node = WDB_NodeGroup.new()
			active_scene.group_nodes.append(node)
		119:
			node = WDB_NodeViewer.new()
			active_scene.viewer_nodes.append(node)
		120:
			node = WDB_NodeFunction.new()
			active_scene.function_nodes.append(node)
		121:
			node = WDB_NodeLevelOfDetail.new()
			active_scene.LOD_nodes.append(node)
		122: #с позиционированием
			node = WDB_NodeCall.new()
			active_scene.posCall_nodes.append(node)
		123:
			node = WDB_NodeModel.new()
		124:
			node = WDB_NodeRoot.new()
		125: # not tested
			node = WDB_NodeRoom.new()
		126:
			node = WDB_NodeDoor.new()
		127:
			node = WDB_NodePlane.new()
		128: #not tested
			node = WDB_NodeSortByCenter.new()
		129: #not tested
			node = WDB_EventInCylinder.new()
		130: #not tested
			node = WDB_EventOutCylinder.new()
		131:
			node = WDB_EventInSphere.new()
		132: #not tested
			node = WDB_EventOutSphere.new()
		133: #not tested
			node = WDB_EventPlane.new()
		134:
			node = WDB_EventObject.new()
		135: #not tested
			node = WDB_EventSimple.new()
		137:
			node = WDB_EventQHullInside.new()
		138: #not tested
			node = WDB_EventQHullOutside.new()
		139:
			node = WDB_NodePumpRoom.new()
		140:
			node = WDB_NodeVoidCall.new()
			active_scene.call_nodes.append(node)
		141:
			node = WDB_NodeMultDoor.new()
		142:
			node = WDB_NodeLocalObjectGroup.new()
		143:
			node = WDB_NodeEmptyCall.new()
			active_scene.call_nodes.append(node)
		144:
			node = WDB_NodeCaseRefSwitchD.new()
		145:
			node = WDB_NodeCaseRefMaskD.new()
		146:
			node = WDB_NodeLoadCaseRef.new()
			active_scene.caseRef_nodes.append(node)
		147:
			node = WDB_NodeCaseRefGroupedSwitchD.new()
		201:
			node = WDB_RefToContainer.new()
			active_scene.refToCnt_nodes.append(node)
		202:
			node = WDB_RefToSelfContainer.new()
		204:
			node = WDB_RefToMultipleContainer.new()
			active_scene.refToMtp_nodes.append(node)
		301:
			node = WDB_ContainerErrorMetricsBySphereCenter.new()
		302:
			node = WDB_ContainerErrorMetricsBySphereProjection.new()
		303:
			node = WDB_ContainerErrorMetricsByPlaneDistance.new()
		304:
			node = WDB_ContainerErrorMetricsByConvexHull.new()
		305:
			node = WDB_ContainerSimpleTextureStatic.new()
		306:
			node = WDB_ContainerTextureStatic.new()
		307:
			node = WDB_ContainerTextureLevels.new()
		308:
			node = WDB_ContainerCubeTexture.new()
		309:
			node = WDB_ContainerVertexDynamic.new()
		310:
			node = WDB_ContainerVertexStatic.new()
		311:
			node = WDB_ContainerVertexBillboard.new()
		312:
			node = WDB_ContainerIndexDynamic.new()
		313:
			node = WDB_ContainerIndexStatic.new()
		314: #not tested
			node = WDB_ContainerVIPMLOD.new()
		315:
			node = WDB_ContainerCollisionVertex.new()
		316:
			node = WDB_ContainerCollisionPolygon.new()
		317:
			node = WDB_ContainerCollisionPlane.new()
		318:
			node = WDB_ContainerCollisionCylinder.new()
		319:
			node = WDB_ContainerCollisionSphere.new()
		320:
			node = WDB_ContainerMaterial.new()
			active_scene.material_nodes.append(node)
		321:
			node = WDB_ContainerDWORD.new()
		322:
			node = WDB_ContainerNotTypifiedData.new()
		323:
			node = WDB_ContainerPyramid.new()
		324:
			node = WDB_ContainerSound.new()
		325:
			node = WDB_ContainerSimpleTextureDynamic.new()
		326:
			node = WDB_ContainerTextureDynamic.new()
		327:
			node = WDB_ContainerDrawPrimitive.new()
		328:
			node = WDB_ContainerDrawPrimitiveIndexed.new()
		329:
			node = WDB_ContainerBonesRef.new()
		330:
			node = WDB_ContainerCollisionEdge.new()
		331:
			node = WDB_ContainerCollisionTriangleEdge.new()
		332:
			node = WDB_ContainerGridCollision.new()
		333:
			node = WDB_ContainerGridCollisionEdges.new()
		334:
			node = WDB_ContainerGridCollision1.new()
		335:
			node = WDB_ContainerGridCollisionEdges1.new()
		336:
			node = WDB_ContainerNotTypifiedDataAsData.new()
		337:
			node = WDB_ContainerNodeFunction.new()
		338:
			node = WDB_ContainerIndexSystem.new()
		339:
			node = WDB_ContainerVertexSystem.new()
		340:
			node = WDB_ContainerVIPMLOD2.new()
		341:
			node = WDB_ContainerVIPM2Operation.new()
		342:
			node = WDB_ContainerTextureLevelsParametrized.new()
		343:
			node = WDB_ContainerCubeTextureParametrized.new()
		##401: - реализовано в WDB_Header.gd
		##	node = WDB_ContainerContents.new()
		402:
			node = WDB_ContainerPumpUnit.new()
		403:
			node = WDB_ContainerUnitGroup.new()
			active_scene.unit_nodes.append(node)
		404:
			node = WDB_ContainerData.new()
			active_scene.data_nodes.append(node)
		405: #not tested
			node = WDB_ContainerRefTable.new()
		406:
			node = WDB_Header.new()
		407:
			node = WDB_ContainerRefTable1.new()
			active_scene.ref_table = node
		754:
			node = WDB_AliasTable.new()
		##755: - реализовано в WDB_AliasTable.gd
		##	node = WDB_AliasTableEntry.new()
		954:
			node = WDB_VolumeTable.new()
		955:
			node = WDB_VolumeRoom.new()
		956:
			node = WDB_VolumeDoor.new()
		##541213783: - реализовано в WDBScenesContainer.gd
		##	node = WDB_Class.new()
	
	if (node != null):
		node.size = size
		node.offset = offset
		node.offset_hex = ("%x" % offset).to_upper()
		node.data_end_offset = offset + size
		
		#print("type=%d, size=%d, pos=%s" % [tag, size, node.offset_hex])

		active_scene.nodes_list.append(node)
		node.LoadFromBuffer(file, loader)
		return node
	else:
		if (tag > 1000):
			print("FATAL import error (tag > 1000)")
			print("pos=%x" % [file.get_position() - 8])
			print("prev_node=%d, pos=%s" % [active_scene.nodes_list[-1].tag, active_scene.nodes_list[-1].offset_hex])
			breakpoint
			return null
		
		if (!size):
			print("FATAL import error (!size)")
			print("pos=%x" % [file.get_position() - 8])
			print("prev_node=%d, pos=%s" % [active_scene.nodes_list[-1].tag, active_scene.nodes_list[-1].offset_hex])
			breakpoint
			return null
		
		#print("! UNKNOWN type %d, size=%d, pos=%x" % [tag, size, file.get_position() - 8])
		LogSystem.writeToErrorLog("! UNKNOWN type %d, size=%d, pos=%x" % [tag, size, file.get_position() - 8])
		file.seek(file.get_position() + size - 8)
		
	return null
