///////////////////////////////////////////////////////////////
// Utility: Join a list of strings with a given delimiter
///////////////////////////////////////////////////////////////
proc/text_join(var/list/L, var/delimiter = "\n")
	var/result = ""
	var/idx = 1
	var/count = L.len
	for(var/entry in L)
		result += "[entry]"
		if(idx < count)
			result += "[delimiter]"
		idx++
	return result

///////////////////////////////////////////////////////////////
// Utility: Strip specific characters from a string
///////////////////////////////////////////////////////////////
proc/strip_chars(var/string, var/remove="() ")
	var/newstr = ""
	var/len = length(string)
	for(var/i = 1 to len)
		var/c = copytext(string,i,i+1)
		// If c is NOT in remove-list, keep it
		if(!findtext(remove,c))
			newstr += c
	return newstr

/mob/living/carbon/human
	////////////////////////////////////////////////////////////
	//  A) Vars for GPT
	////////////////////////////////////////////////////////////
	var
		gpt_enabled = FALSE  // set TRUE if you want GPT AI
		// Times (in ticks) for GPT calls
		gpt_action_interval = 50	// ~5 seconds
		gpt_role_interval   = 300   // ~30 seconds
		next_gpt_action_call = 0
		next_gpt_role_call = 0

		// The short persona text we get from the "role" prompt
		gpt_personality = ""

		// We'll store recent lines of chat
		list/gpt_say_logs = list()

		// occupant map for environment
		list/gpt_occupant_map = list()

		// Where we store GPT's next command
		gpt_pending_cmd = ""
		gpt_pending_args = ""

		// Endpoint URLs (change IP/port as needed)
		gpt_api_url_action = "http://127.0.0.1:5000/npc_gpt"
		gpt_api_url_role   = "http://127.0.0.1:5000/npc_role"

////////////////////////////////////////////////////////////
// Overriding process_ai to do synchronous calls
////////////////////////////////////////////////////////////
	proc/process_ai_gpt()
		if(!gpt_enabled)
			return

		// if we see no players within 20 tiles, skip
		var/has_player_in_range = FALSE
		for(var/mob/living/carbon/human/M in view(20, src))
			if(M.client)
				has_player_in_range = TRUE
				break

		if(!has_player_in_range)
			return

		// If time to refresh role
		if(world.time >= next_gpt_role_call)
			next_gpt_role_call = world.time + gpt_role_interval
			call_gpt_role_sync()

		// If time for an action prompt
		if(world.time >= next_gpt_action_call)
			next_gpt_action_call = world.time + gpt_action_interval
			call_gpt_action_sync()

		// If we have a pending command from GPT, run it
		if(gpt_pending_cmd != "")
			world.log << "[src]: EXECUTING COMMAND: [gpt_pending_cmd] [gpt_pending_args]"
			handle_gpt_command(gpt_pending_cmd, gpt_pending_args)
			gpt_pending_cmd = ""
			gpt_pending_args = ""


	////////////////////////////////////////////////////////////
	//  C) Build the Action Prompt
	////////////////////////////////////////////////////////////
	proc/build_action_prompt()
		var/env_snapshot = gather_gpt_environment_snapshot(3)
		var/saylog_text = text_join(gpt_say_logs, "\n")

		// Combine our existing 'personality' + environment + instructions
		var/prompt = ""
		prompt += "[gpt_personality]\n\n"
		prompt += "ENVIRONMENT (7x7 around me, medieval grimdark):\n"
		prompt += "[env_snapshot]\n"
		prompt += "RECENT SPEECH:\n[saylog_text]\n\n"
		prompt += "You can ONLY RESPOND in JSON:\n"
		prompt += "{\"command\":\"COMMAND\",\"args\":\"ARG\"}\n"
		prompt += "Valid commands: walk, say, retaliate, deaggro.\n"
		prompt += " - walk => '(dx,dy)'\n"
		prompt += " - say => 'some text'\n"
		prompt += " - retaliate => '#ID'\n"
		prompt += " - deaggro => no fights\n\n"
		prompt += "What do you do?\n"

		return prompt

	////////////////////////////////////////////////////////////
	//  D) Build the Role Prompt
	////////////////////////////////////////////////////////////
	proc/build_role_prompt()
		/*
		  If your codebase doesn’t have assigned_role, real_name,
		  species, contents, health, define them or adapt as needed.
		*/
		var/role_info = ""
		// These might be placeholders – adapt to your codebase
		role_info += "Assigned Role: [mind?.assigned_role]\n"
		role_info += "Real Name: [real_name]\n"
		role_info += "Species: [dna.species]\n"
		role_info += "Health: [health]\n"
		// `contents` might be your inventory; adapt
		role_info += "Inventory: [contents]\n"

		var/prompt = ""
		prompt += "You are an NPC in a medieval grimdark environment.\n"
		prompt += "Create a short persona description from this info:\n"
		prompt += "[role_info]\n\n"
		prompt += "Return ONLY the text. No extra JSON.\n"

		return prompt

