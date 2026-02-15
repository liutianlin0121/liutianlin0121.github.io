require 'bibtex'

module Jekyll
  # {% citep key %} — parenthetical citation like \citep
  # Renders: <span id="citation-KEY"><a class="citation" href="#KEY">(Author, Year)</a></span>
  class CitepTag < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      super
      @key = markup.strip
    end

    def render(context)
      # Delegate to jekyll-scholar's {% cite %} for rendering and citation tracking
      cite_output = Liquid::Template.parse("{% cite #{@key} %}").render(context)
      %(<span id="citation-#{@key}">#{cite_output}</span>)
    end
  end

  # {% citet key %} — textual citation like \citet
  # Renders: <span id="citation-KEY"><a class="citation" href="#KEY">Author (Year)</a></span>
  class CitetTag < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      super
      @key = markup.strip
    end

    def render(context)
      site = context.registers[:site]

      # Load bibliography to extract author and year
      source_dir = site.config.dig('scholar', 'source') || './_bibliography'
      bib_file = site.config.dig('scholar', 'bibliography') || 'references.bib'
      bib_path = File.join(site.source, source_dir, bib_file)

      site.data['_bib_cache'] ||= begin
        b = BibTeX.open(bib_path)
        b.replace_strings
        b
      end
      bib = site.data['_bib_cache']
      entry = bib[@key.to_sym]

      if entry
        author_text = format_authors(entry)
        year = entry.year.to_s
      else
        author_text = @key
        year = "?"
      end

      # Use jekyll-scholar internally for citation tracking (hidden from display)
      cite_output = Liquid::Template.parse("{% cite #{@key} %}").render(context)

      visible = %(<span id="citation-#{@key}"><a class="citation" href="##{@key}">#{author_text} (#{year})</a></span>)
      hidden = %(<span hidden>#{cite_output}</span>)
      visible + hidden
    end

    private

    def format_authors(entry)
      return entry.key.to_s unless entry.respond_to?(:author) && entry.author

      authors = entry.author
      return entry.key.to_s if authors.empty?

      if authors.length == 1
        authors[0].last.to_s
      elsif authors.length == 2
        "#{authors[0].last} &amp; #{authors[1].last}"
      else
        "#{authors[0].last} et al."
      end
    end
  end
end

Liquid::Template.register_tag('citep', Jekyll::CitepTag)
Liquid::Template.register_tag('citet', Jekyll::CitetTag)
