local library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/memejames/elerium-v2-ui-library//main/Library",
    true
))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Backpack = LocalPlayer:WaitForChild("Backpack")

local startTime = os.time()

local BossArena = workspace
    :WaitForChild("Events")
    :WaitForChild("BossArena")

local window = library:AddWindow("Private Script", {
    main_color = Color3.fromRGB(10, 100, 150),
    min_size = Vector2.new(400, 500),
    can_resize = true,
})

local farmTab = window:AddTab("Farm Boss")
farmTab:Show()

local bossFolder = farmTab:AddFolder(" Boss Farm")

local nextBossLabel = bossFolder:AddLabel("Next Boss: Searching...")
local timerLabel = bossFolder:AddLabel("Time Left: Searching...")
local currentBossLabel = bossFolder:AddLabel("Current Boss: Waiting...")
local healthLabel = bossFolder:AddLabel("Health: —")
local rewardLabel = bossFolder:AddLabel("Reward: Waiting...")
local statusLabel = bossFolder:AddLabel("Status: Idle")

local State = {
    enabled = false,
    generation = 0,

    currentBoss = nil,
    currentHitbox = nil,

    attacks = 0,
    damage = 0,
    lastBossHealth = nil,

    hitInterval = 0.31,
    touchBegin = 0,

    claiming = false,

    touchTeleporting = false,
    lastConfirmedHitAt = 0,

    antiLag = false,
    antiLagOriginals = setmetatable({}, { __mode = "k" }),
    antiLagConnection = nil,

    bossAddedConnection = nil,
    bossRemovedConnection = nil,
}

do
    local identify = identifyexecutor or getexecutorname

    if type(identify) == "function" then
        local ok, name = pcall(identify)

        if ok and tostring(name):lower():find("real", 1, true) then
            State.touchBegin = 1
        end
    end
end

local bossData = {
    ["1"] = { Rarity = "COMMON", ModelName = "Boss1" },
    ["2"] = { Rarity = "RARE", ModelName = "Boss2" },
    ["3"] = { Rarity = "EPIC", ModelName = "Boss3" },
    ["4"] = { Rarity = "LEGENDARY", ModelName = "Boss4" },
    ["5"] = { Rarity = "MYTHIC", ModelName = "Boss5" },
    ["Rainbow"] = { Rarity = "RAINBOW", ModelName = "BossRainbow" },
}

local bossNameToRarity = {
    Boss1 = "COMMON",
    Boss2 = "RARE",
    Boss3 = "EPIC",
    Boss4 = "LEGENDARY",
    Boss5 = "MYTHIC",
    BossRainbow = "RAINBOW",
}

local function loadBossConfig()
    local shared = ReplicatedStorage:FindFirstChild("shared")
    local configFolder = shared and shared:FindFirstChild("config")
    local module = configFolder and configFolder:FindFirstChild("BossEventConfig")

    if not module or not module:IsA("ModuleScript") then
        return true
    end

    local ok, values = pcall(require, module)

    if not ok or type(values) ~= "table" then
        return true
    end

    if values.ENABLED == false then
        return false
    end

    State.hitInterval = math.max(
        0.36,
        (tonumber(values.MIN_HIT_INTERVAL) or 0.30) + 0.05
    )

    return true
end

local function getNextBoss()
    for _, obj in ipairs(BossArena:GetChildren()) do
        local id = obj.Name:match("^Arena(%d+)$")

        if id and bossData[id] then
            return bossData[id]
        end

        if obj.Name == "ArenaRainbow" then
            return bossData.Rainbow
        end
    end

    for _, obj in ipairs(BossArena:GetChildren()) do
        local id = obj.Name:match("^Path(%d+)$")

        if id and bossData[id] then
            return bossData[id]
        end

        if obj.Name == "PathRainbow" then
            return bossData.Rainbow
        end
    end

    return nil
end

local function getBossTimer()
    local bossSpawn = BossArena:FindFirstChild("BossSpawn")
    local runtime = bossSpawn and bossSpawn:FindFirstChild("bossInfoRuntime")
    local content = runtime and runtime:FindFirstChild("Content")
    local description = content and content:FindFirstChild("Description")

    if description and description:IsA("TextLabel") then
        local text = tostring(description.Text)
        return text:match("(%d+:%d+)") or text
    end

    return "Unknown"
end

local function getBossHealth()
    return math.max(
        0,
        tonumber(workspace:GetAttribute("BossHealth")) or 0
    )
end

local function getBossMaxHealth()
    return math.max(
        getBossHealth(),
        tonumber(workspace:GetAttribute("BossMaxHealth")) or 0
    )
end

local function updateUiInfo()
    local nextBoss = getNextBoss()

    nextBossLabel.Text =
        "Next Boss: "
        .. (nextBoss and nextBoss.Rarity or "Unknown")

    timerLabel.Text =
        "Time Left: "
        .. getBossTimer()

    local health = getBossHealth()
    local maximum = getBossMaxHealth()

    if maximum > 0 and workspace:GetAttribute("BossActive") == true then
        healthLabel.Text =
            "Health: "
            .. tostring(math.floor(health))
            .. " / "
            .. tostring(math.floor(maximum))
    else
        healthLabel.Text = "Health: —"
    end
