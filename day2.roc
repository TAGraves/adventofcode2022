app "day1"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.1/zAoiC9xtQPHywYk350_b7ust04BmWLW00sjb9ZPtSQk.tar.br" }
    imports [pf.File, pf.Stdout, pf.Task, pf.Path]
    provides [main] to pf


readFile = \filePath ->
    task =
        File.readUtf8 (Path.fromStr filePath)

    Task.attempt task \result ->
        when result is
            Err _ -> crash "Error reading file"
            Ok content -> Task.succeed content

partOne = \fileContents ->
    Str.split fileContents "\n"
    |> List.map \round ->
        when Str.split round " " is
            ["A", "X"] -> 1 + 3
            ["A", "Y"] -> 2 + 6
            ["A", "Z"] -> 3 + 0
            ["B", "X"] -> 1 + 0
            ["B", "Y"] -> 2 + 3
            ["B", "Z"] -> 3 + 6
            ["C", "X"] -> 1 + 6
            ["C", "Y"] -> 2 + 0
            ["C", "Z"] -> 3 + 3
            _ -> crash round
    |> List.sum
    |> Num.toStr

partTwo = \fileContents ->
    Str.split fileContents "\n"
    |> List.map \round ->
        when Str.split round " " is
            ["A", "X"] -> 0 + 3
            ["A", "Y"] -> 3 + 1
            ["A", "Z"] -> 6 + 2
            ["B", "X"] -> 0 + 1
            ["B", "Y"] -> 3 + 2
            ["B", "Z"] -> 6 + 3
            ["C", "X"] -> 0 + 2
            ["C", "Y"] -> 3 + 3
            ["C", "Z"] -> 6 + 1
            _ -> crash round
    |> List.sum
    |> Num.toStr

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
