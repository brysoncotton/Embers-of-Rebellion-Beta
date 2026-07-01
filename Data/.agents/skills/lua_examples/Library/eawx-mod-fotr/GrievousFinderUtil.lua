function FindGrievous()
	local GrievousObject = nil

	local GrievousObjectNames = {
		"Grievous_Malevolence_Hunt_Campaign",
		"Grievous_Malevolence_2",
		"Grievous_Malevolence",
		"Grievous_Recusant",
		"Grievous_Invisible_Hand",
		"Grievous_Munificent",
		"General_Grievous",
	}

	for _,GrievousObjectName in pairs(GrievousObjectNames) do
		GrievousObject = Find_First_Object(GrievousObjectName)
		if TestValid(GrievousObject) == true then
			return GrievousObject, Find_Object_Type(GrievousObject), GrievousObjectName
		end
	end
	
	return nil, nil, nil
end
