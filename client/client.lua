-- Importar módulos
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

-- Variáveis do túnel
local vFunc = {}
Tunnel.bindInterface("fpsbooster_lima", vFunc)
local vServer = Tunnel.getInterface("fpsbooster_lima")

-- Variáveis locais
local Config = {}
local isUIOpen = false
local playerConfig = {}

-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES PRINCIPAIS
-----------------------------------------------------------------------------------------------------------------------------------------

-- Função de debug
local function debugPrint(msg)
    if Config.Debug then
        print('[FPS Booster] ' .. msg)
    end
end

-- Carregar configurações
CreateThread(function()
    while not Config do
        Config = exports['fpsbooster_lima']:GetConfig()
        Wait(100)
    end

    -- Configurações do jogador (usando valores padrão do config)
    playerConfig = {
        shadows = Config.DefaultValues.shadows,
        textures = Config.DefaultValues.textures,
        effects = Config.DefaultValues.effects,
        lighting = Config.DefaultValues.lighting,
        distance = Config.DefaultValues.distance
    }
end)

-- Funções de otimização
local function applyShadowsOptimization(value)
    local level = value / 100
    SetTimecycleModifier('cinema')
    SetTimecycleModifierStrength(level)
    CascadeShadowsSetCascadeBoundsScale(1.0 - level)
    debugPrint('Otimização de sombras aplicada: ' .. value .. '%')
end

local function applyTexturesOptimization(value)
    local level = value / 100
    SetStreamedTextureDictAsNoLongerNeeded('all')
    SetPedPopulationBudget(1.0 - level)
    SetVehiclePopulationBudget(1.0 - level)
    debugPrint('Otimização de texturas aplicada: ' .. value .. '%')
end

local function applyEffectsOptimization(value)
    local level = value / 100
    SetParticleFxLoopedScale('all', 1.0 - level)
    SetArtificialLightsState(level > 0.5)
    debugPrint('Otimização de efeitos aplicada: ' .. value .. '%')
end

local function applyLightingOptimization(value)
    local level = value / 100
    SetArtificialVehicleLightsState(level > 0.5)
    SetDisableDecalRenderingThisFrame(level > 0.3)
    debugPrint('Otimização de iluminação aplicada: ' .. value .. '%')
end

local function applyDistanceOptimization(value)
    local level = value / 100
    OverrideLodscaleThisFrame(1.0 - level)
    SetVehicleLodMultiplier(1.0 - level)
    debugPrint('Otimização de distância aplicada: ' .. value .. '%')
end

-- Função para fechar a UI
function closeUI()
    isUIOpen = false
    SetNuiFocus(false, false)
    debugPrint('Interface fechada')
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- COMANDOS
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterCommand(Config.Command, function()
    if isUIOpen then
        closeUI()
    else
        isUIOpen = true
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = "setConfig",
            data = playerConfig
        })
        debugPrint('Interface aberta')
    end
end, false)

-----------------------------------------------------------------------------------------------------------------------------------------
-- EVENTOS
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterNetEvent('fpsbooster:toggle')
AddEventHandler('fpsbooster:toggle', function()
    if isUIOpen then
        closeUI()
    else
        isUIOpen = true
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = "setConfig",
            data = playerConfig
        })
        TriggerEvent("Notify", "sucesso", "Interface aberta via evento do servidor", 2000)
        debugPrint('Interface aberta via evento do servidor')
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CALLBACKS
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterNUICallback('closeUI', function(data, cb)
    closeUI()
    cb('ok')
end)

RegisterNUICallback('updateConfig', function(data, cb)
    playerConfig = data
    
    -- Aplicar otimizações
    applyShadowsOptimization(data.shadows)
    applyTexturesOptimization(data.textures)
    applyEffectsOptimization(data.effects)
    applyLightingOptimization(data.lighting)
    applyDistanceOptimization(data.distance)
    
    -- Salvar configurações no servidor
    TriggerServerEvent('fpsbooster:syncConfig', data)
    TriggerEvent("Notify", "sucesso", "Configurações atualizadas com sucesso", 2000)
    debugPrint('Configurações atualizadas e sincronizadas')
    
    cb('ok')
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADS
-----------------------------------------------------------------------------------------------------------------------------------------

-- Thread para aplicar otimizações continuamente
CreateThread(function()
    while true do
        if not isUIOpen then
            applyShadowsOptimization(playerConfig.shadows)
            applyTexturesOptimization(playerConfig.textures)
            applyEffectsOptimization(playerConfig.effects)
            applyLightingOptimization(playerConfig.lighting)
            applyDistanceOptimization(playerConfig.distance)
        end
        Wait(Config.SaveInterval)
    end
end) 