
/datum/job/roguetown/priest
	title = "Priest"
	flag = PRIEST
	department_flag = TEMPLE
	faction = "Station"
	total_positions = 1
	spawn_positions = 1

	f_title = "Priestess"
	allowed_races = ALL_PLAYER_RACES_BY_NAME
	allowed_patrons = ALL_CLERIC_PATRONS
	tutorial = "The Divine is all that matters in a world of the immoral. The Weeping god left his children to rule over us mortals and you will preach their wisdom to any who still heed their will. The faithless are growing in number, it is up to you to shepard them to a God-Fearing future."
	whitelist_req = TRUE
	bypass_lastclass = TRUE
	outfit = /datum/outfit/job/roguetown/priest

	display_order = JDO_PRIEST
	give_bank_account = 115
	min_pq = 0
	selection_color = "#b7a375"

/datum/outfit/job/roguetown/priest/pre_equip(mob/living/carbon/human/H)
	..()
	H.virginity = TRUE
	H.verbs |= /mob/living/carbon/human/proc/coronate_lord
	H.verbs |= /mob/living/carbon/human/proc/churchexcommunicate
	H.verbs |= /mob/living/carbon/human/proc/churchannouncement
	neck = /obj/item/clothing/neck/roguetown/psycross/silver/astrata
	head = /obj/item/clothing/head/roguetown/priestmask
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/priest
	pants = /obj/item/clothing/under/roguetown/tights/black
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	beltl = /obj/item/keyring/priest
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltr = /obj/item/storage/belt/rogue/pouch/coins/rich
	id = /obj/item/clothing/ring/active/nomag
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/priest
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(/obj/item/needle = 1, /obj/item/storage/belt/rogue/pouch/coins/rich = 1 )

	var/obj/item/rogueweapon/polearm/woodstaff/aries/P = new()
	H.put_in_hands(P, forced = TRUE)

	if((H.dna.species.id == "aasimar" || H.dna.species.id == "dwarf"|| H.dna.species.id == "human"))
		head = /obj/item/clothing/head/roguetown/roguehood/priest

	else
		id = /obj/item/clothing/ring/active/nomag

	var/datum/patron/A = H.patron
	switch(A.name)
		if("Astrata")
			head = /obj/item/clothing/head/roguetown/roguehood/priest
			neck = /obj/item/clothing/neck/roguetown/psycross/silver/astrata
			wrists = /obj/item/clothing/wrists/roguetown/wrappings
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/astrata
		if("Dendor")
			head = /obj/item/clothing/head/roguetown/padded/briarthorns
			neck = /obj/item/clothing/neck/roguetown/psycross/silver/dendor
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/dendor
		if("Necra")
			head = /obj/item/clothing/head/roguetown/padded/deathshroud
			neck = /obj/item/clothing/neck/roguetown/psycross/silver/necra
			pants = /obj/item/clothing/under/roguetown/trou/leather/mourning
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/necra
		if("Eora")
			head = /obj/item/clothing/head/roguetown/roguehood/eora
			neck = /obj/item/clothing/neck/roguetown/psycross/silver/eora
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/eora
		if("Noc")
			head = /obj/item/clothing/head/roguetown/roguehood/nochood
			neck = /obj/item/clothing/neck/roguetown/psycross/noc
			wrists = /obj/item/clothing/wrists/roguetown/nocwrappings
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/noc
		if("Pestra")
			head = /obj/item/clothing/head/roguetown/roguehood/brown
			neck = /obj/item/clothing/neck/roguetown/psycross/silver/pestra
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/phys
		if("Malum")
			head = /obj/item/clothing/head/roguetown/roguehood/black
			neck = /obj/item/clothing/neck/roguetown/psycross/silver/malum
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/malum
		if("Abyssor")
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/shrinekeeper
			neck = /obj/item/clothing/neck/roguetown/psycross/silver
			head = /obj/item/clothing/head/roguetown/roguehood/priest

	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 5, TRUE)
		H.mind.adjust_skillrank(/datum/skill/magic/holy, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE) // Privilege of being the SECOND biggest target in the game, and arguably the worse of the two targets to lose
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sewing, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/medicine, 3, TRUE)
		if(H.age == AGE_OLD)
			H.mind.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
			H.mind.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
		H.change_stat("strength", 1) // One slot and a VERY important role, it deserves a half-decent statline
		H.change_stat("intelligence", 2)
		H.change_stat("endurance", 2)
		H.change_stat("speed", 1)
	var/datum/devotion/cleric_holder/C = new /datum/devotion/cleric_holder(H, H.patron) // This creates the cleric holder used for devotion spells
	C.holder_mob = H
	H.verbs += list(/mob/living/carbon/human/proc/devotionreport, /mob/living/carbon/human/proc/clericpray)
	C.grant_spells_priest(H)

	H.verbs |= /mob/living/carbon/human/proc/coronate_lord
	H.verbs |= /mob/living/carbon/human/proc/churchexcommunicate
	H.verbs |= /mob/living/carbon/human/proc/churchannouncement
