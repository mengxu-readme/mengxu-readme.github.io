# frozen_string_literal: true

require_relative "test_helper"

class StyleRuntimeContractTest < Minitest::Test
  def test_utilities_scss_avoids_transition_all
    utilities_scss = ROOT.join("_sass/_utilities.scss").read
    refute_match(/transition\s*:\s*all\s+/i, utilities_scss)
  end

  def test_tailwind_entry_contract
    tailwind_app_css = ROOT.join("assets/tailwind/app.css").read

    assert_match(/@config\s+"..\/..\/tailwind\.config\.js";/, tailwind_app_css)
    assert_match(/@import\s+"tailwindcss\/theme\.css"\s+layer\(theme\);/, tailwind_app_css)
    assert_match(/@import\s+"tailwindcss\/utilities\.css"\s+layer\(utilities\);/, tailwind_app_css)
    refute_match(/@tailwind\s+base;|@tailwind\s+components;|@tailwind\s+utilities;/, tailwind_app_css)
  end

  def test_repository_template_class_contract
    repository_include = ROOT.join("_includes/repository/repo.liquid").read
    repository_user_include = ROOT.join("_includes/repository/repo_user.liquid").read

    assert_includes repository_include, 'class="repo p-2 text-center"'
    assert_includes repository_user_include, 'class="repo p-2 text-center"'
  end
end
