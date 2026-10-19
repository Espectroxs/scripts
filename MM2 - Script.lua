local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local environment = (getgenv and getgenv()) or _G

if environment.MM2LumenRoles and environment.MM2LumenRoles.Stop then
    pcall(environment.MM2LumenRoles.Stop)
end

local library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Espectroxs/scripts/refs/heads/main/Library%202.0",
    true
))()

local window = library:AddWindow("MM2 | Private Script", {
    main_color = Color3.fromRGB(99, 71, 224),
    size = Vector2.new(650, 500),
    toggle_key = Enum.KeyCode.RightShift,
    show_intro = false,
})

local function addExecutorProfile()
    if not LocalPlayer or not window or not window.Instance then return end

    local body = window.Instance:FindFirstChild("Body")
    local sidebar = body and body:FindFirstChild("Sidebar")
    if not sidebar then return end

    local nav = sidebar:FindFirstChild("TabButtons")
    if nav then
        nav.Size = UDim2.new(1, -24, 1, -183)
    end

    for _, child in ipairs(sidebar:GetChildren()) do
        if child:IsA("TextLabel") and child.Text == "LUMEN  /  2.0" then
            child.Visible = false
        end
    end

    local accent = Color3.fromRGB(99, 71, 224)
    local card = Instance.new("Frame")
    card.Name = "ExecutorProfile"
    card.AnchorPoint = Vector2.new(0, 1)
    card.Position = UDim2.new(0, 12, 1, -10)
    card.Size = UDim2.new(1, -24, 0, 55)
    card.BackgroundColor3 = Color3.fromRGB(248, 245, 255)
    card.BorderSizePixel = 0
    card.ZIndex = sidebar.ZIndex + 2
    card.Parent = sidebar

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 11)
    cardCorner.Parent = card

    local cardStroke = Instance.new("UIStroke")
    cardStroke.Color = accent
    cardStroke.Thickness = 1
    cardStroke.Transparency = 0.68
    cardStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    cardStroke.Parent = card

    local bgGradient = Instance.new("UIGradient")
    bgGradient.Rotation = 20
    bgGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(237, 231, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
    })
    bgGradient.Parent = card

    local avatarBorder = Instance.new("Frame")
    avatarBorder.Name = "AvatarBorder"
    avatarBorder.Position = UDim2.fromOffset(8, 7)
    avatarBorder.Size = UDim2.fromOffset(41, 41)
    avatarBorder.BackgroundColor3 = accent
    avatarBorder.BorderSizePixel = 0
    avatarBorder.ZIndex = card.ZIndex + 1
    avatarBorder.Parent = card

    local avatarBorderCorner = Instance.new("UICorner")
    avatarBorderCorner.CornerRadius = UDim.new(1, 0)
    avatarBorderCorner.Parent = avatarBorder

    local avatar = Instance.new("ImageLabel")
    avatar.Name = "Avatar"
    avatar.Position = UDim2.fromOffset(2, 2)
    avatar.Size = UDim2.new(1, -4, 1, -4)
    avatar.BackgroundColor3 = Color3.fromRGB(245, 242, 255)
    avatar.BorderSizePixel = 0
    avatar.Image = string.format(
        "rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150",
        LocalPlayer.UserId
    )
    avatar.ScaleType = Enum.ScaleType.Crop
    avatar.ZIndex = avatarBorder.ZIndex + 1
    avatar.Parent = avatarBorder

    local avatarCorner = Instance.new("UICorner")
    avatarCorner.CornerRadius = UDim.new(1, 0)
    avatarCorner.Parent = avatar

    local online = Instance.new("Frame")
    online.Name = "StatusDot"
    online.Position = UDim2.fromOffset(38, 38)
    online.Size = UDim2.fromOffset(9, 9)
    online.BackgroundColor3 = Color3.fromRGB(60, 202, 132)
    online.BorderSizePixel = 0
    online.ZIndex = avatar.ZIndex + 1
    online.Parent = card

    local onlineCorner = Instance.new("UICorner")
    onlineCorner.CornerRadius = UDim.new(1, 0)
    onlineCorner.Parent = online

    local onlineBorder = Instance.new("UIStroke")
    onlineBorder.Color = Color3.fromRGB(255, 255, 255)
    onlineBorder.Thickness = 1.5
    onlineBorder.Parent = online

    local nickname = Instance.new("TextLabel")
    nickname.Name = "DisplayName"
    nickname.BackgroundTransparency = 1
    nickname.Position = UDim2.fromOffset(57, 9)
    nickname.Size = UDim2.new(1, -65, 0, 19)
    nickname.Font = Enum.Font.GothamBold
    nickname.Text = LocalPlayer.DisplayName
    nickname.TextColor3 = Color3.fromRGB(55, 41, 98)
    nickname.TextSize = 12
    nickname.TextXAlignment = Enum.TextXAlignment.Left
    nickname.TextTruncate = Enum.TextTruncate.AtEnd
    nickname.ZIndex = card.ZIndex + 2
    nickname.Parent = card

    local username = Instance.new("TextLabel")
    username.Name = "Username"
    username.BackgroundTransparency = 1
    username.Position = UDim2.fromOffset(57, 29)
    username.Size = UDim2.new(1, -65, 0, 17)
    username.Font = Enum.Font.GothamMedium
    username.Text = "@" .. LocalPlayer.Name
    username.TextColor3 = Color3.fromRGB(139, 123, 174)
    username.TextSize = 10
    username.TextXAlignment = Enum.TextXAlignment.Left
    username.TextTruncate = Enum.TextTruncate.AtEnd
    username.ZIndex = card.ZIndex + 2
    username.Parent = card

    if type(window.SetProfile) == "function" then
        window:SetProfile({
            name = LocalPlayer.DisplayName,
            username = "@" .. LocalPlayer.Name,
            status = "Script loaded",
            avatar = avatar.Image,
        })
    end

    task.spawn(function()
        local ok, content = pcall(function()
            return Players:GetUserThumbnailAsync(
                LocalPlayer.UserId,
                Enum.ThumbnailType.HeadShot,
                Enum.ThumbnailSize.Size150x150
            )
        end)
        if ok and type(content) == "string" and content ~= ""
            and card.Parent and not window._dead then
            avatar.Image = content
            if type(window.SetProfile) == "function" then
                window:SetProfile({ avatar = content })
            end
        end
    end)
end

addExecutorProfile()

local tab = window:AddTab("Roles", {
    icon = "profile",
    description = "Live roles and player highlights",
})

local overview = tab:AddSection("Round information")
local statusLabel = overview:AddLabel("Source: checking...")
local murdererLabel = overview:AddLabel("Murderer: checking...")
local sheriffLabel = overview:AddLabel("Sheriff: checking...")
local heroLabel = overview:AddLabel("Hero: checking...")
local innocentLabel = overview:AddLabel("Innocents: checking...")
local unknownLabel = overview:AddLabel("Unknown: checking...")

local settings = { esp = true, tags = true, innocents = true }
local visualSection = tab:AddSection("Visual settings")

local session = { running = true }
local stopExtras = function() end
environment.MM2LumenRoles = session

local COLORS = {
    Murderer = Color3.fromRGB(240, 60, 75),
    Sheriff = Color3.fromRGB(65, 145, 255),
    Innocent = Color3.fromRGB(65, 205, 120),
    Hero = Color3.fromRGB(255, 200, 65),
}

local MARK_HIGHLIGHT = "MM2LumenRoleHighlight"
local MARK_TAG = "MM2LumenRoleTag"
local remote
local remoteRoles = {}
local lastRemoteSuccess = -math.huge
local requesting = false

local function deleteVisuals(character)
    if not character then return end
    local highlight = character:FindFirstChild(MARK_HIGHLIGHT)
    if highlight then highlight:Destroy() end
    local head = character:FindFirstChild("Head")
    local tag = head and head:FindFirstChild(MARK_TAG)
    if tag then tag:Destroy() end
end

local function clearAllVisuals()
    for _, player in ipairs(Players:GetPlayers()) do
        deleteVisuals(player.Character)
    end
end

function session.Stop()
    if not session.running then return end
    session.running = false
    stopExtras()
    clearAllVisuals()
    if window and not window._dead then window:Destroy() end
    if environment.MM2LumenRoles == session then
        environment.MM2LumenRoles = nil
    end
