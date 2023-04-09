//Due to how large this one is it gets its own file. Sister of Battle and all her stuff including items, excluding weapons those are in mattguns.dm, is also located here.

//Confessor

/datum/job/deacon
	title = "Sister Dialogus"
	department = "Ministorum"
	department_flag = MED
	total_positions = 1
	spawn_positions = 1
	open_when_dead = 0
	social_class = SOCIAL_CLASS_HIGH
	latejoin_at_spawnpoints = TRUE
	supervisors = "The Abbess"
	selection_color = "#FCFBFA"
	access = list(access_medical, access_heads, access_advchapel)
	minimal_access = list(access_medical, access_heads, access_advchapel)
	announced = FALSE
	outfit_type = /decl/hierarchy/outfit/job/dialogus
	auto_rifle_skill = 6
	semi_rifle_skill = 6
	sniper_skill = 6
	shotgun_skill = 6
	lmg_skill = 6
	smg_skill = 6
	cultist_chance = 30



	equip(var/mob/living/carbon/human/H)
		var/current_name = H.real_name
		..()
		H.fully_replace_character_name("Sister [current_name]")
		H.add_stats(rand(12,14), rand(12,14), rand(9,12), rand(14,18)) //frail and holy
		H.add_skills(rand(5,10),rand(5,6),rand(5,7),3,rand(4,8))
		H.get_idcard()?.access = list(access_heads, access_security, access_guard_common, access_all_personal_lockers, access_village, access_advchapel,)
		H.warfare_language_shit(LANGUAGE_HIGH_GOTHIC)
		H.adjustStaminaLoss(-INFINITY)
		H.warfare_faction = IMPERIUM
		H.gender = FEMALE
		H.f_style = "shaved"
		H.h_style = "Bobcurl"
		H.vice = "Piety"

		to_chat(H, "<span class='notice'><b><font size=3>You are a Sister Dialogus, a member of the Adeptus Sororitas dedicated to record keeping, translation, oration, and other scholarly endeavors. It is your job to instill faith in The God Emperor of Man and protect the political position of the church.You are also the foremost expert on canon law and may be called upon to judge your fellow servants of the God Emperor.</font></b></span>")

	equip(var/mob/living/carbon/human/H, var/alt_title, var/ask_questions = TRUE)
		. = ..()
		if(!.)
			return
		if(!ask_questions)
			return

		var/obj/item/storage/bible/B = locate(/obj/item/storage/bible) in H
		if(!B)
			return

		spawn(0)
			var/religion_name = "the Imperial Cult"
			var/new_religion = sanitize(input(H, "You are a holy orator of the Ministorum. To change your religion would be heresy and would surely lead to a swift death.", "Name change", religion_name), MAX_NAME_LEN)

			if (!new_religion)
				new_religion = religion_name
			switch(lowertext(new_religion))
				if("imperium")
					B.SetName("Uplifting Primer")
				else
					B.SetName("The Holy Book of [new_religion]")
			feedback_set_details("religion_name","[new_religion]")

		spawn(1)
			var/deity_name = "The God Emperor of Mankind"
			var/new_deity = sanitize(input(H, "Would you like to change your deity? Default is the Emperor", "Name change", deity_name), MAX_NAME_LEN)

			if ((length(new_deity) == 0) || (new_deity == "The God Emperor of Mankind") )
				new_deity = deity_name
			B.deity_name = new_deity

			var/accepted = 0
			var/outoftime = 0
			spawn(200) // 20 seconds to choose
				outoftime = 1
			var/new_book_style = "Bible"

			while(!accepted)
				if(!B) break // prevents possible runtime errors
				new_book_style = input(H,"Which bible style would you like?") in list("Bible", "Koran", "Scrapbook", "Creeper", "White Bible", "Holy Light", "Athiest", "Tome", "The King in Yellow", "Ithaqua", "Scientology", "the bible melts", "Necronomicon")
				switch(new_book_style)
					if("Koran")
						B.icon_state = "koran"
						B.item_state = "koran"
					if("Scrapbook")
						B.icon_state = "scrapbook"
						B.item_state = "scrapbook"
					if("Creeper")
						B.icon_state = "creeper"
						B.item_state = "syringe_kit"
					if("White Bible")
						B.icon_state = "white"
						B.item_state = "syringe_kit"
					if("Holy Light")
						B.icon_state = "holylight"
						B.item_state = "syringe_kit"
					if("Athiest")
						B.icon_state = "athiest"
						B.item_state = "syringe_kit"
					if("Tome")
						B.icon_state = "tome"
						B.item_state = "syringe_kit"
					if("The King in Yellow")
						B.icon_state = "kingyellow"
						B.item_state = "kingyellow"
					if("Ithaqua")
						B.icon_state = "ithaqua"
						B.item_state = "ithaqua"
					if("Scientology")
						B.icon_state = "scientology"
						B.item_state = "scientology"
					if("the bible melts")
						B.icon_state = "melted"
						B.item_state = "melted"
					if("Necronomicon")
						B.icon_state = "necronomicon"
						B.item_state = "necronomicon"
					else
						B.icon_state = "bible"
						B.item_state = "bible"

				H.update_inv_l_hand() // so that it updates the bible's item_state in his hand

				switch(input(H,"Look at your bible - is this what you want?") in list("Yes","No"))
					if("Yes")
						accepted = 1
					if("No")
						if(outoftime)
							to_chat(H, "Welp, out of time, buddy. You're stuck. Next time choose faster.")
							accepted = 1

			if(ticker)
				ticker.Bible_icon_state = B.icon_state
				ticker.Bible_item_state = B.item_state
				ticker.Bible_name = B.name
				ticker.Bible_deity_name = B.deity_name
			feedback_set_details("religion_deity","[new_deity]")
			feedback_set_details("religion_book","[new_book_style]")
		return 1

