/datum/job/roguetown/acolyte
	title = "Acolyte"
	flag = ACOLYTE
	department_flag = TEMPLE
	faction = "Station"
	total_positions = 3
	spawn_positions = 4

	allowed_races = list(
		"Humen",
		"Elf",
		"Half-Elf",
		"Dwarf",
		"Dark Elf",
		"Aasimar",
		"Changeling",
		"Skylancer",
		"Ogrun",
		"Undine"
	)
	tutorial = "Chores, exercise, prayer... and more chores. You are a humble acolyte at the temple in Rockhill, not yet a trained guardian or an ordained priest. But who else would keep the fires lit and the floors clean?"
	allowed_patrons = ALL_TEMPLE_PATRONS
	outfit = /datum/outfit/job/roguetown/acolyte

	display_order = JDO_ACOLYTE
	give_bank_account = TRUE
	min_pq = -10
	bypass_lastclass = TRUE

/datum/outfit/job/roguetown/acolyte
	name = "Acolyte"
	jobtype = /datum/job/roguetown/acolyte

/datum/outfit/job/roguetown/acolyte/pre_equip(mob/living/carbon/human/H)
	..()
	var/datum/patron/A = H.patron
	H.virginity = TRUE
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltl = /obj/item/roguekey/church
	backl = /obj/item/rogueweapon/polearm/woodstaff/quarterstaff
	backpack_contents = list(/obj/item/needle)
	switch(A.name)
		if("Astrata")
			head = /obj/item/clothing/head/roguetown/roguehood/astrata
			neck = /obj/item/clothing/neck/roguetown/psycross/silver/astrata
			wrists = /obj/item/clothing/wrists/roguetown/wrappings
			shoes = /obj/item/clothing/shoes/roguetown/sandals
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/astrata
		if("Eora")
			head = /obj/item/clothing/head/roguetown/padded/rabbetvisage
			neck = /obj/item/clothing/neck/roguetown/psycross/silver/eora
			shoes = /obj/item/clothing/shoes/roguetown/sandals
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/eora
			H.virginity = FALSE
		if("Noc")
			head = /obj/item/clothing/head/roguetown/roguehood/nochood
			neck = /obj/item/clothing/neck/roguetown/psycross/noc
			wrists = /obj/item/clothing/wrists/roguetown/nocwrappings
			shoes = /obj/item/clothing/shoes/roguetown/sandals
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/noc
		if("Pestra")
			head = /obj/item/clothing/head/roguetown/roguehood/brown
			neck = /obj/item/clothing/neck/roguetown/psycross/silver/pestra
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/green
			shoes = /obj/item/clothing/shoes/roguetown/sandals
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/phys
		if("Malum")
			head = /obj/item/clothing/head/roguetown/roguehood/red
			neck = /obj/item/clothing/neck/roguetown/psycross/silver/malum
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/red
			pants = /obj/item/clothing/under/roguetown/tights/red
			shoes = /obj/item/clothing/shoes/roguetown/boots
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/malum
		if("Necra")
			head = /obj/item/clothing/head/roguetown/padded/deathshroud
			neck = /obj/item/clothing/neck/roguetown/psycross/silver/necra
			pants = /obj/item/clothing/under/roguetown/trou/leather/mourning
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/necra
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
			shoes = /obj/item/clothing/shoes/roguetown/sandals
		if("Dendor")
			head = /obj/item/clothing/head/roguetown/antlerhood
			neck = /obj/item/clothing/neck/roguetown/coif
			cloak = /obj/item/clothing/cloak/raincloak/furcloak
			neck = /obj/item/clothing/neck/roguetown/psycross/silver/dendor
			beltr = /obj/item/rogueweapon/knife/stone
		if("Abyssor")
			head = /obj/item/clothing/head/roguetown/padded/shrinekeeper
			neck = /obj/item/clothing/neck/roguetown/psycross/silver/abyssanctum
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/shrinekeeper
			shirt = /obj/item/clothing/suit/roguetown/shirt/rags/monkgarb/random
			shoes = /obj/item/clothing/shoes/roguetown/sandals/geta
			wrists = /obj/item/clothing/wrists/roguetown/shrinekeeper
		else // Failsafe
			head = /obj/item/clothing/head/roguetown/roguehood/random
			neck = /obj/item/clothing/neck/roguetown/psycross/silver
			shoes = /obj/item/clothing/shoes/roguetown/boots
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/plain


	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/misc/sewing, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/medicine, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE) // They get this and a wooden staff to defend themselves
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/axesmaces, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/magic/holy, 3, TRUE)
		if(H.age == AGE_OLD)
			H.mind.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
		H.change_stat("intelligence", 1)
		H.change_stat("endurance", 2) // For casting lots of spells, and working long hours without sleep at the church
		H.change_stat("perception", -1)

	var/datum/devotion/cleric_holder/C = new /datum/devotion/cleric_holder(H, H.patron)
	C.holder_mob = H
	H.verbs += list(/mob/living/carbon/human/proc/devotionreport, /mob/living/carbon/human/proc/clericpray)
	C.grant_spells(H)