end

local function getCharacter()
    return LocalPlayer.Character
end

local function getHumanoid()
    local character = getCharacter()
    return character and character:FindFirstChildOfClass("Humanoid")
end

local function getHands()
    local character = getCharacter()

    if not character then
        return nil, nil
    end

    local leftHand =
        character:FindFirstChild("LeftHand")
        or character:FindFirstChild("Left Arm")

    local rightHand =
        character:FindFirstChild("RightHand")
        or character:FindFirstChild("Right Arm")

    return leftHand, rightHand
end

local function equipPunch()
    local character = getCharacter()
    local humanoid = getHumanoid()

    if not character or not humanoid or humanoid.Health <= 0 then
        return nil
    end

    local punch =
        character:FindFirstChild("Punch")
        or Backpack:FindFirstChild("Punch")

    if not punch then
        return nil
    end

    if punch.Parent ~= character then
        pcall(humanoid.EquipTool, humanoid, punch)
        task.wait(0.02)
    end

    local attackTime = punch:FindFirstChild("attackTime")

    if attackTime and attackTime:IsA("ValueBase") then
        pcall(function()
            attackTime.Value = 0
        end)
    end

    return punch
end

local function firePunch()
    local event = LocalPlayer:FindFirstChild("muscleEvent")

    if not event or not event:IsA("RemoteEvent") then
        return false
    end

    pcall(event.FireServer, event, "punch", "leftHand")
    pcall(event.FireServer, event, "punch", "rightHand")

    return true
end

local function getBossParts(boss)
    if not boss or not boss.Parent or not boss:IsA("Model") then
        return nil, nil
    end

    -- O scanner confirmou BossDamageHitbox como a hitbox real.
    local hitbox =
        boss:FindFirstChild("BossDamageHitbox", true)
        or boss.PrimaryPart
        or boss:FindFirstChild("Boss", true)
        or boss:FindFirstChild("Head", true)
        or boss:FindFirstChildWhichIsA("BasePart", true)

    if not hitbox or not hitbox:IsA("BasePart") then
        return nil, nil
    end

    local target =
        boss:FindFirstChild("Boss", true)
        or boss:FindFirstChild("Head", true)
        or boss.PrimaryPart
        or hitbox

    if not target or not target:IsA("BasePart") then
        target = hitbox
    end

    return hitbox, target
end

local function isIgnoredBossModel(model)
    local current = model

    while current and current ~= BossArena.Parent do
        if current.Name == "RefreshBoss"
            or current.Name == "BossSpawn" then

            return true
        end

        current = current.Parent
    end

    return false
end

local function fallbackFindBoss()
    for _, obj in ipairs(BossArena:GetDescendants()) do
        if obj:IsA("Model")
            and not isIgnoredBossModel(obj) then

            local hitbox, target = getBossParts(obj)

            if hitbox
                and (
                    bossNameToRarity[obj.Name]
                    or obj:FindFirstChildOfClass("AnimationController")
                ) then

                return obj, hitbox, target
            end
        end
    end

    return nil, nil, nil
end

local function findBoss()
    if State.currentBoss and State.currentBoss.Parent then
        local hitbox, target = getBossParts(State.currentBoss)

        if hitbox then
            State.currentHitbox = hitbox
            return State.currentBoss, hitbox, target
        end
    end

    for _, boss in ipairs(CollectionService:GetTagged("BossEventBoss")) do
        local hitbox, target = getBossParts(boss)

        if hitbox then
            State.currentBoss = boss
            State.currentHitbox = hitbox

            return boss, hitbox, target
        end
    end

    local boss, hitbox, target = fallbackFindBoss()

    if boss then
        State.currentBoss = boss
        State.currentHitbox = hitbox
    end

    return boss, hitbox, target
end

local function bossRarity(boss)
    if boss and bossNameToRarity[boss.Name] then
        return bossNameToRarity[boss.Name]
    end

    local display =
        workspace:GetAttribute("BossDisplayName")

    if display and tostring(display) ~= "" then
        return tostring(display)
    end

    local nextBoss = getNextBoss()
    return nextBoss and nextBoss.Rarity or "UNKNOWN"
end

local function applyAntiLagObject(object)
    if not State.antiLag or not object then
        return
    end

    local property

    if object:IsA("ParticleEmitter")
        or object:IsA("Trail")
        or object:IsA("Beam")
        or object:IsA("Fire")
        or object:IsA("Smoke")
        or object:IsA("Sparkles")
        or object:IsA("PointLight")
        or object:IsA("SpotLight")
        or object:IsA("SurfaceLight")
        or object:IsA("Highlight") then

        property = "Enabled"

    elseif object:IsA("BasePart") then
        property = "CastShadow"
    end

    if property and State.antiLagOriginals[object] == nil then
        local ok, value = pcall(function()
            return object[property]
        end)

        if ok then
            State.antiLagOriginals[object] = {
                property = property,
                value = value,
            }

            pcall(function()
                object[property] = false
            end)
        end
    end
end

