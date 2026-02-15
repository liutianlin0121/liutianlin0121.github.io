# Custom Liquid tags for LaTeX-style theorem environments with auto-numbering.
#
# All numbered environments (def, prop, remark, theorem, lemma, corollary)
# share a single counter per page, just like LaTeX.
#
# Usage:
#
#   {% begin_def label:velocity Velocity %}    => "Definition 1 (Velocity)."
#   {% end_def %}
#
#   {% begin_prop label:mass_cons Velocity preserves distributions %}
#                                              => "Proposition 2 (Velocity preserves distributions)."
#   {% end_prop %}
#
#   {% ref mass_cons %}                        => clickable "Proposition 2"
#
#   {% begin_proof %}
#   Content...
#   {% end_proof %}
#
# Labels are optional. If provided, use `label:my_label` as the FIRST word
# of the markup. The rest is the title.

module Jekyll
  ENV_STYLES = {
    'def'       => { name: 'Definition',  bg: '#e9f7ef', border: '#28a745' },
    'prop'      => { name: 'Proposition', bg: '#f0f7ff', border: '#007bff' },
    'remark'    => { name: 'Remark',      bg: '#fff8e1', border: '#ffc107' },
    'theorem'   => { name: 'Theorem',     bg: '#f3e5f5', border: '#9c27b0' },
    'lemma'     => { name: 'Lemma',       bg: '#e8eaf6', border: '#3f51b5' },
    'corollary' => { name: 'Corollary',   bg: '#e0f2f1', border: '#009688' },
  }.freeze

  # ── Pre-render hook: scan for all labels and assign numbers ─────
  #
  # This runs BEFORE Liquid renders tags, so forward references work.
  # We scan the raw content for {% begin_TYPE label:NAME ... %} patterns
  # and build the label→{number, env_name} map.
  #
  Jekyll::Hooks.register :documents, :pre_render do |doc|
    counter = 0
    labels = {}

    doc.content.scan(/\{%[-\s]*begin_(\w+)\s+(.*?)[-\s]*%\}/) do |env_type, markup|
      style = ENV_STYLES[env_type]
      next unless style  # skip proof, etc.

      counter += 1

      if markup =~ /\Alabel:(\S+)/
        label = $1
        labels[label] = { number: counter, name: style[:name] }
      end
    end

    # Store in the document's data so tags can access it
    doc.data['_env_labels_precomputed'] = labels
  end

  # ── Generic numbered environment tag ────────────────────────────
  class BeginEnvTag < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      super
      @env_type = tag_name.sub('begin_', '')
      @markup = markup.strip
    end

    def render(context)
      label, title = parse_markup(@markup)

      # Increment shared counter
      context.registers[:env_counter] ||= 0
      context.registers[:env_counter] += 1
      num = context.registers[:env_counter]

      # Store label in registers too (for backward-compatible refs)
      if label
        context.registers[:env_labels] ||= {}
        context.registers[:env_labels][label] = {
          number: num,
          name: ENV_STYLES[@env_type][:name]
        }
      end

      style = ENV_STYLES[@env_type]
      env_name = style[:name]

      header = if title && !title.empty?
                 "<strong>#{env_name} #{num} (#{title}).</strong>"
               else
                 "<strong>#{env_name} #{num}.</strong>"
               end

      anchor_id = label ? "env-#{label}" : "env-#{num}"

      "<div id=\"#{anchor_id}\" style=\"background-color: #{style[:bg]}; border-left: 5px solid #{style[:border]}; padding: 15px; margin: 20px 0; overflow-x: auto; width: 100%; box-sizing: border-box;\">" +
        "\n#{header} <br>\n"
    end

    private

    def parse_markup(text)
      if text =~ /\Alabel:(\S+)\s*(.*)\z/
        [$1, $2.strip]
      else
        [nil, text]
      end
    end
  end

  class EndEnvTag < Liquid::Tag
    def render(context)
      "\n</div>\n"
    end
  end

  # ── Proof (not numbered) ────────────────────────────────────────
  class BeginProofTag < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      super
      @title = markup.strip.empty? ? "Proof" : markup.strip
    end

    def render(context)
      '<div style="background-color: #f8f9fa; border-left: 4px solid #6c757d; padding: 15px; margin: 20px 0; overflow-x: auto; width: 100%; box-sizing: border-box;">' +
        "\n<em>#{@title}.</em> "
    end
  end

  class EndProofTag < Liquid::Tag
    def render(context)
      "\n" + '<p style="text-align: right; margin-bottom: 0;">&#9633;</p>' + "\n</div>\n"
    end
  end

  # ── Cross-reference tag ─────────────────────────────────────────
  #
  # Uses the pre-computed label map so forward references work.
  #
  class RefTag < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      super
      @label = markup.strip
    end

    def render(context)
      # Try the pre-computed map first (supports forward refs)
      page_data = context.registers[:page] || {}
      precomputed = page_data['_env_labels_precomputed'] || {}
      info = precomputed[@label]

      # Fall back to runtime labels
      unless info
        runtime = context.registers[:env_labels] || {}
        info = runtime[@label]
      end

      if info
        "<a href=\"#env-#{@label}\">#{info[:name]}&nbsp;#{info[:number]}</a>"
      else
        "<span style=\"color:red;font-weight:bold;\">[?? #{@label}]</span>"
      end
    end
  end
end

# Register begin/end tags for all numbered environments
Jekyll::ENV_STYLES.each_key do |env|
  Liquid::Template.register_tag("begin_#{env}", Jekyll::BeginEnvTag)
  Liquid::Template.register_tag("end_#{env}",   Jekyll::EndEnvTag)
end

# Register proof and ref
Liquid::Template.register_tag('begin_proof', Jekyll::BeginProofTag)
Liquid::Template.register_tag('end_proof',   Jekyll::EndProofTag)
Liquid::Template.register_tag('ref',         Jekyll::RefTag)
