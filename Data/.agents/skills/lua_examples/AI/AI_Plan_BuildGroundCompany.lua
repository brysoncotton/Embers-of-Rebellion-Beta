require("pgevents")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))

	Category = "Build_Ground_Company"
	IgnoreTarget = true
	TaskForce = {
	{
		"StructureForce",
		"Aratech_HQ | Balmorran_Arms_HQ | Bespin_Motors_HQ | Carida_Academy | CEC_HQ | Cloning_HQ | Damorian_HQ | Hoersch_Kessel_HQ | Ikas_Adno_HQ | Incom_HQ | KDY_HQ | Mandal_Motors_HQ | Mekuun_HQ | Rendili_HQ | Sorosuub_HQ | Taim_Bak_HQ | TransGalMeg_HQ | Ubrikkian_HQ | Anaxes_War_College | Baktoid_HQ | Colicoid_HQ | Commerce_Guild_HQ | Free_Dac_HQ | Geonosian_HQ | Haor_Chall_HQ | Jedi_Temple | Jedi_Enclave | Rothana_HQ | Retail_Caucus_HQ | Rishi_Station | Skytop_Station | Tactical_Droid_Factory | Techno_Union_HQ = 1"
	}
	}

	DebugMessage("%s -- Done Definitions", tostring(Script))
end

function StructureForce_Thread()
	DebugMessage("%s -- In StructureForce_Thread.", tostring(Script))
	
	StructureForce.Set_As_Goal_System_Removable(false)
	AssembleForce(StructureForce)
	
	StructureForce.Set_Plan_Result(true)
	--Clean out MajorItem budget
	Budget.Flush_Category("MajorItem")
	DebugMessage("%s -- StructureForce done!", tostring(Script));
	ScriptExit()
end

function StructureForce_Production_Failed(tf, failed_object_type)
	DebugMessage("%s -- Abandonning plan owing to production failure.", tostring(Script))
	ScriptExit()
end