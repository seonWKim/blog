---
title: "Infrastructure"
layout: page
permalink: /categories/infra/
---

Posts about infrastructure, cloud platforms, DevOps, and system architecture.

{% for post in site.categories.infra %}
  - [{{ post.title }}]({{ post.url }}) - {{ post.date | date: "%B %-d, %Y" }}
{% endfor %}
