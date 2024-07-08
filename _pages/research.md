---
layout: page
title: Research
description: Meng Xu's Research Page
keywords: research, publication
permalink: /research/
nav: true
nav_order: 3
---

<!-- _pages/research.md -->

{% if site.bib_search %}
<input type="text" id="bibsearch" spellcheck="false" autocomplete="off" class="search bibsearch-form-input" placeholder="Type to filter">
{% endif %}

<div class="publications">

{% bibliography %}

</div>
