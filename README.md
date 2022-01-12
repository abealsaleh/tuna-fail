# tuna-fail
a small containerized service for tuning failures and flap detection in monitoring agents

## Design
Initially, an easier design may have been using nginx to return various failures at different endpoints. This runs into a few issues in my thinking

1) Requires more faffing with config in the monitoring system when you want to test various states
2) it's not easy to to create randomized flapping directly within nginx, and would require a script at that endpoint anyway.

Thus, a lightweight ruby service seems the right way to go, which immediately brought sinatra to my mind.



### Layout
*Dashboard*
 * Displays active endpoints
 * Allows creation of new endpoints
*Endpoint*
 * XXX/manage
   * Allows configuring which behaviors the endpoint will return
 * XXX/target
  * The actual target you point your monitoring agent at


# Requirements
## Development
* Written against ruby 3.1.0, but currently unsure minimum requirements
* Bundler
* docker
