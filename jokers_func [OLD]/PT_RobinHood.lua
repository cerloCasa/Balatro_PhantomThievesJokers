PT_ROBINHOOD = {}

G.J08_RobinHood_Vars = {
    J08_canBetrayalSpawn = false,
    J08_RoundsCounter = 0,
}
 
-- RESET VARIABILI GLOBALI

function PT_ROBINHOOD.resetGlobalVars()
    G.GAME.J08_canBetrayalSpawn = false
    sendTraceMessage("J08_canBetrayalSpawn is " .. tostring(G.GAME.J08_canBetrayalSpawn),"RobinHood")
    G.GAME.J08_RoundsCounter = 0
    sendTraceMessage("J08_RoundsCounter is " .. G.GAME.J08_RoundsCounter,"RobinHood")
end

-- CALCULATE JOKER

function PT_ROBINHOOD.RoundStart(card,rank)
    if rank < 10 then
	    G.GAME.J08_RoundsCounter = G.GAME.J08_RoundsCounter + 1
    end
    if rank < 9 then
        G.GAME.J08_RoundsCounter = G.GAME.J08_RoundsCounter + 1
    end
end

function PT_ROBINHOOD.RoundWon(card,rank)
    if G.GAME.J08_RoundsCounter >= 5 then
        J08_canBetrayalSpawn = true
    end
    if rank < 9 then
	    pt_RobinHood.createMostUsedTarot()
    else
        pt_RobinHood.createNegativeMostUsedTarot()
    end
end

-- FUNZIONI DI SUPPORTO

function PT_ROBINHOOD.createMostUsedTarot()
    -- Create most used tarot
	sendTraceMessage("Creating most useful tarot...","RobinHood")
    if G.GAME.Util_MostUsedTarot_key then
        sendTraceMessage("Creating "..G.GAME.Util_MostUsedTarot_key.."...","RobinHood")
        pt_manageCards.createConsumable(G.GAME.Util_MostUsedTarot_key,'Tarot',nil,nil)
    else
        sendTraceMessage("No tarots used in this run :(","RobinHood")
    end
end

function PT_ROBINHOOD.createNegativeMostUsedTarot()
    -- Create negative most used tarot
	sendTraceMessage("Creating negative most useful tarot...","RobinHood")
    if G.GAME.Util_MostUsedTarot_key then
        sendTraceMessage("Creating "..G.GAME.Util_MostUsedTarot_key.."...","RobinHood")
        pt_manageCards.createConsumable(G.GAME.Util_MostUsedTarot_key,'Tarot',{negative = true},true)
    else
        sendTraceMessage("No tarots used in this run :(","RobinHood")
    end
end

return PT_ROBINHOOD