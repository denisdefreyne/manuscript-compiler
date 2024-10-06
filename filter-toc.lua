-- Generate a Table of Contents.
--
-- This is an adaption of the Haskell code used in pandoc. This script
-- is intended to be adapted to specific requirements before use. E.g.,
-- it can be modified to add additional elements as TOC items, to add
-- more info to each line in the TOC, or to control whether the heading
-- number is included in the link.

local PANDOC_WRITER_OPTIONS = PANDOC_WRITER_OPTIONS
_ENV = pandoc

local not_empty = function(x) return #x > 0 end


-- mutually recursive functions
local section_to_toc_item
local to_toc_item

to_toc_item = function(number, text, id, subcontents)
    -- remove notes and links from toc item text
    text = text:walk {
        Note = function(_) return {} end,
        Link = function(link) return link.content end,
    }

    -- add number to toc item
    if number then
        text = Span({ Str(number), Space() } .. text, { class = 'toc-section-number' })
    end

    -- create link to heading if possible
    local header_link = id == '' and text or Link(text, '#' .. id)
    local subitems = subcontents:map(section_to_toc_item):filter(not_empty)

    return List { Plain { header_link } } ..
        (#subitems == 0 and {} or { BulletList(subitems) })
end

section_to_toc_item = function(div)
    -- bail if this is not a section wrapper
    if div.t ~= 'Div' or not div.content[1] or div.content[1].t ~= 'Header' then
        return {}
    end

    local heading = div.content:remove(1)
    local number = heading.attributes.number

    -- bail if this is not supposed to be included in the toc
    if not number and heading.classes:includes 'unlisted' then
        return {}
    end

    -- bail if heading is deeper than toc depth
    if heading.level > PANDOC_WRITER_OPTIONS.toc_depth then
        return {}
    end

    return to_toc_item(number, heading.content, div.identifier, div.content)
end

-- return filter
return {
    {
        Pandoc = function(doc)
            -- Improvement over pandoc's native TOC generator: unwrap divs to avoid
            -- problems with headings nested below divs.
            local blocks_no_divs = doc.blocks:walk {
                Div = function(x) return x.content end
            }
            local sections = utils.make_sections(true, nil, blocks_no_divs)
            local toc_items = sections:map(section_to_toc_item):filter(not_empty)
            doc.meta['table-of-contents'] = { BulletList(toc_items) }
            doc.meta.toc = doc.meta['table-of-contents'] -- backwards compatibility
            return doc
        end
    },
}
