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

partOne = \fileContents ->
    Str.split fileContents "\n\n"
    |> List.map \elfNums ->
        Str.split elfNums "\n"
        |> List.map \str -> unwrap (Str.toI64 str) str
        |> List.sum
    |> List.max
    |> unwrap ""
    |> Num.toStr

partTwo = \fileContents ->
    Str.split fileContents "\n\n"
    |> List.map \elfNums ->
        Str.split elfNums "\n"
        |> List.map \str -> unwrap (Str.toI64 str) str
        |> List.sum
    |> List.sortDesc
    |> List.takeFirst 3
    |> List.sum
    |> Num.toStr

main =
    fileContents <- readFile "./day1.txt" |> Task.await
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
    1000
    2000
    3000

    4000

    5000
    6000

    7000
    8000
    9000

    10000
    """
expect partOne sampleData == "24000"
expect partTwo sampleData == "45000"
