class NotesController < ApplicationController
  # 1. Sabhi actions se pehle check karo ki user logged-in hai ya nahi
  # before_action :authenticate, only: %i[ index show new create edit update destroy ]
  before_action :set_note, only: %i[ show edit update destroy ]

  # GET /notes or /notes.json
  def index
    # 2. Sirf current logged-in user ke notes fetch karo
    @notes = Current.user.notes
  end

  # GET /notes/1 or /notes/1.json
  def show
    # Security check: Ensure user can only view their own note
    unless @note.user == Current.user
      redirect_to notes_path, alert: "Not authorized."
    end
  end

  # GET /notes/new
  def new
    # 3. Naya note current user ke sath initialize karo
    @note = Current.user.notes.build
  end

  # GET /notes/1/edit
  def edit
    unless @note.user == Current.user
      redirect_to notes_path, alert: "Not authorized."
    end
  end

  # POST /notes or /notes.json
  def create
    # 4. Note banate waqt use current user ke sath associate karo
    @note = Current.user.notes.build(note_params)

    respond_to do |format|
      if @note.save
        format.html { redirect_to @note, notice: "Note was successfully created." }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @note.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /notes/1 or /notes/1.json
  def update
    unless @note.user == Current.user
      redirect_to notes_path, alert: "Not authorized." and return
    end

    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to @note, notice: "Note was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @note.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /notes/1 or /notes/1.json
  def destroy
    unless @note.user == Current.user
      redirect_to notes_path, alert: "Not authorized." and return
    end

    @note.destroy!

    respond_to do |format|
      format.html { redirect_to notes_path, notice: "Note was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      # 5. Find note strictly within current user's notes for security
      @note = Current.user.notes.find(params.expect(:id))
    rescue ActiveRecord::RecordNotFound
      redirect_to notes_path, alert: "Note not found."
    end

    # Only allow a list of trusted parameters through.
    def note_params
      params.expect(note: [ :title, :content, :is_pinned ])
    end
end