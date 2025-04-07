net.Receive("Nexus_MegaloBegin", function()
    local ply = LocalPlayer()
    if not ply then return end

    local bossStart = CurTime()
    local slow = false
    local fightEndTime = bossStart + 20
    local glitches = {}
    local rings = {}

    hook.Add("Think", "Nexus_MegaloFight", function()
        local now = CurTime()

        -- Screen inversion
        if math.random(1, 200) == 1 then
            DrawColorModify({
                ["$pp_colour_addr"] = 1,
                ["$pp_colour_addg"] = 1,
                ["$pp_colour_addb"] = 1,
                ["$pp_colour_brightness"] = 0,
                ["$pp_colour_contrast"] = 1,
                ["$pp_colour_colour"] = 0,
                ["$pp_colour_mulr"] = 0,
                ["$pp_colour_mulg"] = 0,
                ["$pp_colour_mulb"] = 0
            })
        end

        -- Glitches (random flashes)
        if math.random(1, 100) == 1 then
            local glitch = vgui.Create("DPanel")
            glitch:SetSize(ScrW(), ScrH())
            glitch.Paint = function(s, w, h)
                surface.SetDrawColor(255, 255, 255, 10)
                surface.DrawRect(0, 0, w, h)
            end
            glitch:MoveToBack()
            table.insert(glitches, { panel = glitch, time = now + 0.2 })
        end

        -- Cleanup old glitches
        for i = #glitches, 1, -1 do
            if now > glitches[i].time then
                glitches[i].panel:Remove()
                table.remove(glitches, i)
            end
        end

        -- Rings (visual indicator before prop spawns)
        if math.random(1, 40) == 1 then
            local pos = ply:GetPos() + VectorRand() * 100
            local effect = EffectData()
            effect:SetOrigin(pos)
            util.Effect("HelicopterMegaBomb", effect)
        end

        -- Popups
        if math.random(1, 100) <= 5 then
            local msgs = { "IM HERE.", "RUN", "STRIKES BACK", "HEY IM COMING" }
            local msg = msgs[math.random(#msgs)]

            local frame = vgui.Create("DFrame")
            frame:SetSize(300, 100)
            frame:SetTitle("!")
            frame:Center()
            frame:MakePopup()

            local label = vgui.Create("DLabel", frame)
            label:SetText(msg)
            label:Dock(FILL)
            label:SetContentAlignment(5)
        end

        -- SELL YOUR SOUL popup
        if not slow and math.random(1, 100) <= 20 then
            local frame = vgui.Create("DFrame")
            frame:SetSize(300, 100)
            frame:SetTitle("SELL YOUR SOUL?")
            frame:Center()
            frame:MakePopup()

            local yes = vgui.Create("DButton", frame)
            yes:SetText("Yes")
            yes:SetPos(30, 40)
            yes:SetSize(100, 30)
            yes.DoClick = function()
                slow = true
                frame:Close()
                timer.Create("MegaloSlow", 20, 1, function()
                    hook.Remove("Think", "Nexus_MegaloFight")
                    chat.AddText(Color(255, 0, 0), "[NEXUS] You survived the punishment.")
                end)
            end

            local no = vgui.Create("DButton", frame)
            no:SetText("No")
            no:SetPos(160, 40)
            no:SetSize(100, 30)
            no.DoClick = function()
                frame:Close()
            end
        end

        -- Boss end
        if now >= fightEndTime and not slow then
            hook.Remove("Think", "Nexus_MegaloFight")
            chat.AddText(Color(255, 0, 0), "[NEXUS] You survived the Megalo.")
        end
    end)
end)

hook.Add("Initialize", "Nexus_MegaloNet", function()
    net.Receive("Nexus_MegaloBegin", function() end)
end)
