---
layout: page
permalink: /repositories/
title: Repositories
description:
nav: false
sitemap: false
nav_order: 3
---

<div class="projects">
{% if site.data.repositories.github_users %}
<h2 class="category">User</h2>
<div class="d-flex flex-wrap flex-md-row flex-column justify-content-between align-items-center">
  {% for user in site.data.repositories.github_users %}
    {% include repository/repo_user.html username=user %}
  {% endfor %}
</div>
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
