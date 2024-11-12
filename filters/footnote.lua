traverse = 'topdown'

function Note(n)
    -- NOTE: This assumes footnotes contain a single paragraph.

    local span = pandoc.Span(n.content[1].content)
    span.attr = { class = 'footnote' }
    return span
end
