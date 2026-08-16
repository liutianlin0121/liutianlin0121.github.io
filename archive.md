---
layout: page
title:
permalink: /blog
---

<style>
.archive-container {
  max-width: 740px;
  margin: 0 auto;
}

.archive-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-bottom: 8px;
  border-bottom: 1px solid #e5e5e5;
  margin-bottom: 32px;
}

.archive-section-title {
  font-size: 0.85rem;
  font-weight: 700;
  letter-spacing: 0.05em;
  text-transform: uppercase;
  color: #222;
}

.archive-count {
  font-size: 0.85rem;
  color: #999;
}

.blog-list {
  list-style: none;
  padding: 0;
  margin: 0;
}

.blog-card {
  padding-bottom: 28px;
  margin-bottom: 28px;
  border-bottom: 1px solid #f0f0f0;
}

.blog-card:last-child {
  border-bottom: none;
}

.blog-title-heading {
  font-size: 1.35rem;
  font-weight: 700;
  margin: 0 0 8px 0;
  line-height: 1.3;
  letter-spacing: -0.01em;
}

.blog-title-link,
.blog-title-link:visited,
.blog-title-link:active {
  color: #111;
  text-decoration: none;
}

.blog-title-link:hover {
  color: #4183c4;
}

.blog-excerpt {
  color: #555555;
  font-size: 0.96rem;
  line-height: 1.55;
  margin: 8px 0 10px 0;
}

.blog-date {
  font-size: 0.85rem;
  color: #888888;
}
</style>

<div class="archive-container">
  <div class="archive-header">
    <span class="archive-section-title">POSTS</span>
    <span class="archive-count">{{ site.posts.size }} posts</span>
  </div>

  <ul class="blog-list">
    {% for post in site.posts %}
      <li class="blog-card">
        <h2 class="blog-title-heading">
          <a href="{{ post.url }}" class="blog-title-link">{{ post.title }}</a>
        </h2>
        <p class="blog-excerpt">
          {{ post.excerpt | strip_html | truncatewords: 30 }}
        </p>
        <div class="blog-date">{{ post.date | date: "%Y-%m-%d" }}</div>
      </li>
    {% endfor %}
  </ul>
</div>