/obj/item/melee/whip/censer
	name = "imperial censer"
	desc = "A golden censer leaking pure smelling incense. Used by the Ecclesiarchy for blessings."
	attack_verb = list("flogged", "whipped", "lashed", "disciplined")
	icon = 'icons/obj/weapons/melee/misc.dmi'
	icon_state = "censer"
	item_state = "censer"
	w_class = ITEM_SIZE_SMALL

//this blesses humans, pretty straight forward
/obj/item/melee/whip/censer/attack(mob/living/carbon/M as mob, mob/living/carbon/human/user as mob) //very quick and simple blessing system, using attack incase I ever wanna make the censer need to be filled with stuff
	if (istype(M, /mob/living/carbon/human))
		if(M.isblessed == 1) //check this first
			to_chat(user, "<span class='warning'>[M] has already been blessed!</span>")
			return 1
		else
			M.STAT_LEVEL(dex) += 1
			M.STAT_LEVEL(str) += 1
			M.isblessed = 1
			visible_message("[M] inhales the holy incense and is blessed!")


//this blesses guns
/obj/item/melee/whip/censer/attackby(var/obj/item/gun/O, var/mob/user)
	if(O.isblessed == 1)
		to_chat(user, "<span class='warning'>[O] has already been blessed!</span>")
		return 1
	else
		O.name = "blessed [O.name]"
		O.accuracy += 1
		O.armor_penetration += 1
		O.isblessed = 1
		playsound(src, 'sound/voice/blessing.ogg', 70, 0, 1)
		visible_message("[O] is bathed in righteous incense as the Sister chants a short litany, you can sense a change in the weapon just by touching it.")

//this blesses swords
/obj/item/melee/whip/censer/attackby(var/obj/item/melee/sword/O, var/mob/user)
	if(O.isblessed == 1)
		to_chat(user, "<span class='warning'>[O] has already been blessed!</span>")
		return 1
	else
		O.name = "blessed [O.name]"
		O.sharpness += 5
		O.block_chance += 5
		O.isblessed = 1
		playsound(src, 'sound/voice/blessing.ogg', 70, 0, 1)
		visible_message("[O] is bathed in righteous incense as the Sister chants a short litany, you can sense a change in the weapon just by touching it.")



