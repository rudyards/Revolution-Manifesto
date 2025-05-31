class Format
  attr_reader :included_sets, :excluded_sets

  def initialize(time=nil)
    raise ArgumentError unless time.nil? or time.is_a?(Date)
    @time = time
    @ban_list = BanList[format_name]
    if respond_to?(:build_included_sets)
      @included_sets = build_included_sets
      @excluded_sets = nil
    else
      @included_sets = nil
      @excluded_sets = build_excluded_sets
    end
  end

  def legality(card)
    card = card.main_front if card.is_a?(PhysicalCard)
    if card.extra or !in_format?(card)
      nil
    else
      @ban_list.legality(card.name, @time)
    end
  end

  def banned?(card)
    legality(card) == "banned"
  end

  def restricted?(card)
    legality(card) == "restricted"
  end

  def legal?(card)
    legality(card) == "legal"
  end

  def legal_or_restricted?(card)
    l = legality(card)
    l == "legal" or l == "restricted"
  end

  def in_format?(card)
    # Funny check is disabled for Alchemy/Historic
    # as Arena cards sometimes get paper reprints with acorn stamp like in MB2
    return false if card.funny
    return false if card.alchemy
    card.printings.each do |printing|
      next if @time and printing.release_date > @time
      if @included_sets
        next unless @included_sets.include?(printing.set_code)
      else
        next if @excluded_sets.include?(printing.set_code)
      end
      return true
    end
    false
  end

  def cards_probably_in_format(db)
    if @included_sets
      @included_sets.flat_map do |set_code|
        # This will only be nil in subset of db, so really only in tests
        set = db.sets[set_code]
        set ? set.printings.map(&:card) : []
      end.to_set
    else
      db.cards.values
    end
  end

  def deck_issues(deck)
    [
      *deck_size_issues(deck),
      *deck_card_issues(deck),
    ]
  end

  def deck_size_issues(deck)
    issues = []
    if deck.number_of_mainboard_cards < 60
      issues << "Deck must contain at least 60 mainboard cards, has only #{deck.number_of_mainboard_cards}"
    end
    if deck.number_of_sideboard_cards > 15
      issues << "Deck must contain at most 15 sideboard cards, has #{deck.number_of_sideboard_cards}"
    end
    if deck.number_of_commander_cards > 0
      issues << "Format does not support commanders"
    end
    issues
  end

  def deck_card_issues(deck)
    issues = []
    deck.card_counts.each do |card, name, count|
      card_legality = legality(card)
      case card_legality
      when "legal"
        if count > 4 and not card.allowed_in_any_number?
          issues << "Deck contains #{count} copies of #{name}, only up to 4 allowed"
        end
      when "restricted"
        if count > 1
          issues << "Deck contains #{count} copies of #{name}, which is restricted to only up to 1 allowed"
        end
      when "banned"
        issues << "#{name} is banned"
      else
        issues << "#{name} is not in the format"
      end
    end
    issues
  end

  def format_pretty_name
    raise "Subclass responsibility"
  end

  def format_name
    format_pretty_name.downcase
  end

  def to_s
    if @time
      "<Format:#{format_name}:#{@time}>"
    else
      "<Format:#{format_name}>"
    end
  end

  def inspect
    to_s
  end

  def ban_events
    @ban_list.events
  end

  class << self
    def formats_index
      {
        "revolution"                   => FormatRevolution,
        "revolutioneternal"                     => FormatRevolutionEternal,
        "eternalbrawl"                => FormatEternalBrawl,
        "brawl"                      => FormatBrawl,
      }
    end

    def all_format_classes
      @all_format_classes ||= formats_index.values.uniq
    end

    def [](format_name)
      format_name = format_name.downcase.gsub(/\s|-|_/, "")
      return FormatAny if format_name == "*"
      formats_index[format_name] || FormatUnknown
    end
  end
end

require_relative "format_revolution"
require_relative "format_revolution_eternal"
require_relative "format_eternal_brawl"
require_relative "format_brawl"
Dir["#{__dir__}/format_*.rb"].each do |path| require_relative path end
