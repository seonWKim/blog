---
title: "Notes"
layout: page
permalink: /categories/notes/
---

Quick notes, tips, and miscellaneous technical information.

{% for post in site.categories.notes %}
  - [{{ post.title }}]({{ post.url }}) - {{ post.date | date: "%B %-d, %Y" }}
{% endfor %}
