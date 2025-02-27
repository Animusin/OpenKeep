/datum/job/roguetown/farmer
	title = "Soilson"
	flag = FARMER
	department_flag = PEASANTS
	faction = "Station"
	total_positions = 5
	spawn_positions = 5
	display_order = JDO_SOILSON
	bypass_lastclass = FALSE
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(
		"Humen",
		"Elf",
		"Half-Elf",
		"Dwarf",
		"Tiefling",
		"Dark Elf",
		"Aasimar",
		"Changeling",
		"Skylancer",
		"Ogrun",
		"Undine"
	)
	tutorial = "It is a simple life you live, your basic understanding of life is something many would be envious of if they knew how perfect it was. You know a good day's work, the sweat on your brow is yours: Famines and plague may take its toll, but you know how to celebrate life well. Till the soil and produce fresh food for those around you, and maybe youll be more than an unsung hero someday."


	f_title = "Soilbride"
	outfit = /datum/outfit/job/roguetown/farmer
	give_bank_account = 20
	min_pq = -100
	selection_color = "#654d0b"
	whitelist_req = FALSE

/datum/outfit/job/roguetown/farmer/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/whipsflails, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/crafting, pick(2,3), TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/labor/farming, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/labor/taming, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE) // TODO! A way for them to operate submission holes without reading skill. Soilsons shouldn't be able to read.
		H.mind.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)

		H.change_stat("strength", 1)
		H.change_stat("constitution", 1)
		H.change_stat("endurance", 1)
		H.change_stat("intelligence", -1)
		ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_SEEDKNOW, TRAIT_GENERIC)

	neck = /obj/item/storage/belt/rogue/pouch/coins/poor

	if(HAS_TRAIT(H, TRAIT_KAIZOKU))
		wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/khudagach
		gloves = /obj/item/clothing/gloves/roguetown/fingerless/yugake
		armor = /obj/item/clothing/suit/roguetown/armor/gambeson/light/hitatare/random
		beltl = /obj/item/rogueweapon/sickle/kama //proper weapontool. Unique crafting for a handmade flail.kama
		shoes = /obj/item/clothing/shoes/roguetown/sandals/geta
		belt = /obj/item/storage/belt/rogue/leather/rope
		beltr = /obj/item/roguekey/soilson
		if(H.gender == FEMALE)
			shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/kimono
		else
			shirt = /obj/item/clothing/suit/roguetown/shirt/looseshirt
			pants = /obj/item/clothing/under/roguetown/trou/tobi
		var/helmettype = pickweight(list("Gasa" = 1, "Roningasa" = 1, "Sandogasa" = 1, "Takuhatsugasa" = 1, "Torioigasa" = 1))
		switch(helmettype)
			if("Gasa")
				head = /obj/item/clothing/head/roguetown/tengai/gasa
			if("Roningasa")
				head = /obj/item/clothing/head/roguetown/tengai/roningasa
			if("Sandogasa")
				head = /obj/item/clothing/head/roguetown/tengai/sandogasa
			if("Takuhatsugasa")
				head = /obj/item/clothing/head/roguetown/takuhatsugasa
			if("Torioigasa")
				head =/obj/item/clothing/head/roguetown/tengai/torioigasa
	else
		if(H.gender == MALE)
			head = /obj/item/clothing/head/roguetown/roguehood/random
			if(prob(50))
				head = /obj/item/clothing/head/roguetown/strawhat
			pants = /obj/item/clothing/under/roguetown/tights/random
			armor = /obj/item/clothing/suit/roguetown/armor/gambeson/light/striped
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
			shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
			belt = /obj/item/storage/belt/rogue/leather/rope
			beltr = /obj/item/roguekey/soilson
			beltl = /obj/item/rogueweapon/knife/villager
		else
			head = /obj/item/clothing/head/roguetown/armingcap
			armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
			shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
			belt = /obj/item/storage/belt/rogue/leather/rope
			beltr = /obj/item/roguekey/soilson
			beltl = /obj/item/rogueweapon/knife/villager