local function setBossAntiLag(enabled)
    State.antiLag = enabled == true

    if State.antiLagConnection then
        State.antiLagConnection:Disconnect()
        State.antiLagConnection = nil
    end

    if not State.antiLag then
        for object, saved in pairs(State.antiLagOriginals) do
            if object and object.Parent then
                pcall(function()
                    object[saved.property] = saved.value
                end)
            end

            State.antiLagOriginals[object] = nil
        end

        return
    end

    for _, object in ipairs(BossArena:GetDescendants()) do
        applyAntiLagObject(object)
    end

    State.antiLagConnection =
        BossArena.DescendantAdded:Connect(function(object)
            task.defer(applyAntiLagObject, object)
        end)
end

local function releaseContacts(contacts)
    if type(firetouchinterest) ~= "function" then
        return
    end

    for _, pair in ipairs(contacts or {}) do
        local hand = pair[1]
        local target = pair[2]

        if hand and hand.Parent and target and target.Parent then
            pcall(
                firetouchinterest,
                hand,
                target,
                1 - State.touchBegin
            )
        end
    end
end

local function waitPhysicsFrames(count)
    for _ = 1, math.max(1, tonumber(count) or 1) do
        RunService.Heartbeat:Wait()
    end
end

local function fireBossTouch(leftHand, rightHand, hitbox, punch)
    if not hitbox or not hitbox.Parent then
        return false
    end

    firePunch()

    pcall(function()
        punch:Activate()
    end)

    local contacts = {
        { rightHand, hitbox },
        { leftHand, hitbox },
    }

    -- Begin touch.
    for _, pair in ipairs(contacts) do
        local hand = pair[1]
        local target = pair[2]

        if hand and hand.Parent and target and target.Parent then
            pcall(
                firetouchinterest,
                hand,
                target,
                State.touchBegin
            )
        end
    end

    -- Não solta imediatamente: mantém contato durante frames físicos.
    waitPhysicsFrames(4)

    releaseContacts(contacts)

    return true
end

local function attackBoss(boss, hitbox)
    if type(firetouchinterest) ~= "function" then
        statusLabel.Text = "Status: firetouchinterest unavailable"
        return false
    end

    if not boss or not boss.Parent then
        return false
    end

    -- Reobtém a hitbox a cada ataque.
    -- Se o boss recriar a peça internamente, não continuamos usando
    -- uma referência velha.
    local liveHitbox =
        boss:FindFirstChild("BossDamageHitbox", true)

    if liveHitbox and liveHitbox:IsA("BasePart") then
        hitbox = liveHitbox
        State.currentHitbox = liveHitbox
    end

    if not hitbox
        or not hitbox.Parent
        or not hitbox:IsA("BasePart") then

        return false
    end

    local character = getCharacter()
    local humanoid = getHumanoid()
    local root =
        character
        and character:FindFirstChild("HumanoidRootPart")

    if not character
        or not root
        or not humanoid
        or humanoid.Health <= 0 then

        return false
    end

    local leftHand, rightHand = getHands()

    if not leftHand or not rightHand then
        return false
    end

    local punch = equipPunch()

    if not punch then
        statusLabel.Text = "Status: Punch not found"
        return false
    end

    local returnPivot = character:GetPivot()
    local wasAnchored = root.Anchored
    local healthBefore = getBossHealth()

    State.touchTeleporting = true

    local function restoreCharacter()
        pcall(function()
            if character.Parent and root.Parent then
                character:PivotTo(returnPivot)
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                root.Anchored = wasAnchored
            end
        end)

        State.touchTeleporting = false
    end

    local ok = pcall(function()
        root.Anchored = false

        -- Coloca o centro do personagem dentro da BossDamageHitbox real.
        -- Como o scanner mostrou que ela é muito grande, isso também
        -- deixa LeftHand e RightHand fisicamente dentro do volume.
        character:PivotTo(hitbox.CFrame)

        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero

        -- Aguarda a mudança de posição passar por frames de física.
        waitPhysicsFrames(6)

        -- Até 3 tentativas. Só repete quando BossHealth não diminui.
        for attempt = 1, 3 do
            if not State.enabled
                or State.claiming
                or not boss.Parent
                or not hitbox.Parent
                or workspace:GetAttribute("BossActive") ~= true then

                break
            end

            -- Mantém o personagem dentro da hitbox antes de cada pulso.
            character:PivotTo(hitbox.CFrame)
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero

            waitPhysicsFrames(2)

            local before = getBossHealth()

            fireBossTouch(
                leftHand,
                rightHand,
                hitbox,
                punch
            )

            -- Aguarda o atributo de vida replicar.
            local deadline = os.clock() + 0.28
            local registered = false

            while os.clock() < deadline do
                if getBossHealth() < before then
                    registered = true
                    State.lastConfirmedHitAt = os.clock()
                    break
                end

                RunService.Heartbeat:Wait()
            end

            if registered then
                break
            end

            -- Se o toque não registrou, aguarda passar o cooldown
            -- do servidor antes da próxima tentativa.
            if attempt < 3 then
                local retryAt =
                    os.clock()
                    + math.max(State.hitInterval, 0.36)

                while os.clock() < retryAt do
                    if not State.enabled
                        or State.claiming
                        or not boss.Parent then

                        break
                    end

                    -- Segura o personagem fisicamente dentro da
                    -- hitbox durante a espera do retry.
                    character:PivotTo(hitbox.CFrame)
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.AssemblyAngularVelocity = Vector3.zero

                    RunService.Heartbeat:Wait()
                end
            end
        end
    end)

    restoreCharacter()

    if not ok then
        return false
    end

    local healthAfter = getBossHealth()

    if healthAfter < healthBefore then
        State.attacks += 1
        return true
    end

    return false
