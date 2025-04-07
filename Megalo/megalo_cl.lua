-- MegaloBossFight plugin clientside

local function DisplayRandomPopup()
    local messages = {
        "IM HERE.",
        "RUN",
        "STRIKES BACK",
        "HEY IM COMING",
        "RUN"
    }

    if math.random() <= 0.2 then
        table.insert(messages, "SELL YOUR SOUL")
    end

    local message = messages[math.random(#messages)]

    local frame = vgui.Create("DFrame")
    frame:SetSize(300, 150)
    frame:SetTitle("WARNING")
    frame:Center()
    frame:MakePopup()

    local label = vgui.Create("DLabel", frame)
    label:SetText(message)
    label:Dock(TOP)
    label:SetFont("DermaLarge")
    label:SetTextColor(Color(255, 0, 0))
    label:SetContentAlignment(5)
    label:DockMargin(0, 20, 0, 20)
    label:SizeToContents()

    if message == "SELL YOUR SOUL" then
        local yes = vgui.Create("DButton", frame)
        yes:SetText("yes")
        yes:Dock(LEFT)
        yes:DockMargin(50, 0, 10, 0)
        yes.DoClick = function()
            frame:Close()
            net.Start("MegaloBossFight_SoulDeal")
            net.WriteBool(true)
            net.SendToServer()
        end

        local no = vgui.Create("DButton", frame)
        no:SetText("no")
        no:Dock(RIGHT)
        no:DockMargin(10, 0, 50, 0)
        no.DoClick = function()
            frame:Close()
            net.Start("MegaloBossFight_SoulDeal")
            net.WriteBool(false)
            net.SendToServer()
        end
    end
end

net.Receive("MegaloBossFight_ShowPopup", function()
    DisplayRandomPopup()
end)
