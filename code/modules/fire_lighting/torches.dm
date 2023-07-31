//Torches
/obj/item/torch
	icon = 'icons/obj/torches.dmi'
	icon_state = "torch0"
	item_state = "torch0"
	name = "Torch"
	desc = "In radiance may we find victory."
	var/lit = FALSE
	var/self_lighting = 0

/obj/item/torch/self_lit
	name = "Self-igniting Torch"
	desc = "In radiance may we find victory. This torch provides its own."
	self_lighting = 1

/obj/item/torch/Initialize()
	. = ..()
	update_icon()

/obj/item/torch/update_icon()
	..()
	overlays = overlays.Cut()
	if(lit)
		icon_state = "torch1"
		item_state = "torch1"
		set_light(3, 5, "#E38F46")
	else
		icon_state = "torch0"
		item_state = "torch0"
		set_light(0,0)
		if(self_lighting == 1)
			overlays += overlay_image(icon, "lighter")
	update_held_icon()

/obj/item/torch/Process()
	..()
/*	//This used to be broken, it's instead being commented out for not really needing to be used at the moment. Warfare doesn't simulate atmos.
	var/datum/gas_mixture/air = loc.return_air()
	var/oxy_mole = air.get_gas("oxygen")
	var/total_mole = air.get_total_moles()
	var/total_pressure = air.return_pressure()
	if(oxy_mole && total_mole)
		var/o2_pressure = (oxy_mole /total_mole )*total_pressure
		if(o2_pressure <= HAZARD_LOW_PRESSURE)
			snuff()

	//else if(!oxy_mole)
	//	snuff()
*/
	if(prob(1)) //Needs playtesting. This seems a little high.
		if(istype(src.loc, /obj/structure/torchwall))
			return //Please don't put out torches that are on the walls.
		visible_message("A rush of wind puts out the torch.")
		snuff()


/obj/item/torch/proc/light(var/mob/user, var/manually_lit = FALSE)//This doesn't seem to update the icon appropiately, not idea why.
	lit = TRUE
	if(manually_lit && self_lighting == 1)
		user.visible_message("<span class='notice'>\The [user] rips the lighting sheath off their [src].</span>")
	update_icon()
	START_PROCESSING(SSprocessing, src)
	playsound(src, 'sound/items/torch_light.ogg', 50, 0, -1)


/obj/item/torch/proc/snuff()
	lit = FALSE
	update_icon()
	STOP_PROCESSING(SSprocessing, src)
	playsound(src, 'sound/items/torch_snuff.ogg', 50, 0, -1)


/obj/item/torch/attack_self(mob/user)
	..()
	if(self_lighting == 1)
		light(user, TRUE)
		self_lighting = -1
		return
	if(lit)
		snuff()

/obj/item/torch/attackby(obj/item/W, mob/user)
	..()
	if(isflamesource(W))
		light()

/obj/structure/torchwall
	name = "torch fixture"
	icon = 'icons/obj/lighting.dmi'
	icon_state = "torchwall0"
	desc = "A torch fixture."
	anchored = TRUE
	plane = ABOVE_HUMAN_PLANE
	layer = ABOVE_HUMAN_LAYER

	var/obj/item/torch/lighttorch

/obj/structure/torchwall/New()
	..()
	if(prob(98))
		lighttorch = new(src)
		if(prob(75))
			lighttorch.lit = TRUE
	update_icon()

/obj/structure/torchwall/service/New()
	..()
	if(!locate(lighttorch) in src)
		lighttorch = new(src)
	lighttorch.lit = TRUE
	update_icon()


/obj/structure/torchwall/Destroy()
	QDEL_NULL(lighttorch)
	. = ..()


/obj/structure/torchwall/update_icon()
	..()
	if(lighttorch)
		if(lighttorch.lit)
			icon_state = "torchwall1"
			set_light(7, 5,"#E38F46")

		else
			icon_state = "torchwall0"
			set_light(0,0)
	else
		icon_state = "torchwall"
		set_light(0,0)


/obj/structure/torchwall/proc/insert_torch(obj/item/torch/T)
	T.forceMove(src)
	lighttorch = T
	update_icon()
	playsound(src, 'sound/items/torch_fixture1.ogg', 50, 0, -1)


