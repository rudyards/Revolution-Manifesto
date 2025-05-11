BanList.for_format("pauper") do
  # No idea when Cranial Plating was banned,
  # it says in Nov 2008 that it's already banned
  format_start(
    nil,
    "Cranial Plating" => "banned",
  )

  change(
    "2011-07-01",
    # No longer available anywhere online
    "http://web.archive.org/web/20110625123730/http://community.wizards.com/magiconline/blog/2011/06/19/magic_online_br_changes_-_june_2011",
    "Frantic Search" => "banned",
  )

  change(
    "2013-02-01",
    "https://magic.wizards.com/en/articles/archive/january-28-2013-dci-banned-restricted-list-announcement-2013-01-28",
    "Empty the Warrens" => "banned",
    "Grapeshot" => "banned",
    "Invigorate" => "banned",
  )

  change(
    "2013-09-27",
    "https://magic.wizards.com/en/articles/archive/top-decks/september-27-2013-dci-banned-restricted-list-announcement-2013-09-16",
    "Cloudpost" => "banned",
    "Temporal Fissure" => "banned",
  )

  change(
    "2015-03-27",
    "https://magic.wizards.com/en/articles/archive/feature/march-23-2015-banned-and-restricted-announcement-2015-03-23",
    "Treasure Cruise" => "banned",
  )

  change(
    "2016-01-22",
    "https://magic.wizards.com/en/articles/archive/news/january-18-2016-banned-and-restricted-announcement-2016-01-18",
    "Cloud of Faeries" => "banned",
  )

  change(
    "2016-11-16",
    "http://magic.wizards.com/en/articles/archive/magic-online/pauper-banned-list-change-2016-11-03",
    "Peregrine Drake" => "banned",
  )

  change(
    "2019-05-24",
    "https://magic.wizards.com/en/articles/archive/news/may-20-2019-banned-and-restricted-announcement",
    "Gush" => "banned",
    "Gitaxian Probe" => "banned",
    "Daze" => "banned",
  )

  # No banlist date as such, but:
  # "Magic Online will implement the new format with its Core Set 2020 update
  #  and will launch new leagues with the new format starting July 2."
  change(
    "2019-07-02",
    "https://magic.wizards.com/en/articles/archive/news/pauper-comes-paper-2019-06-27",
    "Hymn to Tourach" => "banned",
    "Sinkhole" => "banned",
    "High Tide" => "banned",
  )

  change(
    "2019-10-21",
    "https://magic.wizards.com/en/articles/archive/news/october-21-2019-banned-and-restricted-announcement",
    "Arcum's Astrolabe" => "banned",
  )

  change(
    "2020-06-10",
    "https://magic.wizards.com/en/articles/archive/news/depictions-racism-magic-2020-06-10",
    "Pradesh Gypsies" => "banned",
    "Stone-Throwing Devils" => "banned",
  )

  change(
    "2020-07-13",
    "https://magic.wizards.com/en/articles/archive/news/july-13-2020-banned-and-restricted-announcement-2020-07-13",
    "Expedition Map" => "banned",
    "Mystic Sanctuary" => "banned",
  )

  change(
    "2021-01-14",
    "https://magic.wizards.com/en/articles/archive/news/january-14-2021-banned-and-restricted-announcement",
    "Fall from Favor" => "banned",
  )

  change(
    "2021-09-08",
    "https://magic.wizards.com/en/articles/archive/news/september-8-2021-banned-and-restricted-announcement",
    "Chatterstorm" => "banned",
    "Sojourner's Companion" => "banned",
  )

  change(
    "2022-01-21",
    "https://magic.wizards.com/en/articles/archive/news/january-20-2022-banned-and-restricted-announcement",
    "Atog" => "banned",
    "Bonder's Ornament" => "banned",
    "Prophetic Prism" => "banned",
  )

  change(
    "2022-03-07",
    "https://magic.wizards.com/en/articles/archive/news/march-7-2022-banned-and-restricted-announcement",
    "Galvanic Relay" => "banned",
    "Disciple of the Vault" => "banned",
    "Expedition Map" => "legal",
  )

  change(
    "2022-09-19",
    "https://magic.wizards.com/en/articles/archive/news/september-19-2022-banned-and-restricted-announcement",
    "Aarakocra Sneak" => "banned",
    "Stirring Bard" => "banned",
    "Underdark Explorer" => "banned",
    "Vicious Battlerager" => "banned",
  )

  change(
    "2023-12-04",
    "https://magic.wizards.com/en/news/announcements/december-4-2023-banned-and-restricted-announcement",
    "Monastery Swiftspear" => "banned",
  )

  # The way it's phrased, if any card on corresponding Vintage/Legacy ban gets reprinted as common,
  # it will need to get added here. Very easy to forget this.
  #
  # Manually commented out cards that are not commons
  change(
    "2024-05-13",
    "https://magic.wizards.com/en/news/announcements/may-13-2024-banned-and-restricted-announcement",
    "All That Glitters" => "banned",
    # All Sticker Cards, as per linked url
    "Aerialephant" => "banned",
    # "Ambassador Blorpityblorpboop" => "banned",
    # "Baaallerina" => "banned",
    # "_____ Balls of Fire" => "banned",
    # "Bioluminary" => "banned",
    "_____ Bird Gets the Worm" => "banned",
    "Carnival Carnivore" => "banned",
    "Chicken Troupe" => "banned",
    # "Clandestine Chameleon" => "banned",
    "Command Performance" => "banned",
    # "Done for the Day" => "banned",
    # "Fight the _____ Fight" => "banned",
    "Finishing Move" => "banned",
    "Glitterflitter" => "banned",
    "_____ Goblin" => "banned",
    '"Name Sticker" Goblin' => "banned", # not explicitly, it's just MTGO variant
    # "Last Voyage of the _____" => "banned",
    # "Lineprancers" => "banned",
    # "Make a _____ Splash" => "banned",
    "Minotaur de Force" => "banned",
    "_____-o-saurus" => "banned",
    # "Park Bleater" => "banned",
    # "Pin Collection" => "banned",
    "Prize Wall" => "banned",
    # "Proficient Pyrodancer" => "banned",
    "Robo-Piñata" => "banned",
    # "_____ _____ Rocketship" => "banned",
    # "Roxi, Publicist to the Stars" => "banned",
    # "Scampire" => "banned",
    "Stiltstrider" => "banned",
    # "Sword-Swallowing Seraph" => "banned",
    "Ticketomaton" => "banned",
    # "_____ _____ _____ Trespasser" => "banned",
    # "Tusk and Whiskers" => "banned",
    # "Wicker Picker" => "banned",
    "Wizards of the _____" => "banned",
    "Wolf in _____ Clothing" => "banned",
    # All Attraction Cards, as per linked url
    "Coming Attraction" => "banned",
    # "Complaints Clerk" => "banned",
    "Deadbeat Attendant" => "banned",
    # "Dee Kay, Finder of the Lost" => "banned",
    # "Discourtesy Clerk" => "banned",
    "Draconian Gate-Bot" => "banned",
    # "\"Lifetime\" Pass Holder" => "banned",
    "Line Cutter" => "banned",
    # "Monitor Monitor" => "banned",
    # "Myra the Magnificent" => "banned",
    "Petting Zookeeper" => "banned",
    # "Quick Fixer" => "banned",
    "Rad Rascal" => "banned",
    "Ride Guide" => "banned",
    "Seasoned Buttoneer" => "banned",
    "Soul Swindler" => "banned",
    # "Spinnerette, Arachnobat" => "banned",
    # "Squirrel Squatters" => "banned",
    "Step Right Up" => "banned",
    # "The Most Dangerous Gamer" => "banned",
    # t:attraction r:common
    "Clown Extruder" => "banned",
    "Costume Shop" => "banned",
    "Cover the Spot" => "banned",
    "Dart Throw" => "banned",
    "Drop Tower" => "banned",
    "Foam Weapons Kiosk" => "banned",
    "Fortune Teller" => "banned",
    "Kiddie Coaster" => "banned",
    "Pick-a-Beeble" => "banned",
    "Spinny Ride" => "banned",
    # t:stickers r:common
    "Ancestral Hot Dog Minotaur" => "banned",
    "Carnival Elephant Meteor" => "banned",
    "Contortionist Otter Storm" => "banned",
    "Cool Fluffy Loxodon" => "banned",
    "Cursed Firebreathing Yogurt" => "banned",
    "Deep-Fried Plague Myr" => "banned",
    "Demonic Tourist Laser" => "banned",
    "Eldrazi Guacamole Tightrope" => "banned",
    "Elemental Time Flamingo" => "banned",
    "Eternal Acrobat Toast" => "banned",
    "Familiar Beeble Mascot" => "banned",
    "Geek Lotus Warrior" => "banned",
    "Giant Mana Cake" => "banned",
    "Goblin Coward Parade" => "banned",
    "Happy Dead Squirrel" => "banned",
    "Jetpack Death Seltzer" => "banned",
    "Misunderstood Trapeze Elf" => "banned",
    "Mystic Doom Sandwich" => "banned",
    "Narrow-Minded Baloney Fireworks" => "banned",
    "Night Brushwagg Ringmaster" => "banned",
    "Notorious Sliver War" => "banned",
    "Phyrexian Midway Bamboozle" => "banned",
    "Playable Delusionary Hydra" => "banned",
    "Primal Elder Kitty" => "banned",
    "Sassy Gremlin Blood" => "banned",
    "Slimy Burrito Illusion" => "banned",
    "Snazzy Aether Homunculus" => "banned",
    "Space Fungus Snickerdoodle" => "banned",
    "Spooky Clown Mox" => "banned",
    "Squid Fire Knight" => "banned",
    "Squishy Sphinx Ninja" => "banned",
    "Sticky Kavu Daredevil" => "banned",
    "Trained Blessed Mind" => "banned",
    "Trendy Circus Pirate" => "banned",
    "Unassuming Gelatinous Serpent" => "banned",
    "Unglued Pea-Brained Dinosaur" => "banned",
    "Unhinged Beast Hunt" => "banned",
    "Unique Charmed Pants" => "banned",
    "Unsanctioned Ancient Juggler" => "banned",
    "Unstable Robot Dragon" => "banned",
    "Urza's Dark Cannonball" => "banned",
    "Vampire Champion Fury" => "banned",
    "Weird Angel Flame" => "banned",
    "Werewolf Lightning Mage" => "banned",
    "Wild Ogre Bupkis" => "banned",
    "Wrinkly Monkey Shenanigans" => "banned",
    "Yawgmoth Merfolk Soul" => "banned",
    "Zombie Cheese Magician" => "banned",
  )

  change(
    "2024-06-06",
    "https://magic.wizards.com/en/news/announcements/pauper-bans-for-june-6-2024",
    "Cranial Ram" => "banned",
  )

  # No official announcement, just new card falling under old rule that all sticker cards are banned
  change(
    "2025-03-24",
    nil,
    "Sticker sheet" => "banned",
  )

  change(
    "2025-03-31",
    "https://magic.wizards.com/en/news/announcements/banned-and-restricted-announcement-march-31-2025",
    "Basking Broodscale" => "banned",
    "Kuldotha Rebirth" => "banned",
    "Deadly Dispute" => "banned",
    "Prophetic Prism" => "legal",
    "High Tide" => "legal",
  )
end
