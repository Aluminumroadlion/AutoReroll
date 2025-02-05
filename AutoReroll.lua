--- STEAMODDED HEADER
--- MOD_NAME: AutoReroll
--- MOD_ID: autoreroll
--- PREFIX: autoreroll
--- MOD_AUTHOR: [Aluminumroadlion]
--- MOD_DESCRIPTION: A Balatro mod that adds an auto-reroll mechanic for when you're searching for a specific card.
--- BADGE_COLOUR: 9c66a3
--- DEPENDENCIES: []
--- VERSION: 1.0.0
--- PRIORITY: 0

-- initialize the chosen card to search for
G.CARD_SEARCH = ""
-- initialize the card choice box
G.CARD_SEARCH_UI = nil

-- rerolls only if the shop doesn't have the desired item
smart_reroll = function(desired_joker_key)
    if G and G.shop_jokers then
        local found = nil
        for i=1,#G.shop_jokers.cards do
            if G.shop_jokers.cards[i].config.center.key == desired_joker_key then found = true end
        end
        if (G.GAME.dollars-G.GAME.bankrupt_at) - G.GAME.current_round.reroll_cost > -1 and G.GAME.current_round.reroll_cost ~= 0 and not found then
            G.FUNCS.reroll_shop()
            return false
        end
        return true
    end
end

-- keybind to autoreroll
SMODS.Keybind{
    key_pressed='k',
    action = function(self)
		if G.CARD_SEARCH ~= "" then
			local desired_joker_name = G.CARD_SEARCH
			local desired_joker_key = nil
			for k, v in pairs(G.P_CENTERS) do
				if v.name == desired_joker_name then
					desired_joker_key = k
				end
			end
			G.E_MANAGER:add_event(Event({
				func = function()
					return smart_reroll(desired_joker_key)
				end,
			}),'other')
		end
		return true
    end,
}

-- function to create card search UI
function createUI_autoreroll()
	return {n=G.UIT.ROOT, config={align = "cm"}, nodes={
	   {n=G.UIT.C, config={align = "cm"}, nodes={
		{
			n = G.UIT.R,
			config = { align = "cm" },
			nodes = {{n = G.UIT.T, config = {text = ""}}},
		},
		{
			n = G.UIT.R,
			nodes = {
				create_text_input({
					colour = G.C.BLUE,
					hooked_colour = darken(copy_table(G.C.BLUE), 0.3),
					w = 4.5,
					h = 2,
					max_length = 100,
					extended_corpus = true,
					prompt_text = "Enter Text",
					ref_table = G,
					ref_value = "CARD_SEARCH",
					keyboard_offset = 1,
				}),
			},
		},
		{
			n = G.UIT.R,
			config = { align = "cm" },
			nodes = {{n = G.UIT.T, config = {text = ""}}},
		},
		{
			n = G.UIT.R,
			config = { align = "cm" },
			nodes = {
				{n = G.UIT.T, config = {text = "Press O to close", colour = G.C.UI.TEXT_LIGHT, scale = 0.25}}
			},
		},
		{
			n = G.UIT.R,
			config = { align = "cm" },
			nodes = {{n = G.UIT.T, config = {text = ""}}},
		}
	}}
	}}
end

-- keybind to summon the card choice menu
SMODS.Keybind{
    key_pressed='o',
    action = function(self)
		if G.CARD_SEARCH_UI then
			G.CARD_SEARCH_UI:remove()
			G.CARD_SEARCH_UI = nil
		else
			G.CARD_SEARCH_UI = UIBox({
				definition = createUI_autoreroll(),
				config = {type = "cm"}
			})
		end
    end
}
