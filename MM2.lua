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

local window = library:AddWindow("MM2 | Lumen Complete V4", {
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
    farm.speed = math.clamp(value, 16, 100)
end, { min = 16, max = 100, step = 2, default = 42, suffix = " studs/s" })

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
    description = "Murderer / Sheriff target only | manual activation",
})

local aim = {
    enabled = false,
    active = false,
    autoAttack = false,
    autoEquip = false,
    showTarget = false,
    lockedPlayer = nil,
    highlighter = nil,
    attackAt = 0,
    equipAt = 0,
    lastUiAt = 0,
    attackCooldown = 1.25,
    connections = {},
}
local aimSection = aimTab:AddSection("Aim Lock | Only Murderer & Sheriff")
local aimStatus = aimSection:AddLabel("Aim: OFF | Press your key after enabling")
local aimRoleStatus = aimSection:AddLabel("Your combat role: checking...")
local aimTargetStatus = aimSection:AddLabel("Target: none")
local aimAttackStatus = aimSection:AddLabel("Attack: manual")

local function aimConnect(signal, fn)
    local c = signal:Connect(fn)
    table.insert(aim.connections, c)
    return c
end
local function resetAimTarget()
    aim.lockedPlayer = nil
    if aim.highlighter then aim.highlighter:Destroy() end
    aim.highlighter = nil
end
local function deactivateAim()
    aim.active = false
    resetAimTarget()
end
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

    if role ~= "Unknown" and role ~= "Innocent" then return nil end
    for _, parent in ipairs({LocalPlayer.Character, LocalPlayer:FindFirstChildOfClass("Backpack")}) do
        if parent then
            for _, tool in ipairs(parent:GetChildren()) do
                if tool:IsA("Tool") then
                    local n = tool.Name:lower()
                    if n:find("knife", 1, true) then return "Murderer" end
                    if n:find("gun", 1, true) or n:find("revolver", 1, true)
                        or n:find("pistol", 1, true) then return "Sheriff" end
                end
            end
        end
    end
    return nil
end
local function targetRoleValid(player, localRole)
    if player == LocalPlayer or not isAlive(player) then return false end
    local targetRole, alive = getPlayerRole(player)
    if not alive then return false end
    if localRole == "Sheriff" then return targetRole == "Murderer" end
    if localRole == "Murderer" then
        return targetRole == "Sheriff" or targetRole == "Hero"
    end
    return false
