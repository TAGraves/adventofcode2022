app "day6"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.1/zAoiC9xtQPHywYk350_b7ust04BmWLW00sjb9ZPtSQk.tar.br" }
    imports [pf.Stdout, pf.Task, Util]
    provides [main] to pf

partOne = \fileContents ->
    Str.graphemes fileContents
    |> List.walkUntil { lastFour: [], index: 0 } \{ lastFour, index }, char ->
        newLastFour = lastFour |> List.takeLast 3 |> List.append char
        newData = { lastFour: newLastFour, index: index + 1 }

        if Set.len (Set.fromList newLastFour) == 4 then
            Break newData
        else
            Continue newData
    |> .index
    |> Num.toStr

partTwo = \fileContents ->
    Str.graphemes fileContents
    |> List.walkUntil { lastFourteen: [], index: 0 } \{ lastFourteen, index }, char ->
        newLastFourteen = lastFourteen |> List.takeLast 13 |> List.append char
        newData = { lastFourteen: newLastFourteen, index: index + 1 }

        if Set.len (Set.fromList newLastFourteen) == 14 then
            Break newData
        else
            Continue newData
    |> .index
    |> Num.toStr

main =
    fileContents <- Util.readFile "./day6.txt" |> Task.await
    Stdout.write
        (
            Str.joinWith
                [
                    Str.concat "Part 1: " (partOne fileContents),
                    Str.concat "Part 2: " (partTwo fileContents),
                ]
                "\n"
        )

expect partOne "mjqjpqmgbljsphdztnvjfqwrcgsmlb" == "7"
expect partOne "bvwbjplbgvbhsrlpgdmjqwftvncz" == "5"
expect partOne "nppdvjthqldpwncqszvftbrmjlhg" == "6"
expect partOne "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg" == "10"
expect partOne "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw" == "11"
expect partTwo "mjqjpqmgbljsphdztnvjfqwrcgsmlb" == "19"
expect partTwo "bvwbjplbgvbhsrlpgdmjqwftvncz" == "23"
expect partTwo "nppdvjthqldpwncqszvftbrmjlhg" == "23"
expect partTwo "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg" == "29"
expect partTwo "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw" == "26"
