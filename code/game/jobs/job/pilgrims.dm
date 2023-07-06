/datum/job/penitent //the plan is to have penitent be a default landing job, I will eventually add a randomized system that gives different loadouts much like the migrant system of lifeweb
	title = "Pilgrim"
	department_flag = PIL
	social_class = SOCIAL_CLASS_MIN //these boys are gross
	total_positions = INFINITY //maybe open up more of these when we figure out other classes and depending on player count
	spawn_positions = INFINITY
	supervisors = "The God Emperor of Mankind"
	selection_color = "#848484"
	outfit_type = /decl/hierarchy/outfit/job/penitent
	latejoin_at_spawnpoints = TRUE
	announced = FALSE
	cultist_chance = 100
	role_desc = "You are a vagrant. You have no real home here and you have no real future here. <br> <span class = 'badmood'> + Go to your pilgrim tab and select your fate. + "


	equip(var/mob/living/carbon/human/H)
		H.warfare_faction = IMPERIUM
		..()
		H.add_stats(rand(1,2), rand(1,2), rand(1,2), rand (1,2)) //no stats when spawning so they are FORCED to select class first
		H.warfare_language_shit(LANGUAGE_LOW_GOTHIC)
		H.adjustStaminaLoss(-INFINITY)
		H.assign_random_quirk()
		H.witchblood()
		H.stat = UNCONSCIOUS
		H.sleeping = 500
		to_chat(H, "<span class='notice'><b><font size=3>You are a vagrant. You have no real home here and you have no real future here. <br> <span class = 'badmood'> + Go to your pilgrim tab and select your fate. + </span> </font></b></span>")
		H.verbs += list(
			/mob/living/carbon/human/proc/penitentclass,
		)

/datum/job/citizen //the plan is to have penitent be a default landing job, I will eventually add a randomized system that gives different loadouts much like the migrant system of lifeweb
	title = "Imperial Citizen"
	department_flag = PIL
	social_class = SOCIAL_CLASS_MED //these boys are less gross
	total_positions = INFINITY //maybe open up more of these when we figure out other classes and depending on player count
	spawn_positions = INFINITY
	supervisors = "The God Emperor of Mankind and the Imperial Government"
	selection_color = "#848484"
	outfit_type = /decl/hierarchy/outfit/job/penitent
	latejoin_at_spawnpoints = TRUE
	announced = FALSE
	cultist_chance = 30
	role_desc = "You are an Imperial Citizen local to the planet of Evora IV. <br> <span class = 'badmood'> + Go to your citizen tab and select your fate. +"


	equip(var/mob/living/carbon/human/H)
		H.warfare_faction = IMPERIUM
		..()
		H.add_stats(rand(6,11), rand(7,12), rand(8,12), rand (8,11)) //they suck and are supposed to suck
		H.warfare_language_shit(LANGUAGE_LOW_GOTHIC)
		H.adjustStaminaLoss(-INFINITY)
		H.assign_random_quirk()
		H.witchblood()
		H.get_idcard()?.access = list(access_village) // so they open all 211
		to_chat(H, "<span class='notice'><b><font size=3>You are an Imperial Citizen local to the planet of Evora IV. <br> <span class = 'badmood'> + Go to your citizen tab and select your fate. + </span> </font></b></span>")

		H.verbs += list(
			/mob/living/carbon/human/proc/citizenclass,
		)


/*
Pilgrim Fate System
*/