end
local function getAimPart(player)
    local character = player and player.Character
    return character and (character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart"))
end
local function chooseRoleTarget(myRole, camera)
    local best, bestScore
    for _, player in ipairs(Players:GetPlayers()) do
        if targetRoleValid(player, myRole) then
            local part = getAimPart(player)
            if part then
                local vp, onScreen = camera:WorldToViewportPoint(part.Position)
                local distance = (part.Position - camera.CFrame.Position).Magnitude

                local center = camera.ViewportSize * 0.5
                local pixel = (Vector2.new(vp.X, vp.Y) - center).Magnitude
                local score = (onScreen and vp.Z > 0) and pixel or (100000 + distance)
                if not bestScore or score < bestScore then
                    best, bestScore = player, score
                end
            end
        end
    end
    return best
end
local function showLockedTarget()
    if not aim.showTarget or not aim.lockedPlayer or not aim.lockedPlayer.Character then
        if aim.highlighter then aim.highlighter:Destroy() end
        aim.highlighter = nil
        return
    end
    local char = aim.lockedPlayer.Character
    if aim.highlighter and aim.highlighter.Parent == char then return end
    if aim.highlighter then aim.highlighter:Destroy() end
    local h = Instance.new("Highlight")
    h.Name = "MM2LumenTargetV3"
    h.Adornee = char
    h.FillTransparency = 0.75
    h.OutlineTransparency = 0
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.FillColor = Color3.fromRGB(255, 80, 185)
    h.OutlineColor = Color3.fromRGB(255, 255, 255)
    h.Parent = char
    aim.highlighter = h
end
local function matchingWeapon(tool, role)
    if not tool or not tool:IsA("Tool") then return false end
    local n = tool.Name:lower()
    if role == "Murderer" then return n:find("knife", 1, true) ~= nil end
    return n:find("gun", 1, true) ~= nil or n:find("pistol", 1, true) ~= nil
        or n:find("revolver", 1, true) ~= nil
end
local function findWeapon(role, equipIfNeeded)
    local char = LocalPlayer.Character
    if not char then return nil end
    for _, obj in ipairs(char:GetChildren()) do
        if matchingWeapon(obj, role) then return obj end
    end
    if equipIfNeeded and os.clock() - aim.equipAt > 0.7 then
        local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if backpack and hum and hum.Health > 0 then
            for _, obj in ipairs(backpack:GetChildren()) do
                if matchingWeapon(obj, role) then
                    aim.equipAt = os.clock()
                    pcall(function() hum:EquipTool(obj) end)
                    break
                end
            end
        end
    end
    return nil
end
local function sendGunClick(camera, point)
    local v, vis = camera:WorldToViewportPoint(point)
    if not vis then return false end
    local vim
    pcall(function() vim = game:GetService("VirtualInputManager") end)
    if vim then
        local ok = pcall(function()
            vim:SendMouseButtonEvent(v.X, v.Y, 0, true, game, 0)
            vim:SendMouseButtonEvent(v.X, v.Y, 0, false, game, 0)
        end)
        if ok then return true end
    end
    if type(mouse1click) == "function" then return pcall(mouse1click) end
    return false
end
local function sendKnifeThrow()
    local vim
    pcall(function() vim = game:GetService("VirtualInputManager") end)
    if vim then
        return pcall(function()
            vim:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.delay(0.12, function()
                pcall(function() vim:SendKeyEvent(false, Enum.KeyCode.E, false, game) end)
            end)
        end)
    end
    if type(keypress) == "function" and type(keyrelease) == "function" then
        return pcall(function()
            keypress(0x45)
            task.delay(0.12, function() pcall(keyrelease, 0x45) end)
        end)
    end
    return false
end
local function visibleShot(camera, player, point)
    local param = RaycastParams.new()
    param.FilterType = Enum.RaycastFilterType.Exclude
    param.FilterDescendantsInstances = {LocalPlayer.Character}
    local v = point - camera.CFrame.Position
    local hit = Workspace:Raycast(camera.CFrame.Position, v, param)
    return not hit or (player.Character and hit.Instance:IsDescendantOf(player.Character))
end
local function useAimWeapon(role, camera, point)
    if window._visible or UserInputService:GetFocusedTextBox() then return false end
    local tool = findWeapon(role, aim.autoEquip)
    if not tool then return false end
    if role == "Murderer" then return sendKnifeThrow() end
    if not sendGunClick(camera, point) then
        return pcall(function() tool:Activate() end)
    end
    return true
end

aimSection:AddSwitch("Enable Aim Lock", function(v)
    aim.enabled = v
    if not v then deactivateAim() end
end, {default = false, description = "OFF on startup; choose when to activate"})
local aimKey = aimSection:AddKeybind("Toggle Aim Key (PC)", function()
    if not aim.enabled or not session.running then return end
    if aim.active then deactivateAim() else aim.active = true; aim.attackAt = 0 end
end, {standard = Enum.KeyCode.F, active_when_hidden = true, allow_mouse = true})
aimSection:AddSwitch("Auto Shoot / Throw", function(v)
    aim.autoAttack = v
end, {default = false, description = "OFF on startup; only when target is locked and visible"})
aimSection:AddSwitch("Auto Equip Weapon", function(v)
    aim.autoEquip = v
end, {default = false})
aimSection:AddSwitch("Highlight Locked Player", function(v)
    aim.showTarget = v
    showLockedTarget()
end, {default = false})
aimSection:AddSlider("Shot / Throw Interval", function(v)
    aim.attackCooldown = v / 100
end, {min = 65, max = 300, step = 5, default = 125, suffix = " x0.01s"})
aimSection:AddLabel("Sheriff aims ONLY at Murderer. Murderer aims ONLY at Sheriff/Hero.")
aimSection:AddLabel("If server role data is unavailable, target role may be Unknown.")
aimSection:AddButton("Unlock Current Target", deactivateAim)

aimConnect(LocalPlayer.CharacterAdded, deactivateAim)
aimConnect(Players.PlayerRemoving, function(p)
    if p == aim.lockedPlayer then resetAimTarget() end
end)
local RENDER_KEY = "MM2LumenAimLockRender"
RunService:BindToRenderStep(RENDER_KEY, Enum.RenderPriority.Camera.Value + 2, function()
    if not session.running or window._dead then return end
    if session.Extras and session.Extras.freecam then
        if aim.active then deactivateAim() end
        return
    end
    local role = detectLocalCombatRole()
    if os.clock() - aim.lastUiAt >= 0.20 then
        aim.lastUiAt = os.clock()
        aimRoleStatus.Text = "Your combat role: " .. tostring(role or "Unknown")
        aimStatus.Text = not aim.enabled and "Aim: OFF" or
            (aim.active and "Aim: LOCKING TARGET" or "Aim: ready | press chosen key")
    end
    if not aim.enabled or not aim.active or not role then
        if aim.lockedPlayer then resetAimTarget() end
        return
    end
    local camera = Workspace.CurrentCamera
    if not camera then return end
    if not targetRoleValid(aim.lockedPlayer, role) then
        resetAimTarget()
        aim.lockedPlayer = chooseRoleTarget(role, camera)
    end
    local part = getAimPart(aim.lockedPlayer)
    if not part then
        if os.clock() - aim.lastUiAt < 0.04 then aimTargetStatus.Text = "Target: no confirmed enemy" end
        return
    end
    showLockedTarget()
    local point = part.Position
    local origin = camera.CFrame.Position
    if (point - origin).Magnitude > 0.1 then

        camera.CFrame = CFrame.lookAt(origin, point)
    end
    if os.clock() - aim.lastUiAt < 0.04 then
        aimTargetStatus.Text = "Target: @" .. aim.lockedPlayer.Name
        aimAttackStatus.Text = aim.autoAttack and "Attack: automatic" or "Attack: manual"
    end
    if not aim.autoAttack or os.clock() < aim.attackAt then return end
    if not visibleShot(camera, aim.lockedPlayer, point) then return end
    aim.attackAt = os.clock() + aim.attackCooldown
    useAimWeapon(role, camera, point)
end)
session.AimLock = aim

aim.QuickShootMurder = function()
    if not UserInputService.TouchEnabled then
        window:Notify("Mobile only", "This button is for touch devices", 3)
        return
    end
    if detectLocalCombatRole() ~= "Sheriff" then
        window:Notify("Quick Shoot", "Requires Sheriff/Hero and a gun", 3)
        return
    end
    local camera = Workspace.CurrentCamera
    if not camera then return end
    local target = chooseRoleTarget("Sheriff", camera)
    local part = getAimPart(target)
    if not part then return end
    camera.CFrame = CFrame.lookAt(camera.CFrame.Position, part.Position)
    local gun = findWeapon("Sheriff", true)
    if not gun then task.wait(0.15); gun = findWeapon("Sheriff", false) end
    if gun then pcall(function() gun:Activate() end) end
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
    invisible = false,
    invisibleUser = false,
    feRequested = false,
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
    avatarOriginals = setmetatable({}, {__mode = "k"}),
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

local invisibleTab = window:AddTab("Invisibility", {
    icon = "star",
    description = "Local stealth & defensive settings",
})
local stealthSection = invisibleTab:AddSection("Invisibility")
local invisibleInfo = stealthSection:AddLabel("Visibility: normal")
local function invisibleCharacter()
    local character = LocalPlayer.Character
    if not character then return end
    for _, obj in ipairs(character:GetDescendants()) do
        if obj:IsA("BasePart") then
            local saved = extras.avatarOriginals[obj]
            if saved == nil then extras.avatarOriginals[obj] = obj.LocalTransparencyModifier end
            obj.LocalTransparencyModifier = 1
        elseif obj:IsA("Decal") then
            if extras.avatarOriginals[obj] == nil then
                extras.avatarOriginals[obj] = obj.Transparency
            end
            obj.Transparency = 1
        end
    end
end
local function restoreAvatar()
    for obj, value in pairs(extras.avatarOriginals) do
        if obj and obj.Parent then
            pcall(function()
                if obj:IsA("BasePart") then obj.LocalTransparencyModifier = value
                elseif obj:IsA("Decal") then obj.Transparency = value end
            end)
        end
        extras.avatarOriginals[obj] = nil
    end
end
local function applyStealth()
    if extras.invisible then invisibleCharacter() else restoreAvatar() end
    invisibleInfo.Text = extras.invisible
        and "Invisible locally | Other players MAY still see you"
        or "Visibility: normal"
end
stealthSection:AddSwitch("Invisible Character (Local)", function(v)
    extras.invisibleUser = v
    extras.invisible = extras.invisibleUser or extras.feRequested
    applyStealth()
end, {default = false, description = "Only changes local rendering; no server-side guarantee"})
stealthSection:AddSwitch("FE Invisibility (Premium / Experimental)", function(v)
    extras.feRequested = v
    if v then

        notice("FE Invisibility", "Only local invisibility is available; FE needs server support")
    end
    extras.invisible = extras.invisibleUser or extras.feRequested
    applyStealth()
end, {default = false, description = "No claim of FE replication; local fallback only"})
stealthSection:AddLabel("FE invisibility requires a compatible server ability; this script cannot force it.")
trackExtra(LocalPlayer.CharacterAdded, function()
    extras.avatarOriginals = setmetatable({}, {__mode = "k"})
    extras.originalWalk, extras.originalJump, extras.originalUseJumpPower = nil, nil, nil
    task.delay(0.6, function()
        if not session.running then return end
        if extras.invisible then invisibleCharacter() end
    end)
end)
trackExtra(RunService.Heartbeat, function()
    if not session.running then return end
    local root, hum = rootAndHumanoid()
    if not hum then return end
    if extras.walkEnabled then
        if extras.originalWalk == nil then extras.originalWalk = hum.WalkSpeed end
        hum.WalkSpeed = extras.walkValue
    end
    if extras.jumpEnabled then
        if extras.originalUseJumpPower == nil then extras.originalUseJumpPower = hum.UseJumpPower end
        if extras.originalJump == nil then extras.originalJump = hum.JumpPower end
        hum.UseJumpPower = true
        hum.JumpPower = extras.jumpValue
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
killSection:AddButton("Faster Kill Murder (Mobile Only)", function()
    aim.QuickShootMurder()
end)
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
    deactivateAim()
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

local function stopV3Extras()
    extras.running = false
    extras.graphicsVersion = extras.graphicsVersion + 1
    extras.autoKill, extras.flingAll, extras.flingTouch = false, false, false
    extras.invisible, extras.feRequested = false, false
    extras.walkEnabled, extras.jumpEnabled, extras.noclip = false, false, false
    extras.espHitbox = false
    roleSettings.allPlayers, roleSettings.allNames = false, false
    extras.fpsBoost, extras.noFog, extras.plastic = false, false, false
    farm.permanentNoclip = false
    farm.gunESP = false
    farm.protection = false
    stopFreeCam()
    for p in pairs(extras.visualObjects) do clearESPEntry(p) end
    restoreAvatar()
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
    deactivateAim()
    aim.enabled = false
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

window:Notify("MM2 Lumen V4", "Premium Farm in Farming | ESP in Roles | Anti AFK ON", 5)
