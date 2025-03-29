local OrionLib = {
    Themes = {
        Default = {
            Main = Color3.fromRGB(25, 25, 25),
            Second = Color3.fromRGB(32, 32, 32),
            Stroke = Color3.fromRGB(60, 60, 60),
            Text = Color3.fromRGB(240, 240, 240),
            TextDark = Color3.fromRGB(150, 150, 150)
        }
    },
    SelectedTheme = "Default",
    Flags = {}
}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Orion = Instance.new("ScreenGui")
Orion.Name = "Orion"
Orion.Parent = game.CoreGui

-- وظيفة لإنشاء عناصر واجهة المستخدم
local function CreateElement(Name, Properties, Children)
    local Element = Instance.new(Name)
    for Prop, Value in pairs(Properties or {}) do
        Element[Prop] = Value
    end
    for _, Child in pairs(Children or {}) do
        Child.Parent = Element
    end
    return Element
end

-- وظيفة لإنشاء نافذة رئيسية
function OrionLib:MakeWindow(WindowConfig)
    WindowConfig = WindowConfig or {}
    WindowConfig.Name = WindowConfig.Name or "Orion Library"

    local MainWindow = CreateElement("Frame", {
        Name = "MainWindow",
        BackgroundColor3 = self.Themes[self.SelectedTheme].Main,
        Position = UDim2.new(0.5, -150, 0.5, -100),
        Size = UDim2.new(0, 300, 0, 200),
        Parent = Orion
    }, {
        CreateElement("UICorner", {CornerRadius = UDim.new(0, 6)}),
        CreateElement("UIStroke", {Color = self.Themes[self.SelectedTheme].Stroke, Thickness = 1})
    })

    -- شريط العنوان
    local TopBar = CreateElement("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Parent = MainWindow
    }, {
        CreateElement("TextLabel", {
            Text = WindowConfig.Name,
            TextColor3 = self.Themes[self.SelectedTheme].Text,
            Font = Enum.Font.GothamBold,
            TextSize = 16,
            Size = UDim2.new(1, -80, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left
        }),
        CreateElement("Frame", {
            Size = UDim2.new(1, 0, 0, 1),
            Position = UDim2.new(0, 0, 1, 0),
            BackgroundColor3 = self.Themes[self.SelectedTheme].Stroke,
            BorderSizePixel = 0
        })
    })

    -- منطقة التبويبات
    local TabArea = CreateElement("ScrollingFrame", {
        Size = UDim2.new(0, 120, 1, -30),
        Position = UDim2.new(0, 0, 0, 30),
        BackgroundColor3 = self.Themes[self.SelectedTheme].Second,
        ScrollBarThickness = 4,
        BorderSizePixel = 0,
        Parent = MainWindow
    }, {
        CreateElement("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim2.new(0, 5)
        }),
        CreateElement("UIPadding", {
            PaddingTop = UDim2.new(0, 5),
            PaddingLeft = UDim2.new(0, 5)
        })
    })

    -- منطقة المحتوى
    local ContentArea = CreateElement("ScrollingFrame", {
        Size = UDim2.new(1, -120, 1, -30),
        Position = UDim2.new(0, 120, 0, 30),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        BorderSizePixel = 0,
        Parent = MainWindow
    }, {
        CreateElement("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim2.new(0, 5)
        }),
        CreateElement("UIPadding", {
            PaddingTop = UDim2.new(0, 5),
            PaddingLeft = UDim2.new(0, 5),
            PaddingRight = UDim2.new(0, 5)
        })
    })

    -- وظيفة لجعل النافذة قابلة للسحب
    local Dragging, DragInput, MousePos, FramePos = false
    TopBar.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            MousePos = Input.Position
            FramePos = MainWindow.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(Input)
        if Input == DragInput and Dragging then
            local Delta = Input.Position - MousePos
            MainWindow.Position = UDim2.new(FramePos.X.Scale, FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y)
        end
    end)

    -- وظيفة لإنشاء تبويبات
    local TabFunctions = {}
    function TabFunctions:MakeTab(TabConfig)
        TabConfig = TabConfig or {}
        TabConfig.Name = TabConfig.Name or "New Tab"

        local TabButton = CreateElement("TextButton", {
            Text = TabConfig.Name,
            TextColor3 = self.Themes[self.SelectedTheme].Text,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            Size = UDim2.new(1, -10, 0, 25),
            BackgroundColor3 = self.Themes[self.SelectedTheme].Second,
            AutoButtonColor = false,
            Parent = TabArea
        }, {
            CreateElement("UICorner", {CornerRadius = UDim.new(0, 4)})
        })

        local TabContent = CreateElement("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = false,
            Parent = ContentArea
        }, {
            CreateElement("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim2.new(0, 5)
            })
        })

        TabButton.MouseButton1Click:Connect(function()
            for _, Content in pairs(ContentArea:GetChildren()) do
                if Content:IsA("Frame") then
                    Content.Visible = false
                end
            end
            TabContent.Visible = true
        end)

        -- وظائف العناصر داخل التبويب
        local ElementFunctions = {}
        
        function ElementFunctions:AddButton(ButtonConfig)
            ButtonConfig = ButtonConfig or {}
            ButtonConfig.Name = ButtonConfig.Name or "Button"
            ButtonConfig.Callback = ButtonConfig.Callback or function() end

            local Button = CreateElement("TextButton", {
                Text = ButtonConfig.Name,
                TextColor3 = self.Themes[self.SelectedTheme].Text,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundColor3 = self.Themes[self.SelectedTheme].Second,
                AutoButtonColor = false,
                Parent = TabContent
            }, {
                CreateElement("UICorner", {CornerRadius = UDim.new(0, 4)}),
                CreateElement("UIStroke", {Color = self.Themes[self.SelectedTheme].Stroke, Thickness = 1})
            })

            Button.MouseButton1Click:Connect(function()
                ButtonConfig.Callback()
            end)

            local ButtonFunctions = {}
            function ButtonFunctions:Set(NewText)
                Button.Text = NewText
            end
            
            return ButtonFunctions
        end

        function ElementFunctions:AddLabel(LabelText)
            local Label = CreateElement("TextLabel", {
                Text = LabelText,
                TextColor3 = self.Themes[self.SelectedTheme].Text,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                Parent = TabContent,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local LabelFunctions = {}
            function LabelFunctions:Set(NewText)
                Label.Text = NewText
            end
            
            return LabelFunctions
        end

        return ElementFunctions
    end

    return TabFunctions
end

return OrionLib