end

local function requestRoles()
    if requesting or not session.running then return end
    if not remote or not remote.Parent then
        remote = ReplicatedStorage:FindFirstChild("GetPlayerData", true)
    end
    if not remote or not remote:IsA("RemoteFunction") then return end

    requesting = true
    task.spawn(function()
        local ok, response = pcall(function()
            return remote:InvokeServer()
        end)
        if session.running then
            if ok and type(response) == "table" then
                remoteRoles = response
                lastRemoteSuccess = os.clock()
            else
                remoteRoles = {}
                lastRemoteSuccess = -math.huge
            end
        end
        requesting = false
    end)
end

local function equippedToolRole(player)
    local character = player.Character
    if not character then return "Unknown" end
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Tool") then
            local name = string.lower(child.Name)
            if name:find("knife", 1, true) then return "Murderer" end
            if name:find("gun", 1, true) or name:find("revolver", 1, true) then
                return "Sheriff" 
            end
        end
    end
    return "Unknown"
end

local function getPlayerRole(player)

    if os.clock() - lastRemoteSuccess <= 4 then
        local info = remoteRoles[player.Name]
        if type(info) == "table" then
            local role = info.Role
            if COLORS[role] then
                return role, not (info.Dead == true or info.Killed == true)
            end
        end
    end

    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    local alive = humanoid ~= nil and humanoid.Health > 0
    return equippedToolRole(player), alive
end

local function updateVisual(player, role, alive)
    if player == LocalPlayer then return end
    local character = player.Character
    if not character then return end

    local visibleRole = COLORS[role] and alive and
        (role ~= "Innocent" or settings.innocents)
    local color = COLORS[role]

    local highlight = character:FindFirstChild(MARK_HIGHLIGHT)
    if settings.esp and visibleRole then
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Name = MARK_HIGHLIGHT
            highlight.Adornee = character
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.FillTransparency = 0.70
            highlight.OutlineTransparency = 0
            highlight.Parent = character
        end
        highlight.FillColor = color
        highlight.OutlineColor = color
    elseif highlight then
        highlight:Destroy()
    end

    local head = character:FindFirstChild("Head")
    if not head then return end
    local tag = head:FindFirstChild(MARK_TAG)
    if settings.tags and visibleRole then
        if not tag then
            tag = Instance.new("BillboardGui")
            tag.Name = MARK_TAG
            tag.Adornee = head
            tag.Size = UDim2.fromOffset(200, 40)
            tag.StudsOffsetWorldSpace = Vector3.new(0, 2.3, 0)
            tag.AlwaysOnTop = true
            tag.MaxDistance = 2500
            tag.Parent = head

            local label = Instance.new("TextLabel")
            label.Name = "RoleText"
            label.BackgroundTransparency = 1
            label.Size = UDim2.fromScale(1, 1)
            label.Font = Enum.Font.GothamBold
            label.TextSize = 14
            label.TextStrokeTransparency = 0.25
            label.TextScaled = false
            label.Parent = tag
        end
        local label = tag:FindFirstChild("RoleText")
        if label then
            label.Text = player.DisplayName .. " [" .. role .. "]"
            label.TextColor3 = color
        end
    elseif tag then
        tag:Destroy()
    end
end

visualSection:AddSwitch("Role ESP", function(value)
    settings.esp = value
end, { default = true, description = "See role highlights through walls" })

visualSection:AddSwitch("Role name tags", function(value)
    settings.tags = value
end, { default = true, description = "Display the role above each player" })

visualSection:AddSwitch("Show Innocents", function(value)
    settings.innocents = value
end, { default = true, description = "Include Innocents in highlights and tags" })

local function displayPlayer(player, alive)
    local suffix = player == LocalPlayer and " (you)" or ""
    if not alive then suffix = suffix .. " [out]" end
    return "@" .. player.Name .. suffix
end

local function updateOverview()
    local groups = {
        Murderer = {}, Sheriff = {}, Hero = {}, Innocent = {}, Unknown = {}
    }

    for _, player in ipairs(Players:GetPlayers()) do
        local role, alive = getPlayerRole(player)
        table.insert(groups[role], displayPlayer(player, alive))
        updateVisual(player, role, alive)
    end

    for _, group in pairs(groups) do table.sort(group) end
    local function groupText(group)
        return #group > 0 and table.concat(group, ", ") or "Not identified"
    end

    murdererLabel.Text = "Murderer: " .. groupText(groups.Murderer)
    sheriffLabel.Text = "Sheriff: " .. groupText(groups.Sheriff)
    heroLabel.Text = "Hero: " .. groupText(groups.Hero)
    innocentLabel.Text = "Innocents (" .. #groups.Innocent .. "): " .. groupText(groups.Innocent)
    unknownLabel.Text = "Unknown (" .. #groups.Unknown .. "): " .. groupText(groups.Unknown)

    if os.clock() - lastRemoteSuccess <= 4 then
        statusLabel.Text = "Source: MM2 GetPlayerData (server response)"
    elseif requesting then
        statusLabel.Text = "Source: waiting for server; showing visible weapons only"
    else
        statusLabel.Text = "Source: visible weapons only (unconfirmed players = Unknown)"
    end
end

visualSection:AddButton("Refresh roles now", function()
    requestRoles()
    updateOverview()
end)

visualSection:AddButton("Stop script and remove ESP", session.Stop)

local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")

local farmTab = window:AddTab("Farming", {
    icon = "bag",
    description = "Coins, XP survival and utilities",
})

local farm = {
    autoCoins = false,
    survivalXP = false,
    coinTracer = false,
    protection = false, 
    gunESP = false,
    speed = 42,
    targetStrategy = "Distributed",
    avoidPlayers = true,
    avoidRadius = 30,
    selectionRound = 0,
    bagLimit = 40, 
    bagSource = "not detected",
    activeContainer = nil,
    flyActive = false,
    flyRoot = nil,
    flyAttachment = nil,
    flyForce = nil,
    originalAutoRotate = nil,
    originalPlatformStand = nil,
    lastBagPoll = 0,
    ignoreFullUntil = 0,
    bagCurrent = nil,
    bagMax = nil,
    bagFull = false,
    roundActive = nil,
    coins = {},
    skipped = {},
    collectedEstimate = 0,
    lastScan = 0,
    moveTarget = nil,
    moveToken = 0,
    moveHumanoid = nil,
    originalWalkSpeed = nil,
    noclipUntil = 0,
    collisionOriginal = {},
    flingCollisionOriginal = {},
    tracerOrigin = nil,
    tracers = {},
    gunTarget = nil,
    gunHighlight = nil,
    gunBillboard = nil,
    gunLabel = nil,
    connections = {},
}

local farmSection = farmTab:AddSection("Coins, Items & XP")
local farmStatus = farmSection:AddLabel("Coin farm: disabled")
local bagStatus = farmSection:AddLabel("Coin bag: waiting for server data")
local coinStatus = farmSection:AddLabel("Collectibles in map: 0")
local xpStatus = farmSection:AddLabel("XP: awarded by MM2 during/after rounds")

local function remember(connection)
    table.insert(farm.connections, connection)
    return connection
end

local function rootAndHumanoid()
    local character = LocalPlayer.Character
    if not character then return nil end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root or not humanoid or humanoid.Health <= 0 then return nil end
    return root, humanoid, character
end

local function cancelMove()
    farm.moveToken = farm.moveToken + 1
    farm.moveTarget = nil
    farm.flyActive = false
    farm.noclipUntil = 0

    if farm.flyForce then pcall(function() farm.flyForce:Destroy() end) end
    if farm.flyAttachment then pcall(function() farm.flyAttachment:Destroy() end) end
    farm.flyForce, farm.flyAttachment = nil, nil

    local root = farm.flyRoot
    if root and root.Parent then
        pcall(function()
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end)
    end
    if farm.moveHumanoid and farm.moveHumanoid.Parent then
        local humanoid = farm.moveHumanoid
        pcall(function()
            if farm.originalAutoRotate ~= nil then
                humanoid.AutoRotate = farm.originalAutoRotate
            end
            if farm.originalPlatformStand ~= nil then
                humanoid.PlatformStand = farm.originalPlatformStand
            end
            if not humanoid.PlatformStand and humanoid.Health > 0 then
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end)
    end
    farm.flyRoot = nil
    farm.moveHumanoid = nil
    farm.originalAutoRotate = nil
    farm.originalPlatformStand = nil