// Adepta Sororitas

// Battle Sister

/datum/job/cmo
	title = "Abbess"
	head_position = 1
	department_flag = MED
	department = "Ministorum"
	total_positions = 1
	spawn_positions = 1
	supervisors = "The Adeptus Ministorum"
	selection_color = "#FCFBFA"
	economic_modifier = 10
	open_when_dead = FALSE
	social_class = SOCIAL_CLASS_HIGH
	latejoin_at_spawnpoints = TRUE
	announced = FALSE
	access = list(access_medical, access_heads,
			access_abbess, access_RC_announce,
			access_keycard_auth, access_guard_common, access_village, access_advchapel)
	minimal_access = list(access_medical, access_heads,
			access_abbess, access_RC_announce,
			access_keycard_auth, access_guard_common, access_village, access_advchapel)
	outfit_type = /decl/hierarchy/outfit/job/medical/doctor
	outfit_type = /decl/hierarchy/outfit/job/medical/cmo
	outfit_type = /decl/hierarchy/outfit/job/medical/cmo
	auto_rifle_skill = 10
	semi_rifle_skill = 10
	sniper_skill = 10
	shotgun_skill = 10
	lmg_skill = 10
	smg_skill = 10
	cultist_chance = 5

	equip(var/mob/living/carbon/human/H)
		var/current_name = H.real_name
		..()
		H.fully_replace_character_name("Sister [current_name]")
		H.set_trait(new/datum/trait/death_tolerant())
		H.add_stats(rand(15,17), rand(15,17), rand(15,17), rand(15,17))
		H.add_skills(rand(5,8),rand(5,7),rand(10,11),rand(3,5),rand(10,11)) //melee, ranged, med, eng, surgery
		H.get_equipped_item(slot_s_store)
		H.warfare_faction = IMPERIUM
		H.gender = FEMALE
		H.get_idcard()?.access = list(access_heads, access_security, access_guard_common, access_magi, access_all_personal_lockers, access_advchapel, access_medical, access_village)
		H.warfare_language_shit(LANGUAGE_LOW_GOTHIC)
		H.warfare_language_shit(LANGUAGE_HIGH_GOTHIC)
		H.f_style = "shaved"
		H.h_style = "Bobcurl"
		H.vice = "Piety"

		to_chat(H, "<span class='notice'><b><font size=3>You are the Abbess in Aquileia and a sister of The Order of Our Martyred Lady. You have several sisters in your care and a reliquary full of artifacts of the beata. You must lead your sisters in accordance with the Codex Sororitas and teach the locals to love and revere the God Emperor.</font></b></span>")


/datum/job/sistersuperior
	title = "Sister Superior"
	department = "Ministorum"
	department_flag = MED
	total_positions = 1
	spawn_positions = 1
	open_when_dead = 0
	social_class = SOCIAL_CLASS_HIGH
	latejoin_at_spawnpoints = TRUE
	supervisors = "The Abbess or Deacon"
	selection_color = "#FCFBFA"
	announced = FALSE
	outfit_type = /decl/hierarchy/outfit/job/sisterofbattle/mlsister
	auto_rifle_skill = 10
	semi_rifle_skill = 10
	sniper_skill = 10
	shotgun_skill = 10
	lmg_skill = 10
	smg_skill = 10
	cultist_chance = 7

	equip(var/mob/living/carbon/human/H)
		var/current_name = H.real_name
		..()
		H.fully_replace_character_name("Sister [current_name]")
		H.set_trait(new/datum/trait/death_tolerant)
		H.set_quirk(new/datum/quirk/dead_inside) // the only thing the sisters of the orders millitant feel is the god emperor's light.
		//"BUT THEY ARE DIVINE!!!" don't care, Sister superior is human, stop simping, im still giving them very GOOD stats.
		H.add_stats(rand(18,22), rand(18,22), rand(18,20), 16)
		H.add_skills(rand(9,12),rand(9,12),rand(7,9),rand(4,8),rand(4,7)) //melee, ranged, med, eng, surgery
		H.get_idcard()?.access = list(access_heads, access_security, access_guard_common, access_magi, access_all_personal_lockers, access_advchapel, access_medical, access_village)
		H.get_equipped_item(slot_s_store)
		H.warfare_faction = IMPERIUM
		H.gender = FEMALE
		H.adjustStaminaLoss(-INFINITY)
		H.warfare_language_shit(LANGUAGE_LOW_GOTHIC)
		H.warfare_language_shit(LANGUAGE_HIGH_GOTHIC)
		H.f_style = "shaved"
		H.h_style = "Bobcurl"
		H.vice = "Piety"

		to_chat(H, "<span class='notice'><b><font size=3>You are a Sister of Battle belonging to the Order of Our Martyred Lady assigned to the Monastary, you serve both the Inquisition and Ecclesiarchy directly, though you truly The God Emperor who stands above all.</font></b></span>")
		to_chat(H, "<span class='notice'><b><font size=3>Sisters only concern themselves with xenos, mutants, and heretics. You are not law enforcement but protectors of the faith. Your primary purpose is to protect the reliquary.</font></b></span>")

