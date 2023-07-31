/obj/structure/girder
	icon_state = "girder"
	name = "girder"
	anchored = 1
	density = 1
	plane = OBJ_PLANE
	layer = BELOW_OBJ_LAYER
	w_class = ITEM_SIZE_NO_CONTAINER
	var/state = 0
	var/health = 400
	var/cover = 50 //how much cover the girder provides against projectiles.
	var/material/reinf_material
	var/reinforcing = 0

/obj/structure/girder/displaced
	icon_state = "displaced"
	opacity = 0
	anchored = 0
	health = 50
	cover = 25

/obj/structure/girder/attack_generic(var/mob/user, var/damage, var/attack_message = "smashes apart", var/wallbreaker)
	if(!damage || !wallbreaker)
		return 0
	attack_animation(user)
	visible_message("<span class='danger'>[user] [attack_message] the [src]!</span>")
	spawn(1) dismantle()
	return 1

/obj/structure/girder/bullet_act(var/obj/item/projectile/Proj)
	//Girders only provide partial cover. There's a chance that the projectiles will just pass through. (unless you are trying to shoot the girder)
	if(Proj.original != src && !prob(cover))
		return PROJECTILE_CONTINUE //pass through

	var/damage = Proj.get_structure_damage()
	if(!damage)
		return

	if(!istype(Proj, /obj/item/projectile/beam))
		damage *= 0.4 //non beams do reduced damage

	health -= damage
	..()
	if(health <= 0)
		dismantle()

	return

/obj/structure/girder/proc/reset_girder()
	anchored = 1
	cover = initial(cover)
	health = min(health,initial(health))
	state = 0
	icon_state = "girder"
	reinforcing = 0
	if(reinf_material)
		reinforce_girder()