end

local function restoreCollision()
    for part, original in pairs(farm.collisionOriginal) do
        if part and part.Parent then
            pcall(function() part.CanCollide = original end)
        end
        farm.collisionOriginal[part] = nil
    end
end

local function restoreFlingCollision()
    for part, original in pairs(farm.flingCollisionOriginal) do
        if part and part.Parent then
            pcall(function() part.CanCollide = original end)
        end
        farm.flingCollisionOriginal[part] = nil
    end
end

local function clearCoinTracers()
    for coin, objects in pairs(farm.tracers) do
        for _, obj in ipairs(objects) do
            if obj and obj.Parent then obj:Destroy() end
        end
        farm.tracers[coin] = nil
    end
    if farm.tracerOrigin and farm.tracerOrigin.Parent then
        farm.tracerOrigin:Destroy()
    end
    farm.tracerOrigin = nil
end

local function clearGunESP()
    if farm.gunHighlight then farm.gunHighlight:Destroy() end
    if farm.gunBillboard then farm.gunBillboard:Destroy() end
    farm.gunTarget, farm.gunHighlight, farm.gunBillboard, farm.gunLabel = nil, nil, nil, nil
end

local ITEM_NAMES = {
    coin = true, coin_server = true, candy = true, token = true,
    snowflake = true, pumpkin = true, egg = true, present = true,
    gift = true, star = true, shard = true, beachball = true,
}

local function isCollectibleName(name)
    local n = name:lower()
    if ITEM_NAMES[n] then return true end
    for keyword in pairs(ITEM_NAMES) do
        if n:find(keyword, 1, true) then return true end
    end
    return false
end

local function hasPickupMarker(node)
    return node:FindFirstChild("TouchInterest", true) ~= nil
        or node:FindFirstChild("CoinVisual", true) ~= nil
end

local function selectPickupPart(node)
    if node:IsA("BasePart") then return node end
    if not node:IsA("Model") and not node:IsA("Folder") then return nil end

    for _, desc in ipairs(node:GetDescendants()) do
        if desc:IsA("BasePart") and desc:FindFirstChildOfClass("TouchTransmitter") then
            return desc
        end
    end
    for _, name in ipairs({"Coin_Server", "Coin", "Candy", "Token", "Handle"}) do
        local part = node:FindFirstChild(name, true)
        if part and part:IsA("BasePart") then return part end
    end
    if node:IsA("Model") and node.PrimaryPart then return node.PrimaryPart end
    return node:FindFirstChildWhichIsA("BasePart", true)
end

local function collectedMarker(node)
    if node:GetAttribute("Collected") == true or node:GetAttribute("Delete") == true then
        return true
    end
    local visual = node:FindFirstChild("CoinVisual", true)
    if visual and (visual:GetAttribute("Collected") == true
        or visual:GetAttribute("Delete") == true) then return true end
    return false
end

local function scanCoins()
    local found = {}
    local seen = {}
    local activeContainer
    for _, container in ipairs(Workspace:GetDescendants()) do
        if container.Name == "CoinContainer" then
            local ancestor = container.Parent
            local insideLobby = false
            while ancestor and ancestor ~= Workspace do
                if ancestor.Name:lower() == "lobby" then
                    insideLobby = true
                    break
                end
                ancestor = ancestor.Parent
            end
            if not insideLobby then
                if not activeContainer then activeContainer = container end
                for _, node in ipairs(container:GetChildren()) do
                    local part = selectPickupPart(node)
                    if part and (isCollectibleName(node.Name) or hasPickupMarker(node))
                        and not collectedMarker(node) and not seen[node] then
                        seen[node] = true
                        table.insert(found, {
                            part = part,
                            node = node,
                            container = container,
                            label = node.Name,
                        })
                    end
                end
            end
        end
    end

    if activeContainer and farm.activeContainer and activeContainer ~= farm.activeContainer then
        farm.bagCurrent, farm.bagMax, farm.bagFull = nil, nil, false
        farm.bagSource = "new map"
        farm.ignoreFullUntil = os.clock() + 2
        farm.skipped = {}
    end

    if activeContainer then farm.activeContainer = activeContainer end
    farm.coins = found
    farm.lastScan = os.clock()
end

local function validCoin(record)
    if not record or not record.part or not record.node then return false end
    local part, node, container = record.part, record.node, record.container
    if not part:IsA("BasePart") or not part.Parent or not node.Parent then return false end
    if node.Parent ~= container or not container:IsDescendantOf(Workspace) then return false end
    if collectedMarker(node) then return false end
    if farm.skipped[node] and os.clock() < farm.skipped[node] then return false end
    return true
end

local function coinAssignment(position, groupSize)
    local x = math.floor(position.X * 2 + 0.5)
    local y = math.floor(position.Y * 2 + 0.5)
    local z = math.floor(position.Z * 2 + 0.5)

    local value = ((x * 73856093 + y * 19349663 + z * 83492791) % 2147483647)
    return (value % groupSize) + 1, value
end