/datum/job/hospitaller
	title = "Novitiate Hospitaller"
	department = list("Ministorum", "Medical")
	department_flag = MED
	minimal_player_age = 22
	total_positions = 2
	spawn_positions = 2
	supervisors = "The Abbess and Sister Superior"
	selection_color = "#FCFBFA"
	economic_modifier = 7
	social_class = SOCIAL_CLASS_HIGH
	open_when_dead = FALSE
	latejoin_at_spawnpoints = TRUE
	announced = FALSE
	access = list(access_medical, access_heads,
			access_abbess, access_RC_announce,
			access_keycard_auth, access_guard_common, access_village, access_advchapel)
	minimal_access = list(access_medical, access_heads,
			access_guard_common, access_village, access_advchapel)
	outfit_type = /decl/hierarchy/outfit/job/medical/doctor
	auto_rifle_skill = 7
	semi_rifle_skill = 7
	sniper_skill = 7
	shotgun_skill = 7
	lmg_skill = 7
	smg_skill = 7
	cultist_chance = 10

	equip(var/mob/living/carbon/human/H)
		var/current_name = H.real_name
		..()
		H.fully_replace_character_name("Novitiate Sister [current_name]")
		H.set_trait(new/datum/trait/death_tolerant())
		H.add_stats(rand(14,18), rand(14,18), rand(10,14), rand(17,18)) //nice stats
		H.add_skills(rand(6,8),rand(6,8),rand(8,10),rand(3,5),rand(9,11)) //melee, ranged, med, eng, surgery
		H.get_idcard()?.access = list(access_medical, access_village, access_advchapel)
		H.warfare_language_shit(LANGUAGE_LOW_GOTHIC )
		H.warfare_language_shit(LANGUAGE_HIGH_GOTHIC)
		H.adjustStaminaLoss(-INFINITY)
		H.get_equipped_item(slot_s_store)
		H.gender = FEMALE
		H.warfare_faction = IMPERIUM
		H.f_style = "shaved"
		H.h_style = "Bobcurl"
		H.vice = "Piety"

		to_chat(H, "<span class='notice'><b><font size=3>http://is12wiki.xyz/index.php/Guide_to_Medicine</font></b></span>")
		to_chat(H, "<span class='notice'><b><font size=3>You are a novice sister of the Ordos Hospitaller, The Sisters of our Emperor's Mercy serving under The Abbess to maintain the health and divinity of the township.</font></b></span>")

