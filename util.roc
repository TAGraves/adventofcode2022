interface Util
    exposes [readFile, unwrap, makeTuple]
    imports [pf.Task, pf.File, pf.Path]

unwrap = \result, errMsg ->
    when result is
        Ok a -> a
        Err _ -> crash (Str.concat "Unwrap failed" errMsg)

readFile = \filePath ->
    File.readUtf8 (Path.fromStr filePath)
    |> Task.attempt \result -> Task.succeed (unwrap result "Error reading file")

listToStr = \list ->
    "["
    |> Str.concat (Str.joinWith list ", ")
    |> Str.concat "]"

makeTuple = \list ->
    if List.len list == 2 then
        first = List.first list |> unwrap ""
        second = List.get list 1 |> unwrap ""

        Tuple first second
    else
        crash (Str.concat "Tuple could not be made out of list: " (listToStr list))
