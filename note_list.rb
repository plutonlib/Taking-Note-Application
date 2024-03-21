class NoteList
    attr_reader :listbox
  
    def initialize(parent, note_editor)
      @listbox = TkListbox.new(parent) do
        pack(side: 'left', fill: 'y')
      end
      @listbox.bind('<<ListboxSelect>>') do
        selected_note = selected_note_path
        note_editor.load_note(selected_note) if selected_note
      end
      list_notes("notes")
    end
  
    def list_notes(directory)
      @listbox.delete(0, 'end')
      Dir.glob("#{directory}/*.md").each do |file_path|
        @listbox.insert('end', File.basename(file_path))
      end
    end
  
    def delete_selected_note
      selected = selected_note_path
      File.delete(selected) if selected && File.exist?(selected)
      list_notes("notes")  # Refresh the list
    end
  
    private
  
    def selected_note_path
      selection = @listbox.curselection
      return nil if selection.empty?
      "notes/" + @listbox.get(selection)
    end

    def initialize(parent, note_editor)
        @listbox = TkListbox.new(parent) do
          pack(side: 'left', fill: 'y')
        end
        @listbox.bind('1') do
          if @listbox.curselection.any?
            selected_note = selected_note_path
            note_editor.load_note(selected_note) if selected_note
          end
        end
        list_notes("notes")
      end
  end
  