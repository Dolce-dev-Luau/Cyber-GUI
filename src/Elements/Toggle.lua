-- Toggle Element - Switch with ON/OFF state

local Toggle = {}
Toggle.__index = Toggle
Toggle.__type = "Toggle"

local Creator = require(script.Parent.Parent.Creator)
local New = Creator.New
local BaseElement = require(script.Parent.Parent.Components.Element)

function Toggle:New(Config, Parent, Library)
    assert(Config.Title, "Toggle - Missing Title")
    
    local Theme = Library:GetCurrentThemeColors()
    local State = Config.Default or false
    
    -- Create base element
    local Base = BaseElement.CreateBase(Config, Parent, Library)
    
    -- Toggle container
    local ToggleSize = 50
    local ToggleContainer = New("Frame", {
        Parent = Base.MainFrame,
        Size = UDim2.new(0, ToggleSize, 0, 28),
        Position = UDim2.new(1, -(ToggleSize + 12), 0.5, -14),
        BackgroundColor3 = Theme.BackgroundTertiary,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        ZIndex = 2
    })
    
    -- Toggle background
    local ToggleBg = New("Frame", {
        Parent = ToggleContainer,
        Size = UDim2.new(1, -4, 1, -4),
        Position = UDim2.new(0, 2, 0, 2),
        BackgroundColor3 = Theme.TextDisabled,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        ZIndex = 2
    })
    
    -- Toggle circle
    local ToggleCircle = New("Frame", {
        Parent = ToggleContainer,
        Size = UDim2.new(0, 22, 0, 22),
        Position = State and UDim2.new(1, -26, 0.5, -11) or UDim2.new(0, 2, 0.5, -11),
        BackgroundColor3 = Theme.Text,
        BackgroundTransparency = 0.8,
        BorderSizePixel = 0,
        ZIndex = 3
    })
    
    -- Glow effect
    local Glow = New("Frame", {
        Parent = ToggleCircle,
        Size = UDim2.new(1.5, 0, 1.5, 0),
        Position = UDim2.new(-0.25, 0, -0.25, 0),
        BackgroundColor3 = Theme.Accent,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 0
    })
    
    -- Update toggle state
    local function UpdateToggle(NewState)
        State = NewState
        
        -- Update visual
        if State then
            ToggleBg.BackgroundColor3 = Theme.Accent
            ToggleBg.BackgroundTransparency = 0.2
            ToggleCircle.Position = UDim2.new(1, -26, 0.5, -11)
            Glow.BackgroundTransparency = 0.5
        else
            ToggleBg.BackgroundColor3 = Theme.TextDisabled
            ToggleBg.BackgroundTransparency = 0.5
            ToggleCircle.Position = UDim2.new(0, 2, 0.5, -11)
            Glow.BackgroundTransparency = 1
        end
        
        -- Call callback
        if Config.Callback then
            Library.SafeCallback(Config.Callback, State)
        end
    end
    
    -- Click to toggle
    ToggleContainer.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            UpdateToggle(not State)
        end
    end)
    
    -- Initialize state
    UpdateToggle(State)
    
    -- Return toggle object
    return {
        Base = Base,
        Container = ToggleContainer,
        ToggleBg = ToggleBg,
        ToggleCircle = ToggleCircle,
        Glow = Glow,
        SetState = UpdateToggle,
        GetState = function() return State end
    }
end

return Toggle