////////////////////////////////////////////////////////////
// Synchronous call to action endpoint
////////////////////////////////////////////////////////////
	proc/call_gpt_action_sync()
		var/prompt_text = build_action_prompt()

		var/url = "[gpt_api_url_action]?prompt=[url_encode(prompt_text)]"
		var/list/http_result = world.Export(url, "GET")

		if(!http_result)
			world.log << "[src]: GPT action request failed! No result."
			return

		var/status = http_result["STATUS"]
		// If status is "200 OK" or something, check first 3 or 4 chars:
		if(!status || copytext(status, 1, 4) != "200")
			world.log << "[src]: GPT action request returned status [status]."
			return

		var/content_file = http_result["CONTENT"]
		if(!content_file)
			world.log << "[src]: GPT action request had no CONTENT!"
			return

		var/raw_response = file2text(content_file)
		// optional trim() if you have it, or define your own
		// raw_response = trim(raw_response) // if your older DM has no trim, skip it

		world.log << "[src]: Received GPT action response: [raw_response]"

		// find first '{'
		var/json_start = findtext(raw_response, "{", 1)
		if(!json_start)
			world.log << "[src]: No '{' found in GPT response!"
			return

		// find last '}'
		var/json_end = get_last_brace_index(raw_response)
		if(!json_end || json_end < json_start)
			world.log << "[src]: No '}' found in GPT response, or it's before '{'!"
			return

		// slice from json_start..json_end
		var/json_text = copytext(raw_response, json_start, json_end+1)

		// naive parse of "command" and "args"
		var/command = ""
		var/argument = ""

		var/cpos = findtext(json_text, "\"command\":", 1)
		if(cpos)
			var/startc = findtext(json_text, "\"", cpos+10)
			var/endc   = findtext(json_text, "\"", startc+1)
			if(startc && endc)
				command = copytext(json_text, startc+1, endc)

		var/apos = findtext(json_text, "\"args\":", 1)
		if(apos)
			var/starta = findtext(json_text, "\"", apos+6)
			var/enda   = findtext(json_text, "\"", starta+1)
			if(starta && enda)
				argument = copytext(json_text, starta+1, enda)

		if(!command)
			command = "say"
		if(!argument)
			argument = "..."

		gpt_pending_cmd = command
		gpt_pending_args = argument
		world.log << "[src]: Command=[command], args=[argument] stored."

	// Helper proc for older BYOND to find the last '}' in a string
	proc/get_last_brace_index(var/text)
		var/L = length(text)
		while(L > 0)
			if(copytext(text, L, L+1) == "}")
				return L
			L--
		return 0  // not found


