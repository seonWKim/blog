---
title: "Programming"
layout: page
permalink: /categories/programming/
---

Posts about programming, software development, and coding practices.

{% for post in site.categories.programming %}
  - [{{ post.title }}]({{ post.url | relative_url }}) - {{ post.date | date: "%B %-d, %Y" }}
{% endfor %}
