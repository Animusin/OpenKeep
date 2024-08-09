/datum/antagonist/ork
	name = "Ork"
	roundend_category = "orks"
	antagpanel_category = "Ork"
	job_rank = "Ork"
	antag_hud_type = ANTAG_HUD_TRAITOR
	antag_hud_name = "ork"
	confess_lines = list("RAVAGE!!!", "I WILL NOT LIVE IN YOUR WALLS!", "I WILL NOT FOLLOW YOUR RULES!")

/datum/advclass/ork/ambush
	name = "Ambush ork"
	tutorial = ""
	allowed_sexes = list(MALE)
	outfit = /datum/outfit/job/roguetown/npc/orc/ambush
	category_tags = list(CTAG_ANTAG)
	maximum_possible_slots = 5

/datum/advclass/ork/tribal
	name = "Tribal ork"
	tutorial = ""
	allowed_sexes = list(MALE)
	outfit = /datum/outfit/job/roguetown/npc/orc/tribal
	category_tags = list(CTAG_ANTAG)
	maximum_possible_slots = 5

/datum/advclass/ork/warrior
	name = "Warrior ork"
	tutorial = ""
	allowed_sexes = list(MALE)
	outfit = /datum/outfit/job/roguetown/npc/orc/warrior
	category_tags = list(CTAG_ANTAG)
	maximum_possible_slots = 3

/datum/advclass/ork/marauder
	name = "Marauder ork"
	tutorial = ""
	allowed_sexes = list(MALE)
	outfit = /datum/outfit/job/roguetown/npc/orc/marauder
	category_tags = list(CTAG_ANTAG)
	maximum_possible_slots = 2

/datum/advclass/ork/warlord
	name = "Warlord ork"
	tutorial = ""
	allowed_sexes = list(MALE)
	outfit = /datum/outfit/job/roguetown/npc/orc/warlord
	category_tags = list(CTAG_ANTAG)
	maximum_possible_slots = 1

/datum/job/roguetown/ork
	title = "Ork"
	flag = GRAVEDIGGER
	department_flag = PEASANTS
	faction = "orcs"
	total_positions = 10
	spawn_positions = 0

	allowed_sexes = list(MALE)
	allowed_races = list(
		"Humen",
		"Elf", 
		"Half-Elf",
		"Dwarf",
		"Tiefling",
		"Dark Elf",
		"Aasimar"
	)
	tutorial = ""
	outfit = null
	show_in_credits = FALSE
	give_bank_account = FALSE
	outfit_female = null
	advclass_cat_rolls = list(CTAG_ANTAG = 20)

/datum/job/roguetown/ork/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(L)
		var/mob/living/carbon/human/H = L
		H.advsetup = 1
		H.invisibility = INVISIBILITY_MAXIMUM
		H.become_blind("advsetup")
		if(M.mind)
			M.mind.special_role = "Ork"
			M.mind.assigned_role = "Ork"
			M.mind.current.job = "Ork"
		if(H.dna && H.dna.species)
			H.set_species(/datum/species/orc)
            H.after_creation()
		H.ambushable = FALSE
		H.underwear = "Nude"
		if(H.charflaw)
			QDEL_NULL(H.charflaw)

/datum/outfit/job/roguetown/ork/pre_equip(mob/living/carbon/human/H)
	..()
	var/datum/antagonist/new_antag = new /datum/antagonist/ork()
	H.mind.add_antag_datum(new_antag)