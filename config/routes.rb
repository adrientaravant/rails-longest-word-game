Rails.application.routes.draw do
  get 'game' => 'longest_words#game'

  get 'score' => 'longest_words#score'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
