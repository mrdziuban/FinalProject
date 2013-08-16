# GameDay

GameDay was built over 2 weeks as my capstone project for App Academy. Since I have an economics background and I'm a big hockey fan, I wanted to combine my interests to create a site that lets fans keep track of stats for NHL teams and players, see details about past and future games, and discuss general hockey or specific teams with other fans.

## Tech used

* Rails API
    * User, Team, Player, Goalie, Analysis, Forum, Topic, Comment models
    * Favorite model with polymorphic associations to allow for favoriting of teams, players, and goalies
* JavaScript and jQuery for responsiveness
    * [WMD (WYSIWYM Markdown Editor)](https://github.com/derobins/wmd) for live Markdown preview in the forum using Showdown
    * [typeahead.js](https://github.com/twitter/typeahead.js) for search autocomplete
* AJAX for asynchronous requests
* HTML5
* CSS 2/3
* PostgreSQL for database management
* [Devise](https://github.com/plataformatec/devise) for user registration and authentication
* [Nokogiri](https://github.com/sparklemotion/nokogiri) and OpenURI for gathering stats
* [Paperclip](https://github.com/thoughtbot/paperclip) and Amazon S3 for image storage
* [Kaminari](https://github.com/amatsuda/kaminari) for pagination of stats
* [pg_search](https://github.com/Casecommons/pg_search) for multi-model search
* [SeatGeek](http://seatgeek.com) API integration for tickets info using RestClient and Addressable
* [Chartkick](https://github.com/ankane/chartkick) to create charts using the Google Chart API

Check it out at http://game-day.herokuapp.com. Login to demo with email: test@test.com, password: testpass.