//NOVICE - has just become a sister
/datum/job/progena
	title = "Novitiate Militant"
	department = list("Ministorum", "Medical")
	department_flag = MED
	minimal_player_age = 14
	total_positions = 2
	spawn_positions = 2
	supervisors = "The Abbess and Sister Superior"
	selection_color = "#FCFBFA"
	economic_modifier = 7
	social_class = SOCIAL_CLASS_HIGH
	open_when_dead = FALSE
	latejoin_at_spawnpoints = TRUE
	announced = FALSE
	access = list(access_advchapel, access_medical, access_village)
	minimal_access = list(access_advchapel, access_medical, access_village)
	outfit_type = /decl/hierarchy/outfit/job/novicemilitant
	auto_rifle_skill = 9
	semi_rifle_skill = 9
	sniper_skill = 9
	shotgun_skill = 9
	lmg_skill = 9
	smg_skill = 9
	cultist_chance = 25

	equip(var/mob/living/carbon/human/H)
		var/current_name = H.real_name
		..()
		H.fully_replace_character_name("Novitiate Sister [current_name]")
		H.set_trait(new/datum/trait/death_tolerant())
		H.add_stats(rand(14,18), rand(14,18), rand(10,14), rand(17,18)) //nice stats
		H.add_skills(rand(6,8),rand(6,8),rand(8,10),rand(3,5),rand(5,7)) //melee, ranged, med, eng, surgery
		H.get_idcard()?.access = list(access_medical, access_village, access_advchapel)
		H.warfare_language_shit(LANGUAGE_LOW_GOTHIC )
		H.warfare_language_shit(LANGUAGE_HIGH_GOTHIC)
		H.adjustStaminaLoss(-INFINITY)
		H.get_equipped_item(slot_s_store)
		H.gender = FEMALE
		H.warfare_faction = IMPERIUM
		H.f_style = "shaved"
		H.h_style = "Bobcurl"
		H.vice = "Piety"

		to_chat(H, "<span class='notice'><b><font size=3>You are a recent arrival to the Abbey in Aquileia, coming from the scholam established in the captial of Evora IV after the warp storms cut off the world from the rest of the Imperium. Novitiates are usually stationed in dangerous places to be tempered by battle, but you have the honor of protecting the reliquary and the artifacts of the beata.</font></b></span>")
		to_chat(H, "<span class='notice'><b><font size=3>Sisters only concern themselves with xenos, mutants, and heretics. You are not law enforcement but protectors of the faith. Your primary purpose is to protect the reliquary.</font></b></span>")

/datum/job/preacher
	title = "Scholar"
	department = list("Ministorum", "Medical")
	department_flag = MED
	minimal_player_age = 20
	total_positions = 2
	spawn_positions = 2
	supervisors = "The Abbess and Sister Superior"
	selection_color = "#FCFBFA"
	economic_modifier = 7
	social_class = SOCIAL_CLASS_MED
	open_when_dead = FALSE
	latejoin_at_spawnpoints = TRUE
	announced = FALSE
	access = list(access_advchapel, access_medical, access_village)
	minimal_access = list(access_advchapel, access_medical, access_village)
	outfit_type = /decl/hierarchy/outfit/job/preacher
	auto_rifle_skill = 4
	semi_rifle_skill = 4
	sniper_skill = 4
	shotgun_skill = 4
	lmg_skill = 4
	smg_skill = 4
	cultist_chance = 75 //preaching the word of.... lorgar//

	equip(var/mob/living/carbon/human/H)
		H.set_trait(new/datum/trait/death_tolerant())
		H.add_stats(rand(14,16), rand(14,16), rand(10,14), rand(11,14))
		H.add_skills(rand(5,9),rand(5,9),rand(6,8),rand(2,4),rand(8,9)) //melee, ranged, med, eng, surgery
		H.get_idcard()?.access = list(access_medical, access_village)
		H.warfare_language_shit(LANGUAGE_LOW_GOTHIC )
		H.warfare_language_shit(LANGUAGE_HIGH_GOTHIC)
		H.adjustStaminaLoss(-INFINITY)
		H.get_equipped_item(slot_s_store)
		H.warfare_faction = IMPERIUM

		to_chat(H, "<span class='notice'><b><font size=3>http://is12wiki.xyz/index.php/Guide_to_Medicine</font></b></span>")
		to_chat(H, "<span class='notice'><b><font size=3>You are the scholar studying under the Sister Dialogus and Abbess. While you are not formally a part of the Ecclesiarchy, you are a valued asset to the Abbey thanks to your medical knowledge.</font></b></span>")


