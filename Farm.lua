local environment = getgenv and getgenv() or _G
local previous = environment.PrivateFastFarm
if previous and type(previous.Destroy) == "function" then previous:Destroy() end
local controller = {Alive = true, Tasks = {}, Connections = {}}
environment.PrivateFastFarm = controller
local tabs, windowFrame
function controller:Destroy()
    if not self.Alive then return end
    self.Alive = false
    if tabs then
        for _, mode in pairs(tabs) do
            mode.running = false
            mode.generation = (mode.generation or 0) + 1
        end
    end
    for _, connection in ipairs(self.Connections) do connection:Disconnect() end
    local current = coroutine.running()
    for thread in pairs(self.Tasks) do
        if thread ~= current then pcall(task.cancel, thread) end
    end
    self.Tasks = {}
    if windowFrame and windowFrame.Parent then windowFrame:Destroy() end
    if environment.PrivateFastFarm == self then environment.PrivateFastFarm = nil end
end
local ok, message = pcall(function()
local services = {
    players = game:GetService("Players"),
    replicatedstorage = game:GetService("ReplicatedStorage"),
    runservice = game:GetService("RunService"),
}
local lp = {player = services.players.LocalPlayer}
local runtime = {}
function runtime:Spawn(callback, ...)
    if not controller.Alive then return end
    local args = table.pack(...)
    local thread = coroutine.create(function()
        local success, err = pcall(callback, table.unpack(args, 1, args.n))
        controller.Tasks[coroutine.running()] = nil
        if not success and controller.Alive then warn("[Fast Farm] " .. tostring(err)) end
    end)
    controller.Tasks[thread] = true
    task.spawn(thread)
    return thread
end
function runtime:Connect(signal, callback)
    local connection = signal:Connect(function(...)
        if controller.Alive then callback(...) end
    end)
    table.insert(controller.Connections, connection)
    return connection
end
local function required(parent, name)
    local child = parent:WaitForChild(name, 15)
    assert(child, "Fast Farm: missing " .. name)
    return child
end
services.muscleEvent = required(lp.player, "muscleEvent")
required(lp.player, "petsFolder")
local remotes = required(services.replicatedstorage, "rEvents")
local equipPetRemote = required(remotes, "equipPetEvent")
local rebirthRemote = required(remotes, "rebirthRemote")
local source = game:HttpGet("https://raw.githubusercontent.com/Espectroxs/scripts/refs/heads/main/Library%201.0?v=" .. tostring(os.time()), true)
local compiled, compileError = loadstring(source)
assert(compiled, "UI compilation failed: " .. tostring(compileError))
local library = compiled()
assert(type(library) == "table", "Invalid UI library return")
local window
window, windowFrame = library:AddWindow("Private Script | Fast Farm", {
    main_color = Color3.fromRGB(99, 71, 224),
    min_size = Vector2.new(600, 650),
    can_resize = true,
})
assert(windowFrame, "Library 1.0 window instance is missing")
runtime:Connect(windowFrame.Destroying, function() controller:Destroy() end)
local page = window:AddTab("Fast Farm")

local function section()
    return setmetatable({}, {__index = function(_, key)
        if type(page[key]) == "function" then
            return function(_, ...) return page[key](page, ...) end
        end
    end})
end
tabs = {rebirths = section(), strength = section()}
local petStatus = page:AddLabel("Pets: Ready; bonus pets are optional for rebirths.")
page:AddLabel("Rebirths")
local function formatNumber(num)
    if num >= 1e18 then return string.format("%.2fQi", num/1e18) end
    if num >= 1e15 then return string.format("%.2fQa", num/1e15) end
    if num >= 1e12 then return string.format("%.2fT", num/1e12) end
    if num >= 1e9 then return string.format("%.2fB", num/1e9) end
    if num >= 1e6 then return string.format("%.2fM", num/1e6) end
    if num >= 1e3 then return string.format("%.2fK", num/1e3) end
    return string.format("%.0f", num)
end



local function formatCurrentStat(value)
    return formatNumber(value)
end

local function formatRate(ratePerSecond)
    return formatNumber(ratePerSecond) .. "/s | "
        .. formatNumber(ratePerSecond * 60) .. "/min | "
        .. formatNumber(ratePerSecond * 3600) .. "/h | "
        .. formatNumber(ratePerSecond * 86400) .. "/d"
end

local PETS = {
    ["Omega Overlord"] = {
        repSpeed = 20,
        strength = 0,
        durability = 0,
        rebirth = 0,
    },

    ["Swift Samurai"] = {
        repSpeed = 15,
        strength = 0,
        durability = 0,
        rebirth = 0,
    },

    ["Powercore Hound"] = {
        repSpeed = 0,
        strength = 25,
        durability = 15,
        rebirth = 0,
    },

    ["Titanium Hydra"] = {
        repSpeed = 0,
        strength = 0,
        durability = 0,
        rebirth = 2,
    },

    ["Tribal Overlord"] = {
        repSpeed = 0,
        strength = 0,
        durability = 0,
        rebirth = 2,
    },
	["Inferno Unicorn"] = {
		repSpeed = 0,
		strength = 25,
		durability = 25,
		rebirth = 0,
	},
	["Common Boss Pet"] = {
		repSpeed = 5,
		strength = 0,
		durability = 0,
		rebirth = 0,
	},
	["Rare Boss Pet"] = {
		repSpeed = 7,
		strength = 0,
		durability = 0,
		rebirth = 0,
	},
	["Epic Boss Pet"] = {
		repSpeed = 10,
		strength = 0,
		durability = 0,
		rebirth = 0,
	},
	["Rainbow Boss Pet"] = {
		repSpeed = 10,
		strength = 7,
		durability = 0,
		rebirth = 0,
	},
	["Legendary Boss Pet"] = {
		repSpeed = 10,
		strength = 10,
		durability = 0,
		rebirth = 0,
	},
	["Mythic Boss Pet"] = {
		repSpeed = 10,
		strength = 20,
		durability = 0,
		rebirth = 0,
	},
    ["Inferno Drake"] = {
        repSpeed = 40,
        strength = 0,
        durability = 0,
        rebirth = 0,
    },
}

local MAX_PET_SLOTS = 12
local TARGET_REP_SPEED = 100

local function applyPetLoadout(selected, isCurrent)
    if #selected == 0 then
        petStatus.Text = "Pets: No configured bonus pets; keeping the current loadout."
        return true
    end
    local remote = equipPetRemote
    for _, folder in ipairs(lp.player.petsFolder:GetChildren()) do
        if folder:IsA("Folder") then
            for _, pet in ipairs(folder:GetChildren()) do
                if isCurrent and not isCurrent() then return false end
                remote:FireServer("unequipPet", pet)
            end
        end
    end
    task.wait(0.1)
    for _, pet in ipairs(selected) do
        if isCurrent and not isCurrent() then return false end
        remote:FireServer("equipPet", pet)
    end
    task.wait(0.1)
    petStatus.Text = "Pets: Requested " .. tostring(#selected) .. "; equipment is controlled by the server."
    return not isCurrent or isCurrent()
end

local function trainingReady()
    local character = lp.player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false, "Waiting for Respawn" end
    if humanoid.SeatPart then return true end
    local leaderstats = lp.player:FindFirstChild("leaderstats")
    local strength = leaderstats and leaderstats:FindFirstChild("Strength")
    if not strength then return false, "Waiting for Strength" end
    local backpack = lp.player:FindFirstChild("Backpack")
    local function find(name)
        return character:FindFirstChild(name) or backpack and backpack:FindFirstChild(name)
    end
    local preferred = strength.Value >= 2000 and "Pushups" or "Weight"
    local tool = find(preferred)
    if not tool then
        for _, name in ipairs({"Weight", "Pushups", "Situps", "Handstands"}) do
            local candidate = find(name)
            local required = candidate and candidate:FindFirstChild("requiredAmount")
            if candidate and (not required or tonumber(required.Value) and required.Value <= strength.Value) then tool = candidate break end
        end
    end
    if not tool or not tool:IsA("Tool") then return false, "Waiting for a training tool or machine" end
    local required = tool:FindFirstChild("requiredAmount")
    if required and tonumber(required.Value) and required.Value > strength.Value then
        return false, "Training tool requires more Strength"
    end
    if tool.Parent ~= character then humanoid:EquipTool(tool) end
    if tool.Parent ~= character then return false, "Equipping " .. tool.Name end
    return true
end

local function sendTrainingReps(state, rate, maxBurst, canSend)
    local now = os.clock()
    local ready, reason = trainingReady()
    if not ready then
        state.Tokens = 0
        state.LastAt = now
        if state.Status then state.Status.Text = "Status: " .. tostring(reason) end
        return 0
    end
    local elapsed = math.clamp(now - (state.LastAt or now), 0, 0.1)
    state.LastAt = now
    state.Tokens = math.min(maxBurst, (state.Tokens or 0) + rate * elapsed)
    local sent = 0
    while state.Tokens >= 1 and canSend() do
        services.muscleEvent:FireServer("rep")
        state.Tokens = state.Tokens - 1
        sent = sent + 1
    end
    return sent
end

local function getElapsed(tab)
    return tab.totalElapsed + (tab.timerStarted and os.clock() - tab.startedAt or 0)
end

local function setTimerRunning(tab, enabled)
    tab.totalElapsed = getElapsed(tab)
    tab.startedAt = os.clock()
    tab.timerStarted = enabled
end

local function recordStatGain(tab, key, value)
    local previous = tab.statSamples[key]
    tab.statSamples[key] = value
    if tab.running and tab.timerStarted and previous then
        tab.statGains[key] = tab.statGains[key] + math.max(0, value - previous)
    end
end

local function updateRuntimeLabel(tab)
    local elapsed = getElapsed(tab)
    tab.Runtime.Text = string.format("Runtime: %dd %dh %dm %ds",
        math.floor(elapsed / 86400), math.floor(elapsed % 86400 / 3600),
        math.floor(elapsed % 3600 / 60), math.floor(elapsed % 60))
end

local function normalizedPetName(value)
    local key = tostring(value or ""):lower():gsub("[^%w]", "")
    key = key:gsub("^evolved", ""):gsub("evolved$", "")
    return key
end
local petConfigs = {}
for name, config in pairs(PETS) do petConfigs[normalizedPetName(name)] = config end
local function petNumeric(pet, name)
    local perks = pet:FindFirstChild("perksFolder")
    local object = (perks and perks:FindFirstChild(name)) or pet:FindFirstChild(name)
    return tonumber(object and object.Value) or tonumber(pet:GetAttribute(name)) or 0
end
local function getOwnedConfiguredPets()
    local ownedPets = {}
    local inventory = lp.player:FindFirstChild("petsFolder")
    if not inventory then return ownedPets end
    for _, folder in ipairs(inventory:GetChildren()) do
        if folder:IsA("Folder") then
            for _, pet in ipairs(folder:GetChildren()) do
                local config = petConfigs[normalizedPetName(pet.Name)]
                if not config then
                    config = petConfigs[normalizedPetName(pet:GetAttribute("PetName") or pet:GetAttribute("DisplayName"))]
                end
                if not config and pet:IsA("StringValue") then config = petConfigs[normalizedPetName(pet.Value)] end
                if config then
                    ownedPets[#ownedPets + 1] = {
                        instance = pet, name = pet.Name,
                        repSpeed = config.repSpeed or 0, strength = config.strength or 0,
                        durability = config.durability or 0, rebirth = config.rebirth or 0,
                        actualStrength = petNumeric(pet, "strength"), level = petNumeric(pet, "level"),
                    }
                end
            end
        end
    end
    return ownedPets
end

local function equipBestFarmingPets(isCurrent)
    if isCurrent and not isCurrent() then return end

    local pets = getOwnedConfiguredPets()
    local selected = {}
    local equipped = {}
    local equippedCount = 0
    local currentRepSpeed = 0

    table.sort(pets, function(a, b)
        if a.repSpeed ~= b.repSpeed then return a.repSpeed > b.repSpeed end
        if a.strength ~= b.strength then return a.strength > b.strength end
        if a.actualStrength ~= b.actualStrength then return a.actualStrength > b.actualStrength end
        return a.level > b.level
    end)

    for _, pet in ipairs(pets) do
        if equippedCount >= MAX_PET_SLOTS or currentRepSpeed >= TARGET_REP_SPEED then
            break
        end

        if pet.repSpeed > 0 then
            table.insert(selected, pet.instance)
            equipped[pet.instance] = true
            equippedCount = equippedCount + 1
            currentRepSpeed = currentRepSpeed + pet.repSpeed
        end
    end

    local remainingPets = {}

    for _, pet in ipairs(pets) do
        if not equipped[pet.instance] then
            table.insert(remainingPets, pet)
        end
    end

    table.sort(remainingPets, function(a, b)
        local scoreA = a.strength + a.durability
        local scoreB = b.strength + b.durability
        if scoreA ~= scoreB then return scoreA > scoreB end
        if a.actualStrength ~= b.actualStrength then return a.actualStrength > b.actualStrength end
        return a.level > b.level
    end)

    for _, pet in ipairs(remainingPets) do
        if equippedCount >= MAX_PET_SLOTS then
            break
        end

        if pet.strength > 0 or pet.durability > 0 then
            table.insert(selected, pet.instance)
            equipped[pet.instance] = true
            equippedCount = equippedCount + 1
        end
    end

    applyPetLoadout(selected, isCurrent)
    return currentRepSpeed, equippedCount
end

local function equipBestRebirthPets(isCurrent)
    if isCurrent and not isCurrent() then return end

    local pets = getOwnedConfiguredPets()
    local selected = {}

    table.sort(pets, function(a, b)
        return a.rebirth > b.rebirth
    end)

    local equippedCount = 0
    local totalRebirthMultiplier = 0

    for _, pet in ipairs(pets) do
        if equippedCount >= MAX_PET_SLOTS then
            break
        end

        if pet.rebirth > 0 then
            table.insert(selected, pet.instance)
            equippedCount = equippedCount + 1
            totalRebirthMultiplier = totalRebirthMultiplier + pet.rebirth
        end
    end

    if #selected == 0 then
        petStatus.Text = "Pets: No rebirth bonus pets; continuing with the farming loadout."
        return 0, 0
    end
    applyPetLoadout(selected, isCurrent)
    return totalRebirthMultiplier, equippedCount
end

tabs.rebirths.leaderstats = lp.player:WaitForChild("leaderstats")
tabs.rebirths.rebirths = tabs.rebirths.leaderstats:WaitForChild("Rebirths")
tabs.rebirths.strength = tabs.rebirths.leaderstats:WaitForChild("Strength")
tabs.rebirths.running = false
tabs.rebirths.workerActive = false
tabs.rebirths.startedAt = 0
tabs.rebirths.timerStarted = false
tabs.rebirths.hasStarted = false
tabs.rebirths.baselineReady = false
tabs.rebirths.measuredCycles = 0
tabs.rebirths.lastConfirmedAt = nil
tabs.rebirths.nextRequestAt = 0
tabs.rebirths.cooldown = 6
tabs.rebirths.totalElapsed = 0
tabs.rebirths.statSamples = {Rebirths = tabs.rebirths.rebirths.Value}
tabs.rebirths.statGains = {Rebirths = 0}
tabs.rebirths.generation = 0
tabs.rebirths.adaptive = {
    TargetSeconds = 3,
    MaxRate = 50,
    SendRate = 50,
    StrengthPerRep = nil,
    LastTrainingSeconds = nil
}
tabs.rebirths.Status = tabs.rebirths:AddLabel("Status: Inactive")
tabs.rebirths.Runtime = tabs.rebirths:AddLabel("Runtime: 0d 0h 0m 0s")
tabs.rebirths.RebirthStats = tabs.rebirths:AddLabel("Rebirths: " .. formatCurrentStat(tabs.rebirths.rebirths.Value) .. " | Gained: 0")
tabs.rebirths.AverageRate = tabs.rebirths:AddLabel("Average: -- / Hour | -- / Day | -- / Week")
tabs.rebirths.Status.TextColor3 = Color3.fromRGB(255, 80, 80)

tabs.rebirths.updateStats = function()
    tabs.rebirths.RebirthStats.Text = "Rebirths: " .. formatCurrentStat(tabs.rebirths.rebirths.Value)
        .. " | Gained: " .. formatNumber(tabs.rebirths.statGains.Rebirths)
end

tabs.rebirths.updateRuntime = function()
    updateRuntimeLabel(tabs.rebirths)
end

tabs.rebirths.updateAverage = function()
    local elapsed = getElapsed(tabs.rebirths)
    if elapsed <= 0 then return end
    local hourly = tabs.rebirths.statGains.Rebirths / elapsed * 3600
    tabs.rebirths.AverageRate.Text = string.format("Average: %s / Hour | %s / Day | %s / Week",
        formatNumber(hourly), formatNumber(hourly * 24), formatNumber(hourly * 168))
end

tabs.rebirths.isCurrent = function(generation)
    return controller.Alive and tabs.rebirths.running and tabs.rebirths.generation == generation
end

tabs.rebirths.equipFarmingPets = function(generation)
    equipBestFarmingPets(function() return tabs.rebirths.isCurrent(generation) end)
end

tabs.rebirths.equipRebirthPets = function(generation)
    equipBestRebirthPets(function() return tabs.rebirths.isCurrent(generation) end)
end

tabs.rebirths.updateAdaptiveSpeed = function(cycle)
    local adaptive = tabs.rebirths.adaptive
    local now = os.clock()
    if now - cycle.SampleAt < 0.25 then return end
    local gain = tabs.rebirths.strength.Value - cycle.StartStrength
    if gain > 0 and cycle.Sent > 0 then

        adaptive.StrengthPerRep = gain / cycle.Sent
        local remaining = math.max(0, cycle.Target - tabs.rebirths.strength.Value)
        local seconds = math.max(0.1, adaptive.TargetSeconds - cycle.TrainingSeconds)
        adaptive.SendRate = math.clamp(remaining / adaptive.StrengthPerRep / seconds, 1, adaptive.MaxRate)
    elseif cycle.TrainingSeconds >= adaptive.TargetSeconds then
        adaptive.SendRate = adaptive.MaxRate
    end
    cycle.SampleAt = now
end

tabs.rebirths.performRebirth = function(generation)
    local adaptive = tabs.rebirths.adaptive
    local cycle = {
        Target = 5000 + tabs.rebirths.rebirths.Value * 2550,
        Rebirths = tabs.rebirths.rebirths.Value,
        SampleAt = os.clock(),
        StartStrength = tabs.rebirths.strength.Value,
        Sent = 0,
        Tokens = 0,
        LastAt = os.clock(),
        StatusAt = -math.huge,
        TrainingSeconds = 0
    }
    adaptive.SendRate = adaptive.StrengthPerRep and math.clamp(
        math.max(0, cycle.Target - cycle.StartStrength) / adaptive.StrengthPerRep / adaptive.TargetSeconds,
        1, adaptive.MaxRate) or adaptive.MaxRate
    local lastTrainingAt = os.clock()
    local function needsTraining()
        return tabs.rebirths.isCurrent(generation)
            and tabs.rebirths.rebirths.Value == cycle.Rebirths
            and tabs.rebirths.strength.Value < cycle.Target
    end
    while needsTraining() do
        local now = os.clock()
        local ready, reason = trainingReady()
        if ready then
            cycle.TrainingSeconds = cycle.TrainingSeconds + math.max(0, now - lastTrainingAt)
            tabs.rebirths.updateAdaptiveSpeed(cycle)
            cycle.Sent = cycle.Sent + sendTrainingReps(cycle, adaptive.SendRate, 5, needsTraining)
            if now - cycle.StatusAt >= 0.25 then
                tabs.rebirths.Status.Text = "Status: Strength Training | " .. string.format("%.1fs", cycle.TrainingSeconds)
                    .. " | " .. formatNumber(adaptive.SendRate) .. " reps/s"
                cycle.StatusAt = now
            end
        else
            cycle.Tokens = 0
            cycle.LastAt = now
            tabs.rebirths.Status.Text = "Status: " .. tostring(reason)
        end
        lastTrainingAt = now
        services.runservice.Heartbeat:Wait()
    end
    if not tabs.rebirths.isCurrent(generation) or tabs.rebirths.rebirths.Value ~= cycle.Rebirths then return end
    adaptive.LastTrainingSeconds = cycle.TrainingSeconds
    tabs.rebirths.Status.Text = "Status: Switching to Rebirth Pets"
    tabs.rebirths.equipRebirthPets(generation)
    task.wait(0.25)
    while tabs.rebirths.isCurrent(generation) and tabs.rebirths.rebirths.Value == cycle.Rebirths do
        local remaining = tabs.rebirths.nextRequestAt - os.clock()
        if remaining > 0 then
            tabs.rebirths.Status.Text = "Status: Rebirth Cooldown | " .. string.format("%.1fs", remaining)
            task.wait(math.min(remaining, 0.1))
        else
            tabs.rebirths.nextRequestAt = os.clock() + tabs.rebirths.cooldown
            rebirthRemote:InvokeServer("rebirthRequest")
            tabs.rebirths.recordRebirth()
        end
    end
end

tabs.rebirths.startWorker = function()
    if tabs.rebirths.workerActive then return end
    tabs.rebirths.workerActive = true
    runtime:Spawn(function(generation, success, workerError)
        success, workerError = pcall(function()
            while tabs.rebirths.isCurrent(generation) do
                tabs.rebirths.equipFarmingPets(generation)
                if not tabs.rebirths.isCurrent(generation) then break end
                tabs.rebirths.performRebirth(generation)
                task.wait()
            end
        end)
        tabs.rebirths.workerActive = false
        if not success then
            tabs.rebirths.Status.Text = "Status: " .. tostring(workerError)
            local now = os.clock()
            if not tabs.rebirths.lastWarningAt or now - tabs.rebirths.lastWarningAt >= 10 then
                tabs.rebirths.lastWarningAt = now
                warn("[Fast Farm Rebirths] " .. tostring(workerError))
            end
            task.wait(1)
        end
        if tabs.rebirths.running then tabs.rebirths.startWorker() end
    end, tabs.rebirths.generation)
end

tabs.rebirths.recordRebirth = function()
    local current = tabs.rebirths.rebirths.Value
    local previous = tabs.rebirths.statSamples.Rebirths
    if current > previous then
        tabs.rebirths.lastConfirmedAt = os.clock()
        tabs.rebirths.nextRequestAt = tabs.rebirths.lastConfirmedAt + tabs.rebirths.cooldown
        if tabs.rebirths.running then
            recordStatGain(tabs.rebirths, "Rebirths", current)
            tabs.rebirths.measuredCycles = tabs.rebirths.measuredCycles + 1
            tabs.rebirths.updateAverage()
        end
    end
    tabs.rebirths.statSamples.Rebirths = current
    tabs.rebirths.updateStats()
end

runtime:Connect(tabs.rebirths.rebirths:GetPropertyChangedSignal("Value"), tabs.rebirths.recordRebirth)

tabs.rebirths.Switch = tabs.rebirths:AddSwitch("Fast Rebirths", function(state)
    tabs.rebirths.recordRebirth()
    setTimerRunning(tabs.rebirths, state)
    tabs.rebirths.baselineReady = state or tabs.rebirths.baselineReady
    tabs.rebirths.statSamples.Rebirths = tabs.rebirths.rebirths.Value
    tabs.rebirths.generation = tabs.rebirths.generation + 1
    tabs.rebirths.running = state
    if state then
        if tabs.strength.running then tabs.strength.FastRepToggle:Set(false) end
        tabs.rebirths.hasStarted = true
        tabs.rebirths.Status.Text = "Status: Rebirthing"
        tabs.rebirths.Status.TextColor3 = Color3.fromRGB(80, 255, 120)
        tabs.rebirths.updateStats()
        tabs.rebirths.startWorker()
    else
        tabs.rebirths.Status.Text = tabs.rebirths.hasStarted and "Status: Paused" or "Status: Inactive"
        tabs.rebirths.Status.TextColor3 = tabs.rebirths.hasStarted and Color3.fromRGB(255, 180, 70) or Color3.fromRGB(255, 80, 80)
    end
    tabs.rebirths.updateRuntime()
end)
tabs.rebirths.Switch:Set(false)

page:AddLabel("Strength / Durability")
tabs.strength.leaderstats = lp.player:WaitForChild("leaderstats")
tabs.strength.strength = tabs.strength.leaderstats:WaitForChild("Strength")
tabs.strength.durability = lp.player:WaitForChild("Durability")
tabs.strength.running = false
tabs.strength.workerActive = false
tabs.strength.startedAt = 0
tabs.strength.totalElapsed = 0
tabs.strength.timerStarted = false
tabs.strength.gainedBaselineSet = false
tabs.strength.statSamples = {Strength = tabs.strength.strength.Value, Durability = tabs.strength.durability.Value}
tabs.strength.statGains = {Strength = 0, Durability = 0}
tabs.strength.initialSendRate = 200
tabs.strength.maxSendRate = 640
tabs.strength.sendRate = math.min(tabs.strength.initialSendRate, tabs.strength.maxSendRate)
tabs.strength.maxBurst = 24
tabs.strength.Tokens = 0
tabs.strength.controlInterval = 0.5
tabs.strength.lastControlAt = tick()
tabs.strength.lastControlStrength = tabs.strength.strength.Value
tabs.strength.lastControlDurability = tabs.strength.durability.Value
tabs.strength.stalledIntervals = 0
tabs.strength.LastAt = os.clock()
tabs.strength.Status = tabs.strength:AddLabel("Status: Inactive")
tabs.strength.Runtime = tabs.strength:AddLabel("Runtime: 0d 0h 0m 0s")
tabs.strength.StrengthStats = tabs.strength:AddLabel("Strength: " .. formatCurrentStat(tabs.strength.strength.Value) .. " | Gained: 0")
tabs.strength.DurabilityStats = tabs.strength:AddLabel("Durability: " .. formatCurrentStat(tabs.strength.durability.Value) .. " | Gained: 0")
tabs.strength.StrengthAverage = tabs.strength:AddLabel("Strength rate: --/s | --/min | --/h | --/d")
tabs.strength.DurabilityAverage = tabs.strength:AddLabel("Durability rate: --/s | --/min | --/h | --/d")
tabs.strength.Status.TextColor3 = Color3.fromRGB(255, 80, 80)

tabs.strength.updateRuntime = function()
    updateRuntimeLabel(tabs.strength)
end

tabs.strength.updateStats = function()
    tabs.strength.StrengthStats.Text = "Strength: " .. formatCurrentStat(tabs.strength.strength.Value)
        .. " | Gained: " .. (tabs.strength.running and not tabs.strength.timerStarted
            and "Preparing" or formatNumber(tabs.strength.statGains.Strength))
    tabs.strength.DurabilityStats.Text = "Durability: " .. formatCurrentStat(tabs.strength.durability.Value)
        .. " | Gained: " .. (tabs.strength.running and not tabs.strength.timerStarted
            and "Preparing" or formatNumber(tabs.strength.statGains.Durability))
end

tabs.strength.updateAverage = function()
    local elapsed = getElapsed(tabs.strength)
    if elapsed <= 0 then return end
    tabs.strength.StrengthAverage.Text = "Strength rate: " .. formatRate(tabs.strength.statGains.Strength / elapsed)
    tabs.strength.DurabilityAverage.Text = "Durability rate: " .. formatRate(tabs.strength.statGains.Durability / elapsed)
end

tabs.strength.startMeasurement = function()
    if not tabs.strength.running or tabs.strength.timerStarted then return end
    tabs.strength.statSamples.Strength = tabs.strength.strength.Value
    tabs.strength.statSamples.Durability = tabs.strength.durability.Value
    setTimerRunning(tabs.strength, true)
    tabs.strength.nextAverageElapsed = getElapsed(tabs.strength) + 10
    tabs.strength.updateStats()
end

tabs.strength.updateAdaptiveRate = function()
    tabs.strength.controlNow = tick()
    tabs.strength.controlElapsed = tabs.strength.controlNow - tabs.strength.lastControlAt
    if tabs.strength.controlElapsed < tabs.strength.controlInterval then
        return
    end

    tabs.strength.serverProgress = tabs.strength.strength.Value > tabs.strength.lastControlStrength
        or tabs.strength.durability.Value > tabs.strength.lastControlDurability

    if tabs.strength.serverProgress then
        tabs.strength.stalledIntervals = 0
        tabs.strength.sendRate = math.min(tabs.strength.maxSendRate, tabs.strength.sendRate * 1.12)
        tabs.strength.Status.Text = (tabs.strength.sendRate >= tabs.strength.maxSendRate
            and "Status: Farming | " or "Status: Preparing | ") .. formatNumber(tabs.strength.sendRate) .. " reps/s"
        tabs.strength.Status.TextColor3 = Color3.fromRGB(80, 255, 120)
    else
        tabs.strength.stalledIntervals = tabs.strength.stalledIntervals + 1
    end

    if tabs.strength.stalledIntervals >= 2 then
        tabs.strength.sendRate = math.max(math.min(tabs.strength.initialSendRate, tabs.strength.maxSendRate), tabs.strength.sendRate * 0.65)
        tabs.strength.Tokens = 0
        tabs.strength.Status.Text = "Status: Slowing for server | "
            .. formatNumber(tabs.strength.sendRate) .. " reps/s"
        tabs.strength.Status.TextColor3 = Color3.fromRGB(255, 180, 70)
    end

    tabs.strength.lastControlAt = tabs.strength.controlNow
    tabs.strength.lastControlStrength = tabs.strength.strength.Value
    tabs.strength.lastControlDurability = tabs.strength.durability.Value
end

tabs.strength.workerLoop = function()
    tabs.strength.LastAt = os.clock()
    local function isRunning()
        return controller.Alive and tabs.strength.running
    end
    while controller.Alive and tabs.strength.running do
        tabs.strength.updateAdaptiveRate()
        tabs.strength.startMeasurement()
        sendTrainingReps(tabs.strength, tabs.strength.sendRate, tabs.strength.maxBurst, isRunning)

        services.runservice.Heartbeat:Wait()
    end

    tabs.strength.workerActive = false
    if tabs.strength.running then
        tabs.strength.startWorker()
    end
end

tabs.strength.startWorker = function()
    if tabs.strength.workerActive then
        return
    end

    tabs.strength.workerActive = true
    runtime:Spawn(function()
        local success, err = pcall(function()
            equipBestFarmingPets(function() return controller.Alive and tabs.strength.running end)
            if not controller.Alive or not tabs.strength.running then return end
            tabs.strength.workerLoop()
        end)
        if not success then
            tabs.strength.workerActive = false
            tabs.strength.running = false
            tabs.strength.Status.Text = "Status: Error - " .. tostring(err)
            tabs.strength.FastRepToggle:Set(false)
            tabs.strength.Status.Text = "Status: Error - " .. tostring(err)
            warn("[Fast Farm Strength] " .. tostring(err))
        elseif not tabs.strength.running then
            tabs.strength.workerActive = false
        end
    end)
end

runtime:Connect(tabs.strength.strength:GetPropertyChangedSignal("Value"), function()
    recordStatGain(tabs.strength, "Strength", tabs.strength.strength.Value)
    tabs.strength.updateStats()
end)

runtime:Connect(tabs.strength.durability:GetPropertyChangedSignal("Value"), function()
    recordStatGain(tabs.strength, "Durability", tabs.strength.durability.Value)
    tabs.strength.updateStats()
end)

tabs.strength:AddTextBox("Max reps/s: " .. tabs.strength.maxSendRate, function(inputText, value)
    value = tonumber(inputText)
    if not value or value ~= value or value == math.huge or value == -math.huge then return end
    value = math.max(1, value)
    if value ~= tabs.strength.maxSendRate and tabs.strength.running then
        recordStatGain(tabs.strength, "Strength", tabs.strength.strength.Value)
        recordStatGain(tabs.strength, "Durability", tabs.strength.durability.Value)
        setTimerRunning(tabs.strength, false)
        tabs.strength.updateStats()
    end
    tabs.strength.maxSendRate = value
    tabs.strength.sendRate = math.min(tabs.strength.sendRate, tabs.strength.maxSendRate)
end, {clear = false})

tabs.strength:AddLabel("Recommended Speed: 640, you can always try more.")

tabs.strength.FastRepToggle = tabs.strength:AddSwitch("Fast Strength / Durability", function(state)
    recordStatGain(tabs.strength, "Strength", tabs.strength.strength.Value)
    recordStatGain(tabs.strength, "Durability", tabs.strength.durability.Value)
    setTimerRunning(tabs.strength, false)
    tabs.strength.statSamples.Strength = tabs.strength.strength.Value
    tabs.strength.statSamples.Durability = tabs.strength.durability.Value
    tabs.strength.running = state
    tabs.strength.Tokens = 0
    if state then
        if tabs.rebirths.running then tabs.rebirths.Switch:Set(false) end
        tabs.strength.gainedBaselineSet = true
        tabs.strength.sendRate = math.min(tabs.strength.initialSendRate, tabs.strength.maxSendRate)
        tabs.strength.LastAt = os.clock()
        tabs.strength.lastControlAt = tick()
        tabs.strength.lastControlStrength = tabs.strength.strength.Value
        tabs.strength.lastControlDurability = tabs.strength.durability.Value
        tabs.strength.stalledIntervals = 0
        tabs.strength.Status.Text = "Status: Preparing | " .. formatNumber(tabs.strength.sendRate) .. " reps/s"
        tabs.strength.Status.TextColor3 = Color3.fromRGB(80, 255, 120)
        tabs.strength.startWorker()
    else
        tabs.strength.Status.Text = tabs.strength.gainedBaselineSet and "Status: Paused" or "Status: Inactive"
        tabs.strength.Status.TextColor3 = tabs.strength.gainedBaselineSet and Color3.fromRGB(255, 180, 70) or Color3.fromRGB(255, 80, 80)
        tabs.strength.updateRuntime()
    end
    tabs.strength.updateStats()
end)

tabs.strength.FastRepToggle:Set(false)

runtime:Spawn(function()
    while controller.Alive do
        tabs.rebirths.updateRuntime()
        tabs.strength.updateRuntime()
        if tabs.strength.timerStarted and getElapsed(tabs.strength) >= tabs.strength.nextAverageElapsed then
            tabs.strength.updateAverage()
            tabs.strength.nextAverageElapsed = getElapsed(tabs.strength) + 10
        end
        task.wait(0.1)
    end
end)


page:AddLabel("Pet Loadouts")
local petBusy = false
local function manualLoadout(callback)
    if petBusy or tabs.rebirths.running or tabs.strength.running then
        warn("[Fast Farm] Pause farming before changing pets manually")
        return
    end
    petBusy = true
    runtime:Spawn(function()
        local success, err = pcall(callback, function()
            return controller.Alive and not tabs.rebirths.running and not tabs.strength.running
        end)
        petBusy = false
        if not success then warn("[Fast Farm Pets] " .. tostring(err)) end
    end)
end
page:AddButton("Equip Farming Pets", function() manualLoadout(equipBestFarmingPets) end)
page:AddButton("Equip Rebirth Pets", function() manualLoadout(equipBestRebirthPets) end)
page:AddLabel("Boss pet names are normalized. Rebirth bonus pets are optional.")
page:AddButton("Unload Fast Farm", function() controller:Destroy() end)
page:Show()
controller.Modes = tabs
end)
if not ok then
    controller:Destroy()
    warn("FAST FARM ERROR: " .. tostring(message))
    return nil, message
end
return controller
