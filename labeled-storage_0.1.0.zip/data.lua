-- require('__cb-library__/cb-image-functions')



-- up, down = number of stacks in stack-chests, label in labeled-storage
-- other is req/prov in labeled-storage
-- entity changes

require('prototypes.cb-labeled-storage-functions')

if not cb then cb = {} end
if not cb.ls then cb.ls = {} end

data:extend(
    {
        { type = 'custom-input', name = 'cb-ls-switch', key_sequence = 'KP_MULTIPLY', consuming = nil, order = '01', include_selected_prototype = true },
        { type = 'custom-input', name = 'cb-ls-up',     key_sequence = 'KP_PLUS',     consuming = nil, order = '03', include_selected_prototype = true },
        { type = 'custom-input', name = 'cb-ls-down',   key_sequence = 'KP_MINUS',    consuming = nil, order = '04', include_selected_prototype = true },

        -- not sure of need to include selected prototype; Nullius does
    }
)


if settings.startup['cb-ls-many-containers'].value then
    -- make the item-group image and tab
    local new_layers =
    {
        { file = 'a-square.png',      tint = cb.lib.tints.P,      scale = 1, },
        { file = 'a-square.png',      tint = cb.lib.tints.ltgrey, scale = .75, },
        { file = 'a-tri-topleft.png', tint = cb.lib.tints.dkgrey, scale = 1, },
        { file = 'X.png',             tint = cb.lib.tints.dkgrey, scale = .75 }
    }
    local llayers = cb.lib.make_layers({}, new_layers)


    data:extend(
        {
            { type = 'item-group',    name = 'cb-ls-group', icon_size = 64,        icons = llayers.icons, order = 'y' },
            { type = 'item-subgroup', name = 'cb-ls-test1', group = 'cb-ls-group', order = 'aa' },
        })
end

if settings.startup['cb-ls-tiny-chests'].value then
    data:extend(
        {
            { type = 'item-subgroup', name = 'cb-ls-tiny-chests', group = 'logistics', order = 'aa' },
        }
    )
end
