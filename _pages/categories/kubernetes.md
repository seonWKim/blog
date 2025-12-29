---
title: "Kubernetes"
layout: page
permalink: /categories/kubernetes/
---

Posts about Kubernetes, container orchestration, and cloud-native technologies.

{% for post in site.categories.kubernetes %}
  - [{{ post.title }}]({{ post.url | relative_url }}) - {{ post.date | date: "%B %-d, %Y" }}
{% endfor %}