//mob/living/carbon/human/proc/penitentclass(var/mob/living/carbon/human/M)
/mob/living/carbon/human/proc/penitentclass()
	set name = "Select your class"
	set category = "Pilgrim"
	set desc = "Choose your new profession on this strange world."
	if(!ishuman(src))
		to_chat(src, "<span class='notice'>How tf are you seeing this, ping Wel Ard immediately</span>")
		return
	if(src.stat == DEAD)
		to_chat(src, "<span class='notice'>You can't choose a class when you're dead.</span>")
		return

	var/mob/living/carbon/human/U = src
	var/fates = list("Penitent","Rat Catcher","Drug Dealer")


	var/classchoice = input("Choose your fate", "Available fates") as anything in fates

 //10 is base stat, below 12 is child stat, childs are supposed to be somewhere between 6-14 in stats.
 //skills are between 1-5 for roles that have little to no reason to know something, 5-10 if they are able to naturally learn those skills, 5 is baseline,
	switch(classchoice)

		if("Rat Catcher")
			U.add_stats(rand(13,15), rand(14,16), rand(12,18), rand (12,14)) //ratcatcher has high endurance+dext due to his role in the rat catching, disease chasing society
			U.add_skills(rand(5,8),rand(4,6),rand(3,6),rand(2,6),rand(2,6)) //melee, ranged, med, eng, surgery
			equip_to_slot_or_del(new /obj/item/clothing/under/rank/victorian, slot_w_uniform)
			equip_to_slot_or_del(new /obj/item/clothing/suit/armor/leather, slot_wear_suit)
			equip_to_slot_or_del(new /obj/item/glass_jar, slot_r_hand)
			equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/warfare, slot_back)
			equip_to_slot_or_del(new /obj/item/clothing/head/helmet/hard_had, slot_head)
			equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_service, slot_l_ear)
			equip_to_slot_or_del(new /obj/item/stack/thrones3/twenty, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/melee/trench_axe/bspear, slot_l_hand)
			equip_to_slot_or_del(new /obj/item/device/flashlight/lantern, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/card/id/pilgrim/penitent, slot_wear_id)
			equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots/pilgrim_boots, slot_shoes)
			to_chat(U,"<span class='notice'><b><font size=3>Your father hunted rats. Your grandfather hunted rats. By the emperor, you're going to hunt some rats. Remember, ratmen don't exist. </font></b></span>")
			U.verbs -= list(/mob/living/carbon/human/proc/penitentclass,) //removes verb
			U.stat = CONSCIOUS
			U.sleeping = 0
			to_chat(U, "<span class='goodmood'>+ You awaken from your slumber... +</span>\n")

		if("Penitent")
			U.add_stats(rand(13,14), rand(13,13), rand(10,14), rand (10,12)) //ex criminal, not fed very well, but random stats
			U.add_skills(rand(5,10),rand(5,10),rand(5,10),rand(5,10),rand(5,10)) //melee, ranged, med, eng, surgery
			equip_to_slot_or_del(new /obj/item/clothing/under/rank/penitent, slot_w_uniform)
			equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots/pilgrim_boots, slot_shoes)
			equip_to_slot_or_del(new /obj/item/clothing/suit/raggedrobe, slot_wear_suit)
			equip_to_slot_or_del(new /obj/item/clothing/head/plebhood, slot_head)
			equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_sci, slot_l_ear)
			equip_to_slot_or_del(new /obj/item/card/id/pilgrim/penitent, slot_wear_id)
			equip_to_slot_or_del(new /obj/item/torch/self_lit, slot_l_hand)
			to_chat(U, "<span class='notice'><b><font size=3>You are a penitent, after committing several horrible crimes to the imperium, you were arrested and imprisoned for years, will you repent for your sins or will you fall to the society surrounding you? The Choice is Yours, My friend.</font></b></span>")
			U.verbs -= list(/mob/living/carbon/human/proc/penitentclass,)
			U.stat = CONSCIOUS
			U.sleeping = 0
			to_chat(U, "<span class='goodmood'>+ You awaken from your slumber... +</span>\n")

		if("Drug Dealer")
			U.add_stats(rand(13,14), rand(15,16), rand(10,14), rand (17,18)) //good at dodgin them cops!
			U.add_skills(rand(7,9),rand(5,6),rand(3,5),rand(2,3),rand(3,5)) //melee, ranged, med, eng, surgery
			if(prob(50))
				equip_to_slot_or_del(new /obj/item/clothing/under/rank/victorian, slot_w_uniform)
			else if(prob(50))
				equip_to_slot_or_del(new /obj/item/clothing/under/rank/victorian/blred, slot_w_uniform)
			else
				equip_to_slot_or_del(new /obj/item/clothing/under/rank/victorian/redbl, slot_w_uniform)
			equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/warfare, slot_back)
			equip_to_slot_or_del(new /obj/item/clothing/suit/scum, slot_wear_suit)
			equip_to_slot_or_del(new /obj/item/clothing/head/scum, slot_head)
			equip_to_slot_or_del(new /obj/item/storage/fancy/cigarettes/dromedaryco, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/storage/fancy/cigarettes/dromedaryco, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/storage/pill_bottle/happy, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/storage/pill_bottle/happy, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/storage/pill_bottle/zoom, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/device/flashlight/lantern, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/stack/thrones3/twenty, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/stack/thrones/five, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_service, slot_l_ear)
			equip_to_slot_or_del(new /obj/item/flame/lighter/zippo, slot_l_store)
			equip_to_slot_or_del(new /obj/item/card/id/pilgrim/penitent, slot_wear_id)
			equip_to_slot_or_del(new /obj/item/clothing/shoes/prac_boots, slot_shoes)
			equip_to_slot_or_del(new /obj/item/torch/self_lit, slot_l_hand)
			equip_to_slot_or_del(new /obj/item/stack/thrones3/twenty, slot_in_backpack)
			to_chat(U,"<span class='notice'><b><font size=3>Always on the run, always moving from operation to operation you once again find yourself in a new city. You'll do whatever it takes to get rich. Scamming, gambling, drug dealing. You are the scum of the Imperium but you wouldn't have it any other way.</font></b></span>")
			U.verbs -= list(/mob/living/carbon/human/proc/penitentclass,)
			U.stat = CONSCIOUS
			U.sleeping = 0
			to_chat(U, "<span class='goodmood'>+ You awaken from your slumber... +</span>\n")


