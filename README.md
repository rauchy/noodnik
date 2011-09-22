#noodnik

This gem is a simple solution that allows you to remind your users to do things such as update their profiles, complete surveys or try a new feature. You can easily add links for postponing these reminders.

For users that are signed in, these reminders are saved in the database. For users that are not signed in, the reminders are saved in temporary cookies that can be migrated to the database once users sign up.

## Installation

1. In your Gemfile, add this line: ```gem 'noodnik'```
2. ```$ bundle install```
3. ```$ rake noodnik:install:migrations```
4. ```$ rake db:migrate```
5. ```$ rails g noodnik:install```
6. Edit config/initializers/Noodnik.rb and follow the instructions there.

## Examples

### A Quick Nagging Example

    <%= nag_user_to :update_profile do %>
      You still need to <%= link_to 'update your profile', update_profile_path %>!
    <% end %>

This will render the following HTML:
   
    <div class="noodnik-nag"> 
      You still need to <a href="/profiles/update" class="noodnik-complete" data-noodnik-complete-path="/noodnik/complete?topic=update_profile">update your profile</a>!
    </div>

- Clicking on "**update your profile**" will prevent this message from ever appearing again for the current user.

### Postponing Nags

Inside ```nag_user_to``` blocks, you can use the ```postpone_for``` helper to create links for temporarily postponing nags:

    <%= nag_user_to :complete_survey do %>
      Don't forget to <%= link_to 'complete our survey', complete_survey_path %> 
      (<%= postpone_for 5.days %>)      
    <% end %>

Will output something that looks like:

Don't forget to [complete our survey] [1] ([Remind me in 5 days] [1])

- Clicking on "**complete our survey**" will take the user to ```complete_survey_path```, but will also mark this nag as *complete* (which means that this entire div block won't be displayed ever again in the future)
- Click on "**Remind me in 5 days**" will hide the div block and prevent it from being displayed in the next 5 days. The user will stay in the same page and won't be redirected anywhere.

### Manually Completing Nags

Any ```link_to``` under a ```nag_user_to``` block will automatically mark the nag as *complete* when clicked. You might choose to mark nags as complete at a different time (for example, only after the user actually finishes a survey).
To achieve this, you need to specify ```complete: false``` for links inside ```nag_user_to``` blocks.

    <%= nag_user_to :complete_survey do %>
      <%= link_to 'complete our survey', complete_survey_path, complete: false %>
    <% end %>

Then, you can mark this as complete by calling:

    TODO

  [1]: http://www.example.com/complete_survey