// sob outfits
/decl/hierarchy/outfit/job/sisterofbattle
	name = OUTFIT_JOB_NAME("Sister Superior")
	head = /obj/item/clothing/head/helmet/sisterofbattle
	l_ear = /obj/item/device/radio/headset/heads/cmo
	neck = /obj/item/reagent_containers/food/drinks/canteen
	suit = /obj/item/clothing/suit/sisterofbattle
	belt = /obj/item/melee/chain/mercycs
	uniform = /obj/item/clothing/under/guard/uniform/sisterofbattle
	back = /obj/item/storage/backpack/satchel/warfare/sisterofbattle
	gloves = /obj/item/clothing/gloves/sisterofbattle
	shoes = /obj/item/clothing/shoes/jackboots/sisterofbattle
	glasses = /obj/item/clothing/glasses/hud/health
	id_type = /obj/item/card/id/dog_tag
	l_pocket = /obj/item/storage/box/ifak
	l_hand = /obj/item/gun/projectile/boltrifle/sisterbolter
	r_hand = /obj/item/gun/projectile/bolter_pistol/sisterofbattle
	backpack_contents = list(
	/obj/item/ammo_magazine/bolt_rifle_magazine/sister = 2,
	/obj/item/ammo_magazine/bolt_pistol_magazine = 2,
	/obj/item/reagent_containers/food/snacks/warfare = 1,
	/obj/item/clothing/mask/gas/explorer = 1,
	/obj/item/device/flashlight/lantern = 1,
	/obj/item/stack/thrones3/ten = 2
	)

/decl/hierarchy/outfit/job/sisterofbattle/repentia // unused atm
	name = OUTFIT_JOB_NAME("Sister Repentia")
	head = /obj/item/clothing/head/helmet/sisterofbattle/repentia
	l_ear = /obj/item/device/radio/headset/heads/cmo
	neck = /obj/item/reagent_containers/food/drinks/canteen
	suit = /obj/item/clothing/suit/sisterofbattle/repentia
	belt = /obj/item/melee/chain/mercycs
	uniform = /obj/item/clothing/under/guard/uniform/sisterofbattle/repentia
	back = /obj/item/storage/backpack/satchel/warfare
	shoes = /obj/item/clothing/shoes/jackboots/sisterofbattle/repentia
	id_type = /obj/item/card/id/dog_tag
	l_pocket = /obj/item/storage/box/ifak
	l_hand = /obj/item/melee/chain/mercycs
	r_hand = /obj/item/gun/projectile/boltrifle/sisterbolter
	backpack_contents = list(
	/obj/item/ammo_magazine/bolt_rifle_magazine/sister = 3,
	/obj/item/reagent_containers/food/snacks/warfare = 1,
	/obj/item/clothing/mask/gas/explorer = 1,
	/obj/item/device/flashlight/lantern = 1,
	)


/decl/hierarchy/outfit/job/sisterofbattle/mlsister
	name = OUTFIT_JOB_NAME("Order of Our Martyred Lady")
	head = /obj/item/clothing/head/helmet/sisterofbattle/mlsister
	l_ear = /obj/item/device/radio/headset/heads/cmo
	neck = /obj/item/reagent_containers/food/drinks/canteen
	suit = /obj/item/clothing/suit/sisterofbattle/mlsister
	belt = /obj/item/melee/energy/powersword/astartes/ingelldina
	uniform = /obj/item/clothing/under/guard/uniform/sisterofbattle
	back = /obj/item/storage/backpack/satchel/warfare/sisterofbattle/mlsister
	gloves = /obj/item/clothing/gloves/sisterofbattle/mlsister
	shoes = /obj/item/clothing/shoes/jackboots/sisterofbattle/mlsister
	glasses = /obj/item/clothing/glasses/hud/health
	id_type = /obj/item/card/id/dog_tag
	l_pocket = /obj/item/storage/box/ifak
	l_hand = /obj/item/gun/projectile/boltrifle/sisterbolter
	backpack_contents = list(
	/obj/item/ammo_magazine/bolt_rifle_magazine/sister = 2,
	/obj/item/reagent_containers/food/snacks/warfare = 1,
	/obj/item/device/flashlight/lantern = 1,
	/obj/item/stack/thrones3/ten = 2
	)