/mob/living/carbon/human/proc/citizenclass()
	set name = "Select your class"
	set category = "Citizen"
	set desc = "Remember who you are..."
	if(!ishuman(src))
		to_chat(src, "<span class='notice'>How tf are you seeing this, ping Wel Ard immediately</span>")
		return
	if(src.stat == DEAD)
		to_chat(src, "<span class='notice'>You can't choose a class when you're dead.</span>")
		return

	var/mob/living/carbon/human/U = src
	var/fates = list("Merchant","Miner","Private Investigator", "Musician", "Hunter", "Farmhand")


	var/classchoice = input("Choose your fate", "Available fates") as anything in fates

 //10 is base stat, below 12 is child stat, childs are supposed to be somewhere between 6-14 in stats.
 //skills are between 1-5 for roles that have little to no reason to know something, 5-10 if they are able to naturally learn those skills, 5 is baseline,
	switch(classchoice)

		if("Private Investigator")
			U.add_stats(rand(14,16), rand(14,16), rand(12,15), rand (15,17)) //the private investigator's a smart and keen guy, but he aint that big of a bitch in the world cause hes poor
			U.add_skills(rand(7,10),rand(7,9),rand(2,4),rand(3,4),rand(2,3)) //melee, ranged, med, eng, surgery
			equip_to_slot_or_del(new /obj/item/clothing/under/det/black, slot_w_uniform)
			equip_to_slot_or_del(new /obj/item/clothing/suit/armor/tduster, slot_wear_suit)
			equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/warfare, slot_back)
			equip_to_slot_or_del(new /obj/item/clothing/head/det, slot_head )
			equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_service, slot_l_ear)
			equip_to_slot_or_del(new /obj/item/ammo_magazine/a357/ms, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/ammo_magazine/a357/ms, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/reagent_containers/food/snacks/warfare/rat, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/storage/briefcase/crimekit, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/storage/fancy/cigarettes/dromedaryco, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/flame/lighter, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/gun/projectile/revolver/messina, slot_l_hand)
			equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots/pilgrim_boots, slot_shoes)
			equip_to_slot_or_del(new /obj/item/card/id/pilgrim/penitent, slot_wear_id)
			equip_to_slot_or_del(new /obj/item/stack/thrones3/twenty, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/device/flashlight/lantern, slot_in_backpack)
			to_chat(U,"<span class='notice'><b><font size=3>You are a private eye in the city of settlement of Aquileia. You investigate that which the Enforcers will not.</font></b></span>")
			U.stat = CONSCIOUS
			U.verbs -= list(/mob/living/carbon/human/proc/citizenclass,)
			U.sleeping = 0
			to_chat(U, "<span class='goodmood'>+ You awaken from your slumber... +</span>\n")

		if("Miner")
			U.add_stats(rand(16,18), rand(10,14), rand(10,14), rand (8,12)) //
			U.add_skills(rand(6,8),rand(4,7),rand(3,3),rand(5,6),rand(2,2)) //melee, ranged, med, eng, surgery
			equip_to_slot_or_del(new /obj/item/clothing/gloves/thick, slot_gloves)
			equip_to_slot_or_del(new /obj/item/clothing/head/helmet/hard_had, slot_head)
			equip_to_slot_or_del(new /obj/item/clothing/under/rank/victorian, slot_w_uniform)
			equip_to_slot_or_del(new /obj/item/storage/newore, slot_belt)
			equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/satchel_eng, slot_back)
			equip_to_slot_or_del(new /obj/item/reagent_containers/food/snacks/warfare/rat, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/reagent_containers/food/snacks/warfare/rat, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/pickaxe/newpick, slot_l_hand)
			equip_to_slot_or_del(new /obj/item/melee/trench_axe/glaive, slot_r_hand)
			equip_to_slot_or_del(new /obj/item/clothing/suit/miner, slot_wear_suit)
			equip_to_slot_or_del(new /obj/item/clothing/shoes/prac_boots, slot_shoes)
			equip_to_slot_or_del(new /obj/item/device/flashlight/lantern, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/card/id/ring/disgracedmedicae, slot_in_backpack)
			to_chat(U,"<span class='notice'><b><font size=3>A veteran of many digsites. You traveled the planet looking for work.You supply the Mechanicus and local merchants.</font></b></span>")
			U.stat = CONSCIOUS
			U.verbs -= list(/mob/living/carbon/human/proc/citizenclass,)
			U.sleeping = 0
			to_chat(U, "<span class='goodmood'>+ You awaken from your slumber... +</span>\n")

		if("Farmhand")
			U.add_stats(rand(16,18), rand(10,14), rand(10,14), rand (8,12)) //
			U.add_skills(rand(6,8),rand(4,7),rand(3,3),rand(5,6),rand(2,2)) //melee, ranged, med, eng, surgery
			equip_to_slot_or_del(new /obj/item/clothing/gloves/thick/botany, slot_gloves)
			equip_to_slot_or_del(new /obj/item/clothing/under/rank/victorian, slot_w_uniform)
			equip_to_slot_or_del(new /obj/item/storage/plants, slot_belt)
			equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/satchel_eng, slot_back)
			equip_to_slot_or_del(new /obj/item/reagent_containers/food/snacks/warfare/rat, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/reagent_containers/food/snacks/warfare/rat, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/farmshovel, slot_l_hand)
			equip_to_slot_or_del(new /obj/item/clothing/shoes/prac_boots, slot_shoes)
			equip_to_slot_or_del(new /obj/item/device/flashlight/lantern, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/card/id/ring/disgracedmedicae, slot_in_backpack)
			to_chat(U,"<span class='notice'><b><font size=3>You are a farmhand that works on Sweetberry Farm, the farm in the southeast corner of Aquileia. </font></b></span>")
			U.stat = CONSCIOUS
			U.verbs -= list(/mob/living/carbon/human/proc/citizenclass,)
			U.sleeping = 0
			to_chat(U, "<span class='goodmood'>+ You awaken from your slumber... +</span>\n")

		if("Merchant")
			U.add_stats(rand(12,14), rand(11,14), rand(15,17), rand (15,16)) // hes really not used to this level of shittery, he can range from weaker than a child to average pea-sent
			U.add_skills(rand(3,5),rand(5,7),rand(1,6),rand(1,6),rand(1,6)) //melee, ranged, med, eng, surgery
			equip_to_slot_or_del(new /obj/item/clothing/head/that, slot_head)
			if(prob(60))
				equip_to_slot_or_del(new /obj/item/clothing/under/rank/victorian/blred, slot_w_uniform)
			else
				equip_to_slot_or_del(new /obj/item/clothing/under/rank/victorian/redbl, slot_w_uniform)
			equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/warfare, slot_back)
			equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/leather/tailcoat, slot_wear_suit)
			equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_service, slot_l_ear)
			equip_to_slot_or_del(new /obj/item/reagent_containers/food/snacks/warfare/rat, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/stack/thrones/five, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/stack/thrones/five, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/stack/thrones2/ten, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/stack/thrones2/ten, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/stack/thrones3/twenty, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/card/id/pilgrim/penitent, slot_wear_id)
			equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots/pilgrim_boots, slot_shoes)
			equip_to_slot_or_del(new /obj/item/torch/self_lit, slot_l_hand)
			to_chat(U,"<span class='notice'>Guided by your lust for thrones you smelled opportunity in this city. Work with the local Lord and Ladies to organize trade and enrich yourself.<b><font size=3>")
			U.verbs -= list(/mob/living/carbon/human/proc/citizenclass,)
			U.stat = CONSCIOUS
			U.sleeping = 0
			to_chat(U, "<span class='goodmood'>+ You awaken from your slumber... +</span>\n")

		if("Musician")
			U.add_stats(rand(15,16), rand(8,16), rand(10,14), rand (12,16)) // roaming musician
			U.add_skills(rand(6,8),rand(4,8),rand(1,6),rand(1,6),rand(1,6)) //melee, ranged, med, eng, surgery
			equip_to_slot_or_del(new /obj/item/device/violin, slot_l_hand)
			equip_to_slot_or_del(new /obj/item/clothing/under/rank/victorian, slot_w_uniform)
			equip_to_slot_or_del(new /obj/item/clothing/suit/musician, slot_wear_suit)
			equip_to_slot_or_del(new /obj/item/clothing/head/musichat, slot_head)
			equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_service, slot_l_ear)
			equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/warfare, slot_back)
			equip_to_slot_or_del(new /obj/item/stack/thrones/five, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/stack/thrones2/ten, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/stack/thrones3/twenty, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/device/flashlight/lantern, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/card/id/pilgrim/penitent, slot_wear_id)
			equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots/pilgrim_boots, slot_shoes)

			to_chat(U,"<span class='notice'><b><font size=3>A wandering bard you find yourself moving from tavern to tavern entertaining the masses for a few thrones at a time. This city will surely be no different. </font></b></span>")
			U.verbs -= list(/mob/living/carbon/human/proc/citizenclass,)
			U.stat = CONSCIOUS
			U.sleeping = 0
			to_chat(U, "<span class='goodmood'>+ You awaken from your slumber... +</span>\n")

		if("Hunter")
			U.add_stats(rand(15,16), rand(16,18), rand(16,18), rand (8,12)) //nice stats, really good at being quick, carrying shit and enduring pain
			U.add_skills(rand(6,9),rand(7,10),rand(1,2),rand(3,4),rand(2,3)) //melee, ranged, med, eng, surgery
			equip_to_slot_or_del(new /obj/item/storage/belt/stalker, slot_belt)
			equip_to_slot_or_del(new /obj/item/clothing/under/rank/victorian, slot_w_uniform)
			equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots/pilgrim_boots, slot_shoes)
			equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/warfare, slot_back)
			equip_to_slot_or_del(new /obj/item/material/knife/butch, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_service, slot_l_ear)
			equip_to_slot_or_del(new /obj/item/clothing/suit/chokha, slot_wear_suit)
			equip_to_slot_or_del(new /obj/item/device/flashlight/lantern, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/stack/thrones3/twenty, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/card/id/pilgrim/penitent, slot_wear_id)
			equip_to_slot_or_del(new /obj/item/clothing/head/pillbox, slot_head)
			equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/brifle_handful, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/gun/projectile/shotgun/pump/boltaction/sharpshooter, slot_l_hand)
			to_chat(U,"<span class='notice'><b><font size=3>You guide the highborn of the city when they hunt for sport. You have been granted the right to hunt on your own in the Margrave's woods and in the caves. </font></b></span>")
			U.verbs -= list(/mob/living/carbon/human/proc/citizenclass,)
			U.stat = CONSCIOUS
			U.sleeping = 0
			to_chat(U, "<span class='goodmood'>+ You awaken from your slumber... +</span>\n")

		if("Mercenary")
			U.add_stats(rand(13,17), rand(14,17), rand(14,17), rand (10,12)) //veteran mercenary
			U.add_skills(rand(7,10),rand(8,10),rand(3,6),rand(2,4),rand(1,3)) //melee, ranged, med, eng, surgery
			equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/warfare, slot_back)
			equip_to_slot_or_del(new /obj/item/clothing/under/rank/victorian, slot_w_uniform)
				//Armor Rolls
			if(prob(25))
				equip_to_slot_or_del(new /obj/item/clothing/suit/armor/carapace2, slot_wear_suit)
			else if(prob(25))
				equip_to_slot_or_del(new /obj/item/clothing/suit/armor/flak1, slot_wear_suit)
			else if(prob(25))
				equip_to_slot_or_del(new /obj/item/clothing/suit/armor/breastplate, slot_wear_suit)
			else if(prob(25))
				equip_to_slot_or_del(new /obj/item/clothing/suit/armor/armoredtrench, slot_wear_suit)
			else
				equip_to_slot_or_del(new /obj/item/clothing/suit/armor/bountyhunter2, slot_wear_suit)
				//Weapon Rolls
			if(prob(40))
				equip_to_slot_or_del(new /obj/item/gun/projectile/automatic/machinepistol, slot_l_hand)
			else if(prob(10))
				equip_to_slot_or_del(new /obj/item/gun/projectile/shotgun/pump/shitty/magrave, slot_l_hand)
			else if(prob(10))
				equip_to_slot_or_del(new /obj/item/gun/energy/las/lasgun, slot_l_hand)
			else if(prob(10))
				equip_to_slot_or_del(new /obj/item/gun/projectile/shotgun/pump/boltaction/shitty/tinkered, slot_l_hand)
			else if(prob(10))
				equip_to_slot_or_del(new /obj/item/gun/projectile/automatic/m22/combatrifle, slot_l_hand)
			else
				equip_to_slot_or_del(new /obj/item/gun/energy/las/laspistol, slot_l_hand)
				//Back to Hardset Loadout
			equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_service, slot_l_ear)
			equip_to_slot_or_del(new /obj/item/torch/self_lit, slot_r_hand)
			equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots/pilgrim_boots, slot_shoes)
			equip_to_slot_or_del(new /obj/item/card/id/pilgrim/penitent, slot_wear_id)
			to_chat(U,"<span class='notice'><b><font size=3>You are a mercenary and bounty hunter in the city of Aquileia.</font></b></span>")
			U.verbs -= list(/mob/living/carbon/human/proc/citizenclass,)
			U.stat = CONSCIOUS
			U.sleeping = 0
			to_chat(U, "<span class='goodmood'>+ You awaken from your slumber... +</span>\n")


