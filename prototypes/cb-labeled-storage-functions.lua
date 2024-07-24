require('__cb-library__/cb-image-functions')


if not cb then cb = {} end
if not cb.ls then cb.ls = {} end
if not cb.lib then cb.lib = {} end

-- require('__flib__/data-util')
local flib_data_util = require("__flib__.data-util")
-- -- local serpent = require("serpent")




local function make_one_tiny_chest(c, tech)
    -- actually makes a set of 3, not just 1
    -- c = {
    -- basename = name of the base logistic chest
    -- letter = S or P, also determines corner tab
    -- }

    for i = 1, 3 do
        local lbase = data.raw['logistic-container'][c.basename]

        local nm = 'cb-ls-tiny-chest-' .. c.letter .. tostring(i)
        local litem = table.deepcopy(data.raw.item[c.basename])

        local lrecipe = table.deepcopy(data.raw.recipe[c.basename])
        local lentity = table.deepcopy(data.raw['logistic-container'][c.basename])

        local corner
        if c.letter == 'P' then
            corner = 'a-tri-botleft.png'
        else
            corner = 'a-tri-botright.png'
        end

        local new_layer_info =
        {


            { file = 'a-square.png',               tint = cb.lib.tints[c.letter], scale = 1,    entityshift = 'left-top', iconshift = { -6, 6 } },
            { file = 'a-square.png',               tint = cb.lib.tints.ltgrey,    scale = .75,  entityshift = 'left-top', iconshift = { -6, 6 } },

            { file = c.letter .. '-left.png',      tint = cb.lib.tints.dkgrey,    scale = 0.75, entityshift = 'left-top', iconshift = { -6, 6 } },
            { file = 'smsquare-' .. i .. 'rt.png', tint = cb.lib.tints.dkgrey,    scale = 0.75, entityshift = 'left-top', iconshift = { -6, 6 } },




            -- { file = 'a-square.png',             tint = cb.lib.tints.ltgrey,    scale = 1,    entityshift = 'left-top', iconshift = { -6, -6 } },
            -- { file = c.letter .. '.png',         tint = cb.lib.tints.dkgrey,    scale = 0.75, entityshift = 'left-top', iconshift = { -6, -6 } },
            -- { file = 'frame08.png',              tint = cb.lib.tints[c.letter], scale = 1,    entityshift = 'left-top', iconshift = { -6, -6 } },
            -- { file = 'smsquare-' .. i .. 'lt.png', tint = cb.lib.tints.dkgrey,    scale = 1,    entityshift = 'left-top', iconshift = { -6, -6 } },
        }

        local images = cb.lib.make_layers(lentity, new_layer_info)

        -- ITEM

        litem.name = nm
        litem.subgroup = 'cb-ls-tiny-chests'

        litem.place_result = nm
        -- litem.localised_name = nm
        cb.lib.add_icon_layers(litem, images.icons)
        data:extend({ litem })

        -- RECIPES

        lrecipe = {}
        lrecipe.name = nm
        lrecipe.type = 'recipe'
        lrecipe.ingredients = { { type = 'item', name = c.basename, amount = 1 } }
        lrecipe.results = { { type = 'item', name = nm, amount = 1 } }
        lrecipe.main_product = nm
        lrecipe.category = 'crafting'
        lrecipe.enabled = false
        lrecipe.always_show_made_in = true
        -- icon inherited from item

        data:extend({ lrecipe })

        table.insert(data.raw.technology[tech].effects, { type = 'unlock-recipe', recipe = nm })



        -- ENTITY


        lentity.name = nm
        lentity.minable.result = nm
        cb.lib.add_icon_layers(lentity, images.icons)
        cb.lib.add_animation_layers_to_logcont(lentity, images.animation_layers)
        lentity.inventory_size = i
        lentity.subgroup = 'cb-ls-tiny-chests'
        data:extend({ lentity })
    end
end