end

local function findRewardPrompt()
    for _, chest in ipairs(CollectionService:GetTagged("BossEventChest")) do
        if chest and chest.Parent then
            local prompt =
                chest:FindFirstChild("bossChestPrompt", true)

            if prompt and prompt:IsA("ProximityPrompt") then
                return prompt, chest
            end
        end
    end

    local events = workspace:FindFirstChild("Events")
    local prompt =
        events and events:FindFirstChild("bossChestPrompt", true)

    if prompt and prompt:IsA("ProximityPrompt") then
        return prompt, prompt:FindFirstAncestorOfClass("Model")
    end

    for _, obj in ipairs(BossArena:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            local text = (
                tostring(obj.Name)
                .. " "
                .. tostring(obj.ActionText)
                .. " "
                .. tostring(obj.ObjectText)
            ):lower()

            if (
                text:find("claim", 1, true)
                and text:find("reward", 1, true)
            ) or (
                text:find("boss", 1, true)
                and text:find("chest", 1, true)
            ) then
                return obj, obj:FindFirstAncestorOfClass("Model")
            end
        end
    end

    return nil, nil
end

local function getPromptPart(prompt)
    if not prompt then
        return nil
    end

    local current = prompt.Parent

    while current and current ~= workspace do
        if current:IsA("BasePart") then
            return current
        end

        current = current.Parent
    end

    return nil
end

local function activatePrompt(prompt)
    if not prompt or not prompt.Parent or not prompt.Enabled then
        return false
    end

    if type(fireproximityprompt) == "function" then
        local ok = pcall(fireproximityprompt, prompt)

        if ok then
            return true
        end
    end

    local key = prompt.KeyboardKeyCode

    if key == Enum.KeyCode.Unknown then
        return false
    end

    return pcall(function()
        VirtualInputManager:SendKeyEvent(
            true,
            key,
            false,
            game
        )

        task.wait(
            math.max(
                tonumber(prompt.HoldDuration) or 0,
                0.1
            ) + 0.12
        )

        VirtualInputManager:SendKeyEvent(
            false,
            key,
            false,
            game
        )
    end)
end

local function claimReward(timeout)
    if State.claiming or not State.enabled then
        return false
    end

    State.claiming = true
    rewardLabel.Text = "Reward: Searching chest..."
    statusLabel.Text = "Status: Claiming reward"

    local character = getCharacter()
    local root =
        character
        and character:FindFirstChild("HumanoidRootPart")

    local returnPivot =
        character
        and character:GetPivot()
        or nil

    local opened = false
    local openedConnection

    local rEvents = ReplicatedStorage:FindFirstChild("rEvents")
    local openedEvent =
        rEvents
        and rEvents:FindFirstChild("bossChestOpenedEvent")

    if openedEvent and openedEvent:IsA("RemoteEvent") then
        openedConnection =
            openedEvent.OnClientEvent:Connect(function()
                opened = true
            end)
    end

    local function finish(success, text)
        if openedConnection then
            openedConnection:Disconnect()
        end

        local currentCharacter = getCharacter()
        local currentRoot =
            currentCharacter
            and currentCharacter:FindFirstChild("HumanoidRootPart")

        if returnPivot
            and currentCharacter == character
            and currentRoot then

            pcall(function()
                currentCharacter:PivotTo(returnPivot)
                currentRoot.AssemblyLinearVelocity = Vector3.zero
                currentRoot.AssemblyAngularVelocity = Vector3.zero
            end)
        end

        State.claiming = false
        rewardLabel.Text =
            "Reward: "
            .. (text or (success and "Claimed" or "Not found"))

        return success
    end

    local deadline =
        os.clock()
        + (tonumber(timeout) or 15)

    local attempted = false
    local pendingSeen = false
    local lastAttempt = 0

    while State.enabled and os.clock() < deadline do
        if opened then
            return finish(true, "Claimed")
        end

        local prompt, chest = findRewardPrompt()

        local eligible =
            LocalPlayer:GetAttribute("BossChestEligible")

        local pending =
            LocalPlayer:GetAttribute("BossChestPending")

        local attributesKnown =
            eligible ~= nil
            or pending ~= nil

        if pending == true then
            pendingSeen = true
        end

        if attempted
            and pendingSeen
            and pending == false then

            return finish(true, "Claimed")
        end

        local emerging =
            chest
            and chest:GetAttribute("BossChestEmerging") == true

        local allowed =
            not attributesKnown
            or (
                eligible == true
                and pending == true
            )

        if prompt
            and prompt.Parent
            and not emerging
            and allowed then

            local promptPart = getPromptPart(prompt)
            local currentCharacter = getCharacter()
            local currentRoot =
                currentCharacter
                and currentCharacter:FindFirstChild("HumanoidRootPart")

            if promptPart and currentCharacter and currentRoot then
                pcall(function()
                    currentCharacter:PivotTo(
                        promptPart.CFrame
                        * CFrame.new(
                            0,
                            math.max(
                                4,
                                promptPart.Size.Y * 0.5 + 3
                            ),
                            0
                        )
                    )

                    currentRoot.AssemblyLinearVelocity =
                        Vector3.zero

                    currentRoot.AssemblyAngularVelocity =
                        Vector3.zero
                end)

                task.wait(0.10)
            end

            if prompt.Enabled
                and os.clock() - lastAttempt >= 0.50 then

                lastAttempt = os.clock()
                attempted =
                    activatePrompt(prompt)
                    or attempted
            end
        end

        task.wait(0.10)
    end

    local confirmed =
        opened
        or (
            attempted
            and pendingSeen
            and LocalPlayer:GetAttribute("BossChestPending") ~= true
        )

    return finish(
        confirmed,
        confirmed and "Claimed" or "Claim timeout"
    )
end

local function refreshTaggedBoss()
    local boss = CollectionService:GetTagged("BossEventBoss")[1]

    if boss and boss.Parent then
        State.currentBoss = boss
        State.currentHitbox = select(1, getBossParts(boss))
    elseif State.currentBoss
        and not State.currentBoss.Parent then

        State.currentBoss = nil
        State.currentHitbox = nil
    end
end

State.bossAddedConnection =
    CollectionService
        :GetInstanceAddedSignal("BossEventBoss")
        :Connect(function(boss)
            State.currentBoss = boss
            State.currentHitbox = select(1, getBossParts(boss))
        end)

State.bossRemovedConnection =
    CollectionService
        :GetInstanceRemovedSignal("BossEventBoss")
        :Connect(function(boss)
            if State.currentBoss == boss then
                State.currentBoss = nil
                State.currentHitbox = nil
            end
        end)

refreshTaggedBoss()

local function runBossFarm(generation)
    local hadBoss = false
    local lastBossSeen = 0
    local lastAttack = 0
    local lastFallbackScan = 0

    while State.enabled
        and State.generation == generation do

        updateUiInfo()

        local boss, hitbox =
            findBoss()

        if not boss
            and os.clock() - lastFallbackScan >= 0.50 then

            lastFallbackScan = os.clock()

            boss, hitbox =
                fallbackFindBoss()

            if boss then
                State.currentBoss = boss
                State.currentHitbox = hitbox
            end
        end

        if boss
            and hitbox
            and boss.Parent
            and workspace:GetAttribute("BossActive") ~= false then

            hadBoss = true
            lastBossSeen = os.clock()

            local rarity = bossRarity(boss)

            currentBossLabel.Text =
                "Current Boss: "
                .. rarity

            statusLabel.Text =
                "Status: Attacking"

            rewardLabel.Text =
                "Reward: Waiting for kill"

            local health = getBossHealth()

            if State.lastBossHealth
                and health < State.lastBossHealth then

                State.damage +=
                    State.lastBossHealth - health
            end

            State.lastBossHealth = health

            local now = os.clock()

            if now - lastAttack >= State.hitInterval then
                lastAttack = now
                attackBoss(boss, hitbox)
            end

            task.wait(0.06)

        else
            currentBossLabel.Text =
                "Current Boss: Waiting..."

            State.lastBossHealth = nil

            if hadBoss
                and os.clock() - lastBossSeen >= 0.75 then

                hadBoss = false
                State.currentBoss = nil
                State.currentHitbox = nil

                local defeated =
                    getBossHealth() <= 0
                    or workspace:GetAttribute("BossActive") ~= true
                    or LocalPlayer:GetAttribute("BossChestPending") == true
                    or LocalPlayer:GetAttribute("BossChestEligible") == true

                if defeated and State.enabled then
                    rewardLabel.Text =
                        "Reward: Boss defeated"

                    task.spawn(function()
                        claimReward(15)
                    end)
                end
            end

            statusLabel.Text =
                State.claiming
                and "Status: Claiming reward"
                or "Status: Waiting boss"

            task.wait(0.30)
        end
    end
end

bossFolder:AddSwitch("Auto Boss", function(Value)
    State.generation += 1
    local generation = State.generation

    State.enabled = Value == true

    if not State.enabled then
        setBossAntiLag(false)

        State.currentBoss = nil
        State.currentHitbox = nil
        State.lastBossHealth = nil
        State.touchTeleporting = false
        State.attacks = 0
        State.damage = 0

        currentBossLabel.Text =
            "Current Boss: Waiting..."

        rewardLabel.Text =
            "Reward: Waiting..."

        statusLabel.Text =
            "Status: Disabled"

        return
    end

    if not loadBossConfig() then
        State.enabled = false

        statusLabel.Text =
            "Status: Boss event disabled"

        return
    end

    setBossAntiLag(true)

    State.attacks = 0
    State.damage = 0
    State.lastBossHealth = nil

    statusLabel.Text =
        "Status: Starting..."

    task.spawn(function()
        task.wait(0.15)

        if State.enabled
            and (
                LocalPlayer:GetAttribute("BossChestPending") == true
                or findRewardPrompt() ~= nil
            ) then

            claimReward(8)
        end
    end)

    task.spawn(function()
        runBossFarm(generation)
    end)
end)

task.spawn(function()
    while task.wait(1) do
        pcall(updateUiInfo)
    end
end)

updateUiInfo()

local autoPunchEnabled = false
local autoPunchGeneration = 0

local function getPunch()
    local character = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")

    if not character then
        return nil
    end

    return character:FindFirstChild("Punch")
        or (backpack and backpack:FindFirstChild("Punch"))
end

local function equipPunch()
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local punch = getPunch()

    if not character or not humanoid or humanoid.Health <= 0 or not punch then
        return nil
    end

    if punch.Parent ~= character then
        pcall(humanoid.EquipTool, humanoid, punch)
    end

    local attackTime = punch:FindFirstChild("attackTime")

    if attackTime and attackTime:IsA("ValueBase") then
        pcall(function()
            attackTime.Value = 0
        end)
    end

    return punch
end

local function resetPunch()
    local character = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")

    if character then
        local punch = character:FindFirstChild("Punch")

        if punch then
            local attackTime = punch:FindFirstChild("attackTime")

            if attackTime and attackTime:IsA("ValueBase") then
                pcall(function()
                    attackTime.Value = 0.35
                end)
            end

            if backpack then
                punch.Parent = backpack
            end
        end
    end

    if backpack then
        local punch = backpack:FindFirstChild("Punch")
        local attackTime = punch and punch:FindFirstChild("attackTime")

        if attackTime and attackTime:IsA("ValueBase") then
            pcall(function()
                attackTime.Value = 0.35
            end)
        end
    end
end

bossFolder:AddSwitch("Auto Punch", function(Value)
    autoPunchEnabled = Value == true
    autoPunchGeneration += 1

    local generation = autoPunchGeneration

    if not autoPunchEnabled then
        resetPunch()
        return
    end

    task.spawn(function()
        local lastEquip = 0

        while autoPunchEnabled
            and autoPunchGeneration == generation do

            local character = LocalPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")

            if character and humanoid and humanoid.Health > 0 then
                local now = os.clock()
                local punch = getPunch()

                if not punch
                    or punch.Parent ~= character
                    or now - lastEquip >= 0.5 then

                    punch = equipPunch()
                    lastEquip = now
                end

                local muscleEvent = LocalPlayer:FindFirstChild("muscleEvent")

                if punch
                    and muscleEvent
                    and muscleEvent:IsA("RemoteEvent") then

                    pcall(muscleEvent.FireServer, muscleEvent, "punch", "rightHand")
                    pcall(muscleEvent.FireServer, muscleEvent, "punch", "leftHand")
                    pcall(punch.Activate, punch)
                end
            end

            task.wait(0.03)
        end
    end)
end)

local positionLockConnection = nil
local characterAddedConnection = nil
local lockEnabled = false
local lockedCFrame = nil

local savedMovement = {
    character = nil,
    rootAnchored = nil,
    walkSpeed = nil,
    jumpPower = nil,
    jumpHeight = nil,
    useJumpPower = nil,
    autoRotate = nil,
}

local function saveCharacterMovement(character, rootPart, humanoid)
    if savedMovement.character == character then
        return
    end

    savedMovement.character = character
    savedMovement.rootAnchored = rootPart.Anchored
    savedMovement.walkSpeed = humanoid.WalkSpeed
    savedMovement.useJumpPower = humanoid.UseJumpPower
    savedMovement.autoRotate = humanoid.AutoRotate

    if humanoid.UseJumpPower then
        savedMovement.jumpPower = humanoid.JumpPower
        savedMovement.jumpHeight = nil
    else
        savedMovement.jumpHeight = humanoid.JumpHeight
        savedMovement.jumpPower = nil
    end
end

local function applyHardLock()
    if not lockEnabled
        or not lockedCFrame
        or State.touchTeleporting
        or State.claiming then

        return
    end

    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if not rootPart or not humanoid or humanoid.Health <= 0 then
        return
    end

    saveCharacterMovement(character, rootPart, humanoid)

    pcall(function()
        humanoid.AutoRotate = false
        humanoid.WalkSpeed = 0

        if humanoid.UseJumpPower then
            humanoid.JumpPower = 0
        else
            humanoid.JumpHeight = 0
        end

        humanoid.Jump = false

        rootPart.CFrame = lockedCFrame
        rootPart.AssemblyLinearVelocity = Vector3.zero
        rootPart.AssemblyAngularVelocity = Vector3.zero
        rootPart.Anchored = true
    end)
end

local function startPositionLock()
    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if not rootPart or not humanoid or humanoid.Health <= 0 then
        return false
    end

    lockEnabled = true
    lockedCFrame = rootPart.CFrame

    saveCharacterMovement(character, rootPart, humanoid)
    applyHardLock()

    if positionLockConnection then
        positionLockConnection:Disconnect()
    end

    positionLockConnection = RunService.Heartbeat:Connect(function()
        applyHardLock()
    end)

    if characterAddedConnection then
        characterAddedConnection:Disconnect()
    end

    characterAddedConnection = LocalPlayer.CharacterAdded:Connect(function(newCharacter)
        if not lockEnabled then
            return
        end

        local newRoot = newCharacter:WaitForChild("HumanoidRootPart", 10)
        local newHumanoid = newCharacter:WaitForChild("Humanoid", 10)

        if newRoot and newHumanoid then
            savedMovement.character = nil
            lockedCFrame = newRoot.CFrame
            task.wait()
            applyHardLock()
        end
    end)

    return true
end

local function stopPositionLock()
    lockEnabled = false

    if positionLockConnection then
        positionLockConnection:Disconnect()
        positionLockConnection = nil
    end

    if characterAddedConnection then
        characterAddedConnection:Disconnect()
        characterAddedConnection = nil
    end

    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if character
        and character == savedMovement.character
        and rootPart
        and humanoid then

        pcall(function()
            rootPart.Anchored = savedMovement.rootAnchored == true
            humanoid.AutoRotate = savedMovement.autoRotate ~= false
            humanoid.WalkSpeed = savedMovement.walkSpeed or 16

            if savedMovement.useJumpPower then
                humanoid.UseJumpPower = true
                humanoid.JumpPower = savedMovement.jumpPower or 50
            else
                humanoid.UseJumpPower = false
                humanoid.JumpHeight = savedMovement.jumpHeight or 7.2
            end
        end)
    elseif rootPart then
        pcall(function()
            rootPart.Anchored = false
        end)
    end

    lockedCFrame = nil

    savedMovement = {
        character = nil,
        rootAnchored = nil,
        walkSpeed = nil,
        jumpPower = nil,
        jumpHeight = nil,
        useJumpPower = nil,
        autoRotate = nil,
    }
end

bossFolder:AddSwitch("Lock Position", function(Value)
    if Value then
        startPositionLock()
    else
        stopPositionLock()
    end
end)

bossFolder:AddButton("Anti AFK", function()
    local Players = game:GetService("Players")
    local VirtualUser = game:GetService("VirtualUser")

    local player = Players.LocalPlayer
    local env = getgenv and getgenv() or _G

    if env.AntiAFKConnection then
        pcall(function()
            env.AntiAFKConnection:Disconnect()
        end)

        env.AntiAFKConnection = nil
    end

    local function antiAFKPulse()
        pcall(function()
            VirtualUser:CaptureController()

            local camera = workspace.CurrentCamera
            local cameraCFrame =
                camera and camera.CFrame
                or CFrame.new()

            VirtualUser:Button2Down(
                Vector2.new(0, 0),
                cameraCFrame
            )

            task.wait(0.05)

            VirtualUser:Button2Up(
                Vector2.new(0, 0),
                cameraCFrame
            )
        end)
    end

    env.AntiAFKConnection =
        player.Idled:Connect(antiAFKPulse)

    antiAFKPulse()
end)

local teleportTab = window:AddTab("Teleport")

local function teleportTo(position, lookAt)
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")

    if lookAt then
        rootPart.CFrame = CFrame.lookAt(position, lookAt)
    else
        rootPart.CFrame = CFrame.new(position)
    end

    rootPart.AssemblyLinearVelocity = Vector3.zero
    rootPart.AssemblyAngularVelocity = Vector3.zero
end

teleportTab:AddButton("Spawn", function()
    teleportTo(Vector3.new(2, 8, 115))
end)

teleportTab:AddButton("Tiny Gym", function()
    teleportTo(Vector3.new(50, 7, 1918))
end)

teleportTab:AddButton("Frost Gym", function()
    teleportTo(Vector3.new(-2650, 7, -393))
end)

teleportTab:AddButton("Mythical Gym", function()
    teleportTo(Vector3.new(2255, 7, 1071))
end)

teleportTab:AddButton("Eternal Gym", function()
    teleportTo(Vector3.new(-6768, 7, -1287))
end)

teleportTab:AddButton("Legends Gym", function()
    teleportTo(Vector3.new(4429, 991, -3880))
end)

teleportTab:AddButton("Muscle King", function()
    teleportTo(Vector3.new(-8799, 17, -5798))
end)

teleportTab:AddButton("Jungle Gym", function()
    teleportTo(Vector3.new(-7894, 6, 2386))
end)

teleportTab:AddButton("Industrial Gym", function()
    teleportTo(Vector3.new(-5165, 57, 4945))
end)

teleportTab:AddButton("Boss Arena", function()
    teleportTo(Vector3.new(0, 5, -805))
end)

teleportTab:AddButton("Secret Area", function()
    teleportTo(Vector3.new(1947, 2, 6191))
end)

teleportTab:AddButton("Rip Glitch Pets", function()
    teleportTo(
        Vector3.new(-499.3, 3.15, -204.61),
        Vector3.new(-507.07, 3.15, -204.61)
    )
end)

teleportTab:AddButton("Desert Brawl", function()
    teleportTo(Vector3.new(960, 17, -7398))
end)

teleportTab:AddButton("Lava Brawl", function()
    teleportTo(Vector3.new(4471, 119, -8836))
end)

teleportTab:AddButton("Regular Brawl", function()
    teleportTo(Vector3.new(-1849, 20, -6335))
end)

local farmToolsTab = window:AddTab("Farm Tools")

local farmToolsFolder = farmToolsTab:AddFolder("Auto Tools")

local AutoTools = {
    autoWeight = false,
    autoHandstands = false,
    autoPushups = false,
    autoSitups = false,
}

local generations = {}
local repTimeOriginals = {}

local function getCharacter()
    return LocalPlayer.Character
end

local function getHumanoid()
    local character = getCharacter()

    return character
        and character:FindFirstChildOfClass("Humanoid")
end

local function equipTool(names)
    local character = getCharacter()
    local humanoid = getHumanoid()
    local backpack = LocalPlayer:FindFirstChild("Backpack")

    if not character or not humanoid then
        return nil
    end

    local wanted = {}

    for _, name in ipairs(names) do
        wanted[name:lower()] = true
    end

    for _, container in ipairs({
        character,
        backpack
    }) do
        if container then
            for _, tool in ipairs(container:GetChildren()) do
                if tool:IsA("Tool")
                    and wanted[tool.Name:lower()] then

                    if tool.Parent ~= character then
                        pcall(function()
                            humanoid:EquipTool(tool)
                        end)
                    end

                    return tool
                end
            end
        end
    end

    return nil
end

local function setFastRepTime(key, tool)
    if not tool then
        return
    end

    local repTime = tool:FindFirstChild("repTime", true)

    if not repTime
        or not repTime:IsA("ValueBase") then
        return
    end

    repTimeOriginals[key] =
        repTimeOriginals[key]
        or setmetatable({}, {
            __mode = "k"
        })

    if repTimeOriginals[key][repTime] == nil then
        repTimeOriginals[key][repTime] =
            repTime.Value
    end

    pcall(function()
        repTime.Value = 0
    end)
end

local function restoreRepTime(key)
    local saved = repTimeOriginals[key]

    if not saved then
        return
    end

    for repTime, original in pairs(saved) do
        if repTime and repTime.Parent then
            pcall(function()
                repTime.Value = original
            end)
        end
    end

    repTimeOriginals[key] = nil
end

local function unequipTools(names)
    local character = getCharacter()
    local backpack = LocalPlayer:FindFirstChild("Backpack")

    if not character or not backpack then
        return
    end

    local wanted = {}

    for _, name in ipairs(names) do
        wanted[name:lower()] = true
    end

    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool")
            and wanted[tool.Name:lower()] then

            pcall(function()
                tool.Parent = backpack
            end)
        end
    end
end

local function setAutoRep(key, enabled, tools)
    generations[key] =
        (generations[key] or 0) + 1

    local generation = generations[key]

    AutoTools[key] = enabled == true

    if not enabled then
        restoreRepTime(key)
        unequipTools(tools)
        return
    end

    task.spawn(function()
        while AutoTools[key]
            and generations[key] == generation do

            pcall(function()
                local tool = equipTool(tools)

                if tool then
                    setFastRepTime(key, tool)
                end

                local event =
                    LocalPlayer:FindFirstChild("muscleEvent")

                if event
                    and event:IsA("RemoteEvent") then

                    event:FireServer("rep")
                end
            end)

            task.wait(0.01)
        end
    end)
end

local toolDefinitions = {
    autoWeight = {
        "Weight"
    },

    autoHandstands = {
        "Handstands",
        "Handstand"
    },

    autoPushups = {
        "Pushup",
        "Pushups"
    },

    autoSitups = {
        "Situps",
        "Situp"
    },
}

local toggleControls = {}

local function disableOtherTools(current)
    for key, tools in pairs(toolDefinitions) do
        if key ~= current and AutoTools[key] then
            setAutoRep(
                key,
                false,
                tools
            )

            if toggleControls[key] then
                pcall(function()
                    toggleControls[key]:Set(false)
                end)
            end
        end
    end
end

toggleControls.autoWeight =
    farmToolsFolder:AddSwitch("Auto Weight", function(Value)
        if Value then
            disableOtherTools("autoWeight")
        end

        setAutoRep(
            "autoWeight",
            Value,
            toolDefinitions.autoWeight
        )
    end)

toggleControls.autoHandstands =
    farmToolsFolder:AddSwitch("Auto Handstands", function(Value)
        if Value then
            disableOtherTools("autoHandstands")
        end

        setAutoRep(
            "autoHandstands",
            Value,
            toolDefinitions.autoHandstands
        )
    end)

toggleControls.autoPushups =
    farmToolsFolder:AddSwitch("Auto Pushups", function(Value)
        if Value then
            disableOtherTools("autoPushups")
        end

        setAutoRep(
            "autoPushups",
            Value,
            toolDefinitions.autoPushups
        )
    end)

toggleControls.autoSitups =
    farmToolsFolder:AddSwitch("Auto Situps", function(Value)
        if Value then
            disableOtherTools("autoSitups")
        end

        setAutoRep(
            "autoSitups",
            Value,
            toolDefinitions.autoSitups
        )
    end)