/obj/structure/girder/attackby(obj/item/W as obj, mob/user as mob)
	if(isWrench(W) && state == 0)
		if(anchored && !reinf_material)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
			to_chat(user, "<span class='notice'>The [user] disassembling the girder...</span>")
			if(do_after(user, 40,src))
				if(!src) return
				to_chat(user, "<span class='notice'>The [user] dissasembled the girder!</span>")
				dismantle()
		else if(!anchored)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
			to_chat(user, "<span class='notice'>The [user] securing the girder...</span>")
			if(do_after(user, 40,src))
				to_chat(user, "<span class='notice'>The [user] secured the girder!</span>")
				icon_state = "girder"
				reset_girder()

	else if(istype(W, /obj/item/gun/energy/plasmacutter))
		to_chat(user, "<span class='notice'>The [user] slicing apart the girder...</span>")
		if(do_after(user,30,src))
			if(!src) return
			to_chat(user, "<span class='notice'>The [user] slice apart the girder!</span>")
			dismantle()

	else if(istype(W, /obj/item/pickaxe/diamonddrill))
		to_chat(user, "<span class='notice'>The [user] drill through the girder!</span>")
		dismantle()

	else if(isWrench(W) && anchored && state == 3)
		playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
		to_chat(user, "<span class='notice'>The [user] securing covers...</span>")
		if(do_after(user, 40,src))
			if(!src) return
			to_chat(user, "<span class='notice'>The [user] secured covers!</span>")
			state = 4
			opacity = 1
			icon_state = "r_girder1"

	else if(isScrewdriver(W))
		if(state == 2 && state == 2 && anchored)
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
			to_chat(user, "<span class='notice'>The [user] unsecuring support struts...</span>")
			if(do_after(user, 40,src))
				if(!src) return
				to_chat(user, "<span class='notice'>The [user] unsecured the support struts!</span>")
				state = 1
				opacity = 0
				icon_state = "reinforced"
		else if(isScrewdriver(W) && anchored && state == 1)
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
			to_chat(user, "<span class='notice'>The [user] securing the support struts...</span>")
			if(do_after(user, 40,src))
				if(!src) return
				to_chat(user, "<span class='notice'>The [user] secured the support struts!</span>")
				state = 2
				opacity = 0
				icon_state = "reinforced"

	else if(isWirecutter(W))
		if(state == 1 && state == 1 && anchored)
			playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
			to_chat(user, "<span class='notice'>The [user] removing support struts...</span>")
			if(do_after(user, 40,src))
				if(!src) return
				to_chat(user, "<span class='notice'>The [user] removed the support struts!</span>")
				opacity = 0
				state = 0
				icon_state = "girder"
				new /obj/item/stack/rods(get_turf(src))
				reinf_material.place_dismantled_product(get_turf(src))
				reinf_material = null
				reset_girder()

	else if(isCrowbar(W) && state == 0 && anchored)
		playsound(src.loc, 'sound/items/Crowbar.ogg', 100, 1)
		to_chat(user, "<span class='notice'>The [user] dislodging the girder...</span>")
		if(do_after(user, 40,src))
			if(!src) return
			to_chat(user, "<span class='notice'>The [user] dislodged the girder!</span>")
			icon_state = "displaced"
			opacity = 0
			anchored = 0
			health = 50
			cover = 25

	else if(isCrowbar(W) && anchored && state == 4)
		playsound(src.loc, 'sound/items/Crowbar.ogg', 100, 1)
		to_chat(user, "<span class='notice'>The [user] dislodging the covers...</span>")
		if(do_after(user, 40,src))
			if(!src) return
			to_chat(user, "<span class='notice'>The [user] dislodged the covers!</span>")
			icon_state = "r_girder"
			state = 3
			opacity = 0

	else if(istype(W, /obj/item/stack/rods) && anchored && state == 0)
		var/obj/item/stack/rods/R = W
		if(state == 0 && anchored)
			if (R.get_amount() < 5)
				to_chat(user, "<span class='notice'>The [user] needs five of metal rods to complete this task!</span>")
				return
			if(do_after(user, 40, src, same_direction = 1))
				icon_state = "reinforced"
				to_chat(user, "<span class='notice'>The [user] added metal rods!</span>")
				R.use(5)
				state = 1
				opacity = 0
				return
		else
			if(anchored == 0)
				to_chat(usr,"<span class='notice'>Girder needs to be anchored.</span>")

	else if(istype(W, /obj/item/stack/material/silver) && anchored && state == 2) //Picked silver ingots cause you can buy that for tradeconsole and putting plasteel again seems to brake a code. To lazy to figure out plasteel issue.
		to_chat(user, "<span class='notice'>The [user] adding silver!</span>")
		var/obj/item/stack/material/silver/R = W
		if(state == 2 && anchored)
			if (R.get_amount() < 5)
				to_chat(user, "<span class='notice'>The [user] needs five of silver to complete this task!</span>")
				return
			if(do_after(user, 40, src, same_direction = 1))
				icon_state = "r_girder"
				to_chat(user, "<span class='notice'>The [user] added silver!</span>")
				R.use(5)
				state = 3
				opacity = 0
				return

	else if(istype(W, /obj/item/weldingtool) && state == 3 && anchored)
		user.visible_message("<span class='notice'>The [user] starts slicing covers.</span>")
		var/obj/item/weldingtool/F = W
		if(F.welding && state == 3 && anchored)
			playsound(src.loc, 'sound/items/Welder.ogg', 100, 1)
			to_chat(user, "<span class='notice'>\The [user] slicing covers...</span>")
			if(do_after(user, 100, src) && F.isOn())
				playsound(src.loc, 'sound/items/Welder2.ogg', 100, 1)
				state = 2
				opacity = 0
				new /obj/item/stack/material/silver(get_turf(src))
				icon_state = "reinforced"
				user.visible_message("<span class='notice'>The [user] sliced covers!</span>")
		if(!F.isOn())
			to_chat(user, SPAN_WARNING("Turn \the [W] on first."))
			return
		if(!F.remove_fuel(0,user))
			to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
			return

	else if(istype(W, /obj/item/weldingtool) && state == 5 && anchored)
		var/obj/item/weldingtool/F = W
		if(F.welding && state == 5 && anchored)
			playsound(src.loc, 'sound/items/Welder.ogg', 100, 1)
			to_chat(user, "<span class='notice'>\The [user] opening up covers...</span>")
			if(do_after(user, 100, src) && F.isOn())
				playsound(src.loc, 'sound/items/Welder2.ogg', 100, 1)
				state = 4
				opacity = 1
				icon_state = "r_girder1"
				user.visible_message("<span class='notice'>The [user] opened up covers!</span>")
		if(!F.isOn())
			to_chat(user, SPAN_WARNING("Turn \the [W] on first."))
			return
		if(!F.remove_fuel(0,user))
			to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
			return

	else if(istype(W, /obj/item/weldingtool) && state == 4 && anchored)
		var/obj/item/weldingtool/F = W
		if(F.welding && state == 4 && anchored)
			playsound(src.loc, 'sound/items/Welder.ogg', 100, 1)
			to_chat(user, "<span class='notice'>\The [user] closing up covers...</span>")
			if(do_after(user, 100, src) && F.isOn())
				playsound(src.loc, 'sound/items/Welder2.ogg', 100, 1)
				state = 5
				opacity = 1
				icon_state = "r_girder2"
				user.visible_message("<span class='notice'>The [user] closed up covers!</span>")
		if(!F.isOn())
			to_chat(user, SPAN_WARNING("Turn \the [W] on first."))
			return
		if(!F.remove_fuel(0,user))
			to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
			return

	else if(istype(W, /obj/item/stack/material/plasteel))
		if(reinforcing && !reinf_material)
			if(!reinforce_with_material(W, user))
				return ..()
		else
			if(!construct_wall(W, user))
				return ..()

	else if(istype(W, /obj/item/stack/material/steel))
		if(reinforcing && !reinf_material)
		else
			if(!construct_metal_wall(W, user))
				return ..()

	else
		return ..()