function cb.ls.tiny_chests(list, tech)
    -- list = { basename = 'nullius-small-storage-chest-1',  letter = 'S' },
    -- tech = 'nullius-logistic-robot-1'

    -- DIRECTIONS FOR USING WITH MODS THAT USE NON-STANDARD BASE CHESTS ARE IN DATA.LUA and/or DATA-FINAL-FIXES.LUA, WHICH CALLS THIS FUNCTION.



    for _, c in ipairs(list) do
        make_one_tiny_chest(c, tech) -- makes a set of 3

        data.raw['logistic-container']['cb-ls-tiny-chest-' .. c.letter .. '1'].next_upgrade = 'cb-ls-tiny-chest-' ..
            c.letter .. '2'
        data.raw['logistic-container']['cb-ls-tiny-chest-' .. c.letter .. '2'].next_upgrade = 'cb-ls-tiny-chest-' ..
            c.letter .. '3'
        data.raw['logistic-container']['cb-ls-tiny-chest-' .. c.letter .. '3'].next_upgrade = c.basename
    end
end

function cb.ls.logistic_labels()
    -- local gfolder = '__labeled-storage__/graphics/'

    for _, pt in pairs(data.raw['logistic-container']) do
        -- local litem = data.raw.item[pt.name]
        -- local lentity = data.raw['logistic-container'][pt.name]
        -- if not string.find(pt.name, 'cb') then
        if not (string.sub(pt.name, 1, 5) == 'cb-ls') then
            -- if it's created by this mod, then it already has a label

            local letter = cb.lib.letterlist[pt.logistic_mode]

            local new_layer_info =
            {
                { file = 'a-square.png',   tint = cb.lib.tints[letter], scale = 1,    entityshift = 'left-bot', iconshift = { -6, 6 } },
                { file = 'a-square.png',   tint = cb.lib.tints.ltgrey,  scale = 0.75, entityshift = 'left-bot', iconshift = { -6, 6 } },
                { file = letter .. '.png', tint = cb.lib.tints.dkgrey,  scale = 0.75, entityshift = 'left-bot', iconshift = { -6, 6 } },
            }

            local images = cb.lib.make_layers(pt, new_layer_info)
            cb.lib.add_icon_layers(pt, images.icons) -- pt is the entity
            cb.lib.add_icon_layers(data.raw.item[pt.name], images.icons)
            if pt.animation then
                cb.lib.add_animation_layers_to_logcont(pt, images.animation_layers)
            elseif pt.picture then
                cb.lib.add_picture_layers_to_container(pt, images.picture_layers)
            end
        end
    end
end

