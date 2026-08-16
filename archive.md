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
  border-bottom: 1px solid var(--border-color);
  margin-bottom: 32px;
}

.archive-section-title {
  font-size: 0.85rem;
  font-weight: 700;
  letter-spacing: 0.05em;
  text-transform: uppercase;
  color: var(--heading-color);
}

.archive-count {
  font-size: 0.85rem;
  color: var(--text-muted);
}

.blog-list {
  list-style: none;
  padding: 0;
  margin: 0;
}

.blog-card {
  padding-bottom: 28px;
  margin-bottom: 28px;
  border-bottom: 1px solid var(--border-color);
}

.blog-card:last-child {
  border-bottom: none;
}

.blog-title-heading {
  font-size: 1.35rem;
  font-weight: 700;
  margin: 0 0 6px 0;
  line-height: 1.3;
  letter-spacing: -0.01em;
}

.blog-title-link,
.blog-title-link:visited,
.blog-title-link:active {
  color: var(--heading-color);
  text-decoration: none;
  transition: color 0.2s ease;
}

.blog-title-link:hover {
  color: var(--link-color);
}

.blog-date {
  font-size: 0.85rem;
  font-weight: 600;
  color: var(--text-muted);
  letter-spacing: 0.04em;
  text-transform: uppercase;
  margin: 0 0 8px 0;
}

.blog-summary {
  color: var(--text-color);
  font-size: 1rem;
  line-height: 1.55;
  margin: 0;
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
          <a href="{{ post.url | relative_url }}" class="blog-title-link">{{ post.title }}</a>
        </h2>
        <div class="blog-date">{{ post.date | date: "%d %B %Y" | upcase }}</div>
        <p class="blog-summary">
          {% if post.summary %}
            {{ post.summary }}
          {% else %}
            {{ post.excerpt | strip_html | truncatewords: 25 }}
          {% endif %}
        </p>
      </li>
    {% endfor %}
  </ul>
</div>