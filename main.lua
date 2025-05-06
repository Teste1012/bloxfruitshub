-- Blox Fruits - PvP/PvE Hub Script
local plr = game.Players.LocalPlayer

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 250, 0, 310)
Frame.Position = UDim2.new(0, 10, 0, 10)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local function createButton(text, posY)
	local btn = Instance.new("TextButton", Frame)
	btn.Size = UDim2.new(1, 0, 0, 40)
	btn.Position = UDim2.new(0, 0, 0, posY)
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	return btn
end

local notify = Instance.new("TextLabel", ScreenGui)
notify.Size = UDim2.new(0, 250, 0, 30)
notify.Position = UDim2.new(0, 10, 0, 330)
notify.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
notify.TextColor3 = Color3.fromRGB(0, 255, 0)
notify.Text = "Status: Aguardando..."

-- Speed
createButton("Speed 200", 0).MouseButton1Click:Connect(function()
	plr.Character.Humanoid.WalkSpeed = 200
end)

-- JumpPower
createButton("JumpPower 150", 50).MouseButton1Click:Connect(function()
	plr.Character.Humanoid.JumpPower = 150
end)

-- TP Jungle
createButton("TP Jungle", 100).MouseButton1Click:Connect(function()
	local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
	if hrp then hrp.CFrame = CFrame.new(2899, 7, -2269) end
end)

-- TP Fruta
createButton("TP Fruta Spawnada", 150).MouseButton1Click:Connect(function()
	local fruitFolder = workspace:FindFirstChild("Fruit") or workspace
	for _, fruit in pairs(fruitFolder:GetChildren()) do
		if fruit:IsA("Tool") or fruit:IsA("Model") then
			local pos = fruit:FindFirstChild("Handle") or fruit:FindFirstChildWhichIsA("BasePart")
			if pos then
				plr.Character:WaitForChild("HumanoidRootPart").CFrame = pos.CFrame + Vector3.new(0, 5, 0)
				notify.Text = "Status: Teleportado para fruta!"
				wait(2)
				notify.Text = "Status: Aguardando..."
				break
			end
		end
	end
end)

-- Auto Farm/Quest/Aura Toggle
local isAuto = false
createButton("Toggle Auto Farm/Quest", 200).MouseButton1Click:Connect(function()
	isAuto = not isAuto
	notify.Text = isAuto and "Status: Auto Farm Ativado" or "Status: Auto Farm Desativado"
end)

-- Auto Farm Loop
task.spawn(function()
	while true do
		if isAuto then
			local char = plr.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")

			-- Auto Aura
			pcall(function()
				game:GetService("ReplicatedStorage").Remotes.Comm:InvokeServer("Buso")
			end)

			-- Auto Quest (NPC de exemplo: BanditQuest1, lvl 1)
			pcall(function()
				game:GetService("ReplicatedStorage").Remotes.Comm:InvokeServer("StartQuest", "BanditQuest1", 1)
			end)

			-- Procurar inimigos
			local enemies = workspace.Enemies:GetChildren()
			for _, enemy in pairs(enemies) do
				if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
					hrp.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 0, 3)

					-- Ataque rápido
					for i = 1, 10 do
						game:GetService("VirtualInputManager"):SendMouseButton1Down()
						game:GetService("VirtualInputManager"):SendMouseButton1Up()
						wait(0.05)
					end
				end
			end
		end
		wait(1)
	end
end)