/decl/hierarchy/outfit/job/sisterofbattle/brsister
	name = OUTFIT_JOB_NAME("Order of the Bloody Rose")
	head = /obj/item/clothing/head/helmet/sisterofbattle/brsister
	l_ear = /obj/item/device/radio/headset/heads/cmo
	neck = /obj/item/reagent_containers/food/drinks/canteen
	suit = /obj/item/clothing/suit/sisterofbattle/brsister
	belt = /obj/item/melee/chain/mercycs
	uniform = /obj/item/clothing/under/guard/uniform/sisterofbattle
	back = /obj/item/storage/backpack/satchel/warfare/sisterofbattle/brsister
	gloves = /obj/item/clothing/gloves/sisterofbattle/brsister
	shoes = /obj/item/clothing/shoes/jackboots/sisterofbattle/brsister
	glasses = /obj/item/clothing/glasses/hud/health
	id_type = /obj/item/card/id/dog_tag
	l_pocket = /obj/item/storage/box/ifak
	l_hand = /obj/item/gun/projectile/boltrifle/sisterbolter
	r_hand = /obj/item/gun/projectile/bolter_pistol/sisterofbattle
	backpack_contents = list(
	/obj/item/ammo_magazine/bolt_rifle_magazine/sister = 2,
	/obj/item/ammo_magazine/bolt_pistol_magazine = 2,
	/obj/item/reagent_containers/food/snacks/warfare = 1,
	/obj/item/clothing/mask/gas/explorer = 1,
	/obj/item/device/flashlight/lantern = 1,
	/obj/item/stack/thrones3/ten = 2
	)

/decl/hierarchy/outfit/job/preacher
	name = OUTFIT_JOB_NAME("Scholar")
	head = /obj/item/clothing/head/preacher
	uniform = /obj/item/clothing/under/rank/chaplain
	neck = /obj/item/reagent_containers/food/drinks/canteen
	id_type = /obj/item/card/id/medical
	pda_type = null
	pda_slot = null
	l_ear = /obj/item/device/radio/headset/headset_sci
	r_ear = null
	l_pocket = /obj/item/storage/box/ifak
	belt = /obj/item/device/flashlight/lantern
	back = /obj/item/storage/backpack/satchel/warfare
	shoes = /obj/item/clothing/shoes/jackboots
	glasses = /obj/item/clothing/glasses/hud/health
	r_hand = null
	backpack_contents = list(
	/obj/item/reagent_containers/food/snacks/warfare/rat = 1,
	/obj/item/stack/thrones = 1,
	/obj/item/stack/thrones2/five = 1,
	/obj/item/stack/thrones3/ten = 1
		)


/decl/hierarchy/outfit/job/novicemilitant
	name = OUTFIT_JOB_NAME("Novitiate Militant")
	uniform = /obj/item/clothing/under/guard/uniform/sisterofbattle
	suit = /obj/item/clothing/suit/sisterofbattle/training
	l_ear  = /obj/item/device/radio/headset/headset_sci
	neck = /obj/item/reagent_containers/food/drinks/canteen
	back = /obj/item/storage/backpack/satchel/warfare/sisterofbattle/mlsister
	belt = /obj/item/melee/sword/broadsword
	shoes = /obj/item/clothing/shoes/jackboots
	glasses = /obj/item/clothing/glasses/hud/health
	l_pocket = /obj/item/storage/box/ifak
	r_pocket = /obj/item/device/flashlight/lantern
	r_hand = /obj/item/gun/projectile/bolter_pistol/sisterofbattle
	id_type = /obj/item/card/id/medical
	backpack_contents = list(
		/obj/item/reagent_containers/food/snacks/warfare/rat = 1,
		/obj/item/ammo_magazine/bolt_pistol_magazine = 2,
		/obj/item/stack/thrones2 = 1,
		/obj/item/stack/thrones3/five = 1,)
