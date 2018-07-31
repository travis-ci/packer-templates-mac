# CocoaPods Role

This role ensures CocoaPods is set up correctly.

## Variables

This role doesn't define its own variables, but it reuses two variables from the `ruby` role:

* `rvm_binary`
* `default_ruby`

If you run this role without running the `ruby` role, be sure to define those variables.

## Tasks

* Downloads the repository of CocoaPods specs

## Notes

Running `pod setup` from scratch takes longer than you might expect: the Specs repository is quite large and is slow to clone. Don't surprised if running the playbook stops here for a little while.
