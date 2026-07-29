# frozen_string_literal: true

require_relative "test_helper"

class RepositoryCardsTest < Minitest::Test
  STATS_SERVICE = "https://github-stats-extended.vercel.app"
  TROPHY_SERVICE = "https://github-profile-trophy.vercel.app"

  def repo_card
    ROOT.join("_includes/repository/repo.liquid").read
  end

  def user_card
    ROOT.join("_includes/repository/repo_user.liquid").read
  end

  def trophies_card
    ROOT.join("_includes/repository/repo_trophies.liquid").read
  end

  def test_stats_cards_default_to_maintained_fork
    [repo_card, user_card].each do |template|
      assert_includes template,
                      "{% assign stats_url = site.external_services.github_readme_stats_url | default: '#{STATS_SERVICE}' %}",
                      "stat-card include must fall back to the maintained github-stats-extended instance"
    end
  end

  def test_trophies_card_keeps_an_explicit_default
    assert_includes trophies_card,
                    "{% assign trophy_url = site.external_services.github_profile_trophy_url | default: '#{TROPHY_SERVICE}' %}"
  end

  def test_unmaintained_service_is_no_longer_referenced
    [repo_card, user_card, trophies_card].each do |template|
      refute_includes template, "github-readme-stats.vercel.app"
      refute_includes template, "anuraghazra/github-readme-stats"
    end
  end

  def test_service_url_is_only_interpolated_through_the_resolved_variable
    # A bare `site.external_services.*` interpolation in a src attribute would emit a
    # relative URL when the key is unset, which is what broke cards on sites without
    # an `external_services` block.
    [repo_card, user_card, trophies_card].each do |template|
      refute_match(/src="\{\{ site\.external_services\./, template)
    end
  end

  def test_pinned_repo_cards_preserve_upstream_query_parameters
    %w[
      /api/pin/?username=
      &repo=
      &locale=
      &show_owner=
      &description_lines_count=
    ].each { |fragment| assert_includes repo_card, fragment }

    assert_includes repo_card, "&theme={{ site.repo_theme_light }}"
    assert_includes repo_card, "&theme={{ site.repo_theme_dark }}"
  end

  def test_user_stats_cards_preserve_upstream_query_parameters
    assert_includes user_card, "/api/?username={{ include.username }}"
    assert_includes user_card, "&show_icons=true"
    assert_includes user_card, "&theme={{ site.repo_theme_light }}"
    assert_includes user_card, "&theme={{ site.repo_theme_dark }}"
  end

  def test_light_and_dark_variants_survive_the_service_swap
    [repo_card, user_card].each do |template|
      assert_includes template, 'class="only-light w-100"'
      assert_includes template, 'class="only-dark w-100"'
    end
  end

  def test_cards_still_hide_themselves_when_the_service_fails
    [repo_card, user_card, trophies_card].each do |template|
      assert_includes template, "onerror=\"this.closest('.repo').style.display='none'\""
    end
  end
end
