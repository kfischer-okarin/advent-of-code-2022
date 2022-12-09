def test_day03_rucksack_parse_rucksacks(_args, assert)
  rucksacks = Day03::Rucksack.parse_rucksacks(day03_test_input)

  assert.equal! rucksacks.length, 6
  assert.equal! rucksacks[0].compartment1, %w[v J r w p W t w J g W r]
  assert.equal! rucksacks[0].compartment2, %w[h c s F M M f F F h F p]
  assert.equal! rucksacks[1].compartment1, %w[j q H R N q R j q z j G D L G L]
  assert.equal! rucksacks[1].compartment2, %w[r s F M f F Z S r L r F Z s S L]
  assert.equal! rucksacks[2].compartment1, %w[P m m d z q P r V]
  assert.equal! rucksacks[2].compartment2, %w[v P w w T W B w g]
  assert.equal! rucksacks[3].compartment1, %w[w M q v L M Z H h H M v w L H]
  assert.equal! rucksacks[3].compartment2, %w[j b v c j n n S B n v T Q F n]
  assert.equal! rucksacks[4].compartment1, %w[t t g J t R G J]
  assert.equal! rucksacks[4].compartment2, %w[Q c t T Z t Z T]
  assert.equal! rucksacks[5].compartment1, %w[C r Z s J s P P Z s G z]
  assert.equal! rucksacks[5].compartment2, %w[w w s L w L m p w M D w]
end

def test_day03_rucksack_wrongly_sorted_item_types(_args, assert)
  rucksack = Day03::Rucksack.new(compartment1: %w[a b c c], compartment2: %w[c d e])

  assert.equal! rucksack.wrongly_sorted_item_types, %w[c]
end

def test_day03_rucksack_common_items(_args, assert)
  rucksack1 = Day03::Rucksack.new(compartment1: %w[a b c d], compartment2: %w[f g h])
  rucksack2 = Day03::Rucksack.new(compartment1: %w[g h i j], compartment2: %w[k l m])
  rucksack3 = Day03::Rucksack.new(compartment1: %w[h z], compartment2: %w[y])

  assert.equal! Day03::Rucksack.common_items(rucksack1, rucksack2, rucksack3), %w[h]
end

def test_day03_rucksack_item_type_priority(_args, assert)
  assert.equal! Day03::Rucksack.item_type_priority('a'), 1
  assert.equal! Day03::Rucksack.item_type_priority('z'), 26
  assert.equal! Day03::Rucksack.item_type_priority('A'), 27
  assert.equal! Day03::Rucksack.item_type_priority('Z'), 52
end

def test_day03_part1_example(_args, assert)
  rucksacks = Day03::Rucksack.parse_rucksacks(day03_test_input)

  wrongly_sorted_item_types = rucksacks.map(&:wrongly_sorted_item_types)
  assert.equal! wrongly_sorted_item_types, [%w[p], %w[L], %w[P], %w[v], %w[t], %w[s]]

  sum_of_priorities = wrongly_sorted_item_types.flatten.map { |item_type|
    Day03::Rucksack.item_type_priority(item_type)
  }.sum
  assert.equal! sum_of_priorities, 16 + 38 + 42 + 22 + 20 + 19
end

def test_day03_part2_example(_args, assert)
  rucksacks = Day03::Rucksack.parse_rucksacks(day03_test_input)

  groups = rucksacks.each_slice(3).to_a
  common_items = groups.map { |group|
    Day03::Rucksack.common_items(*group)
  }

  assert.equal! common_items[0], %w[r]
  assert.equal! common_items[1], %w[Z]

  sum_of_priorities = common_items.flatten.map { |item_type|
    Day03::Rucksack.item_type_priority(item_type)
  }.sum
  assert.equal! sum_of_priorities, 18 + 52
end

def day03_test_input
  PuzzleInput.new(<<~INPUT)
    vJrwpWtwJgWrhcsFMMfFFhFp
    jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
    PmmdzqPrVvPwwTWBwg
    wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
    ttgJtRGJQctTZtZT
    CrZsJsPPZsGzwwsLwLmpwMDw
  INPUT
end