/datum/job/underboss  //second in command
	title = "Capo"
	department_flag = PIL
	social_class = SOCIAL_CLASS_HIGH //he's important to the pilgrims, but not to anyone else
	total_positions = 1
	spawn_positions = 1
	open_when_dead = 1
	supervisors = "The Rogue Trader"
	selection_color = "#530606"
	access = list(access_bar, access_ganger)
	minimal_access = list(access_bar)
	outfit_type = /decl/hierarchy/outfit/job/underboss
	latejoin_at_spawnpoints = TRUE
	announced = FALSE
	cultist_chance = 5
	role_desc = "You're one of the leaders of the Rogue Trader's criminal enterprise. You run the inn, the brothel within it, and control the sale of drugs in your territory."

	equip(var/mob/living/carbon/human/H)
		H.warfare_faction = IMPERIUM
		..()
		H.add_stats(rand(13,16), rand(13,16), rand(9,12), rand (8,11))
		H.add_skills(rand(7,8),rand(7,9),rand(2,3),2,2) //melee, ranged, med, eng, surgery
		H.warfare_language_shit(LANGUAGE_LOW_GOTHIC)
		H.adjustStaminaLoss(-INFINITY)
		H.assign_random_quirk()
		to_chat(H, "<span class='notice'><b><font size=3>You're one of the leaders of the Rogue Trader's criminal enterprise. You run the inn, the brothel within it, and control the sale of drugs in your territory. </font></b></span>")

