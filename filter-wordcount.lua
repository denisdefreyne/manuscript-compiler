local word_count = 0

local count_words = {
    Str = function(el)
        -- we don't count a word if it's entirely punctuation:
        if el.text:match("%P") then
            word_count = word_count + 1
        end
    end,

    Code = function(el)
        local _, n = el.text:gsub("%S+", "")
        word_count = word_count + n
    end,

    CodeBlock = function(el)
        local _, n = el.text:gsub("%S+", "")
        word_count = word_count + n
    end
}

function Pandoc(el)
    -- count words from body (ignore metadata)
    el.blocks:walk(count_words)

    -- add word count to metadata
    el.meta.word_count = tostring(math.floor(word_count / 100 + 0.5) * 100)

    return el
end
