## 0.3.1 (2012-06-11)

* Upgrade [pry-debugger][pry-debugger] to 0.2.0.

## 0.3.0 (2012-06-07)

* Replace [pry-nav][pry-nav] with [pry-debugger][pry-debugger] for improved
  performance and no segfaults. `JazzHands.enable_pry_nav` removed.
* Upgrade [pry][pry] to the latest 0.9.9, [pry-doc][pry-doc] 0.4.2,
  [pry-git][pry-git] 0.2.3, [pry-stack_explorer][pry-stack_explorer] 0.4.2,
  [pry-remote][pry-remote] 0.1.4, [coderay][coderay] 1.0.6.

## 0.2.0 (2012-03-19)

* Add [pry-stack_explorer][pry-stack_explorer] 0.4.1.
* Upgrade [pry-remote][pry-remote] to 0.1.1 and [pry-nav][pry-nav] to 0.2.0.
* Upgrade recommended gem minor versions: [pry][pry] 0.9.8.4, [pry-doc][pry-doc]
  0.4.1, [hirb][hirb] 0.6.2, and [coderay][coderay] 1.0.5.

## 0.1.2 (2012-01-23)

* Improved Rails 3.2 compatibility. Console methods like `app`, `new_session`,
  `reload!`, `helper`, and `controller` work as expected.

## 0.1.1 (2012-01-20)

* Rails 3.2 compatibility

## 0.1.0 (2012-01-04)

* For performance, enable [pry-nav][pry-nav] only on MRI 1.9.3 by default. To
  use on MRI 1.9.2, add `JazzHands.enable_pry_nav` to a Rails initializer.
* Due to buggy behavior, syntax highlighting as you type via
  [Coolline][coolline] and [Coderay][coderay] is disabled by default. Enable
  with `JazzHands.enable_syntax_highlighting_as_you_type` in a Rails
  initializer. MRI 1.9.3 only.
* Fix [Hirb][hirb] support.
* Upgrade [awesome_print][awesome_print] to 1.0.2.

## 0.0.6 (2011-12-03)

* Add line numbers to the prompt for easy reference when using `_in_` and
  `_out`.
* Upgrade [pry-nav][pry-nav] to 0.0.4.


## 0.0.5 (2011-12-01)

* Add [Hirb][hirb] support. Enable with `Hirb.enable` in the console.
* Upgrade [pry-nav][pry-nav] to 0.0.3.


## 0.0.4 (2011-11-30)

* Add explicit requires for pry plugin gems.


## 0.0.3 (2011-11-30)

* Add [pry-nav][pry-nav].
* Upgrade [awesome_print][awesome_print] to 1.0.1.


## 0.0.2 (2011-11-25)

* Add [pry-doc][pry-doc].


## 0.0.1 (2011-11-25)

* First release. Combine [pry][pry], [awesome_print][awesome_print],
  [coolline][coolline] + [coderay][coderay], [pry-remote][pry-remote],
  [pry-git][pry-git]. Bit of glue to replace IRB with pry in Rails console,
  pretty colors.


[pry]:                http://pry.github.com
[awesome_print]:      https://github.com/michaeldv/awesome_print
[pry-doc]:            https://github.com/pry/pry-doc
[pry-git]:            https://github.com/pry/pry-git
[pry-nav]:            https://github.com/nixme/pry-nav
[pry-remote]:         https://github.com/Mon-Ouie/pry-remote
[coolline]:           https://github.com/Mon-Ouie/coolline
[coderay]:            https://github.com/rubychan/coderay
[hirb]:               https://github.com/cldwalker/hirb
[pry-stack_explorer]: https://github.com/pry/pry-stack_explorer