local function make_one_labst(args)
    -- orig_entity  -- the entity
    -- tech for recipe

    -- the above is for mods that use the convention of item, entity, and localisation all agree on the name.


    local L = {}

    L.oname = args.orig_entity.name
    L.name = 'cb-ls-mc-' .. L.oname .. '-' .. args.letter .. args.num
    L.p0name = 'cb-ls-mc-' .. L.oname .. '-' .. 'EM0'


    if L.oname == 'angels-pressure-tank-1' then
        local b = 1
    end

    if args.orig_entity.localised_name and args.orig_entity.localised_name[1] then
        L.localised_name = {}
        L.localised_name[1] = args.orig_entity.localised_name[1] .. '-' .. args.letter .. args.num
    end

    if args.orig_entity.localised_description and args.orig_entity.localised_description[1] then
        L.localised_description = {}
        L.localised_description[1] = args.orig_entity.localised_description[1] .. '-' .. args.letter .. args.num
    end




    L.images = {}
    L.new_layer_info = {}


    if not data.raw.item[L.oname] then
        return
    end

    if args.letter == 'EM' then
        L.corner = 'a-tri-topleft.png'
        L.colour = cb.lib.tints.P
    elseif args.letter == 'IM' then
        L.corner = 'a-tri-topright.png'
        L.colour = cb.lib.tints.R
    elseif args.letter == 'EC' then
        L.corner = 'a-tri-botleft.png'
        L.colour = cb.lib.tints.P
    else
        L.corner = 'a-tri-botright.png'
        L.colour = cb.lib.tints.R
    end

    L.new_layer_info =
    {
        { file = 'a-square.png',     tint = cb.lib.tints.ltgrey, scale = 1,   iconshift = { -6, 6 }, entityshift = 'left-bot' },
        { file = L.corner,           tint = cb.lib.tints.dkgrey, scale = 1,   iconshift = { -6, 6 }, entityshift = 'left-bot' },
        { file = 'frame08.png',      tint = L.colour,            scale = 1,   iconshift = { -6, 6 }, entityshift = 'left-bot' },
        { file = args.num .. '.png', tint = cb.lib.tints.dkgrey, scale = .75, iconshift = { -6, 6 }, entityshift = 'left-bot' }
    }
    L.images = cb.lib.make_layers(args.orig_entity, L.new_layer_info)
    -- yes, bottom will be obscured by pipe cover on 1x1 tanks. Alternative is top left (Artisinal Reskins), top right (icon badges), bot right (same problem with pipe cover)


    if args.letter == 'EM' and args.num == '0' then
        L.item = table.deepcopy(data.raw.item[L.oname])
        L.item.name = L.name
        cb.lib.add_icon_layers(L.item, L.images.icons)
        L.item.place_result = L.name
        -- L.item.subgroup = args.subgroup
        L.item.localised_description = L.localised_description
        L.item.localised_name = L.localised_name
        L.item.order = L.item.order .. '1'
        data:extend({ L.item })



        L.recipe =
        {
            name = L.name,
            type = 'recipe',
            -- category = 'crafting',
            -- icons = limages.icons,
            ingredients = { { type = 'item', name = L.oname, amount = 1 } },
            results = { { type = 'item', name = L.name, amount = 1 } },
            main_product = L.name,
            enabled = false,
            hide_from_stats = true,
            unlock_results = true,
            localised_description = L.localised_description,
            localised_name = L.localised_name
        }
        data:extend({ L.recipe })

        if not args.tech then args.tech = 'logistic-science-pack' end
        table.insert(data.raw['technology'][args.tech].effects, { type = 'unlock-recipe', recipe = L.name })
    end



    L.entity = table.deepcopy(args.orig_entity)
    L.entity.name = L.name
    cb.lib.add_icon_layers(L.entity, L.images.icons)

    if L.entity.type == 'container' then
        cb.lib.add_picture_layers_to_container(L.entity, L.images.picture_layers)
    end

    if L.entity.type == 'storage-tank' then
        cb.lib.add_picture_layers_to_storage_tank(L.entity, L.images.spriteNway_layers)
    end


    L.entity.mineable = { mining_time = 0.2, result = L.p0name }

    -- L.entity.subgroup = args.subgroup
    L.entity.next_upgrade = nil
    L.entity.placeable_by = { item = L.p0name, count = 1 }
    L.entity.localised_description = L.localised_description
    L.entity.localised_name = L.localised_name


    data:extend
    {

        L.entity,
    }
end




function cb.ls.make_all_labst(list)
    local L = {}
    for _, v in pairs(list) do
        -- local v = list[1]


        local origpt = table.deepcopy(data.raw[v.type][v.name])

        if not origpt.fast_replaceable_group then
            L.frsize = origpt.selection_box[1][1] * 2
            if origpt.type == 'container' then
                origpt.fast_replaceable_group = 'container-' .. tostring(L.frsize)
            end
            if origpt.type == 'storage-tank' then
                origpt.fast_replaceable_group = 'storage-tank-' .. tostring(L.frsize)
            end
        end
        -- for _, letter in pairs({ 'P' }) do
        --     for _, num in pairs({ '0' }) do
        for _, letter in pairs({ 'EM', 'IM', 'EC', 'IC' }) do
            for _, num in pairs({ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' }) do
                make_one_labst(
                    {
                        orig_entity = origpt,
                        num = num,       -- priority
                        letter = letter, -- P or R
                        type = v.type,
                        -- subgroup = sg,
                        tech = v.tech,

                    })
            end
        end
    end
end

-- need tech for labelled storage
