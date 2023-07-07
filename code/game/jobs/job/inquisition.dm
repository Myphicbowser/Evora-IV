// Interrogator

/datum/job/acolyte
	title = "Interrogator"
	department_flag = INQ
	social_class = SOCIAL_CLASS_MIN
	total_positions = 1
	spawn_positions = 1
	latejoin_at_spawnpoints = TRUE
	open_when_dead = 0
	supervisors = "The Golden Throne, and Your Lord Inquisitor"
	selection_color = "#b4821c"
	economic_modifier = 7
	minimal_player_age = 18
	outfit_type = /decl/hierarchy/outfit/job/interrogator
	announced = FALSE
	auto_rifle_skill = 9
	semi_rifle_skill = 9
	sniper_skill = 9
	shotgun_skill = 9
	lmg_skill = 9
	smg_skill = 9
	cultist_chance = 20
	role_desc = "You are an interrogator, the apprentice of, the Lord Inquisitor. It is not uncommon for Interrogators' to work undercover or incognito. Your task is to assist the Lord Inquisitor in investigating, neutralizing and erasing traces of heresy, chaos, xenos and daemons. Now more then ever your actions are being weighed by not only your master, but the inquisition - this mission is the last opportunity to clear the names of not only the Lord Inquisitor but that of his entire retinue..."

	equip(var/mob/living/carbon/human/H)
		var/current_name = H.real_name
		..()
		H.fully_replace_character_name("[current_name]")
		H.add_stats(rand(15,18), rand(15,18), rand(15,18), rand(15,18)) //highly trained and skilled
		H.add_skills(rand(9,10),rand(9,10),rand(5,7),rand(5,6),rand(6,7)) //SUFFER NOT THE ALIEN, SUFFER NOT THE HERETIC
		H.assign_random_quirk()
		H.witchblood()
		H.set_trait(new/datum/trait/death_tolerant())
		H.warfare_language_shit(LANGUAGE_LOW_GOTHIC )
		H.warfare_language_shit(LANGUAGE_HIGH_GOTHIC )
		H.warfare_faction = IMPERIUM
		H.get_idcard()?.access = list(access_security, access_guard_common, access_magi, access_all_personal_lockers, access_advchapel, access_inquisition)
		H.adjustStaminaLoss(-INFINITY)
		H.vice = null
		H.say(":i [title] &(47*TECHNICA)Z(INQ)... transponder signal active.")
		to_chat(H, "<span class='notice'><b><font size=3> You are an interrogator, the apprentice of, the Lord Inquisitor. It is not uncommon for Interrogators' to work undercover or incognito. Your task is to assist the Lord Inquisitor in investigating, neutralizing and erasing traces of heresy, chaos, xenos and daemons. Now more then ever your actions are being weighed by not only your master, but the inquisition - this mission is the last opportunity to clear the names of not only the Lord Inquisitor but that of his entire retinue...</font></b></span>")

/datum/job/acolyte/equip(var/mob/living/carbon/human/H)
	. = ..()
	if(.)
		H.implant_loyalty(H)

// Inquisitor

