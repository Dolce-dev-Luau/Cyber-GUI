-- Base Element - Template for all UI elements

local Element = {}

local Creator = require(script.Parent.Parent.Creator)
local New = Creator.New

function Element.CreateBase(Config, Parent, Library)
    local Theme = Library:GetCurrentThemeColors()
    
    -- Main frame
    local MainFrame = New("Frame", {
        Parent = Parent,
        Name = "Element",
        Size = UDim2.new(1, -20, 0, 44),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundColor3 = Theme.Background,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = 1
    })
    
    -- Hover effect
    local HoverFrame = New("Frame", {
        Parent = MainFrame,
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Theme.Hover,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 1
    })
    
    -- Title
    local Title = New("TextLabel", {
        Parent = MainFrame,
        Text = Config.Title or "",
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(0.7, -40, 0, 20),
        Position = UDim2.new(0, 12, 0, 4),
        BackgroundTransparency = 1,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        ZIndex = 2
    })
    
    -- Description
    local Desc = nil
    if Config.Description then
        Desc = New("TextLabel", {
            Parent = MainFrame,
            Text = Config.Description,
            TextColor3 = Theme.TextSecondary,
            TextXAlignment = Enum.TextXAlignment.Left,
            Size = UDim2.new(0.7, -40, 0, 18),
            Position = UDim2.new(0, 12, 0, 22),
            BackgroundTransparency = 1,
            TextSize = 11,
            Font = Enum.Font.Gotham,
            ZIndex = 2
        })
    end
    
    -- Hover logic
    local function OnHover()
        HoverFrame.BackgroundTransparency = 0.3
    end
    
    local function OnUnhover()
        HoverFrame.BackgroundTransparency = 1
    end
    
    MainFrame.MouseEnter:Connect(OnHover)
    MainFrame.MouseLeave:Connect(OnUnhover)
    
    return {
        MainFrame = MainFrame,
        Title = Title,
        Description = Desc,
        HoverFrame = HoverFrame,
        Config = Config
    }
end

return Element
