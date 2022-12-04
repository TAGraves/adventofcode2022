app "day4"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.1/zAoiC9xtQPHywYk350_b7ust04BmWLW00sjb9ZPtSQk.tar.br" }
    imports [pf.Stdout, pf.Task, Util]
    provides [main] to pf

partOne = \fileContents ->
    Str.split fileContents "\n"
    |> List.keepIf \pairing ->
        (Tuple firstAssignment secondAssignment) = Util.makeTuple (Str.split pairing ",")
        (Tuple firstAssignmentStart firstAssignmentEnd) = Util.makeTuple (Str.split firstAssignment "-" |> List.map Str.toNat |> List.map \n -> Util.unwrap n "")
        (Tuple secondAssignmentStart secondAssignmentEnd) = Util.makeTuple (Str.split secondAssignment "-" |> List.map Str.toNat |> List.map \n -> Util.unwrap n "")

        (firstAssignmentStart >= secondAssignmentStart && firstAssignmentEnd <= secondAssignmentEnd) || (secondAssignmentStart >= firstAssignmentStart && secondAssignmentEnd <= firstAssignmentEnd)
    |> List.len
    |> Num.toStr

partTwo = \fileContents ->
    Str.split fileContents "\n"
    |> List.keepIf \pairing ->
        (Tuple firstAssignment secondAssignment) = Util.makeTuple (Str.split pairing ",")
        (Tuple firstAssignmentStart firstAssignmentEnd) = Util.makeTuple (Str.split firstAssignment "-" |> List.map Str.toNat |> List.map \n -> Util.unwrap n "")
        (Tuple secondAssignmentStart secondAssignmentEnd) = Util.makeTuple (Str.split secondAssignment "-" |> List.map Str.toNat |> List.map \n -> Util.unwrap n "")

        (firstAssignmentStart >= secondAssignmentStart && firstAssignmentStart <= secondAssignmentEnd)
        || (firstAssignmentEnd >= secondAssignmentStart && firstAssignmentEnd <= secondAssignmentEnd)
        || (secondAssignmentStart >= firstAssignmentStart && secondAssignmentStart <= firstAssignmentEnd)
        || (secondAssignmentEnd >= firstAssignmentStart && secondAssignmentEnd <= firstAssignmentEnd)
    |> List.len
    |> Num.toStr

main =
    fileContents <- Util.readFile "./day4.txt" |> Task.await
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
    2-4,6-8
    2-3,4-5
    5-7,7-9
    2-8,3-7
    6-6,4-6
    2-6,4-8
    """
expect partOne sampleData == "2"
expect partTwo sampleData == "4"
