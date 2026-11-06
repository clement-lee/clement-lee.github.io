---
layout: page
permalink: /slides/
title: Slides
# Decks left out of this listing (they stay reachable by their own URL).
exclude_decks:
  - lancaster.html
  - york.html
---

{% comment %}
Built from every .pdf/.html directly inside slides/ at site build time, so a
newly pushed deck appears here without editing this page. Posts are matched
by searching each post's content for the deck's path.
{% endcomment %}

<table>
  <thead>
    <tr><th>Slides</th><th>Post</th></tr>
  </thead>
  <tbody>
{% assign files = site.static_files | sort_natural: "name" %}
{% for f in files %}
  {% assign parts = f.path | split: "/" %}
  {% unless parts.size == 3 and parts[1] == "slides" %}{% continue %}{% endunless %}
  {% unless f.extname == ".pdf" or f.extname == ".html" %}{% continue %}{% endunless %}
  {% if page.exclude_decks contains f.name %}{% continue %}{% endif %}
    <tr>
      <td><a href="{{ site.baseurl }}{{ f.path }}">{{ f.name }}</a></td>
      <td>
  {% for post in site.posts %}
    {% if post.content contains f.path %}
        <a href="{{ site.baseurl }}{{ post.url }}">{{ post.title }}</a> ({{ post.date | date: "%Y-%m-%d" }})<br>
    {% endif %}
  {% endfor %}
      </td>
    </tr>
{% endfor %}
  </tbody>
</table>
