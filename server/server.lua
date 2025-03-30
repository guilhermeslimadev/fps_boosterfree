-- Importar módulos
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

-- Variáveis do túnel
local vRPclient = Tunnel.getInterface("vRP")
local vFunc = {}
Tunnel.bindInterface("fpsbooster_lima", vFunc)

-- Variáveis locais
local Config = {}

-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES PRINCIPAIS
-----------------------------------------------------------------------------------------------------------------------------------------

-- Função para verificar permissões
local function hasPermission(source)
    if not Config.UsePermissions then return true end
    
    -- Verificar grupos permitidos
    for _, group in ipairs(Config.AllowedGroups) do
        if IsPlayerAceAllowed(source, 'group.' .. group) then
            return true
        end
    end

    -- Notificar jogador sem permissão
    TriggerClientEvent("Notify", source, "negado", "Você não tem permissão para usar este comando!", 5000)
    return false
end

-- Carregar configurações
CreateThread(function()
    Config = exports['fpsbooster_lima']:GetConfig()
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- COMANDOS
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterCommand(Config.Command, function(source, args, rawCommand)
    if source == 0 then
        if Config.Debug then
            print('[FPS Booster] Este comando só pode ser executado por jogadores.')
        end
        return
    end

    if not hasPermission(source) then return end

    -- Trigger o evento no cliente
    TriggerClientEvent('fpsbooster:toggle', source)
    
    -- Feedback para o jogador
    TriggerClientEvent("Notify", source, "sucesso", "Painel FPS aberto com sucesso!", 5000)
end, false)

-----------------------------------------------------------------------------------------------------------------------------------------
-- EVENTOS
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterServerEvent('fpsbooster:syncConfig')
AddEventHandler('fpsbooster:syncConfig', function(config)
    local source = source
    if not hasPermission(source) then return end
    

    
    if Config.Debug then
        print(string.format('[FPS Booster] Configurações sincronizadas para o jogador %s', GetPlayerName(source)))
    end
end) 