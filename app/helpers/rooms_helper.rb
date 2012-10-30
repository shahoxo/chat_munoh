module RoomsHelper
  def munoh_id_options
    Munoh.all.map{ |munoh| [munoh.name, munoh.id] }
  end
end