//	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
//		H.underwear = "Femleotard"
//		H.underwear_color = CLOTHING_BLACK
//		H.update_body()
	H.update_icons()


/mob/living/carbon/human/proc/coronate_lord()
	set name = "Coronate"
	set category = "Priest"
	if(!mind)
		return
	if(!istype(get_area(src), /area/rogue/indoors/town/church/chapel))
		to_chat(src, "<span class='warning'>I need to do this in the chapel.</span>")
		return FALSE
	for(var/mob/living/carbon/human/HU in get_step(src, src.dir))
		if(!HU.mind)
			continue
		if(HU.mind.assigned_role == "Lord")
			continue
		if(!HU.head)
			continue
		if(!istype(HU.head, /obj/item/clothing/head/roguetown/crown/serpcrown))
			continue
		for(var/mob/living/carbon/human/HL in GLOB.human_list)
			if(HL.mind)
				if(HL.mind.assigned_role == "Lord")
					HL.mind.assigned_role = "Ex-Lord"
			if(HL.job == "Lord")
				HL.job = "Ex-Lord"
			if(HL.mind)
				if(HL.mind.assigned_role == "Lady")
					HL.mind.assigned_role = "Ex-Lady"
			if(HL.job == "Lady")
				HL.job = "Ex-Lady"
		switch(HU.gender)
			if("male")
				HU.mind.assigned_role = "Lord"
				HU.job = "Lord"
			if("female")
				HU.mind.assigned_role = "Lady"
				HU.job = "Lady"
		SSticker.rulermob = HU
		var/dispjob = mind.assigned_role
		GLOB.badomens -= "nolord"
		say("By the authority of the gods, I pronounce you Ruler of all Blackwine!")
		priority_announce("[real_name] the [dispjob] has named [HU.real_name] the inheritor of Rockhill!", title = "Long Live [HU.real_name]!", sound = 'sound/misc/bell.ogg')
		return

/mob/living/carbon/human/proc/churchexcommunicate()
	set name = "Curse"
	set category = "Priest"
	if(stat)
		return
	var/inputty = input("Curse someone... (curse them again to remove it)", "Sinner Name") as text|null
	if(inputty)
		if(!istype(get_area(src), /area/rogue/indoors/town/church/chapel))
			to_chat(src, "<span class='warning'>I need to do this from the chapel.</span>")
			return FALSE
		if(inputty in GLOB.excommunicated_players)
			GLOB.excommunicated_players -= inputty
			priority_announce("[real_name] has forgiven [inputty]. Once more walk in the light!", title = "Hail the Ten!", sound = 'sound/misc/bell.ogg')
			for(var/mob/living/carbon/H in GLOB.player_list)
				if(H.real_name == inputty)
					H.remove_stress(/datum/stressevent/psycurse)
			return
		var/found = FALSE
		for(var/mob/living/carbon/H in GLOB.player_list)
			if(H == src)
				continue
			if(H.real_name == inputty)
				found = TRUE
				H.add_stress(/datum/stressevent/psycurse)
		if(!found)
			return FALSE
		GLOB.excommunicated_players += inputty
		priority_announce("[real_name] has put Xylix's curse of woe on [inputty] for offending the church!", title = "SHAME", sound = 'sound/misc/excomm.ogg')

/mob/living/carbon/human/proc/churchannouncement()
	set name = "Announcement"
	set category = "Priest"
	if(stat)
		return
	var/inputty = input("Make an announcement", "ROGUETOWN") as text|null
	if(inputty)
		if(!istype(get_area(src), /area/rogue/indoors/town/church/chapel))
			to_chat(src, "<span class='warning'>I need to do this from the chapel.</span>")
			return FALSE
		priority_announce("[inputty]", title = "The Priest Speaks", sound = 'sound/misc/bell.ogg')
		src.log_talk("[TIMETOTEXT4LOGS] [inputty]", LOG_SAY, tag="Priest announcement")

