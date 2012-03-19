Punching Bag
============
Punching Bag is a hit tracking plugin for Ruby on Rails that specializes in simple trending.

Features
========
* Total hit count
* Hit counts for the last day, week, month, etc.
* Simple trending based on most hits in the last day, week, month, etc.
* Rake task to group old hit records for better performance
* [ActsAsTaggableOn](https://github.com/mbleigh/acts-as-taggable-on) integration for trending tags/topics support
* [Voight-Kampff](https://github.com/biola/Voight-Kampff) integration for bot checking

Installation
============

__In your Gemfile add:__

    gem "punching_bag"

__In the terminal run:__

    bundle install
    rails g punching_bag
    rake db:migrate

__In your model add:__

    acts_as_punchable

Usage
=====
__Tracking hits in your controller__

    class PostsController < ApplicationController
      def show
        @post.punch(request)
      end
    end

__Getting a total hit count in your view__

    @post.hits

__Getting a hit count for a time period in your view__

    @post.hits(1.week.ago)

__Getting a list of the five all-time most hit posts__

    Post.most_hit

__Getting a list of the 10 most hit posts for the last 24 hours__

    Post.most_hit(1.day.ago, 10)  # limit is 5 by default, pass nil for no limits

__Sorting posts based on all time hit count__

    Post.sort_by_popularity('DESC')   # DESC by default, can also use ASC

__Getting a hit count on a tag for the last month__

    tag.hits(1.month.ago)

__Getting a list of the 10 most hit tags in the last week__

    ActsAsTaggableOn::Tag.most_hit(1.month.ago, 10)

__Compressing old hit records to improve performance__  
*The default settings combine records by day if they're older than 7 days, by month if they're older than 1 month and by year if they're older than 1 year*

    rake punching_bag:combine

__Compressing old hit records using custom settings__  
*This time we'll combine records by day if they're older than 14 days, by month if they're older than 3 months and by year if they're older than 2 years*

    rake punching_bag:combine[14,3,2]

Notes
=====
* The `punching_bag:combine` rake tasks is not run automatically. You'll have to run it manually or add it as a cron job.
* The `punching_bag:combine` rake task can take a while depending on how many records need to be combined.
* Passing the `request` object to the `punch` method is optional but without it requests from bots, crawlers and spiders will be tracked.
* See the [Voight-Kampff](https://github.com/biola/Voight-Kampff) documentation if you'd like to customize the list of user-agents considered bots.
* The tag related features will only work if you have [ActsAsTaggableOn](https://github.com/mbleigh/acts-as-taggable-on) installed and enabled on the same models as Punching Bag.
