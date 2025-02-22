# Manuscript compiler

From a Markdown input file, creates a PDF file following the [proper manuscript format](https://www.shunn.net/format/introduction.html).

![Screenshot](./readme-screenshot.png)

## Requirements

Python 3.11 or newer.

## Setup

Run `make` to install dependencies.

## Usage

Command: `bin/compile-manuscript`

Command-line arguments:

1. Template name (e.g. `common`)
2. Input filename
3. Output filename

Example:

    % bin/compile-manuscript common examples/fiction-short-story.md examples/fiction-short-story.pdf

Document metadata:

* `title`: Full title of the document (e.g. `The Essex Conundrum`).
* `title_short`: Short title of the document (e.g. `Conundrum`)
* `byline`: Attribution (e.g. pen name), without “by” (e.g. `Denis Fletcher`)
* `date`: Date in ISO8601 format.

Author metadata:

* `author_first_name`: Legal first name.
* `author_last_name`: Legal last name.
* `author_pronouns`
* `author_address_line_1`
* `author_address_line_2`
* `author_address_line_3`
* `author_phone`
* `author_email_address`

Formatting options:

* `separate_title_page`: Enable to have an entirely separate title page.
  Not compatible with `minimal_header`.
* `minimal_header`: Enable to have a header without contact information or word count. Useful for synopses. Not compatible with `separate_title_page`.
* `nonfiction`: Enable to change the format to be more non-fiction friendly (default: `false`)
