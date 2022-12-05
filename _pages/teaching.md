---
layout: page
permalink: /teaching/
title: Teaching
description:
nav: true
nav_order: 4
display_categories: [Instructor, Teaching Assistant]
horizontal: false
---

<!-- pages/teaching.md -->
<div class="projects">
{%- if site.enable_course_categories and page.display_categories %}
  <!-- Display categorized courses -->
  {%- for category in page.display_categories %}
  <h2 class="category">{{ category }}</h2>
  {%- assign categorized_courses = site.courses | where: "category", category -%}
  {%- assign sorted_courses = categorized_courses | sort: "importance" %}
  <!-- Generate cards for each course -->
  {% if page.horizontal -%}
  <div class="container">
    <div class="row row-cols-2">
    {%- for course in sorted_courses -%}
      {% include courses_horizontal.html %}
    {%- endfor %}
    </div>
  </div>
  {%- else -%}
  <div class="grid">
    {%- for course in sorted_courses -%}
      {% include courses.html %}
    {%- endfor %}
  </div>
  {%- endif -%}
  {% endfor %}

{%- else -%}
<!-- Display courses without categories -->
  {%- assign sorted_courses = site.courses | sort: "importance" -%}
  <!-- Generate cards for each course -->
  {% if page.horizontal -%}
  <div class="container">
    <div class="row row-cols-2">
    {%- for course in sorted_courses -%}
      {% include courses_horizontal.html %}
    {%- endfor %}
    </div>
  </div>
  {%- else -%}
  <div class="grid">
    {%- for course in sorted_courses -%}
      {% include courses.html %}
    {%- endfor %}
  </div>
  {%- endif -%}
{%- endif -%}
</div>