local function findDistributedCoin(origin)
    local users = Players:GetPlayers()
    table.sort(users, function(a, b) return a.UserId < b.UserId end)
    local groupSize = math.max(#users, 1)
    local ownIndex = 1
    for i, user in ipairs(users) do
        if user == LocalPlayer then ownIndex = i; break end
    end

    local competitors = {}
    if farm.avoidPlayers then
        for _, user in ipairs(users) do
            if user ~= LocalPlayer then
                local char = user.Character
                local otherRoot = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if otherRoot and hum and hum.Health > 0 then
                    table.insert(competitors, otherRoot.Position)
                end
            end
        end
    end

    local target, best = nil, math.huge
    farm.selectionRound = farm.selectionRound + 1
    for _, record in ipairs(farm.coins) do
        if validCoin(record) then
            local position = record.part.Position
            local distance = (position - origin).Magnitude
            local slot, hash = coinAssignment(position, groupSize)

            local personal = ((hash + LocalPlayer.UserId * 131) % 997) / 997
            local score
            if farm.targetStrategy == "Farthest First" then
                score = -distance + personal * 22
            elseif farm.targetStrategy == "Random Spread" then
                score = personal * 140 + distance * 0.09

                score = score + ((hash * 7 + farm.selectionRound * 113 + LocalPlayer.UserId) % 151) * 0.7
            else

                score = distance * 0.17 + personal * 20
                if slot ~= ownIndex then score = score + 170 end
            end

            if farm.avoidPlayers then
                for _, otherPosition in ipairs(competitors) do
                    local separation = (position - otherPosition).Magnitude
                    if separation < farm.avoidRadius then
                        score = score + (farm.avoidRadius - separation) * 7 + 80
                    end
                end
            end

            if score < best then
                target, best = record, score
            end
        end
    end
    return target
end

local function canFarmCoins()
    if not session.running or not farm.autoCoins or farm.bagFull or farm.roundActive == false then
        return false
    end
    return rootAndHumanoid() ~= nil
end

local function beginFly(root, humanoid)
    farm.flyRoot = root
    farm.moveHumanoid = humanoid
    farm.originalAutoRotate = humanoid.AutoRotate
    farm.originalPlatformStand = humanoid.PlatformStand
    farm.flyActive = true
    humanoid.AutoRotate = false
    humanoid.PlatformStand = true

    local attachment = Instance.new("Attachment")
    attachment.Name = "MM2LumenFlightAttachment"
    attachment.Parent = root
    local force = Instance.new("VectorForce")
    force.Name = "MM2LumenFlightStabilizer"
    force.Attachment0 = attachment
    force.RelativeTo = Enum.ActuatorRelativeTo.World
    force.ApplyAtCenterOfMass = true
    force.Force = Vector3.new(0, root.AssemblyMass * Workspace.Gravity, 0)
    force.Parent = root
    farm.flyAttachment = attachment
    farm.flyForce = force
end

local function moveToCoin(record)
    local root, humanoid, character = rootAndHumanoid()
    if not root or not validCoin(record) then return end
    local token = farm.moveToken
    farm.moveTarget = record.part
    beginFly(root, humanoid)

    local start = os.clock()
    local travel = (root.Position - record.part.Position).Magnitude
    local deadline = start + math.clamp(travel / math.max(15, farm.speed) * 3 + 5, 6, 35)
    local closeSince
    local originalRotation = root.CFrame.Rotation

    while session.running and token == farm.moveToken and canFarmCoins()
        and validCoin(record) and root.Parent == character and os.clock() < deadline do
        local dt = RunService.Heartbeat:Wait()

        dt = math.clamp(type(dt) == "number" and dt or (1 / 60), 1 / 240, 0.07)
        if token ~= farm.moveToken or not canFarmCoins() or not validCoin(record) then break end

        local goal = record.part.Position + Vector3.new(0, 1, 0)
        local delta = goal - root.Position
        local dist = delta.Magnitude
        if dist > 0.8 then
            closeSince = nil
            local step = math.min(dist, farm.speed * dt)
            local nextPosition = root.Position + delta.Unit * step
            root.CFrame = CFrame.new(nextPosition) * originalRotation
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        else

            if not closeSince then closeSince = os.clock() end
            root.CFrame = CFrame.new(goal) * originalRotation
            root.AssemblyLinearVelocity = Vector3.zero
            if os.clock() - closeSince >= 0.32 then break end
        end

        if farm.flyForce and farm.flyForce.Parent then
            farm.flyForce.Force = Vector3.new(0, root.AssemblyMass * Workspace.Gravity, 0)
        end
        if os.clock() - farm.lastBagPoll > 0.15 and farm.pollBag then
            farm.lastBagPoll = os.clock()
            farm.pollBag()
        end
        farmStatus.Text = string.format("Flying to %s (%d studs)", record.label,
            math.floor(dist))
    end

    if token == farm.moveToken then
        if validCoin(record) and not farm.bagFull then

            farm.skipped[record.node] = os.clock() + 2.5
        end
        cancelMove()
    end
end

task.spawn(function()
    while session.running and not window._dead do
        if farm.pollBag then farm.pollBag() end
        if canFarmCoins() then
            if os.clock() - farm.lastScan >= 1.6 then scanCoins() end
            local root = rootAndHumanoid()
            if root then
                local item = findDistributedCoin(root.Position)
                if item then
                    moveToCoin(item)
                else
                    farmStatus.Text = "Farm: waiting for valid items"
                    task.wait(0.4)
                end
            end
        else
            if farm.moveTarget then cancelMove() end
            if farm.autoCoins then
                farmStatus.Text = farm.bagFull and "Farm: BAG FULL - stopped"
                    or (farm.roundActive == false and "Farm: next round"
                        or "Farm: waiting to spawn")
            else
                farmStatus.Text = "Farm: disabled"
            end
            task.wait(0.3)
        end
        task.wait(0.09)
    end
end)

local function updateCoinTracers()
    local root = rootAndHumanoid()
    if not farm.coinTracer or not root then
        if farm.tracerOrigin then clearCoinTracers() end
        return
    end
    if not farm.tracerOrigin or farm.tracerOrigin.Parent ~= root then
        clearCoinTracers()
        farm.tracerOrigin = Instance.new("Attachment")
        farm.tracerOrigin.Name = "MM2LumenCoinOrigin"
        farm.tracerOrigin.Parent = root
    end
    local nearby = {}
    for _, record in ipairs(farm.coins) do
        if validCoin(record) then
            local dist = (root.Position - record.part.Position).Magnitude
            if dist <= 250 then
                table.insert(nearby, { coin = record.part, dist = dist })
            end
        end
    end
    table.sort(nearby, function(a, b) return a.dist < b.dist end)
    local selected = {}
    for i = 1, math.min(12, #nearby) do
        local coin = nearby[i].coin
        selected[coin] = true
        if not farm.tracers[coin] then
            local endPoint = Instance.new("Attachment")
            endPoint.Name = "MM2LumenCoinTarget"
            endPoint.Parent = coin
            local beam = Instance.new("Beam")
            beam.Name = "MM2LumenCoinBeam"
            beam.Attachment0 = farm.tracerOrigin
            beam.Attachment1 = endPoint
            beam.FaceCamera = true
            beam.LightEmission = 0.9
            beam.Width0 = 0.07
            beam.Width1 = 0.07
            beam.Color = ColorSequence.new(Color3.fromRGB(255, 205, 45))
            beam.Transparency = NumberSequence.new(0.12)
            beam.Parent = root
            farm.tracers[coin] = {beam, endPoint}
        end
    end
    for coin, objects in pairs(farm.tracers) do
        if not selected[coin] then
            for _, object in ipairs(objects) do
                if object and object.Parent then object:Destroy() end
            end
            farm.tracers[coin] = nil
        end
    end
end

local function updateGunESP()
    if not farm.gunESP then
        clearGunESP()
        return
    end
    local gun = Workspace:FindFirstChild("GunDrop", true)
    if gun and not (gun:IsA("BasePart") or gun:IsA("Model")) then gun = nil end
    if gun ~= farm.gunTarget then
        clearGunESP()
        if gun then
            farm.gunTarget = gun
            local part = gun:IsA("BasePart") and gun or gun:FindFirstChildWhichIsA("BasePart", true)
            if not part then farm.gunTarget = nil return end
            local highlight = Instance.new("Highlight")
            highlight.Name = "MM2LumenDroppedGunESP"
            highlight.Adornee = gun
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.FillColor = Color3.fromRGB(80, 195, 255)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.45
            highlight.Parent = gun
            farm.gunHighlight = highlight

            local billboard = Instance.new("BillboardGui")
            billboard.Name = "MM2LumenGunLabel"
            billboard.Adornee = part
            billboard.AlwaysOnTop = true
            billboard.Size = UDim2.fromOffset(160, 34)
            billboard.StudsOffsetWorldSpace = Vector3.new(0, 2.5, 0)
            billboard.MaxDistance = 2000
            billboard.Parent = part
            local textLabel = Instance.new("TextLabel")
            textLabel.BackgroundTransparency = 1
            textLabel.Size = UDim2.fromScale(1, 1)
            textLabel.TextColor3 = Color3.fromRGB(100, 210, 255)
            textLabel.Font = Enum.Font.GothamBold
            textLabel.TextSize = 15
            textLabel.TextStrokeTransparency = 0.15
            textLabel.Parent = billboard
            farm.gunBillboard = billboard
            farm.gunLabel = textLabel
        end
    end
    if farm.gunLabel and farm.gunTarget then
        local root = rootAndHumanoid()
        local part = farm.gunTarget:IsA("BasePart") and farm.gunTarget
            or farm.gunTarget:FindFirstChildWhichIsA("BasePart", true)
        if part then
            local dist = root and math.floor((root.Position - part.Position).Magnitude) or 0
            farm.gunLabel.Text = "DROPPED GUN" .. (root and " [" .. dist .. "m]" or "")
        end
    end
end

local lastEvade = 0
local function avoidMurderer()
    if not farm.survivalXP or os.clock() - lastEvade < 0.6 then return end
    if farm.autoCoins then return end 
    local root, humanoid = rootAndHumanoid()
    if not root then return end
    local ownRole = getPlayerRole(LocalPlayer)
    if ownRole == "Murderer" then return end
    local enemyRoot
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local role, alive = getPlayerRole(player)
            if role == "Murderer" and alive and player.Character then
                enemyRoot = player.Character:FindFirstChild("HumanoidRootPart")
                if enemyRoot then break end
            end
        end
    end
    if not enemyRoot then return end
    local delta = root.Position - enemyRoot.Position
    local flatDelta = Vector3.new(delta.X, 0, delta.Z)
    if flatDelta.Magnitude > 25 or flatDelta.Magnitude < 0.1 then return end
    local candidate = root.Position + flatDelta.Unit * 18
 
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character, enemyRoot.Parent}
    local hit = Workspace:Raycast(candidate + Vector3.new(0, 7, 0), Vector3.new(0, -22, 0), rayParams)
    if hit and hit.Instance and hit.Normal.Y > 0.4 then
        lastEvade = os.clock()
        humanoid:MoveTo(Vector3.new(candidate.X, hit.Position.Y + 3, candidate.Z))
    end
end

local lastProtectionCheck = 0
remember(RunService.Heartbeat:Connect(function()
    if not session.running or not farm.protection then return end
    if os.clock() - lastProtectionCheck < 0.12 then return end
    lastProtectionCheck = os.clock()
    local root = rootAndHumanoid()
    if not root then return end

    if farm.flyActive then return end

    local velocity = root.AssemblyLinearVelocity
    local horizontal = Vector3.new(velocity.X, 0, velocity.Z)
    if horizontal.Magnitude > 95 or root.AssemblyAngularVelocity.Magnitude > 24 then
        root.AssemblyLinearVelocity = Vector3.new(0, math.clamp(velocity.Y, -70, 70), 0)
        root.AssemblyAngularVelocity = Vector3.zero
    end

    local dangerous = {}
    for _, other in ipairs(Players:GetPlayers()) do
        if other ~= LocalPlayer and other.Character then
            local otherRoot = other.Character:FindFirstChild("HumanoidRootPart")
            if otherRoot and (otherRoot.Position - root.Position).Magnitude < 18
                and (otherRoot.AssemblyAngularVelocity.Magnitude > 22
                    or otherRoot.AssemblyLinearVelocity.Magnitude > 110) then
                for _, part in ipairs(other.Character:GetDescendants()) do
                    if part:IsA("BasePart") then dangerous[part] = true end
                end
            end
        end
    end
    for part, original in pairs(farm.flingCollisionOriginal) do
        if not dangerous[part] then
            if part.Parent then pcall(function() part.CanCollide = original end) end
            farm.flingCollisionOriginal[part] = nil
        end
    end
    for part in pairs(dangerous) do
        if farm.flingCollisionOriginal[part] == nil then
            farm.flingCollisionOriginal[part] = part.CanCollide
        end
        part.CanCollide = false
    end
end))

remember(RunService.Stepped:Connect(function()
    if not session.running then return end
    local root, humanoid, character = rootAndHumanoid()
    local shouldNoclip = farm.autoCoins and farm.flyActive and not farm.bagFull
        and root and humanoid and character
        and farm.flyRoot == root
    if shouldNoclip then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                if farm.collisionOriginal[part] == nil then
                    farm.collisionOriginal[part] = part.CanCollide
                end
                part.CanCollide = false
            end
        end
    elseif next(farm.collisionOriginal) ~= nil then
        restoreCollision()
    end
end))

local function bagFromHUD()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local main = playerGui and playerGui:FindFirstChild("MainGUI")
    local gamePanel = main and main:FindFirstChild("Game")
    local bags = gamePanel and gamePanel:FindFirstChild("CoinBags")
    local container = bags and bags:FindFirstChild("Container")
    if not container then return nil, nil, false end

    local current, maximum
    local fullVisible = false
    for _, bag in ipairs(container:GetChildren()) do
        if bag:IsA("GuiObject") and bag.Visible then
            local full = bag:FindFirstChild("Full", true)
                or bag:FindFirstChild("FullBagIcon", true)
            if full and full:IsA("GuiObject") and full.Visible then
                fullVisible = true
            end
            local currency = bag:FindFirstChild("CurrencyFrame", true)
            local coinText = currency and currency:FindFirstChild("Coins", true)
            if coinText and (coinText:IsA("TextLabel") or coinText:IsA("TextButton")) then
                local numbers = {}
                for n in coinText.Text:gmatch("%d+") do
                    table.insert(numbers, tonumber(n))
                end
                if #numbers >= 1 then current = numbers[1] end
                if #numbers >= 2 then maximum = numbers[2] end
            end
        end
    end
    return current, maximum, fullVisible
end

local function resetBag(source)
    farm.bagCurrent, farm.bagMax, farm.bagFull = nil, nil, false
    farm.bagSource = source or "new round"
    farm.ignoreFullUntil = os.clock() + 2
    farm.skipped = {}
    farm.lastScan = 0
end

local function applyBag(current, maximum, fullIcon, source)
    if not session.running then return end
    if type(current) == "number" and current >= 0 then
        current = math.floor(current)
        if type(maximum) == "number" and maximum > 0 and maximum <= 500 then
            farm.bagMax = math.floor(maximum)
        end
        local cap = farm.bagMax or farm.bagLimit
        if farm.bagFull and current == 0 and not fullIcon and farm.roundActive ~= false
            and (not farm.activeContainer or not farm.activeContainer.Parent) then

            resetBag("bag reset")
        end
        farm.bagCurrent = current
        farm.bagSource = source
        if current >= cap then farm.bagFull = true end
    end
    if fullIcon and os.clock() >= farm.ignoreFullUntil then
        farm.bagFull = true
        farm.bagSource = "MM2 Full indicator"
    end
    if farm.bagFull and farm.flyActive then
        cancelMove()
        restoreCollision()
    end
end

farm.pollBag = function()
    local count, max, full = bagFromHUD()
    if count ~= nil or full then
        applyBag(count, max, full, "HUD")
    end
end

task.spawn(function()

    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        or ReplicatedStorage:WaitForChild("Remotes", 15)
    if not session.running or not remotes then return end
    local gameplay = remotes:FindFirstChild("Gameplay")
        or remotes:WaitForChild("Gameplay", 15)
    if not session.running or not gameplay then return end

    local coinEvent = gameplay:FindFirstChild("CoinCollected")
        or gameplay:WaitForChild("CoinCollected", 5)
    if session.running and coinEvent and coinEvent:IsA("RemoteEvent") then
        remember(coinEvent.OnClientEvent:Connect(function(...)

            local numbers = {}
            for i = 1, select("#", ...) do
                local value = select(i, ...)
                if type(value) == "number" then
                    table.insert(numbers, value)
                end
            end
            if #numbers < 2 then return end
            local current, maximum = numbers[#numbers - 1], numbers[#numbers]
            if maximum > 0 and current >= 0 and current <= maximum then
                applyBag(current, maximum, false, "CoinCollected")
                farm.collectedEstimate = current
            end
        end))
    end
    for _, eventName in ipairs({"RoundStart", "CoinsStarted"}) do
        local started = gameplay:FindFirstChild(eventName)
        if started and started:IsA("RemoteEvent") and session.running then
            remember(started.OnClientEvent:Connect(function()
                farm.roundActive = true
                resetBag(eventName)
            end))
        end
    end
    local ended = gameplay:FindFirstChild("RoundEndFade")
    if ended and ended:IsA("RemoteEvent") and session.running then
        remember(ended.OnClientEvent:Connect(function()
            farm.roundActive = false
            cancelMove()
            clearCoinTracers()
        end))
    end
end)

remember(LocalPlayer.CharacterAdded:Connect(function()
    cancelMove()
    restoreCollision()
    clearCoinTracers()
    farm.noclipUntil = 0
    restoreFlingCollision()
    farm.skipped = {}
    farm.activeContainer = nil
end))

farmSection:AddSwitch("Auto Farm Coins & Items", function(value)
    farm.autoCoins = value
    if not value then
        cancelMove()
        restoreCollision()
    else
        farm.lastScan = 0
    end
end, { default = false, description = "Fly directly to real coins/items, with automatic NoClip and bag-stop" })

farmSection:AddLabel("Global selection: all map coins, not just nearby items")
local strategyDropdown = farmSection:AddDropdown("Coin Target Strategy", function(value)
    farm.targetStrategy = value
    farm.skipped = {}
    if farm.moveTarget then cancelMove() end
end)
strategyDropdown:Add("Distributed")
strategyDropdown:Add("Farthest First")
strategyDropdown:Add("Random Spread")
strategyDropdown:Set("Distributed", true)

farmSection:AddSwitch("Avoid Other Players' Coins", function(value)
    farm.avoidPlayers = value
end, { default = true, description = "Prefer coins without other players nearby" })

farmSection:AddSlider("Player Avoidance Radius", function(value)
    farm.avoidRadius = value
end, { min = 10, max = 90, step = 5, default = 30, suffix = " studs" })

farmSection:AddSwitch("Auto XP / Survival", function(value)
    farm.survivalXP = value
end, { default = false, description = "Evade a nearby Murderer; Anti AFK now has its own tab" })

farmSection:AddSlider("Farm Fly Speed", function(value)
    farm.speed = math.clamp(value, 16, 100)
end, { min = 16, max = 100, step = 2, default = 42, suffix = " studs/s" })

farmSection:AddSlider("Coin Bag Limit (Elite = 50)", function(value)
    farm.bagLimit = math.clamp(math.floor(value), 40, 50)
    -- A contagem real recebida do servidor continua tendo prioridade.
    if farm.bagCurrent and farm.bagCurrent >= (farm.bagMax or farm.bagLimit) then
        farm.bagFull = true
        cancelMove()
        restoreCollision()
    end
end, { min = 40, max = 50, step = 10, default = 40, suffix = " coins" })

local utilitySection = farmTab:AddSection("Visuals & Protection")
utilitySection:AddSwitch("Coin Tracer", function(value)
    farm.coinTracer = value
    farm.lastScan = 0
    if not value then clearCoinTracers() end
end, { default = false, description = "Beams to up to 12 nearby coins" })

utilitySection:AddSwitch("Gun ESP", function(value)
    farm.gunESP = value
    if not value then clearGunESP() end
end, { default = false, description = "Highlight the dropped Sheriff gun" })

utilitySection:AddSwitch("Protection: Anti-Fling + NoClip + Anti-KB", function(value)
    farm.protection = value
    if not value then
        farm.noclipUntil = 0
        restoreCollision()
        restoreFlingCollision()
    end
end, { default = false, description = "Anti-fling + Anti-KB; NoClip is already automatic during flying farm" })

utilitySection:AddButton("Rescan Coins & Items", function()
    scanCoins()
    window:Notify("MM2 Farming", "Collectible locations refreshed", 2)
end)

task.spawn(function()
    while session.running and not window._dead do
        if farm.pollBag then farm.pollBag() end
        if farm.autoCoins or farm.coinTracer then
            if os.clock() - farm.lastScan >= 2 then scanCoins() end
        end
        if farm.coinTracer then updateCoinTracers() end
        if farm.gunESP then updateGunESP() end
        if farm.survivalXP then avoidMurderer() end
        if farm.bagCurrent ~= nil then
            bagStatus.Text = string.format("Coin bag: %d / %d%s", farm.bagCurrent,
                farm.bagMax or farm.bagLimit, farm.bagFull and " (FULL - STOPPED)" or "")
        elseif farm.bagFull then
            bagStatus.Text = "Coin bag: FULL - farm stopped"
        else
            bagStatus.Text = "Coin bag: waiting for HUD | fallback " .. tostring(farm.bagLimit)
        end
        local validCount = 0
        for _, record in ipairs(farm.coins) do
            if validCoin(record) then validCount = validCount + 1 end
        end
        coinStatus.Text = "Available coins/items: " .. tostring(validCount)
        xpStatus.Text = farm.survivalXP
            and "XP survival: enabled (server decides rewards)"
            or "XP survival: disabled"
        task.wait(0.7)
    end
end)

stopExtras = function()
    farm.autoCoins, farm.coinTracer, farm.survivalXP = false, false, false
    farm.protection, farm.gunESP = false, false
    cancelMove()
    restoreCollision()
    restoreFlingCollision()
    clearCoinTracers()
    clearGunESP()
    for _, connection in ipairs(farm.connections) do connection:Disconnect() end
    farm.connections = {}
    farm.coins, farm.skipped = {}, {}
    farm.moveTarget = nil
    farm.pollBag = nil
end

session.Farming = farm

local UserInputService = game:GetService("UserInputService")
local aimTab = window:AddTab("Aim Lock", {
    icon = "bolt",
    description = "Role-based aim, PC keybind and weapon control",
})

local aim = {
    enabled = false, 
    active = false,  
    autoAttack = false,
    autoEquip = false,
    sheriffInnocents = false, 
    visibleOnly = false,
    markTarget = false,
    magicBullet = false,
    magicHookInstalled = false,
    magicHookAvailable = false,
    magicIntercepted = 0,
    mode = "Toggle",
    fov = 300,
    range = 250,
    hardLock = false, 
    smoothing = 0.45, 
    prediction = 0,  
    targetPart = "Head",
    attackInterval = 1.25,
    knifeInput = "E",
    target = nil,
    highlighter = nil,
    attackAt = 0,
    equipAt = 0,
    lastStatus = "Waiting for key",
    lastRenderStatus = 0,
    connections = {},
}

local controlSection = aimTab:AddSection("Aim Lock | PC")
local aimStatus = controlSection:AddLabel("Aim: disabled | Select a key to lock")
local roleStatus = controlSection:AddLabel("Your role: checking...")
local targetStatus = controlSection:AddLabel("Target: none")
local attackStatus = controlSection:AddLabel("Attack: awaiting a weapon")
local magicStatus = controlSection:AddLabel("Magic Bullet: OFF (manual activation)")

local function aimConnect(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(aim.connections, connection)
    return connection
end

local function clearAimTarget()
    aim.target = nil
    if aim.highlighter then
        aim.highlighter:Destroy()
        aim.highlighter = nil
    end
end

local function deactivateAim()
    aim.active = false
    clearAimTarget()
end

local function getCombatRole()
    local role, alive = getPlayerRole(LocalPlayer)
    if not alive then return nil end
    if role == "Murderer" then return "Murderer" end
    if role == "Sheriff" or role == "Hero" then return "Sheriff" end
    return nil
end

local function isAllowedRole(otherRole, myRole)
    if myRole == "Murderer" then
        return otherRole == "Sheriff" or otherRole == "Hero" or otherRole == "Innocent"
    elseif myRole == "Sheriff" then
        return otherRole == "Murderer" or (aim.sheriffInnocents and otherRole == "Innocent")
    end
    return false
end

local function getTargetPart(player)
    local char = player and player.Character
    if not char then return nil end
    return char:FindFirstChild(aim.targetPart)
        or char:FindFirstChild("Head")
        or char:FindFirstChild("HumanoidRootPart")
end

local function predictedPoint(player, part)
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local velocity = root and root.AssemblyLinearVelocity or Vector3.zero

    return part.Position + Vector3.new(velocity.X, 0, velocity.Z) * aim.prediction
end

local function canSeePlayer(camera, player, point)
    local exclude = {}
    if LocalPlayer.Character then table.insert(exclude, LocalPlayer.Character) end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = exclude
    params.IgnoreWater = true
    local diff = point - camera.CFrame.Position
    if diff.Magnitude < 0.01 then return true end
    local result = Workspace:Raycast(camera.CFrame.Position, diff, params)
    return not result or (player.Character and result.Instance:IsDescendantOf(player.Character))
end

local function isValidAimTarget(player, myRole, camera, keepCurrent)
    if not player or player == LocalPlayer then return nil end
    local role, alive = getPlayerRole(player)
    if not alive or not isAllowedRole(role, myRole) then return nil end
    local part = getTargetPart(player)
    if not part or not part:IsDescendantOf(Workspace) then return nil end
    local point = predictedPoint(player, part)

    if not keepCurrent then
        local distance = (part.Position - camera.CFrame.Position).Magnitude
        if distance > aim.range then return nil end
        if aim.visibleOnly and not canSeePlayer(camera, player, point) then return nil end
        local screenPoint, visible = camera:WorldToViewportPoint(point)
        if not visible or screenPoint.Z <= 0 then return nil end
        local center = camera.ViewportSize * 0.5
        local error = (Vector2.new(screenPoint.X, screenPoint.Y) - center).Magnitude
        if error > aim.fov then return nil end
        return part, point, error
    end
    return part, point, 0
end

local function findAimTarget(myRole, camera)
    local bestPlayer, bestError
    for _, player in ipairs(Players:GetPlayers()) do
        local part, point, error = isValidAimTarget(player, myRole, camera, false)
        if part then

            if not bestError or error < bestError then
                bestPlayer, bestError = player, error
            end
        end
    end
    return bestPlayer
end

local function refreshTargetHighlight()
    if not aim.markTarget or not aim.target or not aim.target.Character then
        if aim.highlighter then aim.highlighter:Destroy(); aim.highlighter = nil end
        return
    end
    if aim.highlighter and aim.highlighter.Adornee == aim.target.Character then return end
    if aim.highlighter then aim.highlighter:Destroy() end
    local highlight = Instance.new("Highlight")
    highlight.Name = "MM2LumenAimSelected"
    highlight.Adornee = aim.target.Character
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillColor = Color3.fromRGB(255, 95, 185)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.79
    highlight.OutlineTransparency = 0
    highlight.Parent = aim.target.Character
    aim.highlighter = highlight
end

local function getUsableTool(myRole)
    local character = LocalPlayer.Character
    if not character then return nil end
    local function matching(tool)
        if not tool:IsA("Tool") then return false end
        local name = tool.Name:lower()
        if myRole == "Murderer" then
            return name:find("knife", 1, true) ~= nil
        else
            return name:find("gun", 1, true) ~= nil
                or name:find("revolver", 1, true) ~= nil
                or name:find("pistol", 1, true) ~= nil
        end
    end
    for _, item in ipairs(character:GetChildren()) do
        if matching(item) then return item end
    end
    if aim.autoEquip and os.clock() - aim.equipAt >= 1 then
        local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if backpack and humanoid and humanoid.Health > 0 then
            for _, item in ipairs(backpack:GetChildren()) do
                if matching(item) then
                    aim.equipAt = os.clock()
                    pcall(function() humanoid:EquipTool(item) end)
                    break
                end
            end
        end
    end
    return nil
end

local function sendClick(button, screen)
    local vim
    pcall(function() vim = game:GetService("VirtualInputManager") end)
    if vim then
        local x, y = math.floor(screen.X), math.floor(screen.Y)
        local ok = pcall(function()
            vim:SendMouseButtonEvent(x, y, button, true, game, 0)
            vim:SendMouseButtonEvent(x, y, button, false, game, 0)
        end)
        if ok then return true end
    end
    if button == 0 and type(mouse1click) == "function" then
        return pcall(mouse1click)
    end
    if button == 1 and type(mouse2click) == "function" then
        return pcall(mouse2click)
    end
    return false
end

local function sendKnifeKey()
    local vim
    pcall(function() vim = game:GetService("VirtualInputManager") end)
    if vim then
        local ok = pcall(function()
            vim:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        end)
        if ok then
            task.delay(0.18, function()
                pcall(function() vim:SendKeyEvent(false, Enum.KeyCode.E, false, game) end)
            end)
            return true
        end
    end
    if type(keypress) == "function" and type(keyrelease) == "function" then
        local ok = pcall(function() keypress(0x45) end)
        if ok then
            task.delay(0.18, function() pcall(keyrelease, 0x45) end)
            return true
        end
    end
    return false
end

local function fireWeapon(myRole, tool, camera, point)
    if not tool or not tool:IsDescendantOf(LocalPlayer.Character) then return false end
    if window._visible or UserInputService:GetFocusedTextBox() then
        aim.lastStatus = "Close UI (RightShift) before auto attack"
        return false
    end
    local viewportPos = camera:WorldToViewportPoint(point)
    local screen = Vector2.new(viewportPos.X, viewportPos.Y)
    if myRole == "Murderer" then

        if aim.knifeInput == "Right Mouse" then
            return sendClick(1, screen)
        end
        return sendKnifeKey()
    else
        if sendClick(0, screen) then return true end

        return pcall(function() tool:Activate() end)
    end
end

local function installMagicBulletHook()
    if aim.magicHookInstalled then return true end
    if type(hookmetamethod) ~= "function" or type(getnamecallmethod) ~= "function" then
        return false
    end
    local originalNamecall
    local function redirectedNamecall(remote, ...)
        if session.running and aim.enabled and aim.active and aim.magicBullet
            and aim.target and remote and remote.Name == "ShootGun"
            and getnamecallmethod() == "InvokeServer" then
            local args = {...}
            if typeof(args[2]) == "Vector3" then
                local role = getCombatRole()
                local part = getTargetPart(aim.target)
                if role == "Sheriff" and part and part:IsDescendantOf(Workspace) then
                    args[2] = predictedPoint(aim.target, part)
                    aim.magicIntercepted = aim.magicIntercepted + 1
                    return originalNamecall(remote, table.unpack(args))
                end
            end
        end
        return originalNamecall(remote, ...)
    end
    local ok = pcall(function()
        local handler = redirectedNamecall
        if type(newcclosure) == "function" then
            handler = newcclosure(redirectedNamecall)
        end
        originalNamecall = hookmetamethod(game, "__namecall", handler)
    end)
    if ok and type(originalNamecall) == "function" then
        aim.magicHookInstalled = true
        return true
    end
    return false
end

controlSection:AddSwitch("Enable Aim Lock", function(value)
    aim.enabled = value
    if not value then deactivateAim() end
end, { default = false, description = "Use the chosen key to lock/unlock your aim" })

local keybindControl = controlSection:AddKeybind("Aim key (PC)", function()
    if not session.running or not aim.enabled then return end
    if aim.mode == "Toggle" then
        if aim.active then
            deactivateAim()
        else
            aim.active = true
            aim.attackAt = 0
        end
    else
        aim.active = true
        aim.attackAt = 0
    end
end, { standard = Enum.KeyCode.F, active_when_hidden = true, allow_mouse = true })

local aimModeSelect = controlSection:AddDropdown("Key behavior", function(value)
    aim.mode = value
    deactivateAim()
end)
aimModeSelect:Add("Toggle")
aimModeSelect:Add("Hold")
aimModeSelect:Set("Toggle", true)

local aimSettingsSection = aimTab:AddSection("Aim Settings")
aimSettingsSection:AddSwitch("Magic Bullet (Wall Shot - Experimental)", function(value)
    if value then
        aim.magicHookAvailable = installMagicBulletHook()
        aim.magicBullet = aim.magicHookAvailable
        if aim.magicHookAvailable then
            magicStatus.Text = "Magic Bullet: ON | shot redirection (server may block walls)"
        else
            magicStatus.Text = "Magic Bullet: executor lacks hookmetamethod"
            window:Notify("Magic Bullet", "Your executor does not support shot interception", 4)
        end
    else
        aim.magicBullet = false
        magicStatus.Text = "Magic Bullet: OFF"
    end
end, { default = false, description = "Attempts to retarget ShootGun through obstacles. Server can block impacts." })

aimSettingsSection:AddLabel("Experimental: walls are NOT guaranteed to be penetrated.")
aimSettingsSection:AddSwitch("Hard Lock (100% fixed)", function(value)
    aim.hardLock = value
end, { default = false, description = "Instantly follow the same target's head every frame until invalid/unlocked" })

aimSettingsSection:AddSwitch("Auto Shoot / Throw", function(value)
    aim.autoAttack = value
end, { default = false, description = "Shoot as Sheriff; throw as Murderer when locked" })

aimSettingsSection:AddSwitch("Auto Equip Weapon", function(value)
    aim.autoEquip = value
end, { default = false, description = "Equip your own gun or knife if available" })

aimSettingsSection:AddSwitch("Sheriff: target Innocents too", function(value)
    aim.sheriffInnocents = value
    clearAimTarget()
end, { default = false, description = "WARNING: shooting Innocents eliminates the Sheriff" })

aimSettingsSection:AddSwitch("Visible Targets Only", function(value)
    aim.visibleOnly = value
    clearAimTarget()
end, { default = false, description = "Require line of sight; avoids shooting walls" })

aimSettingsSection:AddSwitch("Highlight Locked Target", function(value)
    aim.markTarget = value
    refreshTargetHighlight()
end, { default = false, description = "Pink ESP highlight on selected player" })

aimSettingsSection:AddSlider("Aim FOV (pixels)", function(value)
    aim.fov = value
end, { min = 60, max = 800, step = 20, default = 300, suffix = " px" })

aimSettingsSection:AddSlider("Max Target Distance", function(value)
    aim.range = value
end, { min = 40, max = 600, step = 20, default = 250, suffix = " studs" })

aimSettingsSection:AddSlider("Smooth Strength (Hard Lock OFF)", function(value)
    aim.smoothing = value / 100
end, { min = 10, max = 100, step = 5, default = 45, suffix = "%" })

aimSettingsSection:AddSlider("Movement Prediction", function(value)
    aim.prediction = value / 100
end, { min = 0, max = 25, step = 1, default = 0, suffix = "%" })

aimSettingsSection:AddSlider("Attack Cooldown", function(value)
    aim.attackInterval = value / 100
end, { min = 50, max = 300, step = 5, default = 125, suffix = " x0.01s" })

local hitboxDropdown = aimSettingsSection:AddDropdown("Lock Part", function(value)
    aim.targetPart = value
    clearAimTarget()
end)
hitboxDropdown:Add("Head")
hitboxDropdown:Add("HumanoidRootPart")
hitboxDropdown:Set("Head", true)

local knifeDropdown = aimSettingsSection:AddDropdown("Knife Throw Input", function(value)
    aim.knifeInput = value
end)
knifeDropdown:Add("E")
knifeDropdown:Add("Right Mouse")
knifeDropdown:Set("E", true)

aimSettingsSection:AddButton("Unlock Aim Now", deactivateAim)

aimConnect(UserInputService.InputEnded, function(input)
    if aim.mode ~= "Hold" or not aim.active then return end
    local key = keybindControl:Get()
    if input.KeyCode == key or input.UserInputType == key then
        deactivateAim()
    end
end)

aimConnect(LocalPlayer.CharacterAdded, deactivateAim)
aimConnect(Players.PlayerRemoving, function(player)
    if player == aim.target then clearAimTarget() end
end)

local RENDER_KEY = "MM2LumenAimLockRender"
RunService:BindToRenderStep(RENDER_KEY, Enum.RenderPriority.Camera.Value + 1, function()
    if not session.running or window._dead then return end
    local myRole = getCombatRole()
    if os.clock() - aim.lastRenderStatus >= 0.2 then
        aim.lastRenderStatus = os.clock()
        roleStatus.Text = "Your role: " .. (myRole or "Unknown / no weapon")
    end
    if not aim.enabled or not aim.active or not myRole then
        if aim.target then clearAimTarget() end
        if os.clock() - aim.lastRenderStatus < 0.035 then
            aimStatus.Text = not aim.enabled and "Aim: disabled" or
                (not aim.active and "Aim: ready (press the key)" or "Aim: waiting for role")
            targetStatus.Text = "Target: none"
        end
        return
    end

    local camera = Workspace.CurrentCamera
    if not camera then return end
    local part, point
    if aim.target then
        part, point = isValidAimTarget(aim.target, myRole, camera, true)
        if not part then clearAimTarget() end
    end
    if not aim.target then
        aim.target = findAimTarget(myRole, camera)
        if aim.target then
            aim.attackAt = math.max(aim.attackAt, os.clock() + 0.20)
            part, point = isValidAimTarget(aim.target, myRole, camera, true)
        end
    end
    if not aim.target or not point then
        if os.clock() - aim.lastRenderStatus < 0.035 then
            aimStatus.Text = "Aim: scanning inside FOV"
            targetStatus.Text = "Target: none eligible/visible"
            attackStatus.Text = "Attack: waiting for target"
        end
        return
    end
    refreshTargetHighlight()
    local origin = camera.CFrame.Position
    if (point - origin).Magnitude < 0.1 then return end
    local goal = CFrame.lookAt(origin, point)

    if aim.hardLock then
        camera.CFrame = goal
    else
        camera.CFrame = camera.CFrame:Lerp(goal, math.clamp(aim.smoothing, 0.1, 1))
    end

    local tool = getUsableTool(myRole)
    if os.clock() - aim.lastRenderStatus < 0.035 then
        aimStatus.Text = (aim.hardLock and "Aim: HARD LOCK | " or "Aim: SMOOTH LOCK | ") .. myRole
        targetStatus.Text = "Target: @" .. aim.target.Name
        attackStatus.Text = "Attack: " .. (not aim.autoAttack and "manual" or
            (tool and (myRole == "Murderer" and "knife throw" or "gun shot") or "equipping/waiting"))
        if aim.magicBullet then
            magicStatus.Text = string.format("Magic Bullet: ON | redirected %d shot(s), server decides hits", aim.magicIntercepted)
        end
    end

    if not aim.autoAttack or not tool or os.clock() < aim.attackAt then return end
    local alignment = camera.CFrame.LookVector:Dot((point - camera.CFrame.Position).Unit)
    if alignment < 0.995 then return end

    if not (aim.magicBullet and aim.magicHookAvailable) and not canSeePlayer(camera, aim.target, point) then return end

    aim.attackAt = os.clock() + aim.attackInterval
    local successful = fireWeapon(myRole, tool, camera, point)
    if not successful and os.clock() - aim.lastRenderStatus < 0.035 then
        attackStatus.Text = "Attack: input unavailable (executor/game)"
    end
end)

local antiTab = window:AddTab("Anti AFK", {
    icon = "keyboard",
    description = "Anti-idle automatico, ativado ao executar",
})
local antiSection = antiTab:AddSection("Idle Protection")
local antiStatus = antiSection:AddLabel("Anti AFK: ON | monitoring inactivity")
local antiStats = antiSection:AddLabel("Virtual inputs sent: 0")
local antiAFK = {
    enabled = true,
    lastInput = os.clock(),
    lastPulse = -math.huge,
    sent = 0,
    failed = 0,
    connections = {},
}

local function antiConnect(signal, fn)
    local connection = signal:Connect(fn)
    table.insert(antiAFK.connections, connection)
    return connection
end

local function setAntiStatus(message)
    if antiStatus and antiStatus.Parent then
        antiStatus.Text = message
    end
    if antiStats and antiStats.Parent then
        antiStats.Text = string.format("Virtual inputs sent: %d | Errors: %d", antiAFK.sent, antiAFK.failed)
    end
end

local function antiPulse(reason)
    if not session.running or not antiAFK.enabled then return end
    local now = os.clock()
    if now - antiAFK.lastPulse < 25 then return end
    antiAFK.lastPulse = now

    -- Metodo principal usado em scripts Roblox; nao depende de eventos da arma.
    local ok = pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.zero)
    end)
    if not ok then

        local gotService, vim = pcall(function()
            return game:GetService("VirtualInputManager")
        end)
        if gotService and vim then
            ok = pcall(function()
                vim:SendKeyEvent(true, Enum.KeyCode.F15, false, game)
                vim:SendKeyEvent(false, Enum.KeyCode.F15, false, game)
            end)
        end
    end

    if ok then
        antiAFK.sent = antiAFK.sent + 1
        setAntiStatus("Anti AFK: ON | input sent (" .. reason .. ")")
    else
        antiAFK.failed = antiAFK.failed + 1
        setAntiStatus("Anti AFK: unsupported by this executor")
    end
end

antiSection:AddSwitch("Enable Anti AFK", function(value)
    antiAFK.enabled = value
    antiAFK.lastInput = os.clock()
    if value then
        setAntiStatus("Anti AFK: ON | monitoring inactivity")
    else
        setAntiStatus("Anti AFK: OFF")
    end
end, { default = true, description = "Starts enabled; virtual input on Idled or after inactivity" })

antiSection:AddLabel("Tries to prevent idle kick; executor and server may still disconnect you.")

antiConnect(UserInputService.InputBegan, function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseMovement then
        antiAFK.lastInput = os.clock()
    end
end)
antiConnect(UserInputService.InputChanged, function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        antiAFK.lastInput = os.clock()
    end
end)
antiConnect(LocalPlayer.Idled, function()
    antiPulse("Roblox Idled")
end)

task.spawn(function()
    while session.running and not window._dead do
        if antiAFK.enabled and os.clock() - antiAFK.lastInput >= 90
            and os.clock() - antiAFK.lastPulse >= 90 then
            antiPulse("90s idle")
        end
        task.wait(10)
    end
end)

session.AntiAFK = antiAFK

local previousStopExtras = stopExtras
stopExtras = function()
    antiAFK.enabled = false
    for _, connection in ipairs(antiAFK.connections) do
        connection:Disconnect()
    end
    antiAFK.connections = {}
    deactivateAim()
    aim.enabled = false
    aim.magicBullet = false -- hook remains inert after Stop
    RunService:UnbindFromRenderStep(RENDER_KEY)
    for _, connection in ipairs(aim.connections) do connection:Disconnect() end
    aim.connections = {}
    previousStopExtras()
end

session.AimLock = aim

task.spawn(function()
    while session.running and window.Instance and window.Instance.Parent do
        requestRoles()
        updateOverview()
        task.wait(1.5)
    end
    session.Stop()
end)

window:Notify("MM2 Lumen 2.0", "Distributed Fly Farm ready | Aim options OFF | Anti AFK ON", 5)
