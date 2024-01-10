%dw 2.0
import sumBy from dw::core::Arrays
output application/json

fun getGameId(gameDetails) = 
    (gameDetails scan /^Game (\d+).*/)[0][1] as Number

fun isGameValid(gameDetails) = 
    gameDetails scan /(\d+) (blue|red|green)/
        map ((ballsPerRound) -> {
            (ballsPerRound[2]): ballsPerRound[1]
        })
        then (validateForBlue($) and validateForRed($) and validateForGreen($))

fun validateForBlue(ballCountData) = isEmpty(ballCountData.blue filter ($ as Number > 14))
fun validateForRed(ballCountData) = isEmpty(ballCountData.red filter $ as Number > 12)
fun validateForGreen(ballCountData) = isEmpty(ballCountData.green filter $ as Number > 13)
---
payload splitBy "\n"
    filter isGameValid($)
    sumBy (getGameId($))
