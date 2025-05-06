
-- ZYXNS HUB - | For Private Servers Only
-- Author: Teste1012

-- CONFIGURAÇÕES INICIAIS
local team = getgenv().Team or "Pirates"
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Seleção de time automática
if LocalPlayer.Team == nil or LocalPlayer.Team.Name ~= team then
    for _, v in pairs(game:GetService("ReplicatedStorage").Remotes["CommF_"]:InvokeServer("SetTeam", team)) do end
end

-- Função para usar Haki automaticamente
local function EnableHaki()
    pcall(function()
        if not LocalPlayer.Character:FindFirstChild("HasBuso") then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
        end
    end)
end

-- UI Library carregamento (W-Azure base)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("ZYXNS HUB - Blox Fruits", "DarkTheme")

-- Abas da interface
local FarmTab = Window:NewTab("Auto Farm")
local TeleportTab = Window:NewTab("Teleports")
local FruitTab = Window:NewTab("Fruits")
local SettingsTab = Window:NewTab("Settings")

-- Seções
local FarmSection = FarmTab:NewSection("Farm")
local TeleportSection = TeleportTab:NewSection("Ilhas")
local FruitSection = FruitTab:NewSection("Coleta")
local SettingsSection = SettingsTab:NewSection("Configurações")

-- Auto Farm Toggle
FarmSection:NewToggle("Auto Farm", "Farm automático de inimigos", function(state)
    getgenv().AutoFarm = state
    while getgenv().AutoFarm do
        EnableHaki()
        -- Procura e ataca inimigos
        local enemy = game:GetService("Workspace").Enemies:FindFirstChildOfClass("Model")
        if enemy and enemy:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
            pcall(function() LocalPlayer.Character:FindFirstChildOfClass("Tool"):Activate() end)
        end
        task.wait(0.1)
    end
end)

-- Auto Haki Toggle
FarmSection:NewToggle("Auto Haki", "Ativa Haki automaticamente", function(state)
    getgenv().AutoHaki = state
    while getgenv().AutoHaki do
        EnableHaki()
        task.wait(2)
    end
end)

-- Teleporte exemplo
TeleportSection:NewButton("Ir para Starter Island", "Teleporta para a ilha inicial", function()
    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2067, 38, 2839)
end)

-- Auto Collect Fruit
FruitSection:NewToggle("Auto Coletar Fruta", "Teleporta até as frutas spawnadas", function(state)
    getgenv().AutoFruit = state
    while getgenv().AutoFruit do
        for _, v in pairs(game:GetService("Workspace"):GetChildren()) do
            if v:IsA("Tool") and string.find(v.Name:lower(), "fruit") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = v.Handle.CFrame
            end
        end
        task.wait(5)
    end
end)

-- Settings
SettingsSection:NewKeybind("Fechar GUI", "Esconde ou mostra a interface", Enum.KeyCode.RightControl, function()
    Library:ToggleUI()
end)