/datum/job/pathfinder
	title = "Pathfinder"
	department_flag = PIL
	social_class = SOCIAL_CLASS_HIGH
	total_positions = 1
	spawn_positions = 1
	open_when_dead = 0
	supervisors = "Your own morality and ethics."
	selection_color = "#848484"
	access = list(access_bar,)
	minimal_access = list(access_bar)
	outfit_type = /decl/hierarchy/outfit/job/administrator
	latejoin_at_spawnpoints = TRUE
	announced = FALSE
	cultist_chance = 100
	role_desc = "Your family rose to prominance in court generations ago serving as cartographers for the Lord-Governor. After a series of scandals your clan has lost favor with the ruling houses of Evora IV which has greatly diminished your influence.. You have a manor in the city of Aquileia, a title, and a modest fortune. What you make of this is your choice."

	equip(var/mob/living/carbon/human/H)
		H.warfare_faction = IMPERIUM
		..()
		H.add_stats(rand(15,17), rand(16,17), rand(10,13), rand (16,18)) //strong stats due to their... interesting fame of being cult leaders
		H.add_skills(rand(7,9),rand(7,10),rand(4,6),4,rand(6,8)) //melee, ranged, med, eng, surgery
		H.warfare_language_shit(LANGUAGE_LOW_GOTHIC)
		H.adjustStaminaLoss(-INFINITY)
		H.assign_random_quirk()
		to_chat(H, "<span class='notice'><b><font size=3>Your family rose to prominance in court generations ago serving as cartographers for the Lord-Governor. After a series of scandals your clan has lost favor with the ruling houses of Evora IV which has greatly diminished your influence.. You have a manor in the city of Aquileia, a title, and a modest fortune. What you make of this is your choice.</font></b></span>")

/datum/job/villagemedicae
	title = "Village Medicae"
	department_flag = PIL
	social_class = SOCIAL_CLASS_MED
	total_positions = 3
	spawn_positions = 3
	open_when_dead = 0
	supervisors = "Your own morality and ethics."
	selection_color = "#848484"
	access = list(access_bar,)
	minimal_access = list(access_bar)
	outfit_type = /decl/hierarchy/outfit/job/medicae
	latejoin_at_spawnpoints = TRUE
	announced = FALSE
	cultist_chance = 100

	equip(var/mob/living/carbon/human/H)
		H.warfare_faction = IMPERIUM
		..()
		H.add_stats(rand(13,15), rand(14,15), rand(16,18), rand (18,22)) //strong stats due to their... interesting fame of being cult leaders
		H.add_skills(rand(6,8),rand(6,7),rand(8,10),4,rand(8,10)) //melee, ranged, med, eng, surgery
		H.warfare_language_shit(LANGUAGE_LOW_GOTHIC)
		H.adjustStaminaLoss(-INFINITY)
		H.assign_random_quirk()
		to_chat(H, "<span class='notice'><b><font size=3>Barred from practicing medicine on your world of origin you are one of the many pilgrims who have traveled here in search of a new life.</font></b></span>")


//loadouts below here
/decl/hierarchy/outfit/job/medicae
	name = OUTFIT_JOB_NAME("Village Medicae")
	uniform = /obj/item/clothing/under/rank/victorian
	suit = /obj/item/clothing/suit/prac_arpon
	mask = /obj/item/clothing/mask/gas/prac_mask
	neck = /obj/item/reagent_containers/food/drinks/canteen
	shoes = /obj/item/clothing/shoes/prac_boots
	back = /obj/item/storage/backpack/satchel/warfare
	gloves = /obj/item/clothing/gloves/prac_gloves
	l_hand = /obj/item/storage/firstaid/adv
	l_ear = /obj/item/device/radio/headset/headset_sci
	l_pocket = /obj/item/device/flashlight/lantern
	belt = /obj/item/storage/belt/medical/full
	backpack_contents = list(
	/obj/item/card/id/ring/disgracedmedicae = 1,
	/obj/item/stack/thrones = 1,
	/obj/item/stack/thrones2 = 1,
	)

/decl/hierarchy/outfit/job/penitent
	name = OUTFIT_JOB_NAME("Pilgrim")
	uniform = null//obj/item/clothing/under/rank/penitent
	neck = /obj/item/reagent_containers/food/drinks/canteen
	shoes = null//obj/item/clothing/shoes/prac_boots
	l_ear = null
	r_ear = null
	id_type = /obj/item/card/id/pilgrim/penitent
	gloves = null
	pda_slot = null

