require 'redcarpet'

class MarkdownRenderer
  def self.render(text)
    renderer = Redcarpet::Render::HTML.new
    markdown = Redcarpet::Markdown.new(renderer)
    markdown.render(text)
  end
end
