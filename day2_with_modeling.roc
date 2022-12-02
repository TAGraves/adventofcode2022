app "day2_with_modeling"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.1/zAoiC9xtQPHywYk350_b7ust04BmWLW00sjb9ZPtSQk.tar.br" }
    imports [pf.Stdout, pf.Task, Util]
    provides [main] to pf

sumRounds = \fileContents, fn ->
    Str.split fileContents "\n"
    |> List.map fn
    |> List.sum
    |> Num.toStr

getWinningMatchupFor = \move ->
    when move is
        Rock -> Scissors
        Paper -> Rock
        Scissors -> Paper

getLosingMatchupFor = \move ->
    when move is
        Rock -> Paper
        Paper -> Scissors
        Scissors -> Rock

getOutcome = \ourMove, theirMove ->
    if ourMove == theirMove then
        Draw
    else if getWinningMatchupFor ourMove == theirMove then
        Win
    else
        Lose

getScore = \ourMove, outcome ->
    moveScore = when ourMove is
        Rock -> 1
        Paper -> 2
        Scissors -> 3
    outcomeScore = when outcome is
        Lose -> 0
        Draw -> 3
        Win -> 6

    moveScore + outcomeScore

mapTheirMove = \theirMove ->
    when theirMove is
        "A" -> Rock
        "B" -> Paper
        "C" -> Scissors
        _ -> crash (Str.concat "unknown theirMove: " theirMove)
mapOurMove = \ourMove ->
    when ourMove is
        "X" -> Rock
        "Y" -> Paper
        "Z" -> Scissors
        _ -> crash (Str.concat "unknown ourMove: " ourMove)
mapOutcome = \outcome ->
    when outcome is
        "X" -> Lose
        "Y" -> Draw
        "Z" -> Win
        _ -> crash (Str.concat "unknown outcome: " outcome)

partOne = \fileContents ->
    sumRounds fileContents \round ->
        (Tuple theirMoveRaw ourMoveRaw) = Str.split round " " |> Util.makeTuple
        theirMove = mapTheirMove theirMoveRaw
        ourMove = mapOurMove ourMoveRaw
        outcome = getOutcome ourMove theirMove

        getScore ourMove outcome

partTwo = \fileContents ->
    sumRounds fileContents \round ->
        (Tuple theirMoveRaw outcomeRaw) = Str.split round " " |> Util.makeTuple
        theirMove = mapTheirMove theirMoveRaw
        outcome = mapOutcome outcomeRaw
        ourMove = when outcome is
            Lose -> getWinningMatchupFor theirMove
            Draw -> theirMove
            Win -> getLosingMatchupFor theirMove

        getScore ourMove outcome

main =
    fileContents <- Util.readFile "./day2.txt" |> Task.await
    Stdout.write
        (
            Str.joinWith
                [
                    Str.concat "Part 1: " (partOne fileContents),
                    Str.concat "Part 2: " (partTwo fileContents),
                ]
                "\n"
        )

sampleData =
    """
    A Y
    B X
    C Z
    """
expect partOne sampleData == "15"
expect partTwo sampleData == "12"