/decl/hierarchy/outfit/job/ganger
	name = OUTFIT_JOB_NAME("Ganger")
	uniform = /obj/item/clothing/under/rank/victorian/black
	neck = /obj/item/reagent_containers/food/drinks/canteen
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack/satchel/warfare
	mask = null
	l_pocket = /obj/item/device/flashlight/lantern
	belt = /obj/item/gun/projectile/revolver/villiers
	backpack_contents = list(
	/obj/item/ammo_magazine/a357 = 2,
	/obj/item/stack/thrones = 1,
	/obj/item/stack/thrones2 = 1,
	)

/decl/hierarchy/outfit/job/underboss
	name = OUTFIT_JOB_NAME("Underboss")
	uniform = /obj/item/clothing/under/suit_jacket/really_black
	id_type = /obj/item/card/id/pilgrim/innkeeper
	pda_type = /obj/item/device/pda/penitent
	back = /obj/item/storage/backpack/satchel/warfare
	neck = /obj/item/reagent_containers/food/drinks/canteen
	l_ear = /obj/item/device/radio/headset/headset_service
	r_ear = null
	pda_slot = null
	shoes = /obj/item/clothing/shoes/vigilante
	suit_store = /obj/item/gun/projectile/shotgun/pump/voxlegis
	backpack_contents = list(
	/obj/item/ammo_box/shotgun = 1,
	/obj/item/stack/thrones = 1,
	/obj/item/stack/thrones2 = 1,
	/obj/item/stack/thrones3/twenty = 1,
)


//Administrator
/decl/hierarchy/outfit/job/administrator
	name = OUTFIT_JOB_NAME("Administrator")
	uniform = /obj/item/clothing/under/rank/consort/adept
	head = /obj/item/clothing/head/commissar/adept
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/thick/swat/combat/warfare
	back = /obj/item/storage/backpack/satchel/warfare
	neck = /obj/item/reagent_containers/food/drinks/canteen
	id_type = /obj/item/card/id/ring/administrator
	l_ear = /obj/item/device/radio/headset/headset_service
	belt = /obj/item/device/flashlight/lantern
	pda_slot = null
	backpack_contents = list(
	/obj/item/stack/thrones = 2,
	/obj/item/stack/thrones2/five = 1,
	/obj/item/stack/thrones3/twenty = 1,

	)
	flags = OUTFIT_NO_BACKPACK|OUTFIT_NO_SURVIVAL_GEAR


//Ogryn Bouncer

/decl/hierarchy/outfit/job/ogryn
	name = OUTFIT_JOB_NAME("Ogryn")
	uniform = /obj/item/clothing/under/ogryn/jumpsuit
	head = null
	shoes = /obj/item/clothing/shoes/jackboots/ogryn
	gloves = null
	back = /obj/item/storage/backpack/satchel/warfare
	neck = /obj/item/reagent_containers/food/drinks/canteen
	suit = /obj/item/clothing/suit/armor/ogryn/bouncer
	pda_type = /obj/item/device/pda/penitent
	l_ear = null
	r_ear = null
	belt = /obj/item/device/flashlight/lantern
	pda_slot = null
	l_hand = /obj/item/melee/classic_baton/trench_club
	backpack_contents = list(
	/obj/item/stack/thrones2/five = 1,
	/obj/item/stack/thrones3/ten = 1,

	)

/decl/hierarchy/outfit/job/bouncer
	name = OUTFIT_JOB_NAME("Bouncer")
	uniform = /obj/item/clothing/under/ogryn/jumpsuit
	head = null
	shoes = /obj/item/clothing/shoes/jackboots/ogryn
	gloves = null
	back = /obj/item/storage/backpack/satchel/warfare
	neck = /obj/item/reagent_containers/food/drinks/canteen
	suit = /obj/item/clothing/suit/armor/ogryn/bouncer
	id_type = /obj/item/card/id/pilgrim/innkeeper
	pda_type = /obj/item/device/pda/penitent
	l_ear = null
	r_ear = null
	belt = /obj/item/device/flashlight/lantern
	pda_slot = null
	l_hand = /obj/item/melee/classic_baton/trench_club
	backpack_contents = list(
	/obj/item/stack/thrones = 2,
	/obj/item/stack/thrones2/five = 1,
	/obj/item/stack/thrones3/twenty = 1,

	)
/datum/job/scavenger
    title = "Scavenger"
    department_flag = PIL
    social_class = SOCIAL_CLASS_MIN //these boys are gross
    total_positions = 1
    spawn_positions = 1
    supervisors = "You-yourself, don't listen-hear to man-things!"
    selection_color = "#848484"
    latejoin_at_spawnpoints = TRUE
    announced = FALSE
    cultist_chance = 0
    species_role = "Skaven"


    equip(var/mob/living/carbon/human/H)
        H.warfare_faction = IMPERIUM
        ..()
        H.add_stats(rand(14,15), rand(13,16), rand(13,16), rand (13,16))
        H.add_skills(rand(7,9),rand(9,16),rand(4,6),4,6) //melee, ranged, med, eng, surgery
        H.warfare_language_shit(LANGUAGE_LOW_GOTHIC)
        H.adjustStaminaLoss(-INFINITY)
        H.assign_random_quirk()
        to_chat(H, "<span class='notice'><b><font size=3>You-you are smarter than rest of pack-herd. You-you sneak on ship-transport to go on new world-planet.</font></b></span>")

