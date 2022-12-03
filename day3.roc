app "day3"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.1/zAoiC9xtQPHywYk350_b7ust04BmWLW00sjb9ZPtSQk.tar.br" }
    imports [pf.Stdout, pf.Task, Util]
    provides [main] to pf

getItemPriority = \item ->
    "_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    |> Str.graphemes
    |> List.findFirstIndex \c -> item == c
    |> Util.unwrap "Could not calculate priority for \(item)"

partOne = \fileContents ->
    Str.split fileContents "\n"
    |> List.map \rucksack ->
        items = Str.graphemes rucksack
        compartmentSize = Num.round (Num.toFrac (List.len items) / 2)
        firstCompartment = List.takeFirst items compartmentSize
        secondCompartment = List.takeLast items compartmentSize

        List.keepIf firstCompartment \item -> List.contains secondCompartment item
        |> List.first
        |> Util.unwrap "No item existed in both compartments for rucksack \(rucksack)"
    |> List.map getItemPriority
    |> List.sum
    |> Num.toStr

partTwo = \fileContents ->
    Str.split fileContents "\n"
    |> List.walk { index: 1, groups: [], currentGroup: [] } \state, rucksack ->
        currentGroup = List.append state.currentGroup (Str.graphemes rucksack)

        if state.index % 3 == 0 then
            {
                index: state.index + 1,
                groups: List.append state.groups currentGroup,
                currentGroup: [],
            }
        else
            {
                index: state.index + 1,
                groups: state.groups,
                currentGroup: currentGroup,
            }
    |> .groups
    |> List.map \group ->
        Tuple3 firstGroup secondGroup thirdGroup = Util.makeTuple3 group
        List.keepIf firstGroup \item -> List.contains secondGroup item && List.contains thirdGroup item
        |> List.first
        |> Util.unwrap "no shared item in group"
    |> List.map getItemPriority
    |> List.sum
    |> Num.toStr

main =
    fileContents <- Util.readFile "./day3.txt" |> Task.await
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
    vJrwpWtwJgWrhcsFMMfFFhFp
    jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
    PmmdzqPrVvPwwTWBwg
    wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
    ttgJtRGJQctTZtZT
    CrZsJsPPZsGzwwsLwLmpwMDw
    """
expect partOne sampleData == "157"
expect partTwo sampleData == "70"