/datum/job/inquisitor
	title = "Inquisitor"
	department_flag = INQ
	social_class = SOCIAL_CLASS_MIN
	total_positions = 0
	spawn_positions = 0
	head_position = 1
	supervisors = "The Golden Throne and the Inquisition"
	selection_color = "#b4821c"
	req_admin_notify = 1
	latejoin_at_spawnpoints = TRUE
	economic_modifier = 7
	minimal_player_age = 21
	open_when_dead = 0
	outfit_type = /decl/hierarchy/outfit/job/inquisitor
	auto_rifle_skill = 10
	semi_rifle_skill = 10
	sniper_skill = 10
	shotgun_skill = 10
	lmg_skill = 10
	smg_skill = 10
	cultist_chance = 30

	equip(var/mob/living/carbon/human/H)
		var/current_name = H.real_name
		..()
		H.fully_replace_character_name("[current_name]")
		H.add_stats(rand(17,18), rand(17,18), rand(17,18), rand(17,19)) //PRAISE THE EMPEROR
		H.add_skills(10,10,rand(7,10),rand(5,7),rand(7,8)) //melee, ranged, med, eng, surgery
		H.assign_random_quirk()
		H.warfare_language_shit(LANGUAGE_LOW_GOTHIC )
		H.warfare_language_shit(LANGUAGE_HIGH_GOTHIC )
		H.set_trait(new/datum/trait/death_tolerant())
		H.warfare_faction = IMPERIUM
		H.witchblood()
		H.get_idcard()?.access = list(access_security, access_guard_common, access_magi, access_all_personal_lockers, access_advchapel, access_inquisition, access_inquisition_fancy)
		H.inquisitor = 1
		H.adjustStaminaLoss(-INFINITY)
		H.say(":i [title] &(47*TECHNICA)Z(INQ)... transponder signal active.")
		H.vice = null
		to_chat(H, "<span class='notice'><b><font size=3>You are extremis diabolus, an inquisitor in service to the Ordos that has been considered for reasons up to you, a liability to the inquisition. Every person, asset and object on this planet is a tool or resource to be exploited. Humiliation, torture and the dull thud of a bolt pistol is what awaits you in failure should you not prove yourself here. Your acolytes personally selected to serve only you, whether they survive the horrid taint associated with your name and rise to the ranks of Inquisitor shall be determined in the coming weeks.</font></b></span>")

/datum/job/inquisitor/equip(var/mob/living/carbon/human/H)
	. = ..()
	if(.)
		H.implant_loyalty(H)


// inq outfits
/decl/hierarchy/outfit/job/interrogator
	name = OUTFIT_JOB_NAME("Interrogator")
	uniform = /obj/item/clothing/under/rank/principalagent
	suit = null
	back = /obj/item/storage/backpack/satchel/warfare
	belt = null
	gloves = /obj/item/clothing/gloves/thick/swat/combat/warfare
	shoes = /obj/item/clothing/shoes/jackboots/inquisitor/acolyte
	head = null
	mask = null
	glasses = null
	id = /obj/item/card/id/inquisition/principal_agent
	l_ear = /obj/item/device/radio/headset/inquisition
	r_ear = null
	l_pocket = /obj/item/storage/box/ifak
	r_pocket = null
	suit_store = null
	neck = /obj/item/reagent_containers/food/drinks/canteen
	backpack_contents = list(
	/obj/item/device/flashlight/lantern = 1,
	/obj/item/reagent_containers/food/snacks/warfare/rat = 1,
	/obj/item/stack/thrones/five = 1,
	/obj/item/stack/thrones2/ten = 1,
	/obj/item/stack/thrones3/twenty = 1
	)

	pda_slot = null
	flags = OUTFIT_NO_BACKPACK|OUTFIT_NO_SURVIVAL_GEAR

/decl/hierarchy/outfit/job/inquisitor
	name = OUTFIT_JOB_NAME("Inquisitor")
	uniform = /obj/item/clothing/under/rank/principalagent
	suit = null
	back = /obj/item/storage/backpack/satchel/warfare
	belt = null
	gloves = /obj/item/clothing/gloves/thick/swat/combat/warfare
	shoes = /obj/item/clothing/shoes/jackboots/inquisitor
	head = null
	mask = null
	glasses = null
	id = /obj/item/card/id/inquisition/principal_agent
	l_ear = /obj/item/device/radio/headset/inquisition
	r_ear = null
	l_pocket = /obj/item/storage/box/ifak
	r_pocket = null
	neck = /obj/item/reagent_containers/food/drinks/canteen
	backpack_contents = list(
	/obj/item/device/flashlight/lantern = 1,
	/obj/item/stack/thrones/five = 1,
	/obj/item/stack/thrones2/ten = 1,
	)

	pda_slot = null
	flags = OUTFIT_NO_BACKPACK|OUTFIT_NO_SURVIVAL_GEAR
