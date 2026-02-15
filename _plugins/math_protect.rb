# Protect math expressions from Kramdown's emphasis/underscore processing.
#
# Problem: Kramdown GFM treats `_` inside inline $...$ math as emphasis markers,
# breaking LaTeX subscripts. E.g., `$p_{Y_0}$` becomes `$p<em>{Y_0}$`.
#
# Solution: Before Kramdown processes the markdown, we replace all inline and
# display math with placeholders (HTML comments). After Kramdown renders the
# HTML, we restore the original math expressions. KaTeX's auto-render then
# processes them on the client side.
#
# This also makes the `\_` escaping hack unnecessary. You can write plain `_`
# for subscripts in math: `$p_{Y_0}$` instead of `$p\_{Y_0}$`.

Jekyll::Hooks.register :documents, :pre_render do |doc|
  # Only process markdown files
  next unless doc.extname =~ /\.(md|markdown)$/i

  placeholders = {}
  counter = 0

  content = doc.content

  # Protect display math ($$...$$) first — must come before inline
  content = content.gsub(/\$\$(.*?)\$\$/m) do |match|
    key = "MATH_PLACEHOLDER_#{counter}"
    counter += 1
    placeholders[key] = match
    "<!-- #{key} -->"
  end

  # Protect inline math ($...$)
  # Match $...$ but not $$ and not escaped \$
  content = content.gsub(/(?<!\$)\$(?!\$)((?:[^\$\\]|\\.)+?)\$(?!\$)/) do |match|
    key = "MATH_PLACEHOLDER_#{counter}"
    counter += 1
    placeholders[key] = match
    "<!-- #{key} -->"
  end

  doc.content = content

  # Store placeholders in data for the post_render hook
  doc.data['_math_placeholders'] = placeholders
end

Jekyll::Hooks.register :documents, :post_render do |doc|
  placeholders = doc.data['_math_placeholders']
  next unless placeholders && !placeholders.empty?

  output = doc.output

  placeholders.each do |key, original|
    # Using the block form of gsub prevents Ruby from interpreting backslashes 
    # in the 'original' string as escape sequences.
    placeholder = "<!-- #{key} -->"
    output = output.gsub(placeholder) { original }
    
    escaped_placeholder = "&lt;!-- #{key} --&gt;"
    output = output.gsub(escaped_placeholder) { original }
  end

  doc.output = output
end
