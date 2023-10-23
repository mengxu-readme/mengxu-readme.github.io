---
layout: page
title: Repositories
description: Meng Xu's Repositories Page
keywords: repository, github
nav: false
sitemap: false
---

<div class="projects">
{% if site.data.repositories.github_users %}
<h2 class="category">User</h2>
<div class="d-flex flex-wrap flex-md-row flex-column justify-content-between align-items-center">
  {% for user in site.data.repositories.github_users %}
    {% include repository/repo_user.html username=user %}
  {% endfor %}
</div>

{% if site.repo_trophies.enabled %}
{% for user in site.data.repositories.github_users %}
  {% if site.data.repositories.github_users.size > 1 %}
  <h4>{{ user }}</h4>
  {% endif %}
  <div class="d-flex flex-wrap flex-md-row flex-column justify-content-between align-items-center">
  {% include repository/repo_trophies.html username=user %}
  </div>

{% endfor %}
{% endif %}
{% endif %}

{% if site.data.repositories.github_repos %}
<h2 class="category">Repository</h2>
<div class="d-flex flex-wrap flex-md-row flex-column justify-content-between align-items-center">
  {% for repo in site.data.repositories.github_repos %}
    {% include repository/repo.html repository=repo %}
  {% endfor %}
</div>
{% endif %}
</div>
