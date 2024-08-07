---
layout: page
title: Teaching
description: Meng Xu's Teaching Page
keywords: teaching, course, instructor, teaching assistant
permalink: /teaching/
nav: true
nav_order: 4
display_categories: [Instructor, Teaching Assistant]
horizontal: false
---

<!-- pages/teaching.md -->
<div class="projects">
{% if site.enable_teaching_categories and page.display_categories %}
  <!-- Display categorized courses -->
  {% for category in page.display_categories %}
  <h2 class="category">{{ category }}</h2>
  {% assign categorized_courses = site.teaching | where: "category", category %}
  {% assign sorted_courses = categorized_courses | sort: "importance" %}
  <!-- Generate cards for each course -->
  {% if page.horizontal %}
  <div class="container">
    <div class="row row-cols-1 row-cols-md-2">
    {% for project in sorted_courses %}
      {% include projects_horizontal.liquid %}
    {% endfor %}
    </div>
  </div>
  {% else %}
  <div class="row row-cols-1 row-cols-md-3">
    {% for project in sorted_courses %}
      {% include projects.liquid %}
    {% endfor %}
  </div>
  {% endif %}
  {% endfor %}

{% else %}

<!-- Display courses without categories -->

{% assign sorted_courses = site.teaching | sort: "importance" %}

  <!-- Generate cards for each course -->

{% if page.horizontal %}

  <div class="container">
    <div class="row row-cols-1 row-cols-md-2">
    {% for project in sorted_courses %}
      {% include projects_horizontal.liquid %}
    {% endfor %}
    </div>
  </div>
  {% else %}
  <div class="row row-cols-1 row-cols-md-3">
    {% for project in sorted_courses %}
      {% include projects.liquid %}
    {% endfor %}
  </div>
  {% endif %}
{% endif %}
</div>
