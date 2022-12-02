app "day1"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.1/zAoiC9xtQPHywYk350_b7ust04BmWLW00sjb9ZPtSQk.tar.br" }
    imports [pf.File, pf.Stdout, pf.Task, pf.Path]
    provides [main] to pf

unwrap = \result, errMsg ->
    when result is
        Ok a -> a
        Err _ -> crash (Str.concat "Unwrap failed" errMsg)

readFile = \filePath ->
    task =
        File.readUtf8 (Path.fromStr filePath)

    Task.attempt task \result ->
        when result is
            Err _ -> crash "Error reading file"
            Ok content -> Task.succeed content

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
        moves = Str.split round " "
        theirMove = mapTheirMove (unwrap (List.first moves) "no first element in moves")
        ourMove = mapOurMove (unwrap (List.get moves 1) "no second element in moves")
        outcome = getOutcome ourMove theirMove

        getScore ourMove outcome

partTwo = \fileContents ->
    sumRounds fileContents \round ->
        inputs = Str.split round " "
        theirMove = mapTheirMove (unwrap (List.first inputs) "no first element in inputs")
        outcome = mapOutcome (unwrap (List.get inputs 1) "no second element in inputs")
        ourMove = when outcome is
            Lose -> getWinningMatchupFor theirMove
            Draw -> theirMove
            Win -> getLosingMatchupFor theirMove

        getScore ourMove outcome

main =
    fileContents <- readFile "./day2.txt" |> Task.await
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
