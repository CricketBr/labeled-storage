-- require('__cb-library__/cb-image-functions')
require('prototypes.cb-labeled-storage-functions')

-- require('__flib__/data-util')
local flib_data_util = require("__flib__.data-util")
-- -- local serpent = require("serpent")

if not cb then cb = {} end
if not cb.ls then cb.ls = {} end



if settings.startup['cb-ls-tiny-chests'].value then
    -- TO ADD MODS WITH A DIFFERENT BASE CHEST:
    -- EITHER ADD TO THE ABOVE IF/ELSEIF LIST,
    -- OR MAKE THE OTHER MOD DEP ON THIS ONE, AND DUPLICATE ONE OF IFELSE BLOCKS IN THE OTHER MOD.
    -- cb.ls.tiny_chests can only handle those 2 letters, and needs the tech name to enable the recipe.
    -- Behaviour if sent something different is unpredictable.

    -- cb.ls.skip_base_log_chests is for mods that don't use the base game internal names for the lowest S and P chests.

    -- Nullius
    if mods['nullius'] then
        cb.ls.skip_base_log_chests = true
        cb.ls.tiny_chests(
            {
                { basename = 'nullius-small-storage-chest-1', letter = 'S' },

            },
            'nullius-robotics-1'
        )
        cb.ls.tiny_chests(
            {
                { basename = 'nullius-small-supply-chest-1', letter = 'P' },
            },
            'nullius-logistic-robot-1'
        )
        local lsg = data.raw.item['nullius-small-storage-chest-1'].subgroup
        data.raw['item-subgroup']['cb-ls-tiny-chests'].order = data.raw['item-subgroup'][lsg].order .. '1'
    end


    if not cb.ls.skip_base_log_chests then
        -- base_game
        -- todo does SB use the base game lowest log chests?
        cb.ls.tiny_chests(
            {
                { basename = 'logistic-chest-passive-provider', letter = 'P' },
                { basename = 'logistic-chest-storage',          letter = 'S' },
            },
            'logistic-robotics'
        )
    end
    local lsg = data.raw.item['logistic-chest-passive-provider'].subgroup
    local loldorder = data.raw['item-subgroup'][lsg].order
    local lneworder = string.sub(loldorder, 1, -1)
    data.raw['item-subgroup']['cb-ls-tiny-chests'].order = lneworder
end



-- label logistics chests last, so don't overwrite the labels of the special ones
if settings.startup['cb-ls-logistic-labels'].value then
    -- list needs base containers; does it need more than that?

    -- cb.ls.skip_base_chest_labels SET IF YOUR MOD OR MODPACK CHANGES VANILLA CONTAINERS

    cb.ls.logistic_labels()
end



