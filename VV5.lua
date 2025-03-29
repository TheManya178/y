local Default = {
    Main = Color3.fromRGB(25, 25, 25),
    Second = Color3.fromRGB(32, 32, 32),
    Stroke = Color3.fromRGB(49, 49, 49),
    Divider = Color3.fromRGB(60, 60, 60),
    Text = Color3.fromRGB(240, 240, 240),
    TextDark = Color3.fromRGB(150, 150, 150)
}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer

local function createElement(className, properties, children)
    local element = Instance.new(className)
    for prop, value in pairs(properties or {}) do
        element[prop] = value
    end
    for _, child in pairs(children or {}) do
        child.Parent = element
    end
    return element
end

local OrionLib = {
    Elements = {},
    ThemeObjects = {},
    Connections = {},
    Flags = {},
    Themes = {
        Default = Default
    },
    SelectedTheme = "Default"
}

local Orion = createElement("ScreenGui", {
    Name = "Orion",
    Parent = game.CoreGui
})

local function AddConnection(Signal, Function)
    local SignalConnect = Signal:Connect(Function)
    table.insert(OrionLib.Connections, SignalConnect)
    return SignalConnect
end

local function AddDraggingFunctionality(DragPoint, Main)
    local Dragging, DragInput, MousePos, FramePos = false
    DragPoint.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            MousePos = Input.Position
            FramePos = Main.Position

            Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)
    DragPoint.InputChanged:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement then
            DragInput = Input
        end
    end)
    UserInputService.InputChanged:Connect(function(Input)
        if Input == DragInput and Dragging then
            local Delta = Input.Position - MousePos
            TweenService:Create(Main, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Position = UDim2.new(FramePos.X.Scale, FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y)
            }):Play()
        end
    end)
end

