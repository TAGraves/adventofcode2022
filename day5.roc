app "day5"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.1/zAoiC9xtQPHywYk350_b7ust04BmWLW00sjb9ZPtSQk.tar.br" }
    imports [pf.Stdout, pf.Task, Util]
    provides [main] to pf

getInitialStacks = \stackStr ->
    Str.split stackStr "\n"
    |> List.walkBackwards [] \stacks, stackLine ->
        if Str.startsWith stackLine " 1" then
            stackCount = Str.trimRight stackLine |> Str.split " " |> List.last |> Util.unwrap "a" |> Str.toNat |> Util.unwrap "b"

            List.repeat [] stackCount
        else
            recurse = \chars, workingStacks, i ->
                { before, others } = List.split chars 4

                when List.len before is
                    0 -> workingStacks
                    _ ->
                        crate = List.get before 1 |> Util.unwrap "c"

                        newStacks = when crate is
                            " " -> workingStacks
                            _ ->
                                newStack =
                                    List.get workingStacks i
                                    |> Util.unwrap "d"
                                    |> List.append crate

                                List.set workingStacks i newStack

                        recurse others newStacks (i + 1)

            Str.graphemes stackLine |> recurse stacks 0

parseInstructionString = \instructionStr ->
    (Tuple3 moveCount fromStackNum toStackNum) =
        Str.split instructionStr " "
        |> List.map Str.toNat
        |> List.map \n -> Util.unwrap n ""
        |> Util.makeTuple3

    { moveCount, fromStackIndex: fromStackNum - 1, toStackIndex: toStackNum - 1 }

getInstructions = \instructionsStr ->
    instructionsStr
    |> Str.replaceEach "move " ""
    |> Util.unwrap ""
    |> Str.replaceEach "from " ""
    |> Util.unwrap ""
    |> Str.replaceEach "to " ""
    |> Util.unwrap ""
    |> Str.split "\n"
    |> List.map parseInstructionString

partOne = \fileContents ->
    (Tuple stackStr instructionsStr) = Str.split fileContents "\n\n" |> Util.makeTuple
    initialStacks = getInitialStacks stackStr

    getInstructions instructionsStr
    |> List.walk initialStacks \stacks, { moveCount, fromStackIndex, toStackIndex } ->
        fromStack = List.get stacks fromStackIndex |> Util.unwrap ""
        toStack = List.get stacks toStackIndex |> Util.unwrap ""

        { before: remainingCratesInFrom, others: cratesToMove } = List.split fromStack (List.len fromStack - moveCount)

        newToStack = List.concat (List.walk toStack [] List.append) (List.reverse cratesToMove)

        stacks
        |> List.set fromStackIndex remainingCratesInFrom
        |> List.set toStackIndex newToStack
    |> List.map \stack -> Util.unwrap (List.last stack) ""
    |> Str.joinWith ""

partTwo = \fileContents ->
    (Tuple stackStr instructionsStr) = Str.split fileContents "\n\n" |> Util.makeTuple
    initialStacks = getInitialStacks stackStr

    getInstructions instructionsStr
    |> List.walk initialStacks \stacks, { moveCount, fromStackIndex, toStackIndex } ->
        fromStack = List.get stacks fromStackIndex |> Util.unwrap ""
        toStack = List.get stacks toStackIndex |> Util.unwrap ""

        { before: remainingCratesInFrom, others: cratesToMove } = List.split fromStack (List.len fromStack - moveCount)

        newToStack = List.concat (List.walk toStack [] List.append) cratesToMove

        stacks
        |> List.set fromStackIndex remainingCratesInFrom
        |> List.set toStackIndex newToStack
    |> List.map \stack -> Util.unwrap (List.last stack) ""
    |> Str.joinWith ""

main =
    fileContents <- Util.readFile "./day5.txt" |> Task.await
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
        [D]
    [N] [C]
    [Z] [M] [P]
     1   2   3
    
    move 1 from 2 to 1
    move 3 from 1 to 3
    move 2 from 2 to 1
    move 1 from 1 to 2
    """
expect partOne sampleData == "CMZ"
expect partTwo sampleData == "MCD"