if settings.startup['cb-ls-many-containers'].value then
    local list = {}
    local techlist = {}

    -- list is the list of containers and storage-tanks to get labeled versions.
    --- tech is the original tech, NOT the one made by this mod

    -- techlist is the list of techs that need a labeled-storage version.


    -- Warehousing
    if mods['Warehousing'] then
        -- table.insert(techlist, 'warehouse-research')

        if mods['nullius'] then
            table.insert(list, { name = 'storehouse-basic', type = 'container', tech = 'nullius-warehousing-1' })
            table.insert(list, { name = 'warehouse-basic', type = 'container', tech = 'nullius-warehousing-2' })
        else
            table.insert(list, { name = 'storehouse-basic', type = 'container', tech = 'warehouse-research' })
            table.insert(list, { name = 'warehouse-basic', type = 'container', tech = 'warehouse-research' })
        end
    end

    if mods['nullius'] then
        cb.ls.skip_base_labeled_storage = true
        -- table.insert(techlist, 'nullius-woodworking')
        -- table.insert(techlist, 'nullius-storage-1')
        -- table.insert(techlist, 'nullius-storage-2')
        -- table.insert(techlist, 'nullius-storage-3')
        -- table.insert(techlist, 'nullius-plumbing-1')
        -- table.insert(techlist, 'nullius-plumbing-2')
        -- table.insert(techlist, 'nullius-plumbing-3')
        -- table.insert(techlist, 'nullius-plumbing-4')
        -- table.insert(techlist, 'nullius-plumbing-5')
        -- table.insert(techlist, 'nullius-plumbing-6')


        table.insert(list, { tech = 'nullius-storage-1', type = 'container', name = 'wooden-chest', })
        table.insert(list, { tech = 'nullius-storage-2', type = 'container', name = 'iron-chest', })
        table.insert(list, { tech = 'nullius-storage-2', type = 'container', name = 'nullius-large-chest-1', })
        table.insert(list, { tech = 'nullius-storage-3', type = 'container', name = 'steel-chest', })
        table.insert(list, { tech = 'nullius-storage-3', type = 'container', name = 'nullius-large-chest-2', })

        table.insert(list, { tech = 'nullius-plumbing-1', type = 'storage-tank', name = 'storage-tank', })
        table.insert(list, { tech = 'nullius-plumbing-3', type = 'storage-tank', name = 'nullius-medium-tank-2', })
        table.insert(list, { tech = 'nullius-plumbing-3', type = 'storage-tank', name = 'nullius-small-tank-1', })
        table.insert(list, { tech = 'nullius-plumbing-4', type = 'storage-tank', name = 'nullius-large-tank-1', })
        table.insert(list, { tech = 'nullius-plumbing-5', type = 'storage-tank', name = 'nullius-medium-tank-3', })
        table.insert(list, { tech = 'nullius-plumbing-5', type = 'storage-tank', name = 'nullius-small-tank-2', })
        table.insert(list, { tech = 'nullius-plumbing-5', type = 'storage-tank', name = 'nullius-large-tank-2', })
        table.insert(list, { tech = 'nullius-plumbing-6', type = 'storage-tank', name = 'nullius-large-tank-3', })
    end

    if mods['boblogistics'] then
        cb.ls.skip_base_labeled_storage = true
        table.insert(list, { tech = 'bio-wood-processing', type = 'container', name = 'wooden-chest', })
        table.insert(list, { tech = 'sb-startup3', type = 'container', name = 'iron-chest', })
        table.insert(list, { tech = 'steel-processing', type = 'container', name = 'steel-chest', })
        table.insert(list, { tech = 'zinc-processing', type = 'container', name = 'brass-chest', })
        table.insert(list, { tech = 'titanium-processing', type = 'container', name = 'titanium-chest', })
        table.insert(list, { tech = 'fluid-handling', type = 'storage-tank', name = 'storage-tank', })
        table.insert(list, { tech = 'fluid-handling', type = 'storage-tank', name = 'bob-storage-tank-all-corners', })
        table.insert(list, { tech = 'bob-fluid-handling-2', type = 'storage-tank', name = 'storage-tank-2', })
        table.insert(list,
            { tech = 'bob-fluid-handling-2', type = 'storage-tank', name = 'bob-storage-tank-all-corners-2', })
        table.insert(list, { tech = 'bob-fluid-handling-3', type = 'storage-tank', name = 'storage-tank-3', })
        table.insert(list,
            { tech = 'bob-fluid-handling-3', type = 'storage-tank', name = 'bob-storage-tank-all-corners-3', })
        table.insert(list, { tech = 'bob-fluid-handling-4', type = 'storage-tank', name = 'storage-tank-4', })
        table.insert(list,
            { tech = 'bob-fluid-handling-4', type = 'storage-tank', name = 'bob-storage-tank-all-corners-4', })
    end


    if mods['angelsrefining'] then
        -- table.insert(list, { tech = '', type = 'container', name = '', })
    end

    if mods['angelsaddons-storage'] then
        table.insert(list, { tech = 'pressure-tanks', type = 'storage-tank', name = 'angels-pressure-tank-1', })
        table.insert(list, { tech = 'ore-silos', type = 'container', name = 'silo', })
        table.insert(list, { tech = 'angels-warehouses', type = 'container', name = 'angels-warehouse', })
    end

    if mods['bobplates'] then
        table.insert(list,
            { tech = 'angels-fluid-control', type = 'storage-tank', name = 'bob-small-inline-storage-tank', })
        table.insert(list,
            { tech = 'angels-fluid-control', type = 'storage-tank', name = 'bob-small-storage-tank', })
    end



    if mods['angelspetrochem'] then
        table.insert(list, { tech = 'gas-processing', type = 'storage-tank', name = 'angels-storage-tank-1', })
        table.insert(list, { tech = 'angels-oil-processing', type = 'storage-tank', name = 'angels-storage-tank-2', })
        table.insert(list, { tech = 'angels-fluid-control', type = 'storage-tank', name = 'angels-storage-tank-3', })
    end



    -- base_game
    if not cb.ls.skip_base_labeled_storage then
        table.insert(list, { name = 'wooden-chest', type = 'container', tech = nil })
        table.insert(list, { name = 'iron-chest', type = 'container', tech = nil })
        table.insert(list, { name = 'steel-chest', type = 'container', tech = 'steel-processing' })
        table.insert(list, { name = 'storage-tank', type = 'storage-tank', tech = 'fluid-handling' })
    end



    cb.ls.make_all_labst(list)

    local b = 1
end
