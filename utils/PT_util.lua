PT_UTIL = {}

-- CARICO FIGLI

pt_manageCards = require(SMODS.current_mod.path.."/utils/PT_manageCards")

-- VARIABILI GLOBALI

G.Util_Vars = {
    Util_UsedTarot = {},
    Util_MostUsedTarot_key = nil,
    Util_MostUsedTarot_N = 0,
    Util_UsefulTarots = {}
}

-- RESET VARIABILI GLOBALI

function PT_UTIL.resetGlobalVars()
    G.GAME.Util_UsedTarot = {}
    G.GAME.Util_MostUsedTarot_key = nil
    G.GAME.Util_MostUsedTarot_N = 0
    G.GAME.Util_UsefulTarots = {}
    pt_RobinHood.resetGlobalVars()
end

-- FUNZIONI DI SUPPORTO

function PT_UTIL.evolve(start,dest)
    sendTraceMessage("Evolving to " .. dest,start.config.center_key)
    -- Save START's edition
    local Edition, Negative
    if start.edition then
        Edition = start.edition
        Negative = start.edition.negative
    end

    -- Destroy START
    pt_manageCards.destroyJoker(start)
    -- Create DEST with Edition and Negative
    pt_manageCards.createJoker(dest,Edition,Negative)
    sendTraceMessage("Successfully evolved to " .. dest,start.config.center_key)
end

function PT_UTIL.rankUp(card) 
    card.ability.extra.Rank = card.ability.extra.Rank + 1
    sendTraceMessage("New rank is " .. card.ability.extra.Rank,card.config.center_key)
end

function PT_UTIL.tarotUsed(tarot)
    sendTraceMessage("Adding "..tarot.config.center_key.." to the table","PTutil")
    G.GAME.Util_UsedTarot[tarot.config.center_key] = (G.GAME.Util_UsedTarot[tarot.config.center_key] or 0) + 1
    sendTraceMessage(tarot.config.center_key.." has been used "..G.GAME.Util_UsedTarot[tarot.config.center_key].." times","PTutil")
    if G.GAME.Util_UsedTarot[tarot.config.center_key] > G.GAME.Util_MostUsedTarot_N then
        G.GAME.Util_MostUsedTarot_key = tarot.config.center_key
        G.GAME.Util_MostUsedTarot_N = G.GAME.Util_UsedTarot[tarot.config.center_key]
    end
    sendTraceMessage("The most used Tarot is now "..G.GAME.Util_MostUsedTarot_key.." with "..G.GAME.Util_MostUsedTarot_N.." uses","PTutil")
end

-- MODIFICA LA FUNZIONE use_card CHE SI ATTIVA QUANDO UN CONSUMABILE VIENE USATO

local G_FUNCS_use_card_ref = G.FUNCS.use_card
G.FUNCS.use_card = function(e,mute,nosave)
    G_FUNCS_use_card_ref(e,mute,nosave)
    local card = e.config.ref_table
    if card.ability.consumeable then
        if (card.ability.set == 'Tarot') then
            sendTraceMessage("Calling tarotUsed function","PT_UTIL:use_card")
            pt_util.tarotUsed(card)
        end
    end
end

return PT_UTIL