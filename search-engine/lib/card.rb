# This class represents card from index point of view, not from data point of view
# (thinking in solr/lucene terms)
require "date"
require_relative "ban_list"
require_relative "legality_information"

class Card
  ABILITY_WORD_LIST = ['Vanguard', 'Revolt', 'Drop', 'Approval', 'Inspired',
  'Damned', 'Fabric', 'Corrupt', 'Amity', 'Raid', 'Landfall'].freeze
  ABILITY_WORD_RX = /^(#{Regexp.union(ABILITY_WORD_LIST)}) —/i.freeze

  attr_reader :data, :printings
  attr_writer :printings # For db subset

  attr_reader(
    :alchemy,
    :augment,
    :brawler,
    :cmc,
    :color_identity_set,
    :color_identity,
    :color_indicator_set,
    :color_indicator,
    :colors_set,
    :colors,
    :commander,
    :decklimit,
    :defense,
    :display_mana_cost,
    :display_power,
    :display_toughness,
    :extra,
    :foreign_names_normalized,
    :foreign_names,
    :fulltext_normalized,
    :fulltext,
    :funny,
    :hand,
    :has_alchemy,
    :in_spellbook,
    :keywords,
    :layout,
    :life,
    :loyalty,
    :mana_cost,
    :mana_hash,
    :name,
    :names,
    :otags,
    :power,
    :related,
    :reminder_text,
    :reserved,
    :rulings,
    :specialized,
    :specializes,
    :spellbook,
    :stemmed_name,
    :text_normalized,
    :text,
    :toughness,
    :typeline,
    :types,
  )

  def initialize(data)
    @printings = []
    @name = data["n"]
    @stemmed_name = -@name.downcase.normalize_accents.gsub(/s\b/, "").tr("-", " ")
    @names = data["ns"]
    @layout = data["l"]
    @colors = data["c"] || ""
    @otags = data['atags'] || []
    @colors_set = @colors.chars.to_set
    @color_identity = data["ci"]
    @color_identity_set = @color_identity.chars.to_set
    @funny = data["fu"]
    @fulltext = -(data["o"] || "")
    @fulltext_normalized = -@fulltext.normalize_accents
    @text = @fulltext
    @text = @text.gsub(/\s*\([^\(\)]*\)/, "") unless @funny or @layout == "dungeon"
    @text = -@text.sub(/\s*\z/, "").gsub(/ *\n/, "\n").sub(/\A\s*/, "")
    @text_normalized = -@text.normalize_accents
    @augment = !!(@text =~ /augment \{/i)
    @mana_cost = data["m"]
    @reserved = data["rs"] || false
    @types = ["t", "tb", "tp"]
      .flat_map{|t| data[t] || []}
      .map{|t| -t.downcase.tr("’\u2212", "'-").gsub("'s", "").tr(" ", "-")}
    @cmc = data["v"] || 0
    @power = data["pw"] ? smart_convert_powtou(data["pw"]) : nil
    @toughness = data["to"] ? smart_convert_powtou(data["to"]) : nil
    @loyalty = data["ly"] ? smart_convert_powtou(data["ly"]) : nil
    @display_power = data["dp"] ? data["dp"] : @power
    @display_toughness = data["dt"] ? data["dt"] : @toughness
    @display_mana_cost = data["hm"] ? nil : @mana_cost
    @alchemy = data["al"]
    @has_alchemy = data["ha"]
    if ["vanguard", "planar", "scheme"].include?(@layout) or @types.include?("conspiracy") or @alchemy
      @extra = true
    else
      @extra = false
    end
    @decklimit = data["dl"]
    @hand = data["hd"]
    @life = data["lf"]
    @rulings = data["r"]&.map{|d,t| {"date" => d, "text" => t}}
    @secondary = data["s"]
    @partner = data["ip"]
    @commander = data["cm"]
    @brawler = data["br"]
    @specialized = data["sd"]
    @specializes = data["ss"]
    @spellbook = data["sb"]
    @in_spellbook = data["is"]
    if data["f"]
      @foreign_names = data["f"].map{|k,v| [k.to_sym,v]}.to_h
      raise "Foreign data with empty value for #{name}" if @foreign_names.any?{|k,v| v.empty?}
    else
      @foreign_names = {}
    end
    @foreign_names_normalized = {}
    @foreign_names.each do |lang, names|
      @foreign_names_normalized[lang] = names.map{|n| hard_normalize(n)}
    end
    @related = data["rl"]
    @typeline = [data["tp"], data["t"]].compact.flatten.join(" ")
    if data["tb"]
      @typeline += " - #{data["tb"].join(" ")}"
    end
    @typeline = -@typeline
    if data["k"]
      @keywords = data["k"].map{|k| -k}
    end
    @defense = data["df"]
    calculate_mana_hash
    calculate_color_indicator
    calculate_reminder_text
    @front = (!@secondary or @layout == "aftermath" or @layout == "flip" or @layout == "adventure")
  end

  def partner?
    !!@partner
  end

  def front?
    @front
  end

  def back?
    !front?
  end

  def primary?
    !@secondary
  end

  def secondary?
    @secondary
  end

  def custom?
    # a card is custom if it has been printed in at least one custom set (to exclude uncards)...
    return false unless printings.any? { |printing| printing.set.custom? }
    # ...and hasn't been printed in an official black-border set (to exclude custom reprints of official cards)
    printings.all? { |printing| printing.set.custom? or printing.set.funny? }
  end

  def has_multiple_parts?
    !!@names
  end

  def inspect
    "Card(#{name})"
  end

  include Comparable
  def <=>(other)
    name <=> other.name
  end

  def to_s
    inspect
  end

  def legality_information(date=nil)
    LegalityInformation.new(self, date)
  end

  def first_release_date
    @first_release_date ||= @printings.map(&:release_date).compact.min
  end

  # If a card has non-promo printing, pick oldest, ignore promos
  # If a card has only promo printings, pick oldest
  # This deals with prerelease promos and similar
  #
  # Promos released at same time or earlier than the first release date
  # are not considered reprints
  def first_regular_release_date
    @first_regular_release_date ||= begin
      promo_printings, regular_printings = printings.partition{|cp| cp.set.types.include?("promo")}
      regular_printings.map(&:release_date).min || promo_printings.map(&:release_date).min
    end
  end

  def last_release_date
    @last_release_date ||= @printings.map(&:release_date).compact.max
  end

  def allowed_in_any_number?
    @types.include?("basic") or (
      @text and @text.include?("A deck can have any number of cards named")
    )
  end

  def commander?
    !!@commander
  end

  def brawler?
    !!@brawler
  end

  def count_prints
    @count_prints ||= printings.size
  end

  def count_paperprints
    @count_paperprints ||= printings.count(&:paper?)
  end

  def count_sets
    @count_sets ||= printings.map(&:set).uniq.size
  end

  def count_papersets
    @count_papersets ||= printings.select(&:paper?).map(&:set).uniq.size
  end

  def name_slug
    name
      .normalize_accents
      .gsub("'s", "s")
      .gsub("I'm", "Im")
      .gsub("You're", "Youre")
      .gsub("R&D", "RnD")
      .gsub(/[^a-zA-Z0-9\-]+/, "-")
      .gsub(/(\A-)|(-\z)/, "")
  end

  private

  def calculate_mana_hash
    if @mana_cost.nil?
      @mana_hash = nil
      return
    end
    @mana_hash = Hash.new(0)

    mana = @mana_cost.gsub(/\{(.*?)\}/) do
      m = $1
      case m
      when /\A\d+\z/
        @mana_hash["?"] += m.to_i
      when /\A[wubrgxyzcsdl]\z/
        # x is basically a color for this kind of queries
        @mana_hash[m] += 1
      when %r{\A(vp|flag|mag|ql)\z}
        @mana_hash[m] += 1
      when /\Ah([wubrg])\z/
        @mana_hash[$1] += 0.5
      when /\A([wubrg])\/([wubrg])\z/
        @mana_hash[normalize_mana_symbol(m)] += 1
      when /\A([wubrgc])\/p\z/
        @mana_hash[normalize_mana_symbol(m)] += 1
      when /\A2\/([wubrg])\z/
        @mana_hash[normalize_mana_symbol(m)] += 1
      when /\A([wubrg])\/([wubrg])\/p\z/
        @mana_hash[normalize_mana_symbol(m)] += 1
      when /\Ac\/([wubrg])\z/
        @mana_hash[normalize_mana_symbol(m)] += 1
      else
        raise "Unrecognized mana type: #{m}"
      end
      ""
    end
    raise "Mana query parse error: #{mana}" unless mana.empty?
  end

  def normalize_mana_symbol(sym)
    -sym.downcase.tr("/{}", "").chars.sort.join
  end

  def hard_normalize(s)
    -s.unicode_normalize(:nfd).gsub(/\p{Mn}/, "").downcase
  end

  def smart_convert_powtou(val)
    return val unless val.is_a?(String)
    # Treat augment "+1"/"-1" strings as regular 1/-1 numbers for search engine
    # The view can use special format for them
    return val.to_i if val =~ /\A\+\d+\z/
    if val !~ /\A-?[\d.]+\z/
      # It just so happens that "2+*" > "1+*" > "*" asciibetically
      # so we don't do any extra conversions,
      # but we might need to setup some eventually
      #
      # Including uncards
      # "*" < "*²" < "1+*" < "2+*"
      # but let's not get anywhere near that
      case val
      when "*", "*²", "1+*", "2+*", "7-*", "X", "∞", "?", "1d4+1"
        val
      when "*+1"
        "1+*"
      else
        raise "Unrecognized value #{val.inspect}"
      end
    elsif val.to_i == val.to_f
      val.to_i
    else
      val.to_f
    end
  end

  def calculate_color_indicator
    colors_inferred_from_mana_cost = (@mana_hash || {}).keys
      .flat_map do |x|
        next [] if x =~ /[?xyzcsdvpl]/
        x = x.sub(/[p2]/, "")
        if x =~ /\A[wubrg]+\z/
          x.chars
        else
          raise "Unknown mana cost: #{x}"
        end
      end
      .uniq

    actual_colors = @colors.chars

    if colors_inferred_from_mana_cost.sort == actual_colors.sort
      @color_indicator = nil
    else
      @color_indicator = Color.color_indicator_name(actual_colors)
    end
    if @color_indicator
      @color_indicator_set = actual_colors.to_set
    end
  end

  def calculate_reminder_text
    @reminder_text = nil
    basic_land_types = (["forest", "island", "mountain", "plains", "swamp"] & @types.to_a)
      .sort.join(" ")
    if not basic_land_types.empty?
      # Listing them all explicitly due to wubrg wheel order
      mana = case basic_land_types
      when "plains"
        "{W}"
      when "island"
        "{U}"
      when "swamp"
        "{B}"
      when "mountain"
        "{R}"
      when "forest"
        "{G}"
      when "island plains"
        "{W} or {U}"
      when "plains swamp"
        "{W} or {B}"
      when "island swamp"
        "{U} or {B}"
      when "island mountain"
        "{U} or {R}"
      when "mountain swamp"
        "{B} or {R}"
      when "forest swamp"
        "{B} or {G}"
      when "forest mountain"
        "{R} or {G}"
      when "mountain plains"
        "{R} or {W}"
      when "forest plains"
        "{G} or {W}"
      when "forest island"
        "{G} or {U}"
      when "forest plains swamp"
        "{W}, {B}, or {G}"
      when "forest island mountain"
        "{G}, {U}, or {R}"
      when "island mountain plains"
        "{U}, {R}, or {W}"
      when "mountain plains swamp"
        "{R}, {W}, or {B}"
      when "forest island swamp"
        "{B}, {G}, or {U}"
      when "forest mountain plains"
        "{R}, {G}, or {W}"
      when "island plains swamp"
        "{W}, {U}, or {B}"
      when "forest island plains"
        "{G}, {W}, or {U}"
      when "island mountain swamp"
        "{U}, {B}, or {R}"
      when "forest mountain swamp"
        "{B}, {R}, or {G}"
      else
        raise "No idea what's correct line for #{basic_land_types.inspect}"
      end
      @reminder_text = "({T}: Add #{mana}.)"
    elsif layout == "flip" and secondary?
      # Awkward wording
      other_name = (@names - [@name])[0]
      @reminder_text = "(#{@name} keeps color and mana cost of #{other_name} when flipped)"
    end
  end
end
