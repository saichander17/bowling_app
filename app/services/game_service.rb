class GameService < ApplicationService

  validates_presence_of :game
  def initialize(no_of_players:, lane_id:, players:, total_no_of_sets:, opts: {})
    @no_of_players = no_of_players
    @lane_id = lane_id
    @players = players
    @total_no_of_sets = total_no_of_sets
    @opts = opts.with_indifferent_access
    @errors = ActiveModel::Errors.new(self)
  end
  attr_reader :errors, :players, :lane_id, :total_no_of_sets

  def simulate
    # Make set an entity?
    # If time permits, implement no of plays in each set also to be variable
    # If time permits, write simulation for only a few players while others like to play
    valid? && simulate_all_sets && finish_game
  end

  private

    # def create_players
    #   player_creator_service.create
    # end

    # def player_creator_service
    #   @player_creator_service ||= PlayerCreatorService.new(@players)
    # end

    def simulate_all_sets
      player_ids = players.map{|player| player.id}
      player_ids.each do |player_id|
        # puts "Running for Player: #{player_id}"
        total_score = 0
        sets.each do |set|
          set.player_id = player_id
          set.pins_dropped = []
          cumulative_set_score = 0
          for i in 1..set.plays do
            score = rand(0..(no_of_pins-cumulative_set_score))
            # score = get_score(0,(no_of_pins-cumulative_set_score))
            

            set.pins_dropped<<score
            cumulative_set_score += score
            total_score += score
            if(cumulative_set_score>=no_of_pins)
              if(i==1)
                total_score += set.strike_bonus
                set.bonus_score=set.strike_bonus
              else
                total_score += set.spare_bonus
                set.bonus_score=set.spare_bonus
              end
              # set.scores<<(score+bonus_score)
              break
            end
          end
          if(set.spare_bonus == set.bonus_score)
            total_score += simulate_extra_chances(set, "spare")
          elsif(set.strike_bonus == set.bonus_score)
            total_score += simulate_extra_chances(set, "strike")
          end
          # puts "Score until now: #{total_score}"
          set.save
        end
      end
    end

    def get_score(start, endd)
      first_time = true
      score=nil
      while(score==nil || score<start || score>endd) do
        puts "Wrong input, Please try again" if !first_time
        first_time = false
        score = gets.chomp
        if(score=="X" || score=="x")
          return 10
        elsif(score=="/")
          return endd
        else
          if score!=nil
            if score.to_i.to_s==score
              score = score.to_f
            else
              score = nil
            end
          end
        end
      end
      score
    end

    def simulate_extra_chances(set, spare_or_strike)
      set.extra_chance_pins_dropped = []
      cumulative_extra_set_score = 0
      extra_chances = set.send("extra_chances_for_#{spare_or_strike}")
      for i in 1..extra_chances do
        score = rand(0..(no_of_pins-cumulative_extra_set_score))
        # score = get_score(0,(no_of_pins-cumulative_extra_set_score))
        # score = gets.to_f
        # while(score<0 || score>(no_of_pins-cumulative_extra_set_score)) do
        #   puts "Wrong input, Please try again"
        #   score = gets.to_f
        # end
        set.extra_chance_pins_dropped<<score
        cumulative_extra_set_score += score
        if(cumulative_extra_set_score>=no_of_pins)
          break
        end
      end
      cumulative_extra_set_score
    end

    def finish_game
      if game.finish
      else
      end
    end

    def game_creator_service
      @game_creator_service ||= GameCreatorService.new(game_attrs)
    end

    def game_attrs
      @game_attrs ||= {
        lane_id: lane_id,
        player_ids: [1,2], 
        total_no_of_sets: total_no_of_sets,
        players_go_one_by_one: players_go_one_by_one,
        # no_of_plays_in_each_set: no_of_plays_in_each_set
        # no_of_plays_in_last_set: no_of_plays_in_last_set
      }
    end

    def game
      return @game if @game
      if game_creator_service.create
        @game = game_creator_service.result
      else
        merge_errors_from(game_creator_service)
        return false
      end
    end

    def sets
      return @sets if @sets
      @sets = []
      for i in 1..total_no_of_sets do
        set = GameSet.new()
        set.game_id = game.id
        set.score_per_pin = 1
        # set.score = nil
        set.name = "SET - #{i}"
        set.set_number = i
        set.plays = 2
        set.strike_bonus = strike_bonus
        set.spare_bonus = spare_bonus
        set.no_of_pins = no_of_pins
        if i==total_no_of_sets
          set.extra_chances_for_spare = 1
          set.extra_chances_for_strike = 1
        else
          set.extra_chances_for_spare = 0
          set.extra_chances_for_strike = 0
        end
        # set.save
        @sets<<set
      end
      @sets
    end

    def players_go_one_by_one
      opts[:players_go_one_by_one] || false
    end

    def no_of_pins
      opts[:no_of_pins] || 10
    end

    def strike_bonus
      10
    end

    def spare_bonus
      5
    end

    def opts
      @opts
    end

    def no_of_plays_in_each_set
      return @no_of_plays_in_each_set if @no_of_plays_in_each_set
      @no_of_plays_in_each_set = []
      for i in 1..total_no_of_sets do
        if i==total_no_of_sets
          @no_of_plays_in_each_set<<3
        else
          @no_of_plays_in_each_set<<2
        end
      end
      @no_of_plays_in_each_set
    end

    # def no_of_plays_in_last_set
    #   3
    # end
end