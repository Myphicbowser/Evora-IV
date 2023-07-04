////////////////////STREETLAMP///////////////////////////////////////
#define HALF_HEALTH 2500
/obj/machinery/stolb
	name = "stolb"
	desc = "A solar power powered light post meant to illuminate the forest."
	icon = 'icons/obj/lighting2.dmi'
	icon_state = "stolb1"
	plane = ABOVE_HUMAN_PLANE
	layer = ABOVE_HUMAN_LAYER
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 70
	bound_height = 64
	bound_width = 32
	anchored = 1
	var/lit = 1
	var/id = null
	var/on_icon = "stolb1"
	var/_wifi_id
	var/datum/wifi/receiver/button/holosign/wifi_receiver
	var/health = 5000.0
	var/maxhealth = 5000.0
	var/maximal_heat = T0C + 100
	var/damage_per_fire_tick = 2.0

/obj/machinery/stolb/Initialize()
	. = ..()
	if(_wifi_id)
		wifi_receiver = new(_wifi_id, src)

/obj/machinery/stolb/Destroy()
	qdel(wifi_receiver)
	wifi_receiver = null
	return ..()

/obj/machinery/stolb/proc/toggle()
	if (stat & (BROKEN|NOPOWER))
		return
	lit = !lit
	use_power = lit ? 2 : 1
	update_icon()

//maybe add soft lighting? Maybe, though not everything needs it
/obj/machinery/stolb/update_icon()
	if (!lit || (stat & (BROKEN|NOPOWER)))
		icon_state = "stolb0"
		set_light(0, 0)

	else
		icon_state = on_icon
		set_light(6, 4, "#E38F46")

/obj/machinery/stolb/examine(mob/user)
	. = ..(user)

	if(health == maxhealth)
		to_chat(user, "<span class='notice'>It looks intact.</span>")
	else
		if(health <= HALF_HEALTH)
			to_chat(user, "<span class='notice'>It looks damaged.</span>")

/obj/machinery/stolb/bullet_act(var/obj/item/projectile/Proj)
	..()
	for(var/mob/living/carbon/human/H in loc)
		H.bullet_act(Proj)
	//visible_message("[Proj] hits the [src]!")
	playsound(src, "hitwall", 50, TRUE)
	health -= rand(10, 25)
	if(health <= 0)
		visible_message("<span class='danger'>The [src] crumbles!</span>")
		qdel(src)

/obj/machinery/stolb/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			qdel(src)
			return
		if(3.0)
			if(prob(50))
				qdel(src)

/obj/machinery/stolb/hitby(AM as mob|obj)
	..()
	visible_message("<span class='danger'>[src] was hit by [AM].</span>")
	var/tforce = 0
	if(ismob(AM)) // All mobs have a multiplier and a size according to mob_defines.dm
		var/mob/I = AM
		tforce = I.mob_size * 2 * I.throw_multiplier
	else if(isobj(AM))
		var/obj/item/I = AM
		tforce = I.throwforce
	take_damage(tforce)

/obj/machinery/stolb/attack_generic(var/mob/user, var/damage)
	return FALSE

/obj/machinery/stolb/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > maximal_heat)
		hit(damage_per_fire_tick, 0)
	..()

/obj/machinery/stolb/proc/take_damage(amount)
	health -= amount
	if(health <= 0)
		visible_message("<span class='warning'>\The [src] breaks down!</span>")
		playsound(loc, 'sound/effects/grillehit.ogg', 50, 1)
		new /obj/item/stack/rods(get_turf(usr))
		qdel(src)

/obj/machinery/stolb/attackby(obj/item/W as obj, mob/user as mob)

	// Repair
	if(health < maxhealth && istype(W, /obj/item/weldingtool))
		var/obj/item/weldingtool/F = W
		if(F.welding)
			playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
			if(do_after(user, 20, src))
				user.visible_message("<span class='notice'>\The [user] repairs some damage to \the [src].</span>", "<span class='notice'>You repair some damage to \the [src].</span>")
				health = min(health+(maxhealth/5), maxhealth)//max(health+(maxhealth/5), maxhealth) // 20% repair per application
				return
		else
			if((health <= maxhealth))
				to_chat(usr,"<span class='notice'>It's fully repaired.</span>")
			return

	// Handle harm intent grabbing/tabling.
	if(istype(W, /obj/item/grab) && get_dist(src,user)<2)
		var/obj/item/grab/G = W
		if (istype(G.affecting, /mob/living))
			var/mob/living/M = G.affecting
			var/obj/occupied = turf_is_crowded()
			if(occupied)
				user << "<span class='danger'>There's \a [occupied] in the way.</span>"
				return
			if (G.current_grab < 2)
				if(user.a_intent == I_HURT)
					if (prob(15))	M.Weaken(5)
					M.apply_damage(8,def_zone = "head")
					take_damage(2)
					visible_message("<span class='danger'>[G.assailant] slams [G.affecting]'s face against \the [src]!</span>")
					playsound(loc, 'sound/effects/grillehit.ogg', 50, 1)
				else
					user << "<span class='danger'>You need a better grip to do that!</span>"
					return
			else
				if (get_turf(G.affecting) == get_turf(src))
					G.affecting.forceMove(get_step(src, src.dir))
				else
					G.affecting.forceMove(get_turf(src))
				G.affecting.Weaken(5)
				visible_message("<span class='danger'>[G.assailant] throws [G.affecting] over \the [src]!</span>")
			qdel(W)
			return

	else
		playsound(loc, 'sound/effects/grillehit.ogg', 50, 1)
		take_damage(W.force)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	return ..()

/obj/machinery/stolb/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			qdel(src)
			return
		if(3.0)
			qdel(src)
			return
		else
	return

/obj/machinery/stolb/proc/hit(var/damage, var/sound_effect = 1)
	take_damage(damage)
	return

////////////////////SWITCH///////////////////////////////////////

/obj/machinery/button/stolb
	name = "electrical panel"
	desc = "Electrical panel for streetlamps."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "doortimer1"
	invisibility = INVISIBILITY_MAXIMUM
	active = 1

/obj/machinery/button/stolb/attack_hand(mob/user as mob)
	if(..())
		return

	use_power(5)

	active = !active
	update_icon()

	for(var/obj/machinery/stolb/M in SSmachines.machinery)
		if (M.id == src.id)
			spawn( 0 )
				M.toggle()
				return
	return

/obj/machinery/button/stolb/update_icon()
	icon_state = "doortimer2"
	invisibility = INVISIBILITY_MAXIMUM
	return

/obj/machinery/button/stolb/ex_act()
	return

/obj/machinery/button/stolb/hitby()
	return

/obj/machinery/button/stolb/attackby()
	return

/obj/machinery/button/stolb/attack_hand()
	return
