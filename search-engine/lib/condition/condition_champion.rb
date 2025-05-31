class ConditionChampion< ConditionSimple
  def initialize(champion)
    @champion = champion.downcase.normalize_accents
  end

  def match?(card)
    card.champion =~  @champion
  end

  def to_s
    "champion:#{maybe_quote(@champion)}"
  end
end
