---
title: "Tags"
layout: page
permalink: /tags/
---

{% assign tags_list = site.tags | sort %}
{% for tag in tags_list %}
  {% assign tag_name = tag[0] %}
  {% assign posts = tag[1] %}
  
## {{ tag_name }}
{: #{{ tag_name | slugify }}}

{% for post in posts %}
  - [{{ post.title }}]({{ post.url }}) - {{ post.date | date: "%B %-d, %Y" }}
{% endfor %}

{% endfor %}