/obj/structure/torchwall/attackby(obj/item/W, mob/user)
	// attempt to insert torch
	if(lighttorch && !lighttorch.lit)
		if(isflamesource(W))
			lighttorch.light()
			update_icon()
			return

	if(istype(W, /obj/item/torch))
		if(lighttorch && lighttorch.lit)
			var/obj/item/torch/T = W
			if(!T.lit)
				T.light()
				update_icon()
			return

		else if(lighttorch)//To stop you from putting in a torch twice.
			return

		user.drop_item()
		insert_torch(W)
		src.add_fingerprint(user)

	update_icon()

/obj/structure/torchwall/proc/remove_torch()
	. = lighttorch
	lighttorch.dropInto(loc)
	lighttorch.update_icon()
	lighttorch = null
	update_icon()
	playsound(src, 'sound/items/torch_fixture0.ogg', 50, 0, -1)

// attack with hand - remove torch
/obj/structure/torchwall/attack_hand(mob/user)

	add_fingerprint(user)

	if(!lighttorch)
		to_chat(user, "There is no torch here.")
		return
	// create a torch item and put it in the user's hand
	user.put_in_active_hand(remove_torch())  //puts it in our active hand

//Pyres
/obj/item/pyre
	icon = 'icons/obj/structures/fireplace.dmi'
	icon_state = "fireplacestand"
	item_state = "fireplacestand"
	name = "Pyre"
	desc = "In radiance may we find victory."
	anchored = 1
	density = 1
	var/lit = FALSE
	var/self_lighting = 0

/obj/item/pyre/self_lit
	name = "Self-igniting Pyre"
	desc = "In radiance may we find victory. This pyre provides its own."
	self_lighting = 1
	anchored = 1
	lit = 1
	density = 1

/obj/item/pyre/Initialize()
	. = ..()
	update_icon()

/obj/item/pyre/update_icon()
	..()
	overlays = overlays.Cut()
	if(lit)
		icon_state = "fireplacestand_f"
		item_state = "fireplacestand_f"
		set_light(5, 7, "#E38F46")
	else
		icon_state = "fireplacestand"
		item_state = "fireplacestand"
		set_light(0,0)
		if(self_lighting == 1)
			overlays += overlay_image(icon, "lighter")
	update_held_icon()


/obj/item/pyre/proc/light(var/mob/user, var/manually_lit = FALSE)//This doesn't seem to update the icon appropiately, not idea why.
	lit = TRUE
	if(manually_lit && self_lighting == 1)
		user.visible_message("<span class='notice'>\The [user] rips the lighting sheath off their [src].</span>")
	update_icon()
	START_PROCESSING(SSprocessing, src)
	playsound(src, 'sound/items/torch_light.ogg', 50, 0, -1)


/obj/item/pyre/proc/snuff()
	lit = FALSE
	update_icon()
	STOP_PROCESSING(SSprocessing, src)
	playsound(src, 'sound/items/torch_snuff.ogg', 50, 0, -1)


/obj/item/pyre/attack_self(mob/user)
	..()
	if(self_lighting == 1)
		light(user, TRUE)
		self_lighting = -1
		return
	if(lit)
		snuff()

/obj/item/pyre/attackby(obj/item/W, mob/user)
	..()
	if(isflamesource(W))
		light()

/obj/structure/fireplacebl
	icon = 'icons/obj/structures/fireplacebig.dmi'
	icon_state = "fireplace"
	name = "fireplace"
	desc = "In radiance may we find victory."
	anchored = 1
	density = 1
	var/lit = FALSE
	var/self_lighting = 0
	lit = 1
	bound_width = 64

/obj/item/pyre/Initialize()
	. = ..()
	update_icon()

/obj/structure/fireplacebl/proc/light(var/mob/user, var/manually_lit = FALSE)//This doesn't seem to update the icon appropiately, no idea why.
	lit = TRUE
	if(manually_lit && self_lighting == 1)
		user.visible_message("<span class='notice'>\The [user] rips the lighting sheath off their [src].</span>")
	update_icon()
	START_PROCESSING(SSprocessing, src)
	playsound(src, 'sound/items/torch_light.ogg', 50, 0, -1)

/obj/structure/fireplacebl/update_icon()
	..()
	overlays = overlays.Cut()
	if(lit)
		icon_state = "fire_bl"
		set_light(5, 7, "#E38F46")
	else
		icon_state = "fire_bl"
		set_light(0,0)
		if(self_lighting == 1)
			overlays += overlay_image(icon, "lighter")

