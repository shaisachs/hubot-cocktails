# Description
#   It's 5:00 somewhere!
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   /cocktails <name> - Recipe and thumbnail for the cocktail
#   /cocktails - Recipe and thumbnail for a random cocktail
#
# Author:
#   Shai Sachs
#

apikey = 1;

showCocktail = (robot, msg, input) ->
    if typeof input != 'string'
      msg.send 'Invalid input: ' + input
    else
    	query = input.replace(/\s+/g, ' ')
    	query = query.trim()
    	query = encodeURIComponent query

    	method = if query == 'random' then 'random.php' else 'search.php?s=' + query
    	url = 'http://www.thecocktaildb.com/api/json/v1/' + apikey + '/' + method

    	robot.http(url)
    	  .get() (err, res, body) ->
    	    data = {}
    	    try
    	      data = JSON.parse body
    	    catch dataErr
            err = true

    	    if (err || !data)
            msg.send 'Failed to fetch cocktail: ' + input
          else
      	    if !data.drinks || !Array.isArray(data.drinks) || data.drinks.length <= 0
      	      msg.send 'Failed to find cocktail: ' + input
            else
        	    drink = data.drinks[0]

        	    if !drink.strInstructions && !drink.strDrinkThumb
        	      msg.send 'No interesting details for cocktail: ' + input

        	    msg.send drink.strDrink

        	    if drink.strInstructions
        	      msg.send drink.strInstructions

        	    if drink.strDrinkThumb
        	      msg.send drink.strDrinkThumb

module.exports = (robot) ->
  robot.respond /cocktails\s*$/i, (msg) ->
  	showCocktail(robot, msg, 'random')

  robot.respond /cocktails\s+(\S.*)/i, (msg) ->
    showCocktail(robot, msg, msg.match[1])
