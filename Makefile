# Create new blog posts from the archetypes in archetypes/.
# Usage:
#   make en name=my-post-slug   -> content/en-blog/my-post-slug.md
#   make fa name=my-post-slug   -> content/fa-blog/my-post-slug.md
# Without name=, it asks for the slug.

.PHONY: en fa

en:
	@name="$(name)"; \
	if [ -z "$$name" ]; then read -p "English post slug: " name; fi; \
	if [ -z "$$name" ]; then echo "No slug given."; exit 1; fi; \
	hugo new content "en-blog/$$name.md"

fa:
	@name="$(name)"; \
	if [ -z "$$name" ]; then read -p "Persian post slug: " name; fi; \
	if [ -z "$$name" ]; then echo "No slug given."; exit 1; fi; \
	hugo new content "fa-blog/$$name.md"
