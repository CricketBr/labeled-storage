if not cb then cb = {} end
if not cb.ls then cb.ls = {} end

require('util')





local function decipher_ls_mc_name(oname)
    -- returns nil if not valid labeled storage name, or entity isn't one of mine
    -- if ((entity == nil) or (not entity.valid)) then
    --     return nil
    -- end
    -- local name = entity.name
    -- if (entity.type == 'entity_ghost') then
    --     name = entity.ghost_name
    -- end
    -- if string.sub(name, 1, 9) ~= 'cb-ls-mc-' then
    --     return nil
    -- end

    local R = {}

    R.basename = string.sub(oname, 10, -5)
    R.letter = string.sub(oname, -3, -2)
    R.number = tonumber(string.sub(oname, -1, -1)) -- need number to do math

    return R
end








local function change_storage_label(event)
    -- based on nullius mirror_event(event)
    -- https://github.com/GregorSamsanite/nullius/blob/ecd7633ca47d3035a35021bbfc0b9df789f4a31a/nullius/scripts/mirror.lua
    local L = {}
    if not settings.startup['cb-ls-many-containers'].value then
        return
    end
    L.player = game.players[event.player_index]
    if ((L.player == nil) or (not L.player.valid)) then
        return
    end
    targetentity = table.deepcopy(L.player.selected)
    if not targetentity then
        return
    end
    L.oldname = targetentity.name
    -- L.oldlocal_name = targetentity.localised_name

    if targetentity.type == 'entity-ghost' then
        L.oldname = targetentity.ghost_name
        -- L.oldlocal_name = targetentity.ghost_localised_name
    end

    L.namebits = decipher_ls_mc_name(L.oldname)
    if (L.namebits == nil) then
        return
    end



    if event.input_name == 'cb-ls-switch' then
        if L.namebits.letter == 'EM' then
            L.namebits.letter = 'IM'
        elseif L.namebits.letter == 'IM' then
            L.namebits.letter = 'EC'
        elseif L.namebits.letter == 'EC' then
            L.namebits.letter = 'IC'
        elseif
            L.namebits.letter == 'IC' then
            L.namebits.letter = 'EM'
        end
    end

    if event.input_name == 'cb-ls-up' then
        L.namebits.number = L.namebits.number + 1
        if L.namebits.number > 9 then
            L.namebits.number = 0
        end
    end

    if event.input_name == 'cb-ls-down' then
        L.namebits.number = L.namebits.number - 1
        if L.namebits.number < 0 then
            L.namebits.number = 9
        end
    end

    L.fullnewname = 'cb-ls-mc-' .. L.namebits.basename .. '-' .. L.namebits.letter .. tostring(L.namebits.number)

    -- local force = (event.target.force or event.player.force)
    L.force = (targetentity.force or event.player.force)

    if (game.entity_prototypes[L.fullnewname] == nil) then
        return nil
    end




    -- if L.dir == nil then L.dir = targetentity.direction end ?? edited before snapshotting
    L.dir = targetentity.direction

    -- next bit is from nullius replace_fluid_entity()

    if targetentity.type == 'entity-ghost' then
        L.pos = targetentity.position
        L.surface = targetentity.surface
        targetentity.destroy()
        targetentity = L.surface.create_entity
            {
                name = 'entity-ghost',
                force = L.force,
                direction = L.dir,
                position = L.pos,
                inner_name = L.fullnewname,
                fast_replace = true,
                create_build_effect_smoke = true
            }
    else
        targetentity = targetentity.surface.create_entity
            {
                name = L.fullnewname,
                force = L.force,
                direction = L.dir,
                position = targetentity.position,
                raise_built = true,
                fast_replace = true,
                create_build_effect_smoke = true,
                spill = false
            }
    end
    local b = 1
end







-- script.on_event waits for the event, then calls the function and automatically sends it the event info as an argument.
-- can probably put "if setting" around this, to save processing, but it breaks auto-format, which I rely on heavily.
script.on_event('cb-ls-switch', change_storage_label)
script.on_event('cb-ls-up', change_storage_label)
script.on_event('cb-ls-down', change_storage_label)
