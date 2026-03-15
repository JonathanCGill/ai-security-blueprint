# CLAUDE.md

## Writing style

- Never use em dashes or double hyphens. Use commas, colons, full stops, or rephrase instead.
- Write like a human. Match the existing tone of whatever you are editing. Do not make content sound robotic, corporate, or over-polished.
- Bold for key terms (`**term**`), italics for citations or emphasis (`*text*`), backticks for code, commands, and config keys.

## Fonts

- Text font is Inter. Code font is Roboto Mono. Never introduce other fonts.
- Do not override font sizes with inline styles. Use the existing CSS classes.

## Diagrams and visuals

- No ASCII art. Use SVG for all diagrams and visual elements. SVG is web-compatible and renders cleanly across devices.
- Apply the `{ .arch-diagram }` class to all diagram images.

## Document structure

- H1 (`#`) for the page title only. One per page.
- H2 (`##`) for major sections. H3 (`###`) for subsections.
- Every page must have YAML front matter with a `description` field.

## References

- Every document should end with a references section using an admonition box:
  ```markdown
  !!! info "References"
      - [Source title](https://example.com)
      - [Another source](https://example.com)
  ```
- This keeps references visually distinct and at a smaller font size than body text.

## Callouts

- Use admonitions for callouts: `!!! info`, `!!! warning`, `!!! tip`, `!!! abstract`.
- Do not use ad-hoc blockquotes for callouts.

## Code blocks

- Always include a language identifier on fenced code blocks (e.g. ` ```python `, ` ```bash `).

## Links

- Internal links use relative paths (`[text](../path/file.md)`).
- External links use full URLs (`[text](https://example.com)`).