////////////////////////////////////////////////////////////
// Synchronous call to role endpoint
////////////////////////////////////////////////////////////
	proc/call_gpt_role_sync()
		// 1) Build the prompt for role/persona
		var/prompt_text = build_role_prompt()

		// 2) Construct the URL with ?prompt=...
		var/url = "[gpt_api_url_role]?prompt=[url_encode(prompt_text)]"

		// 3) Perform a synchronous GET
		var/list/http_result = world.Export(url, "GET")

		// 4) If no response at all
		if(!http_result)
			world.log << "[src]: GPT role request failed! No result."
			return

		// 5) Check if HTTP status starts with "200"
		var/status = http_result["STATUS"]
		if(!status || copytext(status, 1, 4) != "200")
			world.log << "[src]: GPT role request returned status [status]."
			return

		// 6) Get the file reference from ["CONTENT"]
		var/content_file = http_result["CONTENT"]
		if(!content_file)
			world.log << "[src]: GPT role request had no CONTENT!"
			return

		// 7) Convert that file to text
		var/raw_response = file2text(content_file)

		// (Optional) If your older BYOND lacks built-in trim(),
		// define your own or skip this step:
		// raw_response = trim(raw_response)

		// 8) Log and store
		world.log << "[src]: Received GPT role response:\n[raw_response]"
		gpt_personality = raw_response



	////////////////////////////////////////////////////////////
	//  G) handle_gpt_command
	////////////////////////////////////////////////////////////
	proc/handle_gpt_command(var/cmd, var/cmd_args)
		world.log << "in the command queue: [cmd] [cmd_args]"
		if(cmd == "walk")
			var/list/coords = parse_relative_coords(cmd_args)
			if(coords.len == 2)
				step_gpt(coords[1], coords[2])

		else if(cmd == "say")
			say("[cmd_args]")

		else if(cmd == "retaliate")
			// e.g. "#2"
			var/mob/living/target_mob = gpt_occupant_map[cmd_args]
			if(target_mob)
				retaliate(target_mob)
			else
				visible_message("[src] growls at the air, no target found.")

		else if(cmd == "deaggro")
			back_to_idle()

		else
			visible_message("[src] looks confused (unknown command).")

	////////////////////////////////////////////////////////////
	//  H) step_gpt to move the mob
	////////////////////////////////////////////////////////////
	proc/step_gpt(var/dx, var/dy)
		var/turf/dest = locate(x + dx, y + dy, z)
		if(dest)
			Move(dest)
		else
			emote("bumps into unseen rubble.")

	////////////////////////////////////////////////////////////
	//  I) Gather environment in a 7x7
	////////////////////////////////////////////////////////////
	proc/gather_gpt_environment_snapshot(var/radius = 3)
		gpt_occupant_map = list()
		var/id_counter = 1
		var/result = ""

		for(var/x_offset in -radius to radius)
			for(var/y_offset in -radius to radius)
				var/dx = x_offset
				var/dy = y_offset
				var/turf/T = locate(x + dx, y + dy, z)

				if(!T)
					result += "([dx],[dy]): ??\n"
					continue

				if(T.density)
					result += "([dx],[dy]): wall\n"
					continue

				// Check occupant
				var/mob/living/occupant = null
				for(var/mob/living/L in T)
					occupant = L
					break

				if(occupant && occupant != src)
					var/id_str = "#[id_counter]"
					gpt_occupant_map[id_str] = occupant
					result += "([dx],[dy]): occupant [id_str] = \"[occupant.name]\"\n"
					id_counter++
				else if(occupant == src)
					result += "([dx],[dy]): me\n"
				else
					result += "([dx],[dy]): free\n"

		return result

	////////////////////////////////////////////////////////////
	//  J) parse_relative_coords
	//	 e.g. "(1,-2)" => list(1, -2)
	////////////////////////////////////////////////////////////
	proc/parse_relative_coords(var/xy)
		var/clean = strip_chars(xy, "() ")
		var/list/parts = splittext(clean, ",")
		if(parts.len < 2)
			return list()
		var/dx = text2num(parts[1])
		var/dy = text2num(parts[2])
		return list(dx, dy)

	////////////////////////////////////////////////////////////
	//  K) Overriding Hear() to store last 10 lines
	////////////////////////////////////////////////////////////
	Hear(var/mob/living/carbon/human/speaker, var/message)
		if(speaker && message && get_dist(speaker, src) <= 7)
			gpt_say_logs += "[speaker.name]: [message]"
			if(gpt_say_logs.len > 10)
				gpt_say_logs.Cut(1,1)
		..()


