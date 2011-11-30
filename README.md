Jazz Hands
==========

Spending hours in the rails console? Spruce it up and show off those
hard-working hands!

**jazz_hands** combines multiple console-related gems and a bit of glue:

* [**Pry**][pry] for a powerful shell alternative to IRB.
* [**Awesome Print**][awesome_print] for stylish pretty print.
* [**Pry Doc**] to browse Ruby source, including C, directly from the console.
* [**Pry Git**][pry-git] to teach the console about git. Diffs, blames, and
  commits on methods and classes, not just files.
* [**Pry Nav**][pry-nav] to turn the console into a simple debugger.
* [**Pry Remote**][pry-remote] to connect remotely to a Pry console.
* [**Coolline**][coolline] and [**Coderay**][coderay] for syntax highlighting as
  you type (_Ruby 1.9.3 only_).


## Usage

Rails 3 and above only. Add to your project Gemfile:

```ruby
group :development, :test do
  gem 'jazz_hands'
end
```


## Contributing

Patches and bug reports are welcome. Just send a [pull request][pullrequests] or
file an [issue][issues]. [Project changelog][changelog].


[pry]:           http://pry.github.com
[awesome_print]: https://github.com/michaeldv/awesome_print
[pry-git]:       https://github.com/pry/pry-git
[pry-nav]:       https://github.com/nixme/pry-nav
[pry-remote]:    https://github.com/Mon-Ouie/pry-remote
[coolline]:      https://github.com/Mon-Ouie/coolline
[coderay]:       https://github.com/rubychan/coderay
[pullrequests]:  https://github.com/nixme/jazz_hands/pulls
[issues]:        https://github.com/nixme/jazz_hands/issues
[changelog]:     https://github.com/nixme/jazz_hands/blob/master/CHANGELOG.md
