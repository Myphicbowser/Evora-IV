/obj/item/spacecash
	name = "0 scrip"
	desc = "Paper currency issued by the local Lord. Not suitable for interplanetary trade."
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "spacecash1"
	opacity = 0
	density = 0
	anchored = 0.0
	force = 1.0
	throwforce = 1.0
	throw_speed = 1
	throw_range = 2
	w_class = ITEM_SIZE_TINY
	var/access = list()
	access = access_crate_cash
	var/worth = 0
	var/global/denominations = list(1000,500,200,100,50,20,10,1)

/obj/item/spacecash/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/spacecash))
		if(istype(W, /obj/item/spacecash/ewallet)) return 0

		var/obj/item/spacecash/bundle/bundle
		if(!istype(W, /obj/item/spacecash/bundle))
			var/obj/item/spacecash/cash = W
			user.drop_from_inventory(cash)
			bundle = new (src.loc)
			bundle.worth += cash.worth
			qdel(cash)
		else //is bundle
			bundle = W
		bundle.worth += src.worth
		bundle.update_icon()
		if(istype(user, /mob/living/carbon/human))
			var/mob/living/carbon/human/h_user = user
			h_user.drop_from_inventory(src)
			h_user.drop_from_inventory(bundle)
			h_user.put_in_hands(bundle)
		to_chat(user, "<span class='notice'>You add [src.worth] scrip worth of money to the bundles.<br>It holds [bundle.worth] scrip now.</span>")
		qdel(src)


/obj/item/spacecash/proc/getMoneyImages()
	if(icon_state)
		return list(icon_state)

/obj/item/spacecash/bundle
	name = "pile of scrip"
	icon_state = ""
	worth = 0

/obj/item/spacecash/bundle/getMoneyImages()
	if(icon_state)
		return list(icon_state)
	. = list()
	var/sum = src.worth
	var/num = 0
	for(var/i in denominations)
		while(sum >= i && num < 50)
			sum -= i
			num++
			. += "spacecash[i]"
	if(num == 0) // Less than one credit, let's just make it look like 1 for ease
		. += "spacecash1"

/obj/item/spacecash/bundle/update_icon()
	overlays.Cut()
	var/list/images = src.getMoneyImages()

	for(var/A in images)
		var/image/banknote = image('icons/obj/items.dmi', A)
		var/matrix/M = matrix()
		M.Translate(rand(-6, 6), rand(-4, 8))
		M.Turn(pick(-45, -27.5, 0, 0, 0, 0, 0, 0, 0, 27.5, 45))
		banknote.transform = M
		src.overlays += banknote

	if(worth in denominations)
		src.SetName("[worth] credit")
	else
		src.SetName("pile of [worth] credits")

	if(overlays.len <= 2)
		w_class = ITEM_SIZE_TINY
	else
		w_class = ITEM_SIZE_SMALL

/obj/item/spacecash/bundle/attack_self()
	var/amount = input(usr, "How many scrip do you want to take? (0 to [src.worth])", "Take Money", 20) as num
	amount = round(Clamp(amount, 0, src.worth))
	if(amount==0) return 0

	src.worth -= amount
	src.update_icon()
	if(!worth)
		usr.drop_from_inventory(src)
	if(amount in list(1000,500,200,100,50,20,1))
		var/cashtype = text2path("/obj/item/spacecash/bundle/c[amount]")
		var/obj/cash = new cashtype (usr.loc)
		usr.put_in_hands(cash)
	else
		var/obj/item/spacecash/bundle/bundle = new (usr.loc)
		bundle.worth = amount
		bundle.update_icon()
		usr.put_in_hands(bundle)
	if(!worth)
		qdel(src)

/obj/item/spacecash/bundle/c1
	name = "1 scrip"
	icon_state = "spacecash1"
	worth = 1

/obj/item/spacecash/bundle/c10
	name = "10 scrip"
	icon_state = "spacecash10"
	worth = 10

/obj/item/spacecash/bundle/c20
	name = "20 scrip"
	icon_state = "spacecash20"
	worth = 20

/obj/item/spacecash/bundle/c50
	name = "50 scrip"
	icon_state = "spacecash50"
	worth = 50

/obj/item/spacecash/bundle/c100
	name = "100 scrip"
	icon_state = "spacecash100"
	worth = 100

/obj/item/spacecash/bundle/c200
	name = "200 scrip"
	icon_state = "spacecash200"
	worth = 200

/obj/item/spacecash/bundle/c500
	name = "500 scrip"
	icon_state = "spacecash500"
	worth = 500

/obj/item/spacecash/bundle/c1000
	name = "1000 scrip"
	icon_state = "spacecash1000"
	worth = 1000

proc/spawn_money(var/sum, spawnloc, mob/living/carbon/human/human_user as mob)
	if(sum in list(10000,5000,1000,500,200,100,50,20,10,1))
		var/cash_type = text2path("/obj/item/spacecash/bundle/c[sum]")
		var/obj/cash = new cash_type (usr.loc)
		if(ishuman(human_user) && !human_user.get_active_hand())
			human_user.put_in_hands(cash)
	else
		var/obj/item/spacecash/bundle/bundle = new (spawnloc)
		bundle.worth = sum
		bundle.update_icon()
		if (ishuman(human_user) && !human_user.get_active_hand())
			human_user.put_in_hands(bundle)
	return

/obj/item/spacecash/ewallet
	name = "Charge card"
	icon_state = "efundcard"
	desc = "A card that holds an amount of money."
	var/owner_name = "" //So the ATM can set it so the EFTPOS can put a valid name on transactions.

/obj/item/spacecash/ewallet/examine(mob/user)
	. = ..(user)
	if (!(user in view(2)) && user!=src.loc) return
	to_chat(user, "<span class='notice'>Charge card's owner: [src.owner_name]. credits remaining: [src.worth].</span>")
