class Game < ActiveRecord::Base
  # This will contain id, lane_id, player_ids, game_progress(Will have scores until this point), total_no_of_sets
  has_many :leader_boards
  has_many :game_sets

  def finish(sets=nil)
    self.finished_at = Time.zone.now
    sets ||= self.game_sets
    create_leaderboard(sets)
    self.save
  end

  def create_leaderboard(sets)
    user_sets_map = {}
    sets.each do |set|
      user_sets_map[set.player_id] ||= []
      user_sets_map[set.player_id] << set
    end
    leaderboards = []
    user_sets_map.each do |player_id, user_sets|
      leaderboard = LeaderBoard.new()
      leaderboard.player_id = player_id
      leaderboard.game_id = self.id
      leaderboard.total_score = 0
      user_sets.each do |set|
        set.bonus_score ||= 0
        set.pins_dropped ||= 0
        set.extra_chance_pins_dropped ||= 0
        leaderboard.total_score += (set.bonus_score + ((set.pins_dropped + set.extra_chance_pins_dropped)*set.score_per_pin) )
      end
      leaderboards<<leaderboard
    end
    leaderboards = leaderboards.sort_by{|el| el.total_score}
    leaderboards.reverse!
    cou = 1
    leaderboards.each do |el|
      el.rank = cou
      el.save
      cou+=1
    end
  end
end
