# plunge
Plunge into the word of securities!

# Requirements
* Ruby 2.5.1p57
* Bundler 1.16.1

Install required dependencies from the Gemfile: 
```
bundle install
```

## Usage
To query the [Quandl WIKIP Stock Price API](https://www.quandl.com/databases/WIKIP) you need a token. To obtain a token you just need to create a free account with Quandl.  

To use the script, move to the _lib/_ directory (until I will have time to create a proper gem) and run the _pc_ (plunge command line) ruby file. 

### Supported operations
Get the monthly average of a security with the -a option:
```
ruby pc.rb -t <your_token> -a GOOGL
```

Get the days where the volume was more than 10% higher than the security’s average volume:
```
ruby pc.rb -t <your_token> -bd GOOGL
```

# Development
Before running the test, place your token in a file named _token_ in the main project directory.
Run the tests with the command `rspec` or `bundle exec rspec` if you didn't install rspec globally in your system. 