/datum/job/penitent //the plan is to have penitent be a default landing job, I will eventually add a randomized system that gives different loadouts much like the migrant system of lifeweb
	title = "Pilgrim"
	department_flag = PIL
	social_class = SOCIAL_CLASS_MIN //these boys are gross
	total_positions = INFINITY //maybe open up more of these when we figure out other classes and depending on player count
	spawn_positions = INFINITY
	supervisors = "The God Emperor of Mankind"
	selection_color = "#848484"
	outfit_type = /decl/hierarchy/outfit/job/penitent
	latejoin_at_spawnpoints = TRUE
	announced = FALSE


	equip(var/mob/living/carbon/human/H)
		H.warfare_faction = IMPERIUM
		..()
		H.add_stats(rand(6,11), rand(7,12), rand(8,12), rand (8,11)) //they suck and are supposed to suck
		H.warfare_language_shit(LANGUAGE_LOW_GOTHIC)
		H.adjustStaminaLoss(-INFINITY)
		H.assign_random_quirk()
		H.witchblood()
		to_chat(H, "<span class='notice'><b><font size=3>You are a Pilgrim. You left your home with little in search of more. Rumors of a holy site drew you to this planet and now life is in your hands. <br> <span class = 'badmood'> + Go to your pilgrim tab and select your fate. + </span> </font></b></span>")


		H.verbs += list(
			/mob/living/carbon/human/proc/penitentclass,
		)

/datum/job/gangboy
	title = "Ganger"
	department_flag = PIL
	social_class = SOCIAL_CLASS_MED //better off than your average gross pilgrim
	total_positions = 3
	spawn_positions = 3
	open_when_dead = 0
	supervisors = "The Rogue Trader and the Capo"
	selection_color = "#530606"
	access = list(access_village, access_ganger,)
	minimal_access = list(access_bar)
	outfit_type = /decl/hierarchy/outfit/job/ganger
	latejoin_at_spawnpoints = TRUE
	announced = FALSE
	cultist_chance = 5
	role_desc = "You are a ganger, made men serving the noble house of the Rogue Trader and his Capo.  "

	equip(var/mob/living/carbon/human/H)
		H.warfare_faction = IMPERIUM

		..()
		H.warfare_language_shit(LANGUAGE_LOW_GOTHIC)
		H.adjustStaminaLoss(-INFINITY)
		H.stat = UNCONSCIOUS
		H.assign_random_quirk()
		H.verbs += list(
			/mob/living/carbon/human/proc/gangerclass,
		)
		to_chat(H, "<span class='notice'><b><font size=3>You are a ganger, made men serving the noble house of the Rogue Trader and his Capo.  </font></b></span>")



/mob/living/carbon/human/proc/gangerclass()
	set name = "Select your class"
	set category = "Ganger"
	set desc = "Choose your ganger archtype."
	if(!ishuman(src))
		to_chat(src, "<span class='notice'>How tf are you seeing this, ping Wel Ard immediately</span>")
		return
	if(src.stat == DEAD)
		to_chat(src, "<span class='notice'>You can't choose a class when you're dead.</span>")
		return

	var/mob/living/carbon/human/U = src
	var/fates = list("Bruiser","Hitman", "Rogue Doc",)


	var/classchoice = input("Choose your fate", "Available fates") as anything in fates

 //10 is base stat, below 12 is child stat, childs are supposed to be somewhere between 6-14 in stats.
 //skills are between 1-5 for roles that have little to no reason to know something, 5-10 if they are able to naturally learn those skills, 5 is baseline,
	switch(classchoice)
		if("Bruiser")
			U.add_stats(rand(17,20), rand(14,17), rand(17,19), rand (12,16))
			U.add_skills(rand(8,10),rand(5,6),rand(1,3),rand(2,6),rand(1,2)) //melee, ranged, med, eng, surgery
			equip_to_slot_or_del(new /obj/item/clothing/under/rank/victorian, slot_w_uniform)
			equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots/pilgrim_boots, slot_shoes)
			equip_to_slot_or_del(new /obj/item/clothing/suit/armor/goliathplate, slot_wear_suit)
			equip_to_slot_or_del(new /obj/item/clothing/head/helmet/gangerhelm, slot_head)
			equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_service, slot_l_ear)
			equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/warfare, slot_back)
			equip_to_slot_or_del(new /obj/item/melee/classic_baton/trench_club, slot_belt)
			equip_to_slot_or_del(new /obj/item/card/id/pilgrim/penitent, slot_wear_id)
			equip_to_slot_or_del(new /obj/item/stack/thrones3/twenty, slot_in_backpack)
			to_chat(U,"<span class='notice'>You're the muscle of the gang. Listen to the boss.<b><font size=3>")
			U.verbs -= list(/mob/living/carbon/human/proc/gangerclass,)
			U.stat = CONSCIOUS
			U.sleeping = 0
			to_chat(U, "<span class='goodmood'>+ You awaken from your slumber... +</span>\n")
		if("Hitman")
			U.add_stats(rand(14,17), rand(15,17), rand(18,20), rand (14,16)) //ex criminal, not fed very well, but random stats
			U.add_skills(rand(5,6),rand(9,11),rand(2,4),rand(5,10),rand(2,4)) //melee, ranged, med, eng, surgery
			equip_to_slot_or_del(new /obj/item/clothing/under/rank/penitent, slot_w_uniform)
			equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots/pilgrim_boots, slot_shoes)
			equip_to_slot_or_del(new /obj/item/clothing/suit/storage/vest/tactical, slot_wear_suit)
			equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_sci, slot_l_ear)
			equip_to_slot_or_del(new /obj/item/card/id/pilgrim/penitent, slot_wear_id)
			equip_to_slot_or_del(new /obj/item/gun/projectile/automatic/messina, slot_l_hand)
			equip_to_slot_or_del(new /obj/item/stack/thrones3/twenty, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/ammo_magazine/c556, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/ammo_magazine/c556, slot_in_backpack)
			to_chat(U, "<span class='notice'><b><font size=3>You're the hitman, the shadow of the gang. Carry out the wishes of the Capo and Rogue Trader.</font></b></span>")
			U.verbs -= list(/mob/living/carbon/human/proc/gangerclass,)
			U.stat = CONSCIOUS
			U.sleeping = 0
			to_chat(U, "<span class='goodmood'>+ You awaken from your slumber... +</span>\n")
		if("Rogue Doc")
			U.add_stats(rand(15,17), rand(12,15), rand(12,15), rand (15,15))
			U.add_skills(rand(4,6),rand(4,6),rand(10,10),rand(9,10),rand(10,10)) //melee, ranged, med, eng, surgery
			equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/warfare, slot_back)
			equip_to_slot_or_del(new /obj/item/clothing/under/rank/victorian, slot_w_uniform)
			equip_to_slot_or_del(new /obj/item/storage/belt/medical/full, slot_belt)
			equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots/pilgrim_boots, slot_shoes)
			equip_to_slot_or_del(new /obj/item/card/id/pilgrim/penitent, slot_wear_id)
			equip_to_slot_or_del(new /obj/item/stack/thrones3/twenty, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/clothing/glasses/eyepatch/hud/medical, slot_glasses)
			equip_to_slot_or_del(new /obj/item/storage/pill_bottle/happy, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/storage/pill_bottle/happy, slot_in_backpack)
			to_chat(U,"<span class='notice'><b><font size=3>You're a step above the rest of the dealers when it comes to chemistry. Due to this, you were hired to a local gang after you caught their interest.</font></b></span>")
			U.verbs -= list(/mob/living/carbon/human/proc/gangerclass,)
			U.stat = CONSCIOUS
			U.sleeping = 0
			to_chat(U, "<span class='goodmood'>+ You awaken from your slumber... +</span>\n")
