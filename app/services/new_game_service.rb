class NewGameService < ApplicationService
  validates_presence_of :game
  def initialize(no_of_players:, lane_id:, players:, total_no_of_sets:, opts: {})
    @no_of_players = no_of_players
    @lane_id = lane_id
    @players = players
    @total_no_of_sets = total_no_of_sets
    @opts = opts.with_indifferent_access
    @errors = ActiveModel::Errors.new(self)
  end
end