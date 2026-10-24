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

local window = library:AddWindow("MM2 | Lumen Seasonal V8", {
    main_color = Color3.fromRGB(99, 71, 224),
    size = Vector2.new(715, 545),
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

local tab = window:AddTab("Roles & ESP", {
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

local roleSettings = { esp = true, tags = true, innocents = true, allPlayers = false, allNames = false }
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

    local allowedRole = (role ~= "Innocent" or roleSettings.innocents)
    local visibleRole = COLORS[role] and alive and allowedRole
    local allPlayersVisible = roleSettings.allPlayers and alive and allowedRole
    local color = (visibleRole and COLORS[role]) or Color3.fromRGB(158, 99, 255)

    local highlight = character:FindFirstChild(MARK_HIGHLIGHT)
    if (roleSettings.esp and visibleRole) or allPlayersVisible then
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

    if (roleSettings.tags and visibleRole) or (roleSettings.allNames and alive and allowedRole) then
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
            label.Text = player.DisplayName
                .. ((roleSettings.tags and visibleRole) and (" [" .. role .. "]") or "")
            label.TextColor3 = color
        end
    elseif tag then
        tag:Destroy()
    end
end

visualSection:AddSwitch("Role ESP", function(value)
    roleSettings.esp = value
end, { default = true, description = "See role highlights through walls" })

visualSection:AddSwitch("Role name tags", function(value)
    roleSettings.tags = value
end, { default = true, description = "Display the role above each player" })

visualSection:AddSwitch("Show Innocents", function(value)
    roleSettings.innocents = value
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
    permanentNoclip = false,
    gunESP = false,
    premiumRouting = true,
    speed = 20,
    targetStrategy = "Distributed",
    proneDuringFarm = true,
    proneJoint = nil,
    proneOriginalC0 = nil,
    flyVelocity = nil,
    stuckCount = 0,
    corrections = 0,
    correctionWindow = 0,
    safetyPauseUntil = 0,
    safetyReason = nil,
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
    roundEndedAt = 0,
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

local function setProneVisual(enabled)
    local motor = farm.proneJoint
    if motor and farm.proneOriginalC0 and motor.Parent then
        pcall(function() motor.C0 = farm.proneOriginalC0 end)
    end
    farm.proneJoint = nil
    farm.proneOriginalC0 = nil
    if not enabled or not farm.proneDuringFarm then return end
    local root, humanoid, character = rootAndHumanoid()
    if not root or not humanoid or not character then return end
    local lowerTorso = character:FindFirstChild("LowerTorso")
    local joint = (lowerTorso and lowerTorso:FindFirstChild("Root"))
        or root:FindFirstChild("RootJoint")
    if not joint or not joint:IsA("Motor6D") then return end
    farm.proneJoint = joint
    farm.proneOriginalC0 = joint.C0
    pcall(function()
        joint.C0 = farm.proneOriginalC0 * CFrame.Angles(math.rad(-75), 0, 0)
    end)
end

local function cancelMove()
    farm.moveToken = farm.moveToken + 1
    farm.moveTarget = nil
    farm.flyActive = false
    farm.noclipUntil = 0

    if farm.flyVelocity then pcall(function() farm.flyVelocity:Destroy() end) end
    if farm.flyForce then pcall(function() farm.flyForce:Destroy() end) end
    if farm.flyAttachment then pcall(function() farm.flyAttachment:Destroy() end) end
    farm.flyVelocity, farm.flyForce, farm.flyAttachment = nil, nil, nil

    local root = farm.flyRoot
    if root and root.Parent then
        pcall(function()
            local current = root.AssemblyLinearVelocity
            root.AssemblyLinearVelocity = Vector3.new(0, math.min(0, current.Y), 0)
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
            if not farm.premiumRouting then
                if distance < best then target, best = record, distance end
            else
            local slot, hash = coinAssignment(position, groupSize)

            local personal = ((hash + LocalPlayer.UserId * 131) % 997) / 997
            local score
            if farm.targetStrategy == "Farthest First" then
                score = -distance + personal * 22
            elseif farm.targetStrategy == "Random Spread" then
                score = personal * 140 + distance * 0.09

                score = score + ((hash * 7 + farm.selectionRound * 113 + LocalPlayer.UserId) % 151) * 0.7
            else

                score = distance * 0.52 + personal * 18
                if slot ~= ownIndex then score = score + 42 end
            end

            if farm.avoidPlayers then
                for _, otherPosition in ipairs(competitors) do
                    local separation = (position - otherPosition).Magnitude
                    if separation < farm.avoidRadius then
                        score = score + (farm.avoidRadius - separation) * 3 + 40
                    end
                end
            end

            if score < best then
                target, best = record, score
            end
            end
        end
    end
    return target
end

local function canFarmCoins()
    if not session.running or not farm.autoCoins or farm.bagFull
        or farm.roundActive == false or os.clock() < farm.safetyPauseUntil then
        return false
    end
    return rootAndHumanoid() ~= nil
end

local function beginFly(root, humanoid)
    if farm.flyActive then return false end
    if not root or root.Anchored or not humanoid or humanoid.Health <= 0 then return false end
    farm.flyRoot = root
    farm.moveHumanoid = humanoid
    farm.originalAutoRotate = humanoid.AutoRotate
    farm.originalPlatformStand = humanoid.PlatformStand
    farm.flyActive = true
    humanoid.AutoRotate = false
    local attachment = Instance.new("Attachment")
    attachment.Name = "MM2LumenFlightAttachment"
    attachment.Parent = root
    local velocity = Instance.new("LinearVelocity")
    velocity.Name = "MM2LumenControlledVelocity"
    velocity.Attachment0 = attachment
    velocity.RelativeTo = Enum.ActuatorRelativeTo.World
    velocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
    velocity.ForceLimitsEnabled = false
    velocity.VectorVelocity = Vector3.zero
    velocity.Parent = root
    local lift = Instance.new("VectorForce")
    lift.Name = "MM2LumenLift"
    lift.Attachment0 = attachment
    lift.RelativeTo = Enum.ActuatorRelativeTo.World
    lift.ApplyAtCenterOfMass = true
    lift.Force = Vector3.new(0, root.AssemblyMass * Workspace.Gravity, 0)
    lift.Parent = root
    farm.flyAttachment = attachment
    farm.flyVelocity = velocity
    farm.flyForce = lift
    if farm.proneDuringFarm and not farm.proneJoint then setProneVisual(true) end
    return true
end

local function finitePosition(position)
    if typeof(position) ~= "Vector3" then return false end
    if position.X ~= position.X or position.Y ~= position.Y or position.Z ~= position.Z then return false end
    return math.abs(position.X) < 15000 and math.abs(position.Y) < 15000 and math.abs(position.Z) < 15000
end

local function moveToCoin(record)
    local root, humanoid, character = rootAndHumanoid()
    if not root or not validCoin(record) then return end
    local goal = record.part.Position + Vector3.new(0, 1.15, 0)
    if not finitePosition(goal) or not finitePosition(root.Position) then
        farm.skipped[record.node] = os.clock() + 5
        return
    end
    local travel = (root.Position - goal).Magnitude
    if travel > 2500 then
        farm.skipped[record.node] = os.clock() + 5
        return
    end
    local token = farm.moveToken
    farm.moveTarget = record.part
    local startedOK, startedFlight = pcall(beginFly, root, humanoid)
    if not startedOK or not startedFlight then
        if farm.flyActive then cancelMove() end
        farm.moveTarget = nil
        farm.skipped[record.node] = os.clock() + 3
        farmStatus.Text = "Farm: flight unavailable, retrying another item"
        return
    end
    local started = os.clock()
    local deadline = started + math.clamp(travel / math.max(12, farm.speed) * 2 + 4, 5, 150)
    local closeSince = nil
    local lastPosition = root.Position
    local bestDistance = travel
    local lastProgress = started
    local lastMovement = started
    local lastStatus = 0
    local result = "interrupted"
    while session.running and token == farm.moveToken and canFarmCoins()
        and validCoin(record) and root.Parent == character and os.clock() < deadline do
        local dt = RunService.Heartbeat:Wait()
        dt = math.clamp(type(dt) == "number" and dt or (1 / 60), 1 / 240, 0.2)
        if token ~= farm.moveToken or not canFarmCoins() or not validCoin(record) then break end
        local now = os.clock()
        goal = record.part.Position + Vector3.new(0, 1.15, 0)
        local position = root.Position
        if not finitePosition(goal) or not finitePosition(position) then
            result = "unsafe"
            break
        end
        local delta = goal - position
        local dist = delta.Magnitude
        local jumped = (position - lastPosition).Magnitude
        local jumpLimit = math.max(15, farm.speed * dt * 4 + 10)
        if jumped > jumpLimit then
            if now - farm.correctionWindow > 25 then
                farm.correctionWindow = now
                farm.corrections = 0
            end
            farm.corrections = farm.corrections + 1
            result = "correction"
            if farm.corrections >= 3 then
                farm.safetyPauseUntil = math.huge
                farm.safetyReason = "server position corrections"
            else
                farm.safetyPauseUntil = now + 2.5
            end
            break
        end
        if jumped > 0.12 then lastMovement = now end
        if dist < bestDistance - 0.65 then
            bestDistance = dist
            lastProgress = now
        end
        if dist <= 2.3 then
            if not closeSince then closeSince = now end
            if now - closeSince >= 0.25 then
                result = "reached"
                break
            end
        else
            closeSince = nil
        end
        if (now - lastMovement > 1.25 and dist > 3.5)
            or (now - lastProgress > 2.35 and dist > 4) then
            farm.stuckCount = farm.stuckCount + 1
            result = "stuck"
            break
        end
        lastPosition = position
        if farm.flyVelocity and farm.flyVelocity.Parent then
            local speed = math.min(farm.speed, dist * 5)
            local direction = dist > 0.05 and delta.Unit or Vector3.zero
            farm.flyVelocity.VectorVelocity = direction * speed
            if farm.flyForce and farm.flyForce.Parent then
                farm.flyForce.Force = Vector3.new(0, root.AssemblyMass * Workspace.Gravity, 0)
            end
        else
            result = "lost controller"
            break
        end
        if now - farm.lastBagPoll >= 0.15 and farm.pollBag then
            farm.lastBagPoll = now
            farm.pollBag()
        end
        if now - lastStatus >= 0.35 then
            lastStatus = now
            farmStatus.Text = string.format("Farm: %s | %d studs | %d speed", record.label, math.floor(dist), farm.speed)
        end
    end
    if os.clock() >= deadline and result == "interrupted" then result = "timeout" end
    if token == farm.moveToken then
        if farm.flyVelocity and farm.flyVelocity.Parent then
            farm.flyVelocity.VectorVelocity = Vector3.zero
        end
        if validCoin(record) and not farm.bagFull then
            farm.skipped[record.node] = os.clock() + (result == "reached" and 2.2 or 4)
        end
        cancelMove()
        if result == "stuck" or result == "timeout" or result == "lost controller" then
            farmStatus.Text = "Farm: changing coin (movement stalled)"
        elseif result == "correction" then
            farmStatus.Text = farm.safetyPauseUntil == math.huge
                and "Farm paused: repeated position corrections"
                or "Farm: position corrected, short cooldown"
        end
    end
end

task.spawn(function()
    while session.running and not window._dead do
        if farm.pollBag then farm.pollBag() end
        if canFarmCoins() then
            if os.clock() - farm.lastScan >= 1.1 then scanCoins() end
            local root = rootAndHumanoid()
            if root then
                local item = findDistributedCoin(root.Position)
                if item then
                    moveToCoin(item)
                else
                    farmStatus.Text = "Farm: searching coins across the map"
                    farm.lastScan = 0
                    task.wait(0.3)
                end
            end
        else
            if farm.moveTarget then cancelMove() end
            if farm.proneJoint and (not farm.autoCoins or farm.bagFull
                or farm.roundActive == false or farm.safetyPauseUntil == math.huge) then
                setProneVisual(false)
            end
            if farm.autoCoins then
                farmStatus.Text = os.clock() < farm.safetyPauseUntil
                    and (farm.safetyPauseUntil == math.huge
                        and "Farm paused: position corrections (toggle OFF/ON)"
                        or "Farm: retrying after position correction")
                    or (farm.bagFull and "Farm: BAG FULL - stopped"
                    or (farm.roundActive == false and "Farm: next round"
                        or "Farm: waiting to spawn"))
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
    local shouldNoclip = (farm.permanentNoclip or
        (farm.autoCoins and farm.flyActive and not farm.bagFull
        and farm.flyRoot == root))
        and root and humanoid and character
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
    if farm.bagFull then
        if farm.flyActive then cancelMove() end
        setProneVisual(false)
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
            farm.roundEndedAt = os.clock()
            cancelMove()
            setProneVisual(false)
            clearCoinTracers()
        end))
    end
end)

remember(LocalPlayer.CharacterAdded:Connect(function()
    cancelMove()
    farm.roundActive = nil
    resetBag("character respawn")
    setProneVisual(false)
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
        setProneVisual(false)
        restoreCollision()
    else
        farm.safetyPauseUntil = 0
        farm.safetyReason = nil
        farm.corrections = 0
        farm.correctionWindow = os.clock()
        farm.stuckCount = 0
        farm.lastScan = 0
    end
end, { default = false, description = "Continuous physical flight, recovers from stalled routes, stops when the bag is full" })

local premiumSection = farmTab:AddSection("Premium Farm | Global Coin Routing")
premiumSection:AddLabel("Uses the main Auto Farm switch; no duplicate auto-farm engine")
premiumSection:AddSwitch("Premium Farm Routing", function(value)
    farm.premiumRouting = value
    farm.skipped = {}
    if farm.moveTarget then cancelMove() end
end, {default = true, description = "ON: search every coin with distributed priorities; OFF: nearest available coin"})

premiumSection:AddLabel("Premium: distributed targets across all distances")
local strategyDropdown = premiumSection:AddDropdown("Coin Target Strategy", function(value)
    farm.targetStrategy = value
    farm.skipped = {}
    if farm.moveTarget then cancelMove() end
end)
strategyDropdown:Add("Distributed")
strategyDropdown:Add("Farthest First")
strategyDropdown:Add("Random Spread")
strategyDropdown:Set("Distributed", true)

premiumSection:AddSwitch("Avoid Other Players' Coins", function(value)
    farm.avoidPlayers = value
end, {default = true, description = "Prefer coins without other players nearby"})

premiumSection:AddSlider("Player Avoidance Radius", function(value)
    farm.avoidRadius = value
end, {min = 10, max = 90, step = 5, default = 30, suffix = " studs"})

farmSection:AddSwitch("Auto XP / Survival", function(value)
    farm.survivalXP = value
end, { default = false, description = "Evade a nearby Murderer; Anti AFK now has its own tab" })

farmSection:AddSlider("Farm Fly Speed", function(value)
    farm.speed = math.clamp(value, 12, 32)

end, { min = 12, max = 32, step = 2, default = 20, suffix = " studs/s" })

farmSection:AddSwitch("Prone Visual During Farming", function(value)
    farm.proneDuringFarm = value
    setProneVisual(false)
    if value and farm.autoCoins and not farm.bagFull then
        setProneVisual(true)
    end
end, { default = true, description = "Lies the body down visually; does not change server hitboxes or block knife damage" })

farmSection:AddLabel("The server controls movement validation. No farm speed guarantees immunity from error 267")

farmSection:AddSlider("Coin Bag Limit (Elite = 50)", function(value)
    farm.bagLimit = math.clamp(math.floor(value), 40, 50)

    if farm.bagCurrent and farm.bagCurrent >= (farm.bagMax or farm.bagLimit) then
        farm.bagFull = true
        cancelMove()
        restoreCollision()
    end
end, { min = 40, max = 50, step = 10, default = 40, suffix = " coins" })

local utilitySection = farmTab:AddSection("Coin Tracer")
utilitySection:AddSwitch("Coin Tracer", function(value)
    farm.coinTracer = value
    farm.lastScan = 0
    if not value then clearCoinTracers() end
end, { default = false, description = "Beams to up to 12 nearby coins" })

premiumSection:AddSwitch("Anti-Fling + Anti-KB + NoClip (Premium)", function(value)
    farm.protection = value
    if not farm.protection then
        farm.noclipUntil = 0
        if not farm.permanentNoclip and not farm.flyActive then restoreCollision() end
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
    setProneVisual(false)
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
local function isAlive(player)
    local char = player and player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head"))
    return hum ~= nil and hum.Health > 0 and root ~= nil
end

local function detectLocalCombatRole()
    local role, alive = getPlayerRole(LocalPlayer)
    if not alive then return nil end
    if role == "Murderer" then return "Murderer" end
    if role == "Sheriff" or role == "Hero" then return "Sheriff" end
    for _, parent in ipairs({LocalPlayer.Character, LocalPlayer:FindFirstChildOfClass("Backpack")}) do
        if parent then
            for _, tool in ipairs(parent:GetChildren()) do
                if tool:IsA("Tool") then
                    local name = tool.Name:lower()
                    if name:find("knife", 1, true) then return "Murderer" end
                    if name:find("gun", 1, true) or name:find("revolver", 1, true) or name:find("pistol", 1, true) then
                        return "Sheriff"
                    end
                end
            end
        end
    end
    return nil
end

local combatEquipAt = 0
local function findWeapon(role, equipIfNeeded)
    local character = LocalPlayer.Character
    if not character then return nil end
    local function matches(obj)
        if not obj:IsA("Tool") then return false end
        local n = obj.Name:lower()
        if role == "Murderer" then return n:find("knife", 1, true) ~= nil end
        return n:find("gun", 1, true) ~= nil or n:find("pistol", 1, true) ~= nil
            or n:find("revolver", 1, true) ~= nil
    end
    for _, obj in ipairs(character:GetChildren()) do
        if matches(obj) then return obj end
    end
    if equipIfNeeded and os.clock() - combatEquipAt > 0.7 then
        local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if backpack and humanoid and humanoid.Health > 0 then
            for _, tool in ipairs(backpack:GetChildren()) do
                if matches(tool) then
                    combatEquipAt = os.clock()
                    pcall(function() humanoid:EquipTool(tool) end)
                    break
                end
            end
        end
    end
    return nil
end

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

local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local extras = {
    running = true,
    walkEnabled = false,
    jumpEnabled = false,
    walkValue = 24,
    jumpValue = 60,
    noclip = false,
    autoKill = false,
    killMode = "Teleport",
    flingAll = false,
    flingTouch = false,
    targetPlayerName = nil,
    espHitbox = false,
    freecam = false,
    freecamSpeed = 45,
    freecamAngles = Vector2.new(0, 0),
    freecamCFrame = nil,
    oldCameraType = nil,
    oldCameraSubject = nil,
    fpsBoost = false,
    noFog = false,
    plastic = false,
    originals = setmetatable({}, {__mode = "k"}),
    graphicsVersion = 0,
    visualMeta = {},
    originalQuality = nil,
    originalWalk = nil,
    originalJump = nil,
    originalUseJumpPower = nil,
    connections = {},
    visualObjects = {},
    busyKill = false,
    busyFling = false,
    lastKillAt = 0,
    lastFlingAt = 0,
}
session.Extras = extras
local function trackExtra(signal, fn)
    local c = signal:Connect(fn)
    table.insert(extras.connections, c)
    return c
end
local function notice(title, body)
    if session.running and not window._dead then window:Notify(title, body, 4) end
end
local function preserveProperty(obj, prop)
    if not obj or not obj.Parent then return end
    local saved = extras.originals[obj]
    if not saved then saved = {}; extras.originals[obj] = saved end
    if saved[prop] == nil then
        local ok, old = pcall(function() return obj[prop] end)
        if ok then saved[prop] = old end
    end
end
local function restoreGraphics()
    for obj, properties in pairs(extras.originals) do
        if obj and obj.Parent then
            for prop, value in pairs(properties) do
                pcall(function() obj[prop] = value end)
            end
        end
        extras.originals[obj] = nil
    end
end
local function boostObject(obj)
    if extras.fpsBoost then
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke")
            or obj:IsA("Fire") or obj:IsA("Sparkles") then
            preserveProperty(obj, "Enabled")
            pcall(function() obj.Enabled = false end)
        elseif obj:IsA("Decal") or obj:IsA("Texture") then

            preserveProperty(obj, "Transparency")
            pcall(function() obj.Transparency = 1 end)
        end
    end
    if extras.plastic and obj:IsA("BasePart") and not (LocalPlayer.Character
        and obj:IsDescendantOf(LocalPlayer.Character)) then
        preserveProperty(obj, "Material")
        preserveProperty(obj, "Reflectance")
        preserveProperty(obj, "CastShadow")
        pcall(function()
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.CastShadow = false
        end)
    end
end
local function applyLighting()
    if extras.noFog or extras.fpsBoost then
        for _, effect in ipairs(Lighting:GetChildren()) do
            if effect:IsA("Atmosphere") then
                preserveProperty(effect, "Density")
                preserveProperty(effect, "Haze")
                preserveProperty(effect, "Glare")
                effect.Density = 0
                effect.Haze = 0
                effect.Glare = 0
            end
        end
        preserveProperty(Lighting, "GlobalShadows")
        preserveProperty(Lighting, "FogEnd")
        preserveProperty(Lighting, "EnvironmentDiffuseScale")
        preserveProperty(Lighting, "EnvironmentSpecularScale")
        pcall(function()
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 1e9
            Lighting.EnvironmentDiffuseScale = 0
            Lighting.EnvironmentSpecularScale = 0
        end)
    end
end
local function rebuildGraphics()
    extras.graphicsVersion = extras.graphicsVersion + 1
    if extras.fpsBoost then
        pcall(function()
            if extras.originalQuality == nil then
                extras.originalQuality = settings().Rendering.QualityLevel
            end
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        end)
    elseif extras.originalQuality ~= nil then
        pcall(function() settings().Rendering.QualityLevel = extras.originalQuality end)
        extras.originalQuality = nil
    end
    local generation = extras.graphicsVersion
    restoreGraphics()
    if extras.noFog or extras.fpsBoost then applyLighting() end
    if not extras.fpsBoost and not extras.plastic then return end
    local all = game:GetDescendants()
    task.spawn(function()
        for i, obj in ipairs(all) do
            if not session.running or generation ~= extras.graphicsVersion then return end
            boostObject(obj)
            if i % 180 == 0 then task.wait() end
        end
    end)
end
trackExtra(game.DescendantAdded, function(obj)
    if extras.noFog and obj:IsA("Atmosphere") then
        task.defer(function() if obj.Parent then applyLighting() end end)
    end
    if extras.fpsBoost or extras.plastic then
        task.defer(function() if obj.Parent and session.running then boostObject(obj) end end)
    end
end)

local combatTab = window:AddTab("Combat & Fling", {
    icon = "bolt",
    description = "Murderer combat, optional physics & player selection",
})
local killSection = combatTab:AddSection("Combat | Murderer")
local combatStatus = killSection:AddLabel("Combat: ready | All actions OFF")
local function combatPlayers()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and isAlive(p) then
            local role = getPlayerRole(p)
            if role ~= "Murderer" then table.insert(list, p) end
        end
    end
    table.sort(list, function(a,b) return a.UserId < b.UserId end)
    return list
end
local function tryKillPlayer(target)
    if not session.running or detectLocalCombatRole() ~= "Murderer" then return false end
    if not isAlive(target) then return false end
    local root, hum = rootAndHumanoid()
    local theirRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    if not root or not theirRoot then return false end
    local knife = findWeapon("Murderer", true)
    if not knife then
        task.wait(0.12)
        knife = findWeapon("Murderer", false)
    end
    if not knife then return false end
    if extras.killMode == "Bring (Experimental)" then

        pcall(function() theirRoot.CFrame = root.CFrame * CFrame.new(0, 0, -2) end)
    else
        pcall(function() root.CFrame = theirRoot.CFrame * CFrame.new(0, 0, 2) end)
    end
    task.wait(0.10)
    pcall(function() knife:Activate() end)
    return true
end
local function killAllOnce()
    if extras.busyKill then return end
    if detectLocalCombatRole() ~= "Murderer" then
        notice("Kill All", "Only works with the Murderer role and a normal knife")
        return
    end
    extras.busyKill = true
    task.spawn(function()
        local count = 0
        for _, p in ipairs(combatPlayers()) do
            if not session.running then break end
            if tryKillPlayer(p) then count = count + 1 end
            task.wait(0.28)
        end
        extras.busyKill = false
        combatStatus.Text = "Combat: attempted " .. count .. " normal knife hit(s)"
    end)
end
killSection:AddButton("Kill All (Premium) | Once", killAllOnce)
local killModeDrop = killSection:AddDropdown("Murderer Auto Kill Mode", function(v)
    extras.killMode = v
end)
killModeDrop:Add("Teleport")
killModeDrop:Add("Bring (Experimental)")
killModeDrop:Set("Teleport", true)
killSection:AddSwitch("Auto Kill All", function(v)
    extras.autoKill = v
    combatStatus.Text = v and "Combat: auto kill ON" or "Combat: auto kill OFF"
end, {default = false, description = "Murderer only; attempts ordinary knife hits"})
killSection:AddLabel("Teleport/Bring and melee hits can be rejected by the MM2 server.")

task.spawn(function()
    while session.running do
        if extras.autoKill and not extras.busyKill and os.clock() - extras.lastKillAt > 1.8 then
            extras.lastKillAt = os.clock()
            if detectLocalCombatRole() == "Murderer" then
                killAllOnce()
            else
                combatStatus.Text = "Combat: waiting for Murderer role"
            end
        end
        task.wait(0.25)
    end
end)
local flingSection = combatTab:AddSection("Fling | Physics (Experimental)")
local playerDropdown = flingSection:AddDropdown("Fling Target Player", function(v)
    extras.targetPlayerName = v
end)
local function refreshPlayerList()
    local old = extras.targetPlayerName
    playerDropdown:Clear()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then playerDropdown:Add(p.Name) end
    end
    if old and playerDropdown:Set(old, true) then
        extras.targetPlayerName = old
    else
        extras.targetPlayerName = nil
    end
end
refreshPlayerList()
flingSection:AddButton("Refresh Target List", refreshPlayerList)
local function flingPlayer(p)
    if extras.busyFling or not isAlive(p) then return false end
    local root, hum = rootAndHumanoid()
    local targetRoot = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
    if not root or not targetRoot then return false end
    extras.busyFling = true
    local savedCF = root.CFrame
    task.spawn(function()

        for _ = 1, 3 do
            if not session.running or not targetRoot.Parent or not root.Parent then break end
            pcall(function()
                root.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 1.4)
                root.AssemblyAngularVelocity = Vector3.new(0, 135, 0)
                root.AssemblyLinearVelocity = targetRoot.CFrame.LookVector * 80
            end)
            task.wait(0.14)
        end
        if root.Parent then
            pcall(function()
                root.AssemblyAngularVelocity = Vector3.zero
                root.AssemblyLinearVelocity = Vector3.zero
                root.CFrame = savedCF
            end)
        end
        extras.busyFling = false
    end)
    return true
end
flingSection:AddButton("Fling Selected Player", function()
    local p = extras.targetPlayerName and Players:FindFirstChild(extras.targetPlayerName)
    if not p or not flingPlayer(p) then notice("Fling", "Select an alive target first") end
end)
flingSection:AddButton("Fling Murderer", function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and getPlayerRole(p) == "Murderer" then
            flingPlayer(p); return
        end
    end
    notice("Fling", "No confirmed Murderer detected")
end)
flingSection:AddButton("Fling Sheriff", function()
    for _, p in ipairs(Players:GetPlayers()) do
        local role = getPlayerRole(p)
        if p ~= LocalPlayer and (role == "Sheriff" or role == "Hero") then
            flingPlayer(p); return
        end
    end
    notice("Fling", "No confirmed Sheriff/Hero detected")
end)
flingSection:AddSwitch("Auto Fling All", function(v)
    extras.flingAll = v
end, {default = false})
flingSection:AddSwitch("Fling Touch", function(v)
    extras.flingTouch = v
    if not v then
        local root = rootAndHumanoid()
        if root then root.AssemblyAngularVelocity = Vector3.zero end
    end
end, {default = false, description = "Attempts spin when nearby players are touching"})
flingSection:AddLabel("Physics may only affect your client. Use OFF to restore normal motion.")
task.spawn(function()
    while session.running do
        if extras.flingAll and not extras.busyFling and os.clock() - extras.lastFlingAt > 1.4 then
            extras.lastFlingAt = os.clock()
            local players = {}
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and isAlive(p) then table.insert(players, p) end
            end
            if #players > 0 then
                extras.flingIndex = ((extras.flingIndex or 0) % #players) + 1
                flingPlayer(players[extras.flingIndex])
            end
        end
        if extras.flingTouch then
            local root = rootAndHumanoid()
            if root then
                local near = false
                for _, p in ipairs(Players:GetPlayers()) do
                    local other = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                    if p ~= LocalPlayer and other and (other.Position - root.Position).Magnitude < 5 then
                        near = true
                        break
                    end
                end
                if near and not extras.busyFling then
                    root.AssemblyAngularVelocity = Vector3.new(0, 100, 0)
                elseif not extras.busyFling then
                    root.AssemblyAngularVelocity = Vector3.zero
                end
            end
        end
        task.wait(0.18)
    end
end)

local visualsTab = window:AddTab("Player", {
    icon = "profile",
    description = "Movement and free camera",
})

local visualExtras = tab:AddSection("Premium ESP | All Players & Dropped Gun")
local function clearESPEntry(player)
    local objects = extras.visualObjects[player]
    if objects then
        for _, obj in ipairs(objects) do
            if obj then pcall(function() obj:Destroy() end) end
        end
    end
    extras.visualObjects[player] = nil
    extras.visualMeta[player] = nil
end
local function refreshPlayerESP()

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local char = p.Character
            local signature = tostring(extras.espHitbox)
            local meta = extras.visualMeta[p]
            if not (meta and meta.char == char and meta.signature == signature) then
                clearESPEntry(p)
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if extras.espHitbox and root and isAlive(p) then
                    local box = Instance.new("BoxHandleAdornment")
                    box.Name = "MM2HitboxVisualOnly"
                    box.Adornee = root
                    box.Size = root.Size * 1.25
                    box.AlwaysOnTop = true
                    box.Transparency = 0.58
                    box.Color3 = Color3.fromRGB(255, 190, 68)
                    box.ZIndex = 1
                    box.Parent = root
                    extras.visualObjects[p] = {box}
                    extras.visualMeta[p] = {char = char, signature = signature}
                end
            end
        end
    end
end
visualExtras:AddSwitch("ESP Names (All Players)", function(v)
    roleSettings.allNames = v
    updateOverview()
end, {default = false, description = "Extends the existing role name tag to players without a confirmed role"})
visualExtras:AddSwitch("ESP Peoples (All Players)", function(v)
    roleSettings.allPlayers = v
    updateOverview()
end, {default = false, description = "Uses the existing Role ESP highlight for players without a confirmed role"})
visualExtras:AddSwitch("ESP Dropped Gun", function(v)
    farm.gunESP = v
    if not v then clearGunESP() end
end, {default = false, description = "Single Gun ESP control in Roles & ESP"})
visualExtras:AddSwitch("Show HitBox", function(v)
    extras.espHitbox = v
    refreshPlayerESP()
end, {default = false, description = "Visual-only box; does not enlarge real hitboxes"})
trackExtra(Players.PlayerRemoving, clearESPEntry)
task.spawn(function()
    while session.running do
        if extras.espHitbox then
            refreshPlayerESP()
        end
        task.wait(1.2)
    end
end)

local motionSection = visualsTab:AddSection("Movement")
motionSection:AddSwitch("Player Speed", function(v)
    extras.walkEnabled = v
    local _, hum = rootAndHumanoid()
    if not v and hum and extras.originalWalk then hum.WalkSpeed = extras.originalWalk end
end, {default = false})
motionSection:AddSlider("Speed Value", function(v)
    extras.walkValue = v
end, {min = 16, max = 100, step = 2, default = 24, suffix = " studs/s"})
motionSection:AddSwitch("Player Jump Power", function(v)
    extras.jumpEnabled = v
    local _, hum = rootAndHumanoid()
    if not v and hum and extras.originalJump then
        hum.JumpPower = extras.originalJump
        if extras.originalUseJumpPower ~= nil then hum.UseJumpPower = extras.originalUseJumpPower end
    end
end, {default = false})
motionSection:AddSlider("Jump Power Value", function(v)
    extras.jumpValue = v
end, {min = 50, max = 180, step = 5, default = 60})
motionSection:AddSwitch("Noclip", function(v)
    extras.noclip = v
    farm.permanentNoclip = v
    if not v and not farm.flyActive then restoreCollision() end
end, {default = false})

local cameraSection = visualsTab:AddSection("Free Cam | PC")
local camStatus = cameraSection:AddLabel("Free Cam: OFF")
local function stopFreeCam()
    if not extras.freecam then return end
    extras.freecam = false
    local camera = Workspace.CurrentCamera
    if camera then
        camera.CameraType = extras.oldCameraType or Enum.CameraType.Custom
        if extras.oldCameraSubject and extras.oldCameraSubject.Parent then
            camera.CameraSubject = extras.oldCameraSubject
        end
    end
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    camStatus.Text = "Free Cam: OFF"
end
local function startFreeCam()
    local camera = Workspace.CurrentCamera
    if not camera then return end
    extras.oldCameraType = camera.CameraType
    extras.oldCameraSubject = camera.CameraSubject
    extras.freecamCFrame = camera.CFrame
    local look = camera.CFrame.LookVector
    extras.freecamAngles = Vector2.new(math.asin(math.clamp(look.Y, -1, 1)), math.atan2(-look.X, -look.Z))
    camera.CameraType = Enum.CameraType.Scriptable
    extras.freecam = true
    camStatus.Text = "Free Cam: ON | WASD / Q E / right mouse"
end
cameraSection:AddSwitch("Free Cam", function(v)
    if v then startFreeCam() else stopFreeCam() end
end, {default = false, description = "Right click to look; WASD and Q/E to move"})
cameraSection:AddSlider("Free Cam Speed", function(v) extras.freecamSpeed = v end,
    {min = 10, max = 150, step = 5, default = 45})
trackExtra(RunService.RenderStepped, function(dt)
    if not extras.freecam or not extras.freecamCFrame then return end
    local camera = Workspace.CurrentCamera
    if not camera then return end
    if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local delta = UserInputService:GetMouseDelta()
        extras.freecamAngles = Vector2.new(
            math.clamp(extras.freecamAngles.X - delta.Y * .003, -1.48, 1.48),
            extras.freecamAngles.Y - delta.X * .003
        )
    end
    local pitch, yaw = extras.freecamAngles.X, extras.freecamAngles.Y
    local rotation = CFrame.Angles(0, yaw, 0) * CFrame.Angles(pitch, 0, 0)
    local axis = Vector3.zero
    if not UserInputService:GetFocusedTextBox() then
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then axis = axis + Vector3.new(0, 0, -1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then axis = axis + Vector3.new(0, 0, 1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then axis = axis + Vector3.new(-1, 0, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then axis = axis + Vector3.new(1, 0, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.E) then axis = axis + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.Q) then axis = axis + Vector3.new(0, -1, 0) end
    end
    local pos = extras.freecamCFrame.Position
    if axis.Magnitude > 0 then pos = pos + rotation:VectorToWorldSpace(axis.Unit) * extras.freecamSpeed * dt end
    extras.freecamCFrame = CFrame.new(pos) * rotation
    camera.CFrame = extras.freecamCFrame
end)

local perfTab = window:AddTab("Performance & Server", {
    icon = "settings",
    description = "Graphics, FPS, rejoin and server hop",
})
local perfSection = perfTab:AddSection("Graphics")
local perfStatus = perfSection:AddLabel("Graphics: unchanged | all effects OFF")
local function refreshPerformance()
    perfStatus.Text = "Graphics: " .. (extras.fpsBoost and "BOOST " or "")
        .. (extras.noFog and "NO FOG " or "")
        .. (extras.plastic and "PLASTIC " or "")
    if not extras.fpsBoost and not extras.noFog and not extras.plastic then
        perfStatus.Text = "Graphics: restored"
    end
    rebuildGraphics()
end
perfSection:AddSwitch("FPS Booster", function(v)
    extras.fpsBoost = v
    refreshPerformance()
end, {default = false, description = "Disables particles and textures locally; may improve FPS"})
perfSection:AddSwitch("Disable Shadows & Fog", function(v)
    extras.noFog = v
    refreshPerformance()
end, {default = false})
perfSection:AddSwitch("Smooth Plastic World", function(v)
    extras.plastic = v
    refreshPerformance()
end, {default = false, description = "Replace visible world part materials with Plastic locally"})
perfSection:AddButton("Reapply FPS Boost", refreshPerformance)
perfSection:AddLabel("Original graphics are restored when all performance toggles are OFF.")
local serverSection = perfTab:AddSection("Server")
serverSection:AddButton("Rejoin Server", function()
    task.spawn(function()
        local ok, err = pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end)
        if not ok then notice("Rejoin", tostring(err)) end
    end)
end)
serverSection:AddButton("Server Hop", function()
    task.spawn(function()
        local url = string.format(
            "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100",
            game.PlaceId
        )
        local ok, response = pcall(function() return HttpService:JSONDecode(game:HttpGet(url)) end)
        if not ok or type(response) ~= "table" or type(response.data) ~= "table" then
            notice("Server Hop", "Server list request failed in this executor")
            return
        end
        for _, item in ipairs(response.data) do
            if type(item.id) == "string" and item.id ~= game.JobId
                and (item.playing or 0) < (item.maxPlayers or 0) then
                local okTeleport, err = pcall(function()
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, item.id, LocalPlayer)
                end)
                if not okTeleport then notice("Server Hop", tostring(err)) end
                return
            end
        end
        notice("Server Hop", "No other non-full server found in this page")
    end)
end)
serverSection:AddLabel("Rejoin/Hop may be blocked by Roblox or your executor.")

local themeColors = {
    ["Roxo"] = {
        accent = Color3.fromRGB(99, 71, 224),
        pale = Color3.fromRGB(237, 231, 255),
        header = Color3.fromRGB(99, 71, 224),
        background = Color3.fromRGB(248, 247, 252),
        surface = Color3.fromRGB(255, 255, 255),
        border = Color3.fromRGB(232, 225, 244),
        text = Color3.fromRGB(48, 39, 67),
        muted = Color3.fromRGB(139, 129, 158),
        inactive = Color3.fromRGB(220, 216, 231),
        green = Color3.fromRGB(68, 153, 121),
    },
    ["Preto"] = {
        accent = Color3.fromRGB(194, 195, 210),
        pale = Color3.fromRGB(49, 49, 53),
        header = Color3.fromRGB(31, 31, 35),
        background = Color3.fromRGB(19, 19, 22),
        surface = Color3.fromRGB(31, 31, 35),
        border = Color3.fromRGB(62, 62, 70),
        text = Color3.fromRGB(242, 242, 245),
        muted = Color3.fromRGB(171, 171, 181),
        inactive = Color3.fromRGB(73, 73, 81),
        green = Color3.fromRGB(93, 211, 151),
    },
    ["Amarelo"] = {
        accent = Color3.fromRGB(255, 208, 57),
        pale = Color3.fromRGB(58, 49, 25),
        header = Color3.fromRGB(83, 64, 18),
        background = Color3.fromRGB(23, 22, 18),
        surface = Color3.fromRGB(36, 33, 26),
        border = Color3.fromRGB(82, 69, 42),
        text = Color3.fromRGB(255, 250, 233),
        muted = Color3.fromRGB(198, 183, 149),
        inactive = Color3.fromRGB(95, 82, 58),
        green = Color3.fromRGB(129, 211, 132),
    },
    ["Claro"] = {
        accent = Color3.fromRGB(82, 106, 205),
        pale = Color3.fromRGB(230, 237, 255),
        header = Color3.fromRGB(81, 105, 193),
        background = Color3.fromRGB(248, 250, 254),
        surface = Color3.fromRGB(255, 255, 255),
        border = Color3.fromRGB(222, 229, 241),
        text = Color3.fromRGB(40, 49, 67),
        muted = Color3.fromRGB(116, 128, 151),
        inactive = Color3.fromRGB(214, 223, 237),
        green = Color3.fromRGB(57, 152, 105),
    },
    ["Escuro"] = {
        accent = Color3.fromRGB(132, 146, 255),
        pale = Color3.fromRGB(42, 49, 72),
        header = Color3.fromRGB(31, 37, 55),
        background = Color3.fromRGB(19, 23, 33),
        surface = Color3.fromRGB(29, 34, 47),
        border = Color3.fromRGB(57, 65, 85),
        text = Color3.fromRGB(237, 239, 252),
        muted = Color3.fromRGB(159, 171, 198),
        inactive = Color3.fromRGB(69, 77, 98),
        green = Color3.fromRGB(87, 215, 161),
    },
    ["Noite Dark"] = {
        accent = Color3.fromRGB(108, 165, 255),
        pale = Color3.fromRGB(22, 42, 74),
        header = Color3.fromRGB(13, 29, 54),
        background = Color3.fromRGB(8, 15, 29),
        surface = Color3.fromRGB(16, 27, 46),
        border = Color3.fromRGB(39, 62, 91),
        text = Color3.fromRGB(232, 242, 255),
        muted = Color3.fromRGB(143, 173, 209),
        inactive = Color3.fromRGB(43, 68, 99),
        green = Color3.fromRGB(100, 226, 183),
    },
    ["Halloween"] = {
        accent = Color3.fromRGB(255, 128, 38),
        pale = Color3.fromRGB(57, 35, 74),
        header = Color3.fromRGB(47, 12, 74),
        background = Color3.fromRGB(23, 12, 34),
        surface = Color3.fromRGB(39, 22, 52),
        border = Color3.fromRGB(112, 58, 130),
        text = Color3.fromRGB(255, 244, 226),
        muted = Color3.fromRGB(202, 168, 216),
        inactive = Color3.fromRGB(77, 54, 92),
        green = Color3.fromRGB(160, 235, 126),
    },
    ["Hello Kitty"] = {
        accent = Color3.fromRGB(235, 89, 154),
        pale = Color3.fromRGB(255, 223, 238),
        header = Color3.fromRGB(248, 161, 200),
        background = Color3.fromRGB(255, 246, 250),
        surface = Color3.fromRGB(255, 255, 255),
        border = Color3.fromRGB(250, 194, 220),
        text = Color3.fromRGB(107, 64, 86),
        muted = Color3.fromRGB(177, 124, 150),
        inactive = Color3.fromRGB(248, 214, 230),
        green = Color3.fromRGB(122, 192, 139),
    },
    ["Preto Puro"] = {
        accent = Color3.fromRGB(255, 255, 255),
        pale = Color3.fromRGB(25, 25, 25),
        header = Color3.fromRGB(0, 0, 0),
        background = Color3.fromRGB(0, 0, 0),
        surface = Color3.fromRGB(9, 9, 9),
        border = Color3.fromRGB(54, 54, 54),
        text = Color3.fromRGB(255, 255, 255),
        muted = Color3.fromRGB(180, 180, 180),
        inactive = Color3.fromRGB(63, 63, 63),
        green = Color3.fromRGB(109, 227, 165),
    },
}

local function themeAncestor(instance, name)
    local parent = instance.Parent
    while parent and parent ~= window.Instance do
        if parent.Name == name then return true end
        parent = parent.Parent
    end
    return false
end

local function specialObject(parent, className, name, position, size, color, z)
    local object = Instance.new(className)
    object.Name = name
    object.Position = position
    object.Size = size
    object.BackgroundColor3 = color
    object.BackgroundTransparency = className == "TextLabel" and 1 or 0
    object.BorderSizePixel = 0
    object.ZIndex = z or (parent.ZIndex + 1)
    object.Parent = parent
    return object
end

local function specialRound(frame, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = frame
    return frame
end

local function specialText(parent, name, text, x, y, width, height, color, size, z)
    local lbl = specialObject(parent, "TextLabel", name,
        UDim2.fromOffset(x, y), UDim2.fromOffset(width, height), Color3.new(1, 1, 1), z)
    lbl.Text = text
    lbl.TextColor3 = color
    lbl.TextSize = size
    lbl.TextXAlignment = Enum.TextXAlignment.Center
    lbl.Font = Enum.Font.GothamBold
    return lbl
end

local function specialDisc(parent, name, x, y, width, height, color, z)
    return specialRound(specialObject(parent, "Frame", name,
        UDim2.fromOffset(x, y), UDim2.fromOffset(width, height), color, z), math.max(width, height))
end

local function specialStroke(parent, color, transparency, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Transparency = transparency or 0
    stroke.Thickness = thickness or 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

local function specialLine(parent, name, x, y, length, angle, color, thickness, z)
    local segment = specialObject(parent, "Frame", name, UDim2.fromOffset(x, y),
        UDim2.fromOffset(length, thickness or 2), color, z)
    segment.Rotation = angle
    specialRound(segment, 2)
    return segment
end

local function specialGradient(parent, first, second, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Name = "SeasonalGradient"
    gradient.Color = ColorSequence.new(first, second)
    gradient.Rotation = rotation or 0
    gradient.Parent = parent
    return gradient
end

local function specialFlower(parent, x, y, scale, baseZ)
    local group = specialObject(parent, "Frame", "PinkFlower", UDim2.fromOffset(x, y),
        UDim2.fromOffset(30 * scale, 30 * scale), Color3.new(1, 1, 1), baseZ)
    group.BackgroundTransparency = 1
    for index = 0, 4 do
        local angle = 2 * math.pi * index / 5
        specialDisc(group, "Petal", (15 + math.sin(angle) * 8) * scale - 5 * scale,
            (15 - math.cos(angle) * 8) * scale - 5 * scale,
            12 * scale, 12 * scale, Color3.fromRGB(255, 155, 201), baseZ + 1)
    end
    specialDisc(group, "FlowerCenter", 11 * scale, 11 * scale, 9 * scale, 9 * scale,
        Color3.fromRGB(255, 226, 104), baseZ + 2)
    return group
end

local function specialBow(parent, x, y, scale, z)
    local c = Color3.fromRGB(235, 74, 139)
    local group = specialObject(parent, "Frame", "KittyBow", UDim2.fromOffset(x, y),
        UDim2.fromOffset(34 * scale, 26 * scale), Color3.new(1, 1, 1), z)
    group.BackgroundTransparency = 1
    local left = specialRound(specialObject(group, "Frame", "LeftBow", UDim2.fromOffset(0, 4 * scale),
        UDim2.fromOffset(17 * scale, 18 * scale), c, z + 1), 9 * scale)
    left.Rotation = -26
    local right = specialRound(specialObject(group, "Frame", "RightBow", UDim2.fromOffset(16 * scale, 4 * scale),
        UDim2.fromOffset(17 * scale, 18 * scale), c, z + 1), 9 * scale)
    right.Rotation = 26
    specialDisc(group, "BowKnot", 11 * scale, 7 * scale, 12 * scale, 12 * scale,
        Color3.fromRGB(255, 117, 168), z + 2)
    return group
end

local function specialKitty(parent, x, y, scale, z)
    local root = specialObject(parent, "Frame", "KittyIllustration", UDim2.fromOffset(x, y),
        UDim2.fromOffset(104 * scale, 100 * scale), Color3.new(1, 1, 1), z)
    root.BackgroundTransparency = 1
    local white = Color3.fromRGB(255, 255, 255)
    local outline = Color3.fromRGB(124, 79, 99)
    local ear1 = specialRound(specialObject(root, "Frame", "KittyEar", UDim2.fromOffset(13 * scale, 4 * scale),
        UDim2.fromOffset(32 * scale, 38 * scale), white, z + 1), 8 * scale)
    ear1.Rotation = -19
    specialStroke(ear1, outline, 0.1, 1.2)
    local ear2 = specialRound(specialObject(root, "Frame", "KittyEar", UDim2.fromOffset(60 * scale, 4 * scale),
        UDim2.fromOffset(32 * scale, 38 * scale), white, z + 1), 8 * scale)
    ear2.Rotation = 19
    specialStroke(ear2, outline, 0.1, 1.2)
    local face = specialRound(specialObject(root, "Frame", "KittyFace", UDim2.fromOffset(7 * scale, 23 * scale),
        UDim2.fromOffset(91 * scale, 66 * scale), white, z + 2), 30 * scale)
    specialStroke(face, outline, 0.05, 1.3)
    specialDisc(root, "Eye", 34 * scale, 58 * scale, 6 * scale, 9 * scale, Color3.fromRGB(48, 45, 51), z + 3)
    specialDisc(root, "Eye", 69 * scale, 58 * scale, 6 * scale, 9 * scale, Color3.fromRGB(48, 45, 51), z + 3)
    specialRound(specialObject(root, "Frame", "Nose", UDim2.fromOffset(49 * scale, 72 * scale),
        UDim2.fromOffset(9 * scale, 6 * scale), Color3.fromRGB(255, 217, 89), z + 3), 4 * scale)
    for _, side in ipairs({-1, 1}) do
        for index = -1, 1 do
            local px = side == -1 and 8 or 80
            specialLine(root, "Whisker", (px + (side == -1 and 0 or 0)) * scale,
                (67 + index * 7) * scale, 19 * scale,
                side * (index * 12), outline, 1.3 * scale, z + 3)
        end
    end
    specialBow(root, 61 * scale, 8 * scale, 0.95 * scale, z + 4)
    return root
end

local function specialPumpkin(parent, x, y, scale, z)
    local group = specialObject(parent, "Frame", "Pumpkin", UDim2.fromOffset(x, y),
        UDim2.fromOffset(83 * scale, 68 * scale), Color3.new(1, 1, 1), z)
    group.BackgroundTransparency = 1
    local orange = Color3.fromRGB(255, 134, 34)
    specialRound(specialObject(group, "Frame", "Stem", UDim2.fromOffset(37 * scale, 1 * scale),
        UDim2.fromOffset(12 * scale, 18 * scale), Color3.fromRGB(100, 169, 54), z + 1), 5 * scale)
    specialDisc(group, "PumpkinSide", 1 * scale, 17 * scale, 46 * scale, 48 * scale,
        Color3.fromRGB(220, 95, 28), z + 2)
    specialDisc(group, "PumpkinSide", 36 * scale, 17 * scale, 46 * scale, 48 * scale,
        Color3.fromRGB(225, 96, 25), z + 2)
    specialDisc(group, "PumpkinBody", 19 * scale, 11 * scale, 45 * scale, 56 * scale, orange, z + 3)
    local dark = Color3.fromRGB(65, 25, 71)
    specialDisc(group, "Eye", 30 * scale, 32 * scale, 8 * scale, 9 * scale, dark, z + 4)
    specialDisc(group, "Eye", 49 * scale, 32 * scale, 8 * scale, 9 * scale, dark, z + 4)
    specialRound(specialObject(group, "Frame", "Smile", UDim2.fromOffset(35 * scale, 49 * scale),
        UDim2.fromOffset(17 * scale, 5 * scale), dark, z + 4), 4 * scale)
    return group
end

local function specialGhost(parent, x, y, scale, z)
    local group = specialObject(parent, "Frame", "Ghost", UDim2.fromOffset(x, y),
        UDim2.fromOffset(52 * scale, 58 * scale), Color3.new(1, 1, 1), z)
    group.BackgroundTransparency = 1
    specialRound(specialObject(group, "Frame", "GhostBody", UDim2.fromOffset(6 * scale, 6 * scale),
        UDim2.fromOffset(42 * scale, 48 * scale), Color3.fromRGB(255, 255, 255), z + 1), 22 * scale)
    specialDisc(group, "Eye", 18 * scale, 24 * scale, 5 * scale, 8 * scale,
        Color3.fromRGB(53, 24, 73), z + 2)
    specialDisc(group, "Eye", 32 * scale, 24 * scale, 5 * scale, 8 * scale,
        Color3.fromRGB(53, 24, 73), z + 2)
    specialDisc(group, "Mouth", 25 * scale, 38 * scale, 6 * scale, 9 * scale,
        Color3.fromRGB(53, 24, 73), z + 2)
    return group
end

local function specialBat(parent, x, y, scale, z)
    local group = specialObject(parent, "Frame", "Bat", UDim2.fromOffset(x, y),
        UDim2.fromOffset(44 * scale, 24 * scale), Color3.new(1, 1, 1), z)
    group.BackgroundTransparency = 1
    local color = Color3.fromRGB(30, 11, 46)
    local wing1 = specialDisc(group, "BatWing", 1 * scale, 6 * scale, 25 * scale, 14 * scale, color, z + 1)
    wing1.Rotation = -24
    local wing2 = specialDisc(group, "BatWing", 20 * scale, 6 * scale, 25 * scale, 14 * scale, color, z + 1)
    wing2.Rotation = 24
    specialDisc(group, "BatBody", 18 * scale, 8 * scale, 10 * scale, 13 * scale, color, z + 2)
    return group
end

local function clearSeasonal(root)
    for _, obj in ipairs(root:GetDescendants()) do
        if obj.Name == "SeasonalGradient" then obj:Destroy() end
    end
    local old = root:FindFirstChild("SeasonalDecor")
    if old then old:Destroy() end
    for _, node in ipairs(root:GetDescendants()) do
        if node.Name == "SeasonalTop" or node.Name == "SeasonalSidebar"
            or node.Name == "SeasonalHero" or node.Name == "SeasonalIllustration" then
            node:Destroy()
        end
    end
end

local function applySeasonalTheme(name, palette)
    local root = window.Instance
    if not root then return end
    clearSeasonal(root)
    local themed = name == "Halloween" or name == "Hello Kitty"
    local top = root:FindFirstChild("TopBar")
    local body = root:FindFirstChild("Body")
    local sidebar = body and body:FindFirstChild("Sidebar")
    local workspace = body and body:FindFirstChild("Workspace")
    local hero = workspace and workspace:FindFirstChild("Intro")
    local art = hero and hero:FindFirstChild("Illustration")
    local nativeIcon = art and art:FindFirstChild("Icon_grid")
    local caption = sidebar and sidebar:FindFirstChildWhichIsA("TextLabel")
    if caption then caption.Text = name == "Halloween" and "SPOOKY MENU"
        or name == "Hello Kitty" and "HELLO KITTY" or "WORKSPACE" end
    if hero then
        local kick = hero:FindFirstChild("TextLabel")
        for _, label in ipairs(hero:GetChildren()) do
            if label:IsA("TextLabel") then
                if label.TextSize == 9 then label.Text = name == "Halloween" and "TRICK OR TREAT"
                    or name == "Hello Kitty" and "A LITTLE BIT OF CUTE" or "A LITTLE MORE CLARITY" end
                if label.TextSize == 20 then label.Text = name == "Halloween" and "Spooky night"
                    or name == "Hello Kitty" and "Pink paradise" or "Your workspace" end
                if label.TextSize == 11 then label.Text = name == "Halloween" and "Boo! Your controls are ready."
                    or name == "Hello Kitty" and "Sweet controls, happy vibes." or "Simple controls. A smoother flow." end
            end
        end
    end
    if art then
        art.BackgroundTransparency = themed and 1 or 0
        if nativeIcon then nativeIcon.Visible = not themed end
    end
    if not themed then
        window:SetTitle("MM2 | Lumen Seasonal V8")
        return
    end
    if name == "Halloween" then
        window:SetTitle("MM2  |  HALLOWEEN NIGHT")
        if top then specialGradient(top, Color3.fromRGB(28, 5, 47), Color3.fromRGB(93, 31, 112), 0) end
        if sidebar then specialGradient(sidebar, Color3.fromRGB(34, 14, 51), Color3.fromRGB(48, 22, 63), 90) end
        if hero then specialGradient(hero, Color3.fromRGB(74, 40, 86), Color3.fromRGB(39, 23, 61), 12) end
    else
        window:SetTitle("MM2  |  HELLO KITTY CLUB")
        if top then specialGradient(top, Color3.fromRGB(245, 145, 187), Color3.fromRGB(255, 192, 215), 0) end
        if sidebar then specialGradient(sidebar, Color3.fromRGB(255, 229, 242), Color3.fromRGB(255, 246, 251), 90) end
        if hero then specialGradient(hero, Color3.fromRGB(255, 211, 231), Color3.fromRGB(255, 242, 248), 0) end
    end
    if top then
        local base = top.ZIndex + 4
        local layer = specialObject(top, "Frame", "SeasonalTop", UDim2.new(), UDim2.new(1, 0, 1, 0),
            palette.header, base)
        layer.BackgroundTransparency = 1
        if name == "Hello Kitty" then
            specialKitty(layer, 14, 5, 0.38, base)
            specialFlower(layer, 510, 8, 0.75, base)
            specialText(layer, "TopHeart", "♥", 0, 17, 715, 19, Color3.fromRGB(255, 243, 249), 16, base)
        else
            specialPumpkin(layer, 10, 6, 0.44, base)
            specialBat(layer, 505, 10, 0.75, base)
            specialText(layer, "TopStar", "✦", 530, 2, 40, 24,
                Color3.fromRGB(255, 186, 71), 19, base)
        end
    end
    if sidebar then
        local z = sidebar.ZIndex + 2
        local layer = specialObject(sidebar, "Frame", "SeasonalSidebar",
            UDim2.fromOffset(3, 4), UDim2.new(1, -6, 1, -8), palette.surface, z)
        layer.BackgroundTransparency = 1
        if name == "Hello Kitty" then
            specialFlower(layer, 102, 18, 0.63, z)
            specialText(layer, "TinyHeart", "♡", 85, 87, 30, 22,
                Color3.fromRGB(234, 126, 165), 20, z)
            specialBow(layer, 9, 91, 0.56, z)
            specialFlower(layer, 105, 340, 0.62, z)
        else
            specialBat(layer, 99, 10, 0.6, z)
            specialText(layer, "TinyStars", "✦", 86, 85, 30, 22,
                Color3.fromRGB(255, 151, 44), 17, z)
            specialDisc(layer, "Moon", 115, 336, 21, 21,
                Color3.fromRGB(255, 215, 139), z)
            specialBat(layer, 12, 93, 0.46, z)
        end
    end
    if hero and art then
        local z = hero.ZIndex + 5
        local layer = specialObject(hero, "Frame", "SeasonalHero",
            UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 1, 0), palette.pale, z)
        layer.BackgroundTransparency = 1
        if name == "Hello Kitty" then
            specialKitty(layer, 342, 2, 0.89, z)
            specialFlower(layer, 295, 62, 0.82, z)
            specialText(layer, "Heart", "♥", 264, 8, 28, 26,
                Color3.fromRGB(245, 127, 179), 17, z)
            specialText(layer, "Heart", "♡", 311, 21, 25, 29,
                Color3.fromRGB(246, 151, 196), 21, z)
        else
            specialPumpkin(layer, 348, 16, 1.00, z)
            specialGhost(layer, 294, 43, 0.63, z)
            specialDisc(layer, "FullMoon", 285, 8, 27, 27,
                Color3.fromRGB(255, 222, 151), z)
            specialBat(layer, 323, 6, 0.55, z)
            specialText(layer, "Star", "✦", 266, 36, 24, 24,
                Color3.fromRGB(255, 146, 40), 18, z)
        end
    end
    for _, item in ipairs(root:GetDescendants()) do
        if item:IsA("GuiObject") and (item.Name == "Folder" or item.Name == "Switch"
            or item.Name == "Dropdown" or item.Name == "Slider" or item.Name == "Keybind") then
            if name == "Hello Kitty" then
                specialGradient(item, Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 242, 249), 0)
            else
                specialGradient(item, Color3.fromRGB(53, 30, 66), Color3.fromRGB(37, 22, 51), 0)
            end
        end
    end
end

local function applyInterfaceTheme(name)
    local palette = themeColors[name]
    if not palette or not window or window._dead or not window.Instance then return end
    environment.MM2LumenThemeChoice = name
    window._theme = palette
    for callback in pairs(window._paints or {}) do
        pcall(callback, palette)
    end
    local root = window.Instance
    root.BackgroundColor3 = palette.background
    for _, object in ipairs(root:GetDescendants()) do
        local objectName = object.Name
        if object:IsA("GuiObject") then
            if objectName == "TopBar" or objectName == "SquareBottom" then
                object.BackgroundColor3 = palette.header
            elseif objectName == "Sidebar" or objectName == "ProfileCard" or objectName == "QuickAccess" then
                object.BackgroundColor3 = palette.surface
            elseif objectName == "Folder" or objectName == "Switch" or objectName == "Dropdown" or objectName == "Slider" or objectName == "Keybind" or objectName == "TextInput" or objectName == "ColorPicker" or objectName == "Code" then
                object.BackgroundColor3 = palette.surface
            elseif objectName == "Search" and object.Parent and object.Parent.Name == "Sidebar" then
                object.BackgroundColor3 = palette.background
            elseif objectName == "Intro" or objectName == "Badge" then
                object.BackgroundColor3 = palette.pale
            elseif objectName == "Divider" then
                object.BackgroundColor3 = palette.border
            end
        end
        if object:IsA("TextLabel") and not themeAncestor(object, "TopBar")
            and not themeAncestor(object, "TabButtons") and not themeAncestor(object, "ExecutorProfile")
            and not themeAncestor(object, "Status") then
            if objectName == "Title" then
                local parent = object.Parent
                if parent and parent.Name == "Button" and parent.Parent and parent.Parent.Name == "Folder" then
                    object.TextColor3 = palette.accent
                else
                    object.TextColor3 = palette.text
                end
            elseif objectName == "Heading" or objectName == "DisplayName" then
                object.TextColor3 = palette.text
            elseif objectName == "Value" then
                object.TextColor3 = object.Text == "Choose an option" and palette.muted or palette.accent
            elseif themeAncestor(object, "Badge") then
                object.TextColor3 = palette.accent
            elseif objectName == "Label" or objectName == "EmptyState" or objectName == "Username"
                or object.TextSize <= 12 then
                object.TextColor3 = palette.muted
            else
                object.TextColor3 = palette.text
            end
        elseif object:IsA("TextBox") then
            object.TextColor3 = palette.text
            object.PlaceholderColor3 = palette.muted
        elseif object:IsA("UIStroke") then
            local parent = object.Parent
            if parent and (parent == root or parent.Name == "Folder" or parent.Name == "Switch"
                or parent.Name == "Dropdown" or parent.Name == "Slider" or parent.Name == "Keybind"
                or parent.Name == "ProfileCard" or parent.Name == "QuickAccess" or parent.Name == "Search") then
                object.Color = palette.border
            end
        end
    end
    local sidebar = root:FindFirstChild("Body")
    sidebar = sidebar and sidebar:FindFirstChild("Sidebar")
    local profile = sidebar and sidebar:FindFirstChild("ExecutorProfile")
    if profile then
        profile.BackgroundColor3 = palette.pale
        local gradient = profile:FindFirstChildOfClass("UIGradient")
        if gradient then
            gradient.Color = ColorSequence.new(palette.pale, palette.surface)
        end
        local frameStroke = profile:FindFirstChildOfClass("UIStroke")
        if frameStroke then frameStroke.Color = palette.accent end
        local avatarBorder = profile:FindFirstChild("AvatarBorder")
        if avatarBorder then
            avatarBorder.BackgroundColor3 = palette.accent
            local avatar = avatarBorder:FindFirstChild("Avatar")
            if avatar then avatar.BackgroundColor3 = palette.surface end
        end
        local nickname = profile:FindFirstChild("DisplayName")
        if nickname then nickname.TextColor3 = palette.text end
        local username = profile:FindFirstChild("Username")
        if username then username.TextColor3 = palette.muted end
    end
    if window._bubble and window._bubble.Parent then
        window._bubble.BackgroundColor3 = palette.accent
    end
    window._options.show_intro = name == "Halloween" or name == "Hello Kitty"
    if window._options.show_intro then
        if window._size.Y < 580 then window:SetSize(Vector2.new(window._size.X, 590)) end
    else
        if window._size.Y == 590 then window:SetSize(Vector2.new(window._size.X, 545)) end
    end
    applySeasonalTheme(name, palette)
end

local customizeTab = window:AddTab("Customization", {
    icon = "settings",
    description = "Choose the appearance of the entire UI",
})
local themeSection = customizeTab:AddSection("UI Themes")
themeSection:AddLabel("Seasonal themes: Halloween and Hello Kitty | Full UI makeover")
local currentTheme = themeSection:AddLabel("Current theme: Roxo")
local themeDropdown = themeSection:AddDropdown("Select UI Theme", function(value)
    applyInterfaceTheme(value)
    currentTheme.Text = "Current theme: " .. value
end, {max_visible = 9})
for _, themeName in ipairs({"Roxo", "Preto", "Amarelo", "Claro", "Escuro", "Noite Dark", "Preto Puro", "Halloween", "Hello Kitty"}) do
    themeDropdown:Add(themeName)
end
local initialTheme = themeColors[environment.MM2LumenThemeChoice] and environment.MM2LumenThemeChoice or "Roxo"
themeDropdown:Set(initialTheme, true)
currentTheme.Text = "Current theme: " .. initialTheme
applyInterfaceTheme(initialTheme)
themeSection:AddButton("Reset to Purple", function()
    themeDropdown:Set("Roxo")
end)

local function stopV3Extras()
    if window and window.Instance then clearSeasonal(window.Instance) end
    extras.running = false
    extras.graphicsVersion = extras.graphicsVersion + 1
    extras.autoKill, extras.flingAll, extras.flingTouch = false, false, false
    extras.walkEnabled, extras.jumpEnabled, extras.noclip = false, false, false
    extras.espHitbox = false
    roleSettings.allPlayers, roleSettings.allNames = false, false
    extras.fpsBoost, extras.noFog, extras.plastic = false, false, false
    farm.permanentNoclip = false
    farm.gunESP = false
    farm.protection = false
    stopFreeCam()
    for p in pairs(extras.visualObjects) do clearESPEntry(p) end
    restoreGraphics()
    if extras.originalQuality ~= nil then
        pcall(function() settings().Rendering.QualityLevel = extras.originalQuality end)
        extras.originalQuality = nil
    end
    local root, hum = rootAndHumanoid()
    if root then root.AssemblyAngularVelocity = Vector3.zero end
    if hum then
        if extras.originalWalk ~= nil then hum.WalkSpeed = extras.originalWalk end
        if extras.originalJump ~= nil then hum.JumpPower = extras.originalJump end
        if extras.originalUseJumpPower ~= nil then hum.UseJumpPower = extras.originalUseJumpPower end
    end
    restoreCollision()
    restoreFlingCollision()
    for _, c in ipairs(extras.connections) do pcall(function() c:Disconnect() end) end
    extras.connections = {}
end

local previousStopExtras = stopExtras
stopExtras = function()
    stopV3Extras()
    antiAFK.enabled = false
    for _, connection in ipairs(antiAFK.connections) do
        connection:Disconnect()
    end
    antiAFK.connections = {}
    previousStopExtras()
end


task.spawn(function()
    while session.running and window.Instance and window.Instance.Parent do
        requestRoles()
        updateOverview()
        task.wait(1.5)
    end
    session.Stop()
end)

window:Notify("MM2 Lumen V8", "Premium Farm in Farming | ESP in Roles | Anti AFK ON", 5)
