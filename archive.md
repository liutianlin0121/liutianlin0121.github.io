---
layout: page
title: 
permalink: /blog
---


<ul>
    {% for post in site.posts %}
      <li><a href="{{ post.url }}">{{ post.title }}</a> {{post.date| date: '%B %Y'}} </li>
    {% endfor %}
 </ul>