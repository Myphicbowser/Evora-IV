/obj/item/gun/projectile/sec/MK
	desc = "Similar in both appearance and use of the NT Mk58, the MK pistol is an cheap knock off that preys on the unsuspecting firearm buyers."
	condition = 45
/*
/obj/item/gun/projectile/silenced/cheap
	desc = "A handgun with an integrated silencer(?). Uses .45 rounds."

/obj/item/gun/projectile/silenced/cheap/handle_post_fire()
	silenced = prob(50)
	return ..()

/obj/item/gun/projectile/heavysniper/ant
	name = "ant-material rifle"
	desc = "A portable anti-armour rifle fitted with a scope, the HI PTR-7 Rifle was originally designed to used against armoured exosuits. It is capable of punching through windows and non-reinforced walls with ease. Fires armor piercing 14.5mm shells. This replica however fires 9mm rounds."
	ammo_type = /obj/item/ammo_casing/c9mm
	caliber = "9mm"
*/
/obj/item/gun/energy/laser/dogan
	desc = "This carbine works just as well as a normal carbine. Most of the time." //removed reference to Dogan, since only the merchant is likely to know who that is.

/obj/item/gun/energy/laser/dogan/consume_next_projectile()
	projectile_type = pick(/obj/item/projectile/beam/midlaser, /obj/item/projectile/beam/lastertag/red, /obj/item/projectile/beam)
	return ..()
