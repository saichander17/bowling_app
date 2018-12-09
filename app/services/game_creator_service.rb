class GameCreatorService < ApplicationService
  
  def initialize(attrs)
    @attrs = attrs
    @errors = ActiveModel::Errors.new(self)
  end
  attr_reader :result

  def create
    game = Game.new(@attrs)
    if game.save
      @result = game
      return @result
    else
      merge_errors_from(game)
      return false
    end
  end
end