/obj/structure/fireplacebl/proc/snuff()
	lit = FALSE
	update_icon()
	STOP_PROCESSING(SSprocessing, src)
	playsound(src, 'sound/items/torch_snuff.ogg', 50, 0, -1)

/obj/structure/fireplacebl/attackby(obj/item/W, mob/user)
	..()
	if(isflamesource(W))
		light()

/obj/item/campfire
	icon = 'icons/obj/firepit.dmi'
	icon_state = "cauldron0"
	item_state = "cauldron0"
	name = "Camp Fire"
	desc = "In radiance may we find victory."
	anchored = 1
	density = 1
	var/lit = FALSE
	var/self_lighting = 0
	var/destroyed = 0

/obj/item/campfire/self_lit
	name = "Self-igniting Pyre"
	desc = "In radiance may we find victory. This pyre provides its own."
	self_lighting = 1
	anchored = 1
	lit = 1
	density = 1

/obj/item/campfire/Initialize()
	. = ..()
	update_icon()

/obj/item/campfire/update_icon()
	..()
	overlays = overlays.Cut()
	if(lit)
		icon_state = "cauldron1"
		item_state = "cauldron1"
		set_light(5, 7, "#E38F46")
	else
		icon_state = "cauldron0"
		item_state = "cauldron0"
		set_light(0,0)
		if(self_lighting == 1)
			overlays += overlay_image(icon, "lighter")
	update_held_icon()


/obj/item/campfire/proc/light(var/mob/user, var/manually_lit = FALSE)//This doesn't seem to update the icon appropiately, not idea why.
	lit = TRUE
	if(manually_lit && self_lighting == 1)
		user.visible_message("<span class='notice'>\The [user] rips the lighting sheath off their [src].</span>")
	update_icon()
	START_PROCESSING(SSprocessing, src)
	playsound(src, 'sound/items/torch_light.ogg', 50, 0, -1)


/obj/item/campfire/proc/snuff()
	lit = FALSE
	update_icon()
	STOP_PROCESSING(SSprocessing, src)
	playsound(src, 'sound/items/torch_snuff.ogg', 50, 0, -1)


/obj/item/campfire/attack_self(mob/user)
	..()
	if(self_lighting == 1)
		light(user, TRUE)
		self_lighting = -1
		return
	if(lit)
		snuff()

/obj/item/campfire/attackby(obj/item/W, mob/user)
	..()
	if(isflamesource(W))
		light()

//burnbbarrel

/obj/item/burnbarrel
	icon = 'icons/obj/torches.dmi'
	icon_state = "burnbarrel"
	item_state = "burnbarrel"
	name = "Pyre"
	desc = "In radiance may we find victory."
	anchored = 1
	density = 1
	var/lit = FALSE
	var/self_lighting = 0

/obj/item/burnbarrel/self_lit
	name = "burning barrel"
	desc = "In radiance may we find victory. This pyre provides its own."
	self_lighting = 1
	anchored = 1
	lit = 1
	density = 1

/obj/item/burnbarrel/Initialize()
	. = ..()
	update_icon()

/obj/item/burnbarrel/update_icon()
	..()
	overlays = overlays.Cut()
	if(lit)
		icon_state = "burnbarrel_on"
		item_state = "burnbarrel_on"
		set_light(5, 7, "#E38F46")
	else
		icon_state = "burnbarrel"
		item_state = "burnbarrel"
		set_light(0,0)
		if(self_lighting == 1)
			overlays += overlay_image(icon, "lighter")
	update_held_icon()


/obj/item/burnbarrel/proc/light(var/mob/user, var/manually_lit = FALSE)//This doesn't seem to update the icon appropiately, not idea why.
	lit = TRUE
	if(manually_lit && self_lighting == 1)
		user.visible_message("<span class='notice'>\The [user] rips the lighting sheath off their [src].</span>")
	update_icon()
	START_PROCESSING(SSprocessing, src)
	playsound(src, 'sound/items/torch_light.ogg', 50, 0, -1)


/obj/item/burnbarrel/proc/snuff()
	lit = FALSE
	update_icon()
	STOP_PROCESSING(SSprocessing, src)
	playsound(src, 'sound/items/torch_snuff.ogg', 50, 0, -1)


/obj/item/burnbarrel/attack_self(mob/user)
	..()
	if(self_lighting == 1)
		light(user, TRUE)
		self_lighting = -1
		return
	if(lit)
		snuff()

/obj/item/burnbarrel/attackby(obj/item/W, mob/user)
	..()
	if(isflamesource(W))
		light()