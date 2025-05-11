# This test is quite bad now because we have a lot of "boosters" for various randomized promo things
# like box toppers that don't follow traditional rules at all
describe "is:booster" do
  include_context "db"

  let(:set_types_with_boosters) do
    Set[
      "conspiracy",
      "core",
      "expansion",
      "jumpstart",
      "masters",
      "modern",
      "reprint",
      "starter",
      "two-headed giant",
      "un",
    ]
  end

  it "set has boosters" do
    db.sets.each do |set_code, set|
      set_pp = "#{set.name} [#{set.code}]"
      should_have_boosters = (
        %W[mb1 cmr dbl clb 30a zne who sld clu pip slc].include?(set_code) or (
          !(set_types_with_boosters & set.types).empty? and
          !%W[ced cei tsb itp s00 cp1 cp2 cp3 w16 w17 gk1 ppod ana oana fmb1 anb plst slx ulst sis md1 big h2r].include?(set.code)
        )
      )
      should_be_in_other_boosters = (
        %W[tsb exp mps mp2 fmb1 plst sta sunf brr sis slx h2r big].include?(set.code)
      )
      if %W[j21 ajmp].include?(set_code)
        # Arena extras
        set.should_not have_boosters, "#{set_pp} should not have boosters"
      elsif should_have_boosters
        set.should have_boosters, "#{set_pp} should have boosters"
      else
        set.should_not have_boosters, "#{set_pp} should not have boosters"
      end
      if should_be_in_other_boosters
        set.should be_in_other_boosters, "#{set_pp} should be included in other boosters"
      else
        set.should_not be_in_other_boosters, "#{set_pp} should not be included in other boosters"
      end
    end
  end

  # Tests for is:booster removed as
  # realistically it would be far too complex

  describe "Arena and play boosters" do
    let(:pack_factory) { PackFactory.new(db) }

    let(:standard_arena_sets) do
      db.sets.values.select{|s|
        (s.types.include?("standard") or s.code == "ltr") and
        s.types.include?("booster") and
        s.printings.any?(&:arena?) and
        (
          # older ones keep getting into remasters and I don't want to maintain a list here, so date cutoff
          # except KTK was imported in whole, without remaster
          s.release_date >= Date.parse("2017-09-29") or
          s.code == "ktk"
        ) and
        !%W[big].include?(s.code)
      }.map(&:code).to_set
    end

    # tpr is MTGO remaster
    # rvr is non-Arena remaster
    let(:remaster_arena_sets) do
      %W[akr klr sir].to_set
    end

    it do
      db.sets.each do |set_code, set|
        if set_code == "sir"
          pack_factory.for(set_code, "arena-1").should_not(be_nil, "#{set_code} should have Arena boosters")
          pack_factory.for(set_code, "arena-2").should_not(be_nil, "#{set_code} should have Arena boosters")
          pack_factory.for(set_code, "arena-3").should_not(be_nil, "#{set_code} should have Arena boosters")
          pack_factory.for(set_code, "arena-4").should_not(be_nil, "#{set_code} should have Arena boosters")
          pack_factory.for(set_code, nil).should(be_nil, "#{set_code} should not have default boosters")
        elsif remaster_arena_sets.include?(set_code)
          pack_factory.for(set_code, "arena").should_not(be_nil, "#{set_code} should have Arena boosters")
          pack_factory.for(set_code, "draft").should(be_nil, "#{set_code} should not have draft boosters")
        elsif standard_arena_sets.include?(set_code)
          # MKM
          if set.release_date >=  Date.parse("2024-02-09")
            # not sure if these should be xxx-play-arena or just xxx-arena
            pack_factory.for(set_code, "play-arena").should_not(be_nil, "#{set_code} should have Arena Play boosters")
            pack_factory.for(set_code, "play").should_not(be_nil, "#{set_code} should have regular boosters")
            pack_factory.for(set_code, "draft").should(be_nil, "#{set_code} should not have draft boosters")
          elsif set_code == "mat"
            pack_factory.for(set_code, "arena").should_not(be_nil, "#{set_code} should have Arena boosters")
            pack_factory.for(set_code, nil).should_not(be_nil, "#{set_code} should have default boosters")
          else
            pack_factory.for(set_code, "arena").should_not(be_nil, "#{set_code} should have Arena boosters")
            pack_factory.for(set_code, "draft").should_not(be_nil, "#{set_code} should have draft boosters")
          end
        else
          pack_factory.for(set_code, "arena").should(be_nil, "#{set_code} should not have Arena boosters")
        end
      end
    end
  end
end
