GLOBAL_LIST_INIT(dna_machinery_styles, list(
		"cyan",
		"yellow",
		"purple"))


var/global/default_dna_machinery_style


/hook/roundstart/proc/pick_dna_machinery_style()
	default_dna_machinery_style = pick(GLOB.dna_machinery_styles)


/datum/computer_file/binary/animalgene
	filetype = "ADNA"
	size = 5
	var/gene_type
	var/gene_value


/datum/mutation
	var/name = "Unknown"
	var/desc = "Unknown"
	var/hex = "FFFFFF"
	var/tier_num = 0 // 0, 1, 2, 3, 4
	var/tier_string = "Nero" // "Nero", "Vespasian", "Tacitus", "Hadrian", "Aurelien"
	var/NSA_load = 1 // How much NSA holder get if mutation is active
	var/is_active = FALSE
	var/domino_r = 1
	var/domino_l = 1


/datum/mutation/New()
	hex = num2hex(rand(21845, 65535))
	domino_r = pick(1, 2, 3, 4, 5, 6, 7, 8)
	domino_l = pick(1, 2, 3, 4, 5, 6, 7, 8)


/datum/mutation/proc/imprint(mob/living/carbon/user)
	if(!istype(user))
		return

	if(src in user.active_mutations)
		return

// Check for maximum active mutations of certain type

	if(src in user.dormant_mutations)
		user.dormant_mutations -= src

	user.active_mutations |= src
	user.metabolism_effects.adjust_nsa(NSA_load, "Mutation_[hex]_[name]")


/datum/mutation/proc/cleanse(mob/living/carbon/user)
	if(!istype(user))
		return

	user.active_mutations -= src
	user.dormant_mutations |= src
	user.metabolism_effects.remove_nsa("Mutation_[hex]_[name]")

/mob/proc/GetMutation(M)
	if(M in active_mutations)
		return TRUE
	return FALSE
