/// DEFINITIONS ///
#define CLERIC_T0 0
#define CLERIC_T1 1
#define CLERIC_T2 2
#define CLERIC_T3 3

#define CLERIC_REQ_1 2
#define CLERIC_REQ_2 3
#define CLERIC_REQ_3 5

// Cleric Holder Datums

/datum/devotion/cleric_holder
	var/holder_mob = null
	var/patron = null
	var/devotion = 0
	var/max_devotion = 100
	var/progression = 0
	var/level = CLERIC_T0

/datum/devotion/cleric_holder/New(mob/living/carbon/human/holder, god)
	holder_mob = holder
	holder.cleric = src
	patron = god

/datum/devotion/cleric_holder/proc/check_devotion(req)
	if(abs(req) <= devotion)
		return TRUE
	else
		return FALSE

// This is a proc to deduct a devotion cost out of spells when cast.
// We do this to avoid using negative values, which BYOND calculates in a really stupid way if we do the math wrong.
/datum/devotion/cleric_holder/proc/consume_devotion(amt as num)
	devotion -= amt
	var/mob/living/carbon/human/C = holder_mob
	var/amt2raise = C.STAINT*2
	progression += amt2raise

// This spell is used to ADD devotion to the player, through prayer or job initialization.
/datum/devotion/cleric_holder/proc/update_devotion(dev_amt as num, prog_amt)
	var/datum/patron/P = patron
	devotion += dev_amt
	//Max devotion limit
	if(devotion > max_devotion)
		devotion = max_devotion
		to_chat(holder_mob, "<font color='red'>I have reached the limit of my devotion...</font>")
	if(!prog_amt) // no point in the rest if it's just an expenditure
		return
	progression += prog_amt
	var/mob/living/carbon/human/H = holder_mob
	var/skill = H.mind?.get_skill_level(/datum/skill/magic/holy)
	switch(level)
		if(CLERIC_T0)
			if(skill >= CLERIC_REQ_1)
				level = CLERIC_T1
				usr.mind.AddSpell(new P.t1)
				max_devotion += 100
				return
		if(CLERIC_T1)
			if(skill >= CLERIC_REQ_2)
				level = CLERIC_T2
				usr.mind.AddSpell(new P.t2)
				max_devotion += 100
				return
		if(CLERIC_T2)
			return
	/*
			if(skill >= CLERIC_REQ_3)
				level = CLERIC_T3
				usr.mind.AddSpell(new P.t3)
				max_devotion += 100
				return
		if(CLERIC_T3) // already maxed out
			return
	*/

// Cleric Spell Spawner
/datum/devotion/cleric_holder/proc/grant_spells_priest(mob/living/carbon/human/H)
	if(!H || !H.mind)
		return

	var/datum/patron/A = H.patron
	var/list/spelllist = list(A.t0, A.t1, A.t2, A.t3)
	for(var/spell_type in spelllist)
		if(!spell_type || H.mind.has_spell(spell_type))
			continue
		H.mind.AddSpell(new spell_type)
	level = CLERIC_T3
	update_devotion(100, 900)
	max_devotion += 300

/datum/devotion/cleric_holder/proc/grant_spells(mob/living/carbon/human/H)
	if(!H || !H.mind)
		return

	var/datum/patron/A = H.patron
	var/list/spelllist = list(A.t0, A.t1, A.t2)
	for(var/spell_type in spelllist)
		if(!spell_type || H.mind.has_spell(spell_type))
			continue
		H.mind.AddSpell(new spell_type)
	level = CLERIC_T2
	max_devotion += 200

/datum/devotion/cleric_holder/proc/grant_spells_cleric(mob/living/carbon/human/H)
	if(!H || !H.mind)
		return

	var/datum/patron/A = H.patron
	var/list/spelllist = list(A.t0, A.t1, A.t2)
	for(var/spell_type in spelllist)
		if(!spell_type || H.mind.has_spell(spell_type))
			continue
		H.mind.AddSpell(new spell_type)
	level = CLERIC_T2
	max_devotion += 200

/datum/devotion/cleric_holder/proc/grant_spells_templar(mob/living/carbon/human/H)
	if(!H || !H.mind)
		return

	var/datum/patron/A = H.patron
	var/list/spelllist = list(/obj/effect/proc_holder/spell/targeted/churn, A.t0)
	for(var/spell_type in spelllist)
		if(!spell_type || H.mind.has_spell(spell_type))
			continue
		H.mind.AddSpell(new spell_type)
	level = CLERIC_T0

/mob/living/carbon/human/proc/devotionreport()
	set name = "Check Devotion"
	set category = "Cleric"

	var/datum/devotion/cleric_holder/C = src.cleric
	to_chat(src,"My devotion is [C.devotion].")

// Debug verb
/mob/living/carbon/human/proc/devotionchange()
	set name = "(DEBUG)Change Devotion"
	set category = "Special Verbs"

	var/datum/devotion/cleric_holder/C = src.cleric
	var/changeamt = input(src, "My devotion is [C.devotion]. How much to change?", "How much to change?") as null|num
	if(!changeamt)
		return
	C.devotion += changeamt

// Generation Procs

/mob/living/carbon/human/proc/clericpray()
	set name = "Start praying"
	set category = "Cleric"

	var/datum/devotion/cleric_holder/C = src.cleric
	var/prayersesh = 0

	visible_message("[src] kneels their head in prayer.", "I kneel my head in prayer to [patron.name]")
	for(var/i in 1 to 20)
		if(do_after(src, 30))
			if(C.devotion >= C.max_devotion)
				to_chat(src, "<font color='red'>I have reached the limit of my devotion...</font>")
				break
			var/devotiongain = 2
			for(var/obj/item/clothing/neck/roguetown/psycross/D in oview(5, src))
				devotiongain = 4
			for(var/obj/structure/fluff/psycross/S in oview(5, src))
				devotiongain = 8
			C.update_devotion(devotiongain, devotiongain)
			prayersesh += devotiongain
		else
			visible_message("[src] concludes their prayer.", "I conclude my prayer.")
			to_chat(src, "<font color='purple'>I gained [prayersesh] devotion!</font>")
			return
	to_chat(src, "<font color='purple'>I gained [prayersesh] devotion!</font>")

//kaizoku asset

/datum/devotion/cleric_holder/proc/grant_spells_sohei(mob/living/carbon/human/H)
	if(!H || !H.mind)
		return

	var/datum/patron/A = H.patron
	var/list/spelllist = list(/obj/effect/proc_holder/spell/invoked/icebind, A.t0)
	for(var/spell_type in spelllist)
		if(!spell_type || H.mind.has_spell(spell_type))
			continue
		H.mind.AddSpell(new spell_type)
	level = CLERIC_T0
	max_devotion = 200
