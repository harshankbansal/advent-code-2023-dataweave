%dw 2.0
import sumBy from dw::core::Arrays
output application/json

fun getPowerOfGame(gameDetails) = 
    gameDetails scan /(\d+) (blue|red|green)/
        map ((ballsPerRound) -> {
            color: (ballsPerRound[2]),
            count: ballsPerRound[1] as Number
        })
        groupBy $.color
        mapObject ((countPerColor, color) -> (color):max(countPerColor.count))
        then product(valuesOf($))

fun product(array: Array<Number>) = 
    array reduce ((number, product = 1) -> product * number)
---
payload splitBy "\n"
    sumBy getPowerOfGame($)
