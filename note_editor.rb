class NoteEditor
  attr_reader :text_widget
  
  def initialize(parent)
    @text_widget = TkText.new(parent) do
      pack(side: 'left', fill: 'both', expand: true)
    end
  end

  def load_note(file_path)
    content = File.read(file_path)
    @text_widget.delete('1.0', 'end')
    @text_widget.insert('1.0', content)
  end

  def save_note(file_path)
    content = @text_widget.get('1.0', 'end -1 chars')
    File.write(file_path, content)
  end

  def delete_note(file_path)
    File.delete(file_path) if File.exist?(file_path)
  end

  def clear
    @text_widget.delete('1.0', 'end')
  end
end
