

A barebones website hosted on github pages
------------------------------------------

### Creating the webpages themselves

The file [index.html](index.html) is a standalone webpage template with styling and minimal interactivity created with a few Javascript functions.

Preview it by cloning this branch:

```bash
git clone https://github.com/jimmymathews/jimmymathews.github.io
git checkout tutorial
```

Then open `index.html` in a browser. On a mac, this may work: `open -a Safari index.html`

Also take a look at the text of the file itself. The 3 important parts are:

1. The `<style> ... </style>` section.
2. The `<script> ... </script>` section.
3. The `<body> ... </body>` section.

The body should be as close as possible to barebones HTML. This is just a bunch of text, hierarchically organized into sections (`div` elements, sometimes `span`), incorporating tables, lists, paragraphs, and headers as necessary.

The style section is [CSS](https://www.w3schools.com/cssref/). The point of the CSS is to add color, size, patterning, and even a little interactivity. It accomplishes this by mentioning styling elements in the context of either specific HTML element types (like `p` or `td` or `div` ...), or in the context of your own custom-named classes of elements. In the latter case you just have to make sure to add something like `class="customclassname"` to the HTML element in the body. Writing CSS is always a matter of taking a few examples, and reworking them by searching the [W3C reference](https://www.w3schools.com/cssref/) for the correct attribute names and usage rules.

The script section is Javascript (JS). I have included some JS functions here to do minimal interactive section-toggling.

### Publishing as a website

Github offers hosting of static "content" (like the example above), one website per account. You just need to:

1. Create a repository named `<your username>.github.io` .
2. Add an HTML source file to the `main` branch and call it `index.html` .
3. Push to github.

After a couple minutes you should be able to reach your page at `https://<your username>.github.io` .

It is possible you might have to fiddle with something in the "Pages" section of this repository's "Settings" in order to get this to work the first time.

### Using a custom website name

If you have registered a domain name by purchasing the registration service from a "registrar" (like NoIP, Namecheap, or GoDaddy), you should be able to make it point to your website hosted on github. This used to be a somewhat complicated process, but these days it should not be that hard:

1. Fill out the "custom domain" text field under Github -> the repository -> Settings -> Pages.
2. Log in to your account with the registrar.
3. Locate the area for settings related to the domain you purchased.
4. Add a CNAME record pointing your domain to `<your username>.github.io` .

After a few minutes you should find that your domain works! (Note that this is not a "redirect"; a redirect would rename the visible URL to the target URL).

