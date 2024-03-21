require 'tk'
require_relative 'note_list'
require_relative 'note_editor'
require_relative 'markdown_renderer'

root = TkRoot.new { title "Ruby Note Taking App - Mini Obsidian" }
root.minsize(800, 600)

# Define themes
themes = {
  'light' => {
    'background' => 'white',
    'foreground' => 'black',
    'button' => '☀️'
  },
  'dark' => {
    'background' => '#333',
    'foreground' => 'white',
    'button' => '🌙'
  }
}
$current_theme = 'light'

# Method to update the theme
def update_theme(widgets, theme, theme_button)
  widgets.each do |widget|
    widget.configure('background' => theme['background'])
    widget.configure('foreground' => theme['foreground']) if widget.respond_to?(:configure) && widget.winfo_class != 'TkFrame'
  end
  theme_button.configure('text' => theme['button'])
end

list_frame = TkFrame.new(root).pack(side: 'left', fill: 'y')
edit_frame = TkFrame.new(root).pack(side: 'left', fill: 'both', expand: true)

note_editor = NoteEditor.new(edit_frame)
note_list = NoteList.new(list_frame, note_editor)

button_frame = TkFrame.new(edit_frame).pack(side: 'bottom', fill: 'x')

new_button = TkButton.new(button_frame) {
  text 'New Note'
  command proc {
    note_name = Tk.getSaveFile(
      'initialdir' => 'notes',
      'defaultextension' => '.md',
      'filetypes' => [['Markdown files', '.md']]
    )
    unless note_name.empty?
      note_editor.save_note(note_name)
      note_list.list_notes('notes')
      note_editor.load_note(note_name)
    end
  }
}.pack(side: 'left')

save_button = TkButton.new(button_frame) {
  text 'Save Note'
  command proc {
    begin
      selection = note_list.listbox.curselection
      if selection.empty?
        note_name = Tk.getSaveFile(
          'initialdir' => 'notes',
          'defaultextension' => '.md',
          'filetypes' => [['Markdown files', '.md']]
        )
        note_editor.save_note(note_name) unless note_name.empty?
      else
        selected = note_list.listbox.get(selection)
        note_editor.save_note("notes/#{selected}")
      end
      note_list.list_notes('notes') # Refresh the note list
    rescue => e
      Tk.messageBox('type' => 'ok', 'icon' => 'error', 'title' => 'Error', 'message' => e.message)
    end
  }
}.pack(side: 'left')

delete_button = TkButton.new(button_frame) {
  text 'Delete Note'
  command proc {
    begin
      selection = note_list.listbox.curselection
      unless selection.empty?
        selected = note_list.listbox.get(selection)
        if Tk.messageBox('type' => 'yesno', 'icon' => 'question', 'title' => 'Confirm Delete', 'message' => 'Are you sure you want to delete this note?') == 'yes'
          note_editor.delete_note("notes/#{selected}")
          note_list.delete_selected_note
          note_editor.clear
        end
      end
    rescue => e
      Tk.messageBox('type' => 'ok', 'icon' => 'error', 'title' => 'Error', 'message' => e.message)
    end
  }
}.pack(side: 'left')

# Theme switch button at the bottom left corner of the window
theme_button_frame = TkFrame.new(root).pack(side: 'bottom', anchor: 'sw')
theme_button = TkButton.new(theme_button_frame) {
  text themes[$current_theme]['button']
  command proc {
    $current_theme = $current_theme == 'light' ? 'dark' : 'light'
    update_theme([note_editor.text_widget, note_list.listbox], themes[$current_theme], theme_button)
    root.configure('background' => themes[$current_theme]['background'])
  }
}.pack(side: 'left')

# Apply the initial theme
update_theme([note_editor.text_widget, note_list.listbox], themes[$current_theme], theme_button)
root.configure('background' => themes[$current_theme]['background'])
Tk.mainloop