function OrionLib:MakeWindow(WindowConfig)
    WindowConfig = WindowConfig or {}
    WindowConfig.Name = WindowConfig.Name or "Orion Library"
    WindowConfig.HidePremium = WindowConfig.HidePremium or false
    WindowConfig.CloseCallback = WindowConfig.CloseCallback or function() end

    local FirstTab = true
    local Minimized = false
    local UIHidden = false

    local TabHolder = createElement("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, -50),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Default.Divider,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    }, {
        createElement("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim2.new(0, 0)
        }),
        createElement("UIPadding", {
            PaddingTop = UDim2.new(0, 8),
            PaddingLeft = UDim2.new(0, 0),
            PaddingRight = UDim2.new(0, 0),
            PaddingBottom = UDim2.new(0, 8)
        })
    })

    AddConnection(TabHolder.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
        TabHolder.CanvasSize = UDim2.new(0, 0, 0, TabHolder.UIListLayout.AbsoluteContentSize.Y + 16)
    end)

    local CloseBtn = createElement("TextButton", {
        Text = "",
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(0.5, 0, 1, 0),
        Position = UDim2.new(0.5, 0, 0, 0)
    }, {
        createElement("ImageLabel", {
            Image = "rbxassetid://7072725342",
            Position = UDim2.new(0, 9, 0, 6),
            Size = UDim2.new(0, 18, 0, 18),
            BackgroundTransparency = 1,
            ImageColor3 = Default.Text
        })
    })

    local MinimizeBtn = createElement("TextButton", {
        Text = "",
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(0.5, 0, 1, 0)
    }, {
        createElement("ImageLabel", {
            Image = "rbxassetid://7072719338",
            Position = UDim2.new(0, 9, 0, 6),
            Size = UDim2.new(0, 18, 0, 18),
            BackgroundTransparency = 1,
            ImageColor3 = Default.Text,
            Name = "Ico"
        })
    })

    local DragPoint = createElement("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1
    })

    local WindowStuff = createElement("Frame", {
        BackgroundColor3 = Default.Second,
        Size = UDim2.new(0, 150, 1, -50),
        Position = UDim2.new(0, 0, 0, 50),
        BorderSizePixel = 0
    }, {
        createElement("UICorner", {CornerRadius = UDim.new(0, 10)}),
        createElement("Frame", {
            Size = UDim2.new(1, 0, 0, 10),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundColor3 = Default.Second,
            BorderSizePixel = 0
        }),
        createElement("Frame", {
            Size = UDim2.new(0, 10, 1, 0),
            Position = UDim2.new(1, -10, 0, 0),
            BackgroundColor3 = Default.Second,
            BorderSizePixel = 0
        }),
        createElement("Frame", {
            Size = UDim2.new(0, 1, 1, 0),
            Position = UDim2.new(1, -1, 0, 0),
            BackgroundColor3 = Default.Stroke,
            BorderSizePixel = 0
        }),
        TabHolder,
        createElement("Frame", {
            Size = UDim2.new(1, 0, 0, 50),
            Position = UDim2.new(0, 0, 1, -50),
            BackgroundTransparency = 1
        }, {
            createElement("Frame", {
                Size = UDim2.new(1, 0, 0, 1),
                BackgroundColor3 = Default.Stroke,
                BorderSizePixel = 0
            }),
            createElement("TextLabel", {
                Text = LocalPlayer.DisplayName,
                TextColor3 = Default.Text,
                TextSize = WindowConfig.HidePremium and 14 or 13,
                Size = UDim2.new(1, -60, 0, 13),
                Position = WindowConfig.HidePremium and UDim2.new(0, 50, 0, 19) or UDim2.new(0, 50, 0, 12),
                Font = Enum.Font.GothamBold,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left
            }),
            createElement("TextLabel", {
                Text = "",
                TextColor3 = Default.TextDark,
                TextSize = 12,
                Size = UDim2.new(1, -60, 0, 12),
                Position = UDim2.new(0, 50, 1, -25),
                Visible = not WindowConfig.HidePremium,
                Font = Enum.Font.Gotham,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left
            })
        })
    })

    local WindowName = createElement("TextLabel", {
        Text = WindowConfig.Name,
        TextColor3 = Default.Text,
        TextSize = 20,
        Size = UDim2.new(1, -30, 2, 0),
        Position = UDim2.new(0, 25, 0, -24),
        Font = Enum.Font.GothamBlack,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local WindowTopBarLine = createElement("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = Default.Stroke,
        BorderSizePixel = 0
    })

    local MainWindow = createElement("Frame", {
        BackgroundColor3 = Default.Main,
        Position = UDim2.new(0.5, -307, 0.5, -172),
        Size = UDim2.new(0, 290, 0, 180),
        ClipsDescendants = true,
        Parent = Orion
    }, {
        createElement("UICorner", {CornerRadius = UDim.new(0, 10)}),
        createElement("Frame", {
            Size = UDim2.new(1, 0, 0, 50),
            Name = "TopBar",
            BackgroundTransparency = 1
        }, {
            WindowName,
            WindowTopBarLine,
            createElement("Frame", {
                Size = UDim2.new(0, 70, 0, 30),
                Position = UDim2.new(1, -90, 0, 10),
                BackgroundColor3 = Default.Second
            }, {
                createElement("UICorner", {CornerRadius = UDim.new(0, 7)}),
                createElement("UIStroke", {Color = Default.Stroke, Thickness = 1}),
                createElement("Frame", {
                    Size = UDim2.new(0, 1, 1, 0),
                    Position = UDim2.new(0.5, 0, 0, 0),
                    BackgroundColor3 = Default.Stroke,
                    BorderSizePixel = 0
                }),
                CloseBtn,
                MinimizeBtn
            }),
        }),
        DragPoint,
        WindowStuff
    })

    AddDraggingFunctionality(DragPoint, MainWindow)

    AddConnection(CloseBtn.MouseButton1Up, function()
        MainWindow.Visible = false
        UIHidden = true
        WindowConfig.CloseCallback()
    end)

    AddConnection(UserInputService.InputBegan, function(Input)
        if Input.KeyCode == Enum.KeyCode.RightShift and UIHidden then
            MainWindow.Visible = true
        end
    end)

    AddConnection(MinimizeBtn.MouseButton1Up, function()
        if Minimized then
            TweenService:Create(MainWindow, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, 290, 0, 180)}):Play()
            MinimizeBtn.Ico.Image = "rbxassetid://7072719338"
            wait(.02)
            MainWindow.ClipsDescendants = false
            WindowStuff.Visible = true
            WindowTopBarLine.Visible = true
        else
            MainWindow.ClipsDescendants = true
            WindowTopBarLine.Visible = false
            MinimizeBtn.Ico.Image = "rbxassetid://7072720870"
            TweenService:Create(MainWindow, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, WindowName.TextBounds.X + 140, 0, 50)}):Play()
            wait(0.1)
            WindowStuff.Visible = false
        end
        Minimized = not Minimized
    end)

    local TabFunction = {}
    function TabFunction:MakeTab(TabConfig)
        TabConfig = TabConfig or {}
        TabConfig.Name = TabConfig.Name or "Tab"
        TabConfig.PremiumOnly = TabConfig.PremiumOnly or false

        local TabFrame = createElement("TextButton", {
            Text = "",
            AutoButtonColor = false,
            Size = UDim2.new(1, 0, 0, 30),
            Parent = TabHolder,
            BackgroundTransparency = 1
        }, {
            createElement("TextLabel", {
                Text = TabConfig.Name,
                TextColor3 = Default.Text,
                TextTransparency = 0.4,
                TextSize = 14,
                Size = UDim2.new(1, -35, 1, 0),
                Position = UDim2.new(0, 35, 0, 0),
                Font = Enum.Font.GothamSemibold,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Name = "Title"
            })
        })

        local Container = createElement("ScrollingFrame", {
            Size = UDim2.new(1, -150, 1, -50),
            Position = UDim2.new(0, 150, 0, 50),
            Parent = MainWindow,
            Visible = false,
            Name = "ItemContainer",
            BackgroundTransparency = 1,
            ScrollBarThickness = 5,
            ScrollBarImageColor3 = Default.Divider,
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0)
        }, {
            createElement("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim2.new(0, 6)
            }),
            createElement("UIPadding", {
                PaddingTop = UDim2.new(0, 15),
                PaddingLeft = UDim2.new(0, 10),
                PaddingRight = UDim2.new(0, 10),
                PaddingBottom = UDim2.new(0, 15)
            })
        })

        AddConnection(Container.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
            Container.CanvasSize = UDim2.new(0, 0, 0, Container.UIListLayout.AbsoluteContentSize.Y + 30)
        end)

        if FirstTab then
            FirstTab = false
            TabFrame.Title.TextTransparency = 0
            TabFrame.Title.Font = Enum.Font.GothamBlack
            Container.Visible = true
        end

        AddConnection(TabFrame.MouseButton1Click, function()
            for _, Tab in next, TabHolder:GetChildren() do
                if Tab:IsA("TextButton") then
                    Tab.Title.Font = Enum.Font.GothamSemibold
                    TweenService:Create(Tab.Title, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0.4}):Play()
                end
            end
            for _, ItemContainer in next, MainWindow:GetChildren() do
                if ItemContainer.Name == "ItemContainer" then
                    ItemContainer.Visible = false
                end
            end
            TweenService:Create(TabFrame.Title, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
            TabFrame.Title.Font = Enum.Font.GothamBlack
            Container.Visible = true
        end)

        local function GetElements(ItemParent)
            local ElementFunction = {}
            
            function ElementFunction:AddLabel(Text)
                local LabelFrame = createElement("Frame", {
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundColor3 = Default.Second,
                    BackgroundTransparency = 0.7,
                    Parent = ItemParent,
                    BorderSizePixel = 0
                }, {
                    createElement("UICorner", {CornerRadius = UDim.new(0, 5)}),
                    createElement("UIStroke", {Color = Default.Stroke, Thickness = 1}),
                    createElement("TextLabel", {
                        Text = Text,
                        TextColor3 = Default.Text,
                        TextSize = 15,
                        Size = UDim2.new(1, -12, 1, 0),
                        Position = UDim2.new(0, 12, 0, 0),
                        Font = Enum.Font.GothamBold,
                        BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Name = "Content"
                    })
                })

                local LabelFunction = {}
                function LabelFunction:Set(ToChange)
                    LabelFrame.Content.Text = ToChange
                end
                return LabelFunction
            end
            
            function ElementFunction:AddParagraph(Text, Content)
                Text = Text or "Text"
                Content = Content or "Content"

                local ParagraphFrame = createElement("Frame", {
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundColor3 = Default.Second,
                    BackgroundTransparency = 0.7,
                    Parent = ItemParent,
                    BorderSizePixel = 0
                }, {
                    createElement("UICorner", {CornerRadius = UDim.new(0, 5)}),
                    createElement("UIStroke", {Color = Default.Stroke, Thickness = 1}),
                    createElement("TextLabel", {
                        Text = Text,
                        TextColor3 = Default.Text,
                        TextSize = 15,
                        Size = UDim2.new(1, -12, 0, 14),
                        Position = UDim2.new(0, 12, 0, 10),
                        Font = Enum.Font.GothamBold,
                        BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Name = "Title"
                    }),
                    createElement("TextLabel", {
                        Text = Content,
                        TextColor3 = Default.TextDark,
                        TextSize = 13,
                        Size = UDim2.new(1, -24, 0, 0),
                        Position = UDim2.new(0, 12, 0, 26),
                        Font = Enum.Font.GothamSemibold,
                        BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Name = "Content",
                        TextWrapped = true
                    })
                })

                AddConnection(ParagraphFrame.Content:GetPropertyChangedSignal("Text"), function()
                    ParagraphFrame.Content.Size = UDim2.new(1, -24, 0, ParagraphFrame.Content.TextBounds.Y)
                    ParagraphFrame.Size = UDim2.new(1, 0, 0, ParagraphFrame.Content.TextBounds.Y + 35)
                end)

                local ParagraphFunction = {}
                function ParagraphFunction:Set(ToChange)
                    ParagraphFrame.Content.Text = ToChange
                end
                return ParagraphFunction
            end
            
            function ElementFunction:AddButton(ButtonConfig)
                ButtonConfig = ButtonConfig or {}
                ButtonConfig.Name = ButtonConfig.Name or "Button"
                ButtonConfig.Callback = ButtonConfig.Callback or function() end

                local Button = {}

                local ButtonFrame = createElement("Frame", {
                    Size = UDim2.new(1, 0, 0, 33),
                    BackgroundColor3 = Default.Second,
                    Parent = ItemParent,
                    BorderSizePixel = 0
                }, {
                    createElement("UICorner", {CornerRadius = UDim.new(0, 5)}),
                    createElement("UIStroke", {Color = Default.Stroke, Thickness = 1}),
                    createElement("TextLabel", {
                        Text = ButtonConfig.Name,
                        TextColor3 = Default.Text,
                        TextSize = 15,
                        Size = UDim2.new(1, -12, 1, 0),
                        Position = UDim2.new(0, 12, 0, 0),
                        Font = Enum.Font.GothamBold,
                        BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Name = "Content"
                    }),
                    createElement("TextButton", {
                        Text = "",
                        AutoButtonColor = false,
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0
                    })
                })

                local Click = ButtonFrame:FindFirstChild("TextButton")

                AddConnection(Click.MouseEnter, function()
                    TweenService:Create(ButtonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        BackgroundColor3 = Color3.fromRGB(Default.Second.R * 255 + 3, Default.Second.G * 255 + 3, Default.Second.B * 255 + 3)
                    }):Play()
                end)

                AddConnection(Click.MouseLeave, function()
                    TweenService:Create(ButtonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        BackgroundColor3 = Default.Second
                    }):Play()
                end)

                AddConnection(Click.MouseButton1Up, function()
                    TweenService:Create(ButtonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        BackgroundColor3 = Color3.fromRGB(Default.Second.R * 255 + 3, Default.Second.G * 255 + 3, Default.Second.B * 255 + 3)
                    }):Play()
                    spawn(function()
                        ButtonConfig.Callback()
                    end)
                end)

                AddConnection(Click.MouseButton1Down, function()
                    TweenService:Create(ButtonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        BackgroundColor3 = Color3.fromRGB(Default.Second.R * 255 + 6, Default.Second.G * 255 + 6, Default.Second.B * 255 + 6)
                    }):Play()
                end)

                function Button:Set(ButtonText)
                    ButtonFrame.Content.Text = ButtonText
                end

                return Button
            end
            
            function ElementFunction:AddToggle(ToggleConfig)
                ToggleConfig = ToggleConfig or {}
                ToggleConfig.Name = ToggleConfig.Name or "Toggle"
                ToggleConfig.Default = ToggleConfig.Default or false
                ToggleConfig.Callback = ToggleConfig.Callback or function() end
                ToggleConfig.Color = ToggleConfig.Color or Color3.fromRGB(9, 99, 195)
                ToggleConfig.Flag = ToggleConfig.Flag or nil

                local Toggle = {Value = ToggleConfig.Default}

                local ToggleFrame = createElement("Frame", {
                    Size = UDim2.new(1, 0, 0, 38),
                    BackgroundColor3 = Default.Second,
                    Parent = ItemParent,
                    BorderSizePixel = 0
                }, {
                    createElement("UICorner", {CornerRadius = UDim.new(0, 5)}),
                    createElement("UIStroke", {Color = Default.Stroke, Thickness = 1}),
                    createElement("TextLabel", {
                        Text = ToggleConfig.Name,
                        TextColor3 = Default.Text,
                        TextSize = 15,
                        Size = UDim2.new(1, -12, 1, 0),
                        Position = UDim2.new(0, 12, 0, 0),
                        Font = Enum.Font.GothamBold,
                        BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Name = "Content"
                    }),
                    createElement("Frame", {
                        Size = UDim2.new(0, 24, 0, 24),
                        Position = UDim2.new(1, -24, 0.5, 0),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        BackgroundColor3 = ToggleConfig.Default and ToggleConfig.Color or Default.Divider,
                        BorderSizePixel = 0
                    }, {
                        createElement("UICorner", {CornerRadius = UDim.new(0, 4)}),
                        createElement("UIStroke", {
                            Color = ToggleConfig.Default and ToggleConfig.Color or Default.Stroke,
                            Thickness = 1,
                            Transparency = 0.5,
                            Name = "Stroke"
                        }),
                        createElement("ImageLabel", {
                            Image = "rbxassetid://3944680095",
                            Size = UDim2.new(0, 20, 0, 20),
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            Position = UDim2.new(0.5, 0, 0.5, 0),
                            ImageColor3 = Color3.fromRGB(255, 255, 255),
                            BackgroundTransparency = 1,
                            Name = "Ico"
                        })
                    }),
                    createElement("TextButton", {
                        Text = "",
                        AutoButtonColor = false,
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0
                    })
                })

                local ToggleBox = ToggleFrame:FindFirstChild("Frame")
                local Click = ToggleFrame:FindFirstChild("TextButton")

                function Toggle:Set(Value)
                    self.Value = Value
                    TweenService:Create(ToggleBox, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        BackgroundColor3 = Toggle.Value and ToggleConfig.Color or Default.Divider
                    }):Play()
                    TweenService:Create(ToggleBox.Stroke, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        Color = Toggle.Value and ToggleConfig.Color or Default.Stroke
                    }):Play()
                    TweenService:Create(ToggleBox.Ico, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        ImageTransparency = Toggle.Value and 0 or 1,
                        Size = Toggle.Value and UDim2.new(0, 20, 0, 20) or UDim2.new(0, 8, 0, 8)
                    }):Play()
                    ToggleConfig.Callback(Toggle.Value)
                end

                Toggle:Set(Toggle.Value)

                AddConnection(Click.MouseEnter, function()
                    TweenService:Create(ToggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        BackgroundColor3 = Color3.fromRGB(Default.Second.R * 255 + 3, Default.Second.G * 255 + 3, Default.Second.B * 255 + 3)
                    }):Play()
                end)

                AddConnection(Click.MouseLeave, function()
                    TweenService:Create(ToggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        BackgroundColor3 = Default.Second
                    }):Play()
                end)

                AddConnection(Click.MouseButton1Up, function()
                    Toggle:Set(not Toggle.Value)
                end)

                AddConnection(Click.MouseButton1Down, function()
                    TweenService:Create(ToggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        BackgroundColor3 = Color3.fromRGB(Default.Second.R * 255 + 6, Default.Second.G * 255 + 6, Default.Second.B * 255 + 6)
                    }):Play()
                end)

                if ToggleConfig.Flag then
                    OrionLib.Flags[ToggleConfig.Flag] = Toggle
                end
                return Toggle
            end
            
            return ElementFunction
        end

        local ElementFunction = {}
        
        function ElementFunction:AddSection(SectionConfig)
            SectionConfig.Name = SectionConfig.Name or "Section"

            local SectionFrame = createElement("Frame", {
                Size = UDim2.new(1, 0, 0, 26),
                BackgroundTransparency = 1,
                Parent = Container
            }, {
                createElement("TextLabel", {
                    Text = SectionConfig.Name,
                    TextColor3 = Default.TextDark,
                    TextSize = 14,
                    Size = UDim2.new(1, -12, 0, 16),
                    Position = UDim2.new(0, 0, 0, 3),
                    Font = Enum.Font.GothamSemibold,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left
                }),
                createElement("Frame", {
                    AnchorPoint = Vector2.new(0, 0),
                    Size = UDim2.new(1, 0, 1, -24),
                    Position = UDim2.new(0, 0, 0, 23),
                    BackgroundTransparency = 1,
                    Name = "Holder"
                }, {
                    createElement("UIListLayout", {
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Padding = UDim2.new(0, 6)
                    })
                })
            })

            AddConnection(SectionFrame.Holder.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
                SectionFrame.Size = UDim2.new(1, 0, 0, SectionFrame.Holder.UIListLayout.AbsoluteContentSize.Y + 31)
                SectionFrame.Holder.Size = UDim2.new(1, 0, 0, SectionFrame.Holder.UIListLayout.AbsoluteContentSize.Y)
            end)

            local SectionFunction = {}
            for i, v in next, GetElements(SectionFrame.Holder) do
                SectionFunction[i] = v
            end
            return SectionFunction
        end

        for i, v in next, GetElements(Container) do
            ElementFunction[i] = v
        end

        if TabConfig.PremiumOnly then
            for i, v in next, ElementFunction do
                ElementFunction[i] = function() end
            end
            Container:FindFirstChild("UIListLayout"):Destroy()
            Container:FindFirstChild("UIPadding"):Destroy()
            createElement("Frame", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Parent = Container
            }, {
                createElement("TextLabel", {
                    Text = "Premium Features",
                    TextColor3 = Default.Text,
                    TextSize = 14,
                    Size = UDim2.new(1, -150, 0, 14),
                    Position = UDim2.new(0, 150, 0, 112),
                    Font = Enum.Font.GothamBold,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left
                }),
                createElement("TextLabel", {
                    Text = "This part of the script is locked to premium users.",
                    TextColor3 = Default.TextDark,
                    TextSize = 12,
                    Size = UDim2.new(1, -200, 0, 14),
                    Position = UDim2.new(0, 150, 0, 138),
                    Font = Enum.Font.Gotham,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true
                })
            })
        end
        
        return ElementFunction
    end
    
    return TabFunction
end

function OrionLib:Destroy()
    Orion:Destroy()
end

return OrionLib