/obj/structure/girder/proc/construct_metal_wall(obj/item/stack/material/S, mob/user)
	if(S.get_amount() < 4)
		to_chat(user, "<span class='notice'>There isn't enough material here to construct a wall.</span>")
		return 0

//	var/material/M = name_to_material[S.default_type]
//	if(!istype(M))
//		return 0

	var/wall_fake
	add_hiddenprint(usr)

//	if(M.integrity < 50)
//		to_chat(user, "<span class='notice'>This material is too soft for use in wall construction.</span>")
//		return 0

	if(anchored == 0)
		to_chat(user, "<span class='notice'>Girder needs to be anchored.</span>")
		return 0

	if(state == 0)
		to_chat(user, "<span class='notice'>Does not fit in frame.</span>")
		return 0

	if(state == 3)
		to_chat(user, "<span class='notice'>Does not fit in frame.</span>")
		return 0

	if(state == 4)
		to_chat(user, "<span class='notice'>Does not fit in frame.</span>")
		return 0

	if(state == 5)
		to_chat(user, "<span class='notice'>Does not fit in frame.</span>")
		return 0

	to_chat(user, "<span class='notice'>The [user] begin adding plating...</span>")

	if(!do_after(user,40,src) || !S.use(4))
		return 1 //once we've gotten this far don't call parent attackby()

	if(state == 2)
		to_chat(user, "<span class='notice'>The [user] added the plating!</span>")
	else
		to_chat(user, "<span class='notice'>The [user] create a false wall! Push on it to open or close the passage.</span>")
		wall_fake = 1

	var/turf/Tsrc = get_turf(src)
	Tsrc.ChangeTurf(/turf/simulated/wall/concrete)
	var/turf/simulated/wall/concrete/T = get_turf(src)
	//T.set_material(M, reinf_material)
	if(wall_fake)
		T.can_open = 1
	T.add_hiddenprint(usr)
	qdel(src)
	return 1

/obj/structure/girder/proc/construct_wall(obj/item/stack/material/S, mob/user)
	if(S.get_amount() < 4)
		to_chat(user, "<span class='notice'>There isn't enough material here to construct a wall.</span>")
		return 0

//	var/material/M = name_to_material[S.default_type]
//	if(!istype(M))
//		return 0

	var/wall_fake
	add_hiddenprint(usr)

//	if(M.integrity < 50)
//		to_chat(user, "<span class='notice'>This material is too soft for use in wall construction.</span>")
//		return 0

	if(anchored == 0)
		to_chat(user, "<span class='notice'>Girder needs to be anchored.</span>")
		return 0

	if(state == 0)
		to_chat(user, "<span class='notice'>Does not fit in frame.</span>")
		return 0

	if(state == 1)
		to_chat(user, "<span class='notice'>Does not fit in frame.</span>")
		return 0

	if(state == 2)
		to_chat(user, "<span class='notice'>Does not fit in frame.</span>")
		return 0

	if(state == 4)
		to_chat(user, "<span class='notice'>Does not fit in frame.</span>")
		return 0

	to_chat(user, "<span class='notice'>The [user] begin adding plating...</span>")

	if(!do_after(user,40,src) || !S.use(4))
		return 1 //once we've gotten this far don't call parent attackby()

	if(state == 5)
		to_chat(user, "<span class='notice'>The [user] added the plating!</span>")

	else
		to_chat(user, "<span class='notice'>The [user] create a false wall! Push on it to open or close the passage.</span>")
		wall_fake = 1

	var/turf/Tsrc = get_turf(src)
	Tsrc.ChangeTurf(/turf/simulated/wall/r_wall)
	var/turf/simulated/wall/r_wall/T = get_turf(src)
	//T.set_material(M, reinf_material)
	if(wall_fake)
		T.can_open = 1
	T.add_hiddenprint(usr)
	qdel(src)
	return 1

/obj/structure/girder/proc/reinforce_with_material(obj/item/stack/material/S, mob/user) //if the verb is removed this can be renamed.
	if(reinf_material)
		to_chat(user, "<span class='notice'>\The [src] is already reinforced.</span>")
		return 0

	if(S.get_amount() < 4)
		to_chat(user, "<span class='notice'>There isn't enough material here to reinforce the girder.</span>")
		return 0

	var/material/M = name_to_material[S.default_type]
	if(!istype(M) || M.integrity < 50)
		to_chat(user, "You cannot reinforce \the [src] with that; it is too soft.")
		return 0

	to_chat(user, "<span class='notice'>Now reinforcing...</span>")
	if (!do_after(user, 40,src) || !S.use(4))
		return 1 //don't call parent attackby() past this point
	to_chat(user, "<span class='notice'>You added reinforcement!</span>")

	reinf_material = M
	reinforce_girder()
	return 1

/obj/structure/girder/proc/reinforce_girder()
	name = "girder"
	opacity = 1
	cover = 75
	health = 700
	state = 5
	opacity = 1
	icon_state = "r_girder2"
	reinforcing = 0

/obj/structure/girder/proc/dismantle()
	new /obj/item/stack/material/steel(get_turf(src))
	qdel(src)

/obj/structure/girder/attack_hand(mob/user as mob)
	if (HULK in user.mutations)
		visible_message("<span class='danger'>[user] smashes [src] apart!</span>")
		dismantle()
		return
	return ..()


/obj/structure/girder/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(30))
				dismantle()
			return
		if(3.0)
			if (prob(5))
				dismantle()
			return
		else
	return

/obj/structure/girder/cult
	icon= 'icons/obj/cult.dmi'
	icon_state= "cultgirder"
	health = 450
	cover = 70

/obj/structure/girder/cult/dismantle()
	qdel(src)

/obj/structure/girder/cult/attackby(obj/item/W as obj, mob/user as mob)
	if(isWrench(W))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
		to_chat(user, "<span class='notice'>Now disassembling the girder...</span>")
		if(do_after(user,40,src))
			to_chat(user, "<span class='notice'>You dissasembled the girder!</span>")
			dismantle()

	else if(istype(W, /obj/item/gun/energy/plasmacutter))
		to_chat(user, "<span class='notice'>Now slicing apart the girder...</span>")
		if(do_after(user,30,src))
			to_chat(user, "<span class='notice'>You slice apart the girder!</span>")
		dismantle()

	else if(istype(W, /obj/item/pickaxe/diamonddrill))
		to_chat(user, "<span class='notice'>You drill through the girder!</span>")
		new /obj/item/remains/human(get_turf(src))
		dismantle()
