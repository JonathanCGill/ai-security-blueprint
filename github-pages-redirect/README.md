# GitHub Pages Redirect: jonathancgill.github.io → airuntimesecurity.co.za

These files redirect `https://jonathancgill.github.io/` to `https://airuntimesecurity.co.za/`.

## Setup Instructions

1. **Create a new repository** on GitHub named exactly `JonathanCGill.github.io`
2. **Copy the files** from this directory (`index.html` and `404.html`) into the root of that new repository
3. **Push to `main`** branch
4. **Enable GitHub Pages** in the repository settings:
   - Go to Settings → Pages
   - Source: Deploy from a branch
   - Branch: `main`, folder: `/ (root)`
   - Save

GitHub will automatically serve `index.html` at `https://jonathancgill.github.io/`, which performs an instant redirect to `https://airuntimesecurity.co.za/`.

The `404.html` ensures that any sub-path (e.g. `jonathancgill.github.io/anything`) also redirects.