/datum/job/bouncer
	title = "Bouncer"
	department_flag = PIL
	social_class = SOCIAL_CLASS_MIN //these boys are gross
	total_positions = 1
	spawn_positions = 1
	supervisors = "The Rogue Trader and his Capo."
	selection_color = "#530606"
	outfit_type = /decl/hierarchy/outfit/job/bouncer
	latejoin_at_spawnpoints = TRUE
	announced = FALSE
	cultist_chance = 0 // grog like emperorah :) // bouncer should only be cultist if the innkeeper is. as they would get easily indoctrinated by their dad/boss
	species_role = "Ogryn"
	role_desc = "You're the biggest, baddest, muscle of the gang. Listen to the Rogue Trader and Capo."


	equip(var/mob/living/carbon/human/H)
	//theres gonna be some redundencies here but I do not careeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
		H.warfare_faction = IMPERIUM
		..()
		H.add_stats(rand(20,30), rand(15,18), rand(15,18), rand (2,5)) //ogryn are stronger than astartes or smh i don't remember
		H.add_skills(rand(10,13),1,1,1,1) //melee, ranged, med, eng, surgery
		H.warfare_language_shit(LANGUAGE_LOW_GOTHIC)
		to_chat(H, "<span class='notice'><b><font size=3>You're the biggest, baddest, muscle of the gang. Listen to the Underboss.</font></b></span>")



/*
//loadouts below here
/decl/hierarchy/outfit/job/penitent
	name = OUTFIT_JOB_NAME("Pilgrim")
	uniform = /obj/item/clothing/under/rank/penitent
	neck = /obj/item/reagent_containers/food/drinks/canteen
	shoes = /obj/item/clothing/shoes/prac_boots
	l_ear = null
	r_ear = null
	id_type = null
	gloves = null
	pda_slot = null

/decl/hierarchy/outfit/job/ganger
	name = OUTFIT_JOB_NAME("Ganger")
	uniform = /obj/item/clothing/under/syndicate
	neck = /obj/item/reagent_containers/food/drinks/canteen
	shoes = /obj/item/clothing/shoes/prac_boots
	suit_store = /obj/item/gun/projectile/shotgun/pump/shitty
	backpack_contents = list(
	/obj/item/ammo_magazine/handful/shotgun/shotgun_handful = 2,
	/obj/item/storage/box/beanbags = 1,
	/obj/item/stack/thrones = 1,
	/obj/item/stack/thrones2 = 1,
)

/decl/hierarchy/outfit/job/innkeeper
	name = OUTFIT_JOB_NAME("Innkeeper")
	uniform = /obj/item/clothing/under/syndicate
	suit = /obj/item/clothing/suit/innapron
	id_type = /obj/item/card/id/pilgrim/innkeeper
	pda_type = /obj/item/device/pda/penitent
	back = /obj/item/storage/backpack/satchel/warfare
	neck = /obj/item/reagent_containers/food/drinks/canteen
	head = /obj/item/clothing/head/bardhat
	l_ear = /obj/item/device/radio/headset/headset_service
	r_ear = null
	pda_slot = null
	shoes = /obj/item/clothing/shoes/vigilante
	suit_store = /obj/item/gun/projectile/shotgun/pump/shitty
	backpack_contents = list(
	/obj/item/ammo_magazine/handful/shotgun/shotgun_handful = 2,
	/obj/item/storage/box/beanbags = 1,
	/obj/item/stack/thrones = 1,
	/obj/item/stack/thrones2 = 1,
	/obj/item/stack/thrones3/five = 1,
)

//Administrator
/decl/hierarchy/outfit/job/administrator
	name = OUTFIT_JOB_NAME("Administrator")
	uniform = /obj/item/clothing/under/rank/consort/adept
	head = /obj/item/clothing/head/commissar/adept
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/thick/swat/combat/warfare
	back = /obj/item/storage/backpack/satchel/warfare
	neck = /obj/item/reagent_containers/food/drinks/canteen
	id_type = /obj/item/card/id/ring/administrator
	l_ear = /obj/item/device/radio/headset/headset_service
	belt = /obj/item/device/flashlight/lantern
	pda_slot = null
	backpack_contents = list(
	/obj/item/stack/thrones = 2,
	/obj/item/stack/thrones2/five = 1,
	/obj/item/stack/thrones3/twenty = 1,

	)
	flags = OUTFIT_NO_BACKPACK|OUTFIT_NO_SURVIVAL_GEAR
*/
