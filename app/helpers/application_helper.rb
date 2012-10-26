module ApplicationHelper
  def select_munoh_ids
    Munoh.all.map{ |munoh| [munoh.name, munoh.id] }
  end
end
