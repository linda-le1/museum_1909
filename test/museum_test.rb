require 'minitest/autorun'
require 'minitest/pride'
require './lib/exhibit'
require  './lib/patron'
require  './lib/museum'

class MuseumTest < Minitest::Test

  def test_it_exists
    dmns = Museum.new("Denver Museum of Nature and Science")
    assert_instance_of Museum, dmns
  end

  def test_it_initializes
    dmns = Museum.new("Denver Museum of Nature and Science")
    assert_equal "Denver Museum of Nature and Science", dmns.name
  end

  def test_it_has_exhibits
    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    imax = Exhibit.new("IMAX", 15)

    assert_equal [], dmns.exhibits

    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)

    assert_equal [gems_and_minerals, dead_sea_scrolls, imax], dmns.exhibits
  end

  def test_it_has_recommendations
    dmns = Museum.new("Denver Museum of Nature and Science")
    bob = Patron.new("Bob", 20)
    sally = Patron.new("Sally", 20)
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    imax = Exhibit.new("IMAX", 15)

    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(imax)

    bob.add_interest("Dead Sea Scrolls")
    bob.add_interest("Gems and Minerals")

    sally.add_interest("IMAX")

    assert_equal [dead_sea_scrolls, gems_and_minerals], dmns.recommend_exhibits(bob)
    assert_equal [imax], dmns.recommend_exhibits(sally)
  end

  def test_it_can_admit_patrons
    dmns = Museum.new("Denver Museum of Nature and Science")
    bob = Patron.new("Bob", 20)
    sally = Patron.new("Sally", 20)
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    imax = Exhibit.new("IMAX", 15)

    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(imax)

    assert_equal [], dmns.patrons

    dmns.admit(bob)
    dmns.admit(sally)

    assert_equal [bob, sally], dmns.patrons
  end

  def test_it_can_find_patrons_by_exhibit_interest
    dmns = Museum.new("Denver Museum of Nature and Science")
    bob = Patron.new("Bob", 20)
    sally = Patron.new("Sally", 20)
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    imax = Exhibit.new("IMAX", 15)
    expected = {gems_and_minerals => [bob], dead_sea_scrolls => [bob, sally],
                imax => []}

    dmns.add_exhibit(gems_and_minerals)            
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)

    bob.add_interest("Dead Sea Scrolls")
    bob.add_interest("Gems and Minerals")
    sally.add_interest("Dead Sea Scrolls")

    dmns.admit(bob)
    dmns.admit(sally)

    assert_equal expected, dmns.patrons_by_exhibit_interest